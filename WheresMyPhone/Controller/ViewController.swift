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


//let devices = [Device]()

class ViewController: UIViewController {
    
    //MARK: - properties -
//    var viewModel = DeviceViewModel(devices: [])
//    let publishSubject = PublishSubject<Int>() // reactive component for tracking viewModel.devices.count values
//    let publishCoordSubject = PublishSubject<CLLocation>()
//    let disposeBag = DisposeBag() //disposeBag for Disposables
    let drawing = Drawing() //used for drawing polylines
    var manager: PeripheralManager?

    
    @IBOutlet weak var mapView: GMSMapView!
    
//    @IBOutlet weak var tableView: UITableView!
    
    //MARK: - life cycle -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        manager = PeripheralManager()
        LocationManager.shared.start()
       
//        mapSetup()

//        //subscribing to onNext events for count property of viewModel.devices array and
//        //modifying UI according to the result
//        publishSubject.subscribe(onNext: { count in
//            //if viewModel.devices.count is 0, tableView is hidden and mapView spans over the entire screen
//            if count == 0 {
//                self.mapView.clear()
//                DispatchQueue.main.async {
//                    UIView.animate(withDuration: 1, animations: {
//                        self.tableView.alpha = 0
//                        self.mapView.frame.size.height = self.view.frame.size.height
//                        self.tableView.frame.origin.y = self.view.frame.maxY
//                    })
//                }
//
//                //else, tableView is showing with the list of devices and mapView takes up it's position above tableView
//            } else {
//                DispatchQueue.main.async {
//                    UIView.animate(withDuration: 1, animations: {
//                        self.mapView.frame.size.height = self.view.frame.size.height - self.tableView.frame.size.height
//                        self.tableView.frame.origin.y = self.view.frame.size.height - self.tableView.frame.size.height
//                        self.tableView.alpha = 1
//                    })
//                }
//            }
//
//        }).disposed(by: disposeBag)
//        publishSubject.onNext(viewModel.devices.count)
//
//        //Subscribe to onNext events once the device is connected
//        publishCoordSubject.subscribe(onNext: { location in
//            guard self.viewModel.devices.count != 0 else {return}
//            let row = self.tableView.indexPathForSelectedRow?.row ?? 0
//            self.viewModel.devices[row].coordinates.append(location)
//            self.drawing.drawPolylinesOn(self.mapView, forDevice: self.viewModel.devices[row])
//        }).disposed(by: disposeBag)
//        view.backgroundColor = UIColor.lightText
//
//
//        //add left and right navigationBar buttons for removing and adding new Devices
//        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Disconnect", style: .done, target: self, action: #selector(disconnectDevice))
//        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Connect", style: .done, target: self, action: #selector(connectDevice))
        
    }
    @IBAction func startAdver(_ sender: Any) {
        manager?.startAdvertising()
    }
    
    @IBAction func stopAdver(_ sender: Any) {
    }
    
    @objc func connectDevice() {
//        for device in devices {
//            viewModel.addDevice(device)
//        }
//        //Advertises onNext event once the 'viewModel.devices.count' changes
//        publishSubject.onNext(viewModel.devices.count)
//        
//        //Timer for displaying mocked CLLocations over time using publishCoordSubject
//        
//        tableView.reloadData()
    }
    @IBAction func fetch(_ sender: Any) {
        print(CoreDataManager.fetch())
    }
    @IBAction func deleteObjects(_ sender: Any) {
        CoreDataManager.delete()
    }
    
    //Remocve last Device in the array of devices
    @objc func disconnectDevice() {
//        guard viewModel.devices.count != 0 else {return}
//        //viewModel.removeLastDevice()
//        let row = tableView.indexPathForSelectedRow?.row ?? 0
//        
//        drawing.removePolyline(forDeviceTitle: viewModel.devices[row].name)
//        viewModel.removeDevice(named: viewModel.devices[row].name)  //remove specific Device.
//        
//        //Advertises onNext event once the 'viewModel.devices.count' changes
//        publishSubject.onNext(viewModel.devices.count)
//        
//        tableView.reloadData()
    }

//    func mapSetup() {
//
//        mapView.delegate = self
//        mapView.settings.compassButton = true //displays compas on the map when map heading is changed
//        mapView.settings.myLocationButton = true //displays round myLocation button
//        mapView.isMyLocationEnabled = true //enables user location
//    }
}



