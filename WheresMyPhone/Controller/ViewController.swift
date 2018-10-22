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
    
    let disposeBag = DisposeBag() //disposeBag for Disposables
    var mockData = MockData()
    let mapManager = MapManager()
    
    @IBOutlet weak var vcMapView: UIView!
    var trackedDevice: DeviceViewModel!
    //var deviceViewModel: DeviceViewModel?
    
    //MARK: - life cycle -
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapManager.setupMapFor(self, andView: vcMapView)//setup settings for mapView
        setupNavigationBar() //setup navigationBar buttons
        
        trackedDevice = DeviceViewModel(deviceModel: mockData.mockDevice)
        
        trackedDevice.deviceModel.coordinates.asObservable()
            .subscribe(onNext: { coordinates in
                self.mapManager.displayDevice(self.trackedDevice)
                self.mapManager.drawPolylinesFor(self.trackedDevice)
            }).disposed(by: disposeBag)
        
    }
    
    fileprivate func setupNavigationBar() {
        view.backgroundColor = UIColor.lightText //set view background color
    }
}

//MARK: Extensions in Extensions folder
extension ViewController: GMSMapViewDelegate {
    
}



