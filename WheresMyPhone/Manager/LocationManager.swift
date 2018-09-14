//
//  LocationManager.swift
//  WheresMyPhone
//
//  Created by Marko Trajcevic on 9/11/18.
//  Copyright © 2018 Dusan Juranovic. All rights reserved.
//

import Foundation
import CoreLocation
import RxSwift

class LocationManager: NSObject {
    
    private let locationViewModel = DeviceLocationViewModel()
    
    public static let shared = LocationManager()
   
    
    private lazy var location: CLLocationManager = {
        var location = CLLocationManager()
        location.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        location.pausesLocationUpdatesAutomatically = true
        location.allowsBackgroundLocationUpdates = true
        location.delegate = self
        
        return location
    }()
    
    
    private override init() {
        super.init()
    }
    
    // Start with updating location and checks For
    public func start() {
        if CLLocationManager.locationServicesEnabled() == false {
            print("Service is not available")
            return
        }
        let status = CLLocationManager.authorizationStatus()
        if  status == .denied || status == .restricted {
            print("LocationManagaer status is : \(status) ")
        } else {
            location.startUpdatingLocation()
        }
    }
    
    // Stop with updating location
    
    public func stop() {
        location.stopUpdatingLocation()
        BackgroundTaskManager.shared.drain()
    }
    
}
extension LocationManager: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        let data = location.toModel()
        locationViewModel.subject.onNext(data)
        locationViewModel.saveLocation()
        
        BackgroundTaskManager.shared.new()
    }
}

