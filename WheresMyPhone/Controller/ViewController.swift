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
import RxCocoa

//MARK: - Mocked data -
class ViewController: UIViewController {
    
    //MARK: - properties -
    
    let disposeBag = DisposeBag() //disposeBag for Disposables
    var mockData = MockData()
    let mapManager = MapManager()
    
    @IBOutlet weak var vcMapView: UIView!
    
    var deviceViewModel: DeviceViewModel?
    @IBOutlet weak var toggleRangeButton: UIBarButtonItem!
    let errors = PublishRelay<Error>()
    
    //MARK: - life cycle -
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapManager.setupMapFor(self, andView: vcMapView) //setup map and settings for mapView
        setupNavigationBar() //setup navigationBar
        
        //create 'deviceViewModel' from mock device
        deviceViewModel = DeviceViewModel(deviceModel: mockData.mockDevice)
        
        
        errorsObservable() // subscribe to errors observable
        trackDeviceObservable() // subscribe to device tracking onservable
    }
    
    func errorsObservable() {
        errors
            .observeOn(MainScheduler.instance)
            .map({error in
                return WMPError.deviceNotSelected // Implement switching through different errors
            })
            .subscribe(onNext: { error in
                AlertManager.errorAlert(withError: error, self) //display alert for 'onNext' error
            })
            .disposed(by: disposeBag)
    }
    
    func trackDeviceObservable() {
        deviceViewModel!.deviceModel.coordinates.asObservable()
            .subscribe(onNext: { coordinates in
                self.mapManager.displayDevice(self.deviceViewModel!) // tracking device with new coordinates
                // self.mapManager.drawPolylinesFor(self.trackedDevice) // drawing polylines
            }, onError: { error in
                self.errors.accept(error) //add error to errors observable
            }, onCompleted: {
                print("Completed")
            }, onDisposed: {
                print("Disposed")
            }).disposed(by: disposeBag)
    }
    
    //Optionaly modify automatic segue for embedded range view
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print("rangeSegue")
    }
    
    fileprivate func setupNavigationBar() {
        view.backgroundColor = UIColor.lightText //set view background color
        //TODO: - TODO -
        //Add more content to navigation bar
        //like buttons or title
    }
    
    
}

//MARK: Extensions in Extensions folder



