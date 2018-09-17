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

//MARK: - Mocked data -
class ViewController: UIViewController {
    
    //MARK: - properties -
    var viewModel = DeviceViewModel(devices: [])
    let publishSubject = PublishSubject<Int>() // reactive component for tracking viewModel.devices.count values
    let publishCoordSubject = PublishSubject<CLLocation>()
    let disposeBag = DisposeBag() //disposeBag for Disposables
    let drawing = Drawing() //used for drawing polylines
    let locationManager = CLLocationManager()
    var previouslySelected = IndexPath()
    var mockData = MockData()
   // var locationArray = [CLLocation]()
    
    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var tableView: UITableView!
    
    //MARK: - life cycle -
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManagerSetup() //setup locationManager
        mapSetup() //setup settings for mapView
        setupNavigationBar() //setup navigationBar buttons
        
        //subscribing to onNext events for count property of viewModel.devices array and
        //modifying UI according to the result
        publishSubject.subscribe(onNext: { count in
            
            if count == 0 { //if viewModel.devices.count is 0, tableView is hidden and mapView spans over the entire screen
                self.removeTableView()
                
            } else { //else, tableView is showing with the list of devices and mapView takes up it's position above tableView
                self.displayTableView()
            }
        }).disposed(by: disposeBag)
        
        publishSubject.onNext(viewModel.devices.count) //Initially checks count property of viewModel.devices array
        
        publishCoordSubject.subscribe(onNext: { location in //Subscribe to onNext events
            guard self.viewModel.devices.count != 0 else {return}
            guard let row = self.tableView.indexPathForSelectedRow?.row else {return}
            
            self.viewModel.devices[row].coordinates.append(location)
            self.drawing.drawPolylinesOn(self.mapView, forDevice: self.viewModel.devices[row], withZoom: self.mapView.camera.zoom)
        }).disposed(by: disposeBag)
        
        mockData.mockedDataWithTimer(for: self, and: tableView) //Timer for displaying mocked CLLocations over time using publishCoordSubject
    }
    
    //MARK: - Helper methods -
    fileprivate func removeTableView() {
        self.mapView.clear()
        DispatchQueue.main.async {
            UIView.animate(withDuration: 1, animations: {
                self.tableView.alpha = 0
                self.mapView.frame.size.height = self.view.frame.size.height
                self.tableView.frame.origin.y = self.view.frame.maxY
            })
        }
    }
    
    fileprivate func displayTableView() {
        DispatchQueue.main.async {
            UIView.animate(withDuration: 1, animations: {
                self.mapView.frame.size.height = self.view.frame.size.height - self.tableView.frame.size.height
                self.tableView.frame.origin.y = self.view.frame.size.height - self.tableView.frame.size.height
                self.tableView.alpha = 1
            })
        }
    }
    
    fileprivate func setupNavigationBar() {
        view.backgroundColor = UIColor.lightText //set view background color
        
        //add left and right navigationBar buttons for removing and adding new Devices
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Disconnect", style: .done, target: self, action: #selector(disconnectDevice))
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Connect", style: .done, target: self, action: #selector(connectDevice))
    }
    
    fileprivate func locationManagerSetup() {
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
    
    fileprivate func mapSetup() {
        mapView.delegate = self //assign mapView delegate to 'self'
        mapView.settings.compassButton = true //displays compas on the map when map heading is changed
        mapView.settings.myLocationButton = true //displays round myLocation button
        mapView.isMyLocationEnabled = true //enables user location
    }
    
    @objc func connectDevice() {
        for device in mockData.devices { //add mock devices from devices array
            if viewModel.addDevice(device) == true {
                publishSubject.onNext(viewModel.devices.count) //advertises onNext event once the 'viewModel.devices.count' changes
                tableView.reloadData()
            }
        }
    }
    
    //Remove Device from the array of devices
    @objc func disconnectDevice() {
        guard viewModel.devices.count != 0 else {return} //check the count of devices, if 0, return
        //viewModel.removeLastDevice() // remove last device from devices array
        guard let row = tableView.indexPathForSelectedRow?.row else {return} //if device row is selected, extract the row Int
        drawing.removePolylinesFor(viewModel.devices[row])
        viewModel.removeDevice(named: viewModel.devices[row].name) //remove specific Device.
        publishSubject.onNext(viewModel.devices.count) //advertise onNext event once the 'viewModel.devices.count' changes
        tableView.reloadData() //reload tableView
    }
}
//MARK: Extensions in Extensions folder




