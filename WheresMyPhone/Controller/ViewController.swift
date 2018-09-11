//
//  ViewController.swift
//  WheresMyPhone
//
//  Created by Dusan Juranovic on 8/30/18.
//  Copyright © 2018 Dusan Juranovic. All rights reserved.
//

import UIKit
import GoogleMaps
import RxSwift

let mockDevice = Device(name: "First", uuid: UIDevice.current.identifierForVendor!, coordinates: [CLLocation(latitude: 30, longitude: 20), CLLocation(latitude: 35, longitude: 25)])
let mockDevice2 = Device(name: "Second", uuid: UIDevice.current.identifierForVendor!, coordinates: [CLLocation(latitude: 40, longitude: 30), CLLocation(latitude: 45, longitude: 35)])
let mockDevice3 = Device(name: "Third", uuid: UIDevice.current.identifierForVendor!, coordinates: [CLLocation(latitude: 50, longitude: 40), CLLocation(latitude: 55, longitude: 45)])
let mockDevice4 = Device(name: "Fourth", uuid: UIDevice.current.identifierForVendor!, coordinates: [CLLocation(latitude: 60, longitude: 50), CLLocation(latitude: 65, longitude: 55)])

let devices = [mockDevice, mockDevice2, mockDevice3, mockDevice4]

class ViewController: UIViewController, GMSMapViewDelegate {
    
    //MARK: - properties -
    var viewModel = DeviceViewModel(devices: [])
    let publishSubject = PublishSubject<Int>() // reactive component for tracking viewModel.devices.count values
    let publishCoordSubject = PublishSubject<CLLocation>()
    let disposeBag = DisposeBag() //disposeBag for Disposables
    let drawing = Drawing() //used for drawing polylines
    let locationManager = CLLocationManager()
    
   // var index = 0
   // var locationArray = [CLLocation]()
    
    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var tableView: UITableView!
    
    //MARK: - life cycle -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManagerSetup()
        mapSetup()
        
        //subscribing to onNext events for count property of viewModel.devices array and
        //modifying UI according to the result
        publishSubject.subscribe(onNext: { count in
            //if viewModel.devices.count is 0, tableView is hidden and mapView spans over the entire screen
            if count == 0 {
                self.mapView.clear()
                DispatchQueue.main.async {
                    UIView.animate(withDuration: 1, animations: {
                        self.tableView.alpha = 0
                        self.mapView.frame.size.height = self.view.frame.size.height
                        self.tableView.frame.origin.y = self.view.frame.maxY
                    })
                }
                
                //else, tableView is showing with the list of devices and mapView takes up it's position above tableView
            } else {
                DispatchQueue.main.async {
                    UIView.animate(withDuration: 1, animations: {
                        self.mapView.frame.size.height = self.view.frame.size.height - self.tableView.frame.size.height
                        self.tableView.frame.origin.y = self.view.frame.size.height - self.tableView.frame.size.height
                        self.tableView.alpha = 1
                    })
                }
            }
            
        }).disposed(by: disposeBag)
        publishSubject.onNext(viewModel.devices.count)
        
        //Subscribe to onNext events once the device is connected
        publishCoordSubject.subscribe(onNext: { location in
            guard self.viewModel.devices.count != 0 else {return}
            let row = self.tableView.indexPathForSelectedRow?.row ?? 0
            self.viewModel.devices[row].coordinates.append(location)
            self.drawing.drawPolylinesOn(self.mapView, forDevice: self.viewModel.devices[row])
        }).disposed(by: disposeBag)
        view.backgroundColor = UIColor.lightText
        
        
        //add left and right navigationBar buttons for removing and adding new Devices
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Disconnect", style: .done, target: self, action: #selector(disconnectDevice))
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Connect", style: .done, target: self, action: #selector(connectDevice))
        
    }
    
    //MARK: - Custom methods -
    
    func mockedDataWithTimer() {
        Timer.scheduledTimer(withTimeInterval: 2, repeats: true) { _ in
            let row = self.tableView.indexPathForSelectedRow?.row ?? 0
            guard self.viewModel.devices.count != 0 else {return}
            
            let lat = self.viewModel.devices[row].coordinates.last!.coordinate.latitude
            let lon = self.viewModel.devices[row].coordinates.last!.coordinate.longitude
            
            let randomNumber = Double(arc4random_uniform(5))
            let randomNumber1 = Double(arc4random_uniform(5))
            
            let cll = CLLocation(coordinate: CLLocationCoordinate2D(latitude: CLLocationDegrees(lat + randomNumber), longitude: CLLocationDegrees(lon + randomNumber1)), altitude: 2, horizontalAccuracy: 2, verticalAccuracy: 2, course: 2, speed: CLLocationSpeed(randomNumber), timestamp: Date() + TimeInterval(randomNumber))
            
            self.publishCoordSubject.onNext(cll)
        }
    }
    
    @objc func connectDevice() {
        for device in devices {
            viewModel.addDevice(device)
        }
        //Advertises onNext event once the 'viewModel.devices.count' changes
        publishSubject.onNext(viewModel.devices.count)
        
        //Timer for displaying mocked CLLocations over time using publishCoordSubject
        mockedDataWithTimer()
        
        tableView.reloadData()
    }
    
    //Remocve last Device in the array of devices
    @objc func disconnectDevice() {
        guard viewModel.devices.count != 0 else {return}
        //viewModel.removeLastDevice()
        let row = tableView.indexPathForSelectedRow?.row ?? 0
        
        drawing.removePolyline(forDeviceTitle: viewModel.devices[row].name)
        viewModel.removeDevice(named: viewModel.devices[row].name)  //remove specific Device.
        
        //Advertises onNext event once the 'viewModel.devices.count' changes
        publishSubject.onNext(viewModel.devices.count)
        
        tableView.reloadData()
    }
    
    func locationManagerSetup() {
        locationManager.delegate = self
        locationManager.showsBackgroundLocationIndicator = true
        locationManager.allowsBackgroundLocationUpdates = true
        locationManager.requestAlwaysAuthorization() //request authorisation from the user on initial app run
        locationManager.requestWhenInUseAuthorization() //request authorisation from the user on initial app run
        locationManager.startUpdatingLocation()
        
        //center map on current user location if location available
        if let currentLocation = locationManager.location {
            let camera = GMSCameraPosition.camera(withTarget: CLLocationCoordinate2D(latitude: currentLocation.coordinate.latitude, longitude: currentLocation.coordinate.longitude), zoom: 10)
            mapView.camera = camera
        }
    }
    
    func mapSetup() {
        
        mapView.delegate = self
        mapView.settings.compassButton = true //displays compas on the map when map heading is changed
        mapView.settings.myLocationButton = true //displays round myLocation button
        mapView.isMyLocationEnabled = true //enables user location
    }
}
//MARK: Extensions in Extensions folder



