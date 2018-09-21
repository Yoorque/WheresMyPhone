//
//  MockData.swift
//  WheresMyPhone
//
//  Created by Dusan Juranovic on 9/13/18.
//  Copyright © 2018 Dusan Juranovic. All rights reserved.
//

import UIKit
import CoreLocation

class MockData {
    let mockDevice = Device(name: "First", uuid: UIDevice.current.identifierForVendor!, coordinates: [CLLocation(latitude: 30, longitude: 20), CLLocation(latitude: 35, longitude: 25)])
    let mockDevice2 = Device(name: "Second", uuid: UIDevice.current.identifierForVendor!, coordinates: [CLLocation(latitude: 40, longitude: 30), CLLocation(latitude: 45, longitude: 35)])
    let mockDevice3 = Device(name: "Third", uuid: UIDevice.current.identifierForVendor!, coordinates: [CLLocation(latitude: 50, longitude: 40), CLLocation(latitude: 55, longitude: 45)])
    let mockDevice4 = Device(name: "Fourth", uuid: UIDevice.current.identifierForVendor!, coordinates: [CLLocation(latitude: 60, longitude: 50), CLLocation(latitude: 65, longitude: 55)])
    let viewModel: DeviceViewModel
    let devices: [Device]
    init() {
         devices = [mockDevice, mockDevice2, mockDevice3, mockDevice4]
         viewModel = DeviceViewModel(devices: devices)
    }
    //Mock movement of the devices on the screen by adding random coordinates
    func mockedDataWithTimer(for viewController: ViewController, and tableView: UITableView) {
        Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            guard let row = tableView.indexPathForSelectedRow?.row else {return}
            guard self.viewModel.devices.count != 0 else {return}
            
            let lat = viewController.viewModel.devices[row].coordinates.last!.coordinate.latitude
            let lon = viewController.viewModel.devices[row].coordinates.last!.coordinate.longitude
            
            //Produce new random coordinates every 'timeInterval' seconds
            let randomNumber = Double(arc4random_uniform(5))
            let randomNumber1 = Double(arc4random_uniform(5))
            
            //create CLLocation object to be sent
            let cll = CLLocation(coordinate: CLLocationCoordinate2D(latitude: CLLocationDegrees(lat + randomNumber), longitude: CLLocationDegrees(lon + randomNumber1)), altitude: 2, horizontalAccuracy: 2, verticalAccuracy: 2, course: 2, speed: CLLocationSpeed(randomNumber), timestamp: Date() + TimeInterval(randomNumber))
            
            //advertise onNext event with newly created CLLocation object
            viewController.publishCoordSubject.onNext(cll)
        }
    }
}
