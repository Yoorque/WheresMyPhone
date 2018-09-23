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
    let mockDevice = Device(name: "First", uuid: UIDevice.current.identifierForVendor!, coordinates: [
        Coordinates(latitude: 30.0, longitude: 20.0, timestamp: Date(), speed: 0, accuracy: 3)])
    let mockDevice2 = Device(name: "Second", uuid: UIDevice.current.identifierForVendor!, coordinates: [
        Coordinates(latitude: 50.0, longitude: 30.0, timestamp: Date(), speed: 0, accuracy: 3)])
    let mockDevice3 = Device(name: "Third", uuid: UIDevice.current.identifierForVendor!, coordinates: [
        Coordinates(latitude: 15.0, longitude: 10.0, timestamp: Date(), speed: 0, accuracy: 3)])
    
    let mockDevice4 = Device(name: "Fourth", uuid: UIDevice.current.identifierForVendor!, coordinates: [
        Coordinates(latitude: 40.0, longitude: 40.0, timestamp: Date(), speed: 0, accuracy: 3)])
    
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
            guard viewController.viewModel.devices.count != 0 else {return}
            
            let lat = viewController.viewModel.devices[row].coordinates.last!.latitude
            let lon = viewController.viewModel.devices[row].coordinates.last!.longitude
            let accuracy = viewController.viewModel.devices[row].coordinates.last!.accuracy
            
            //Produce new random coordinates every 'timeInterval' seconds
            let randomNumber = Double(arc4random_uniform(5))
            let randomNumber1 = Double(arc4random_uniform(5))
            
            //create CLLocation object to be sent
            let cll = CLLocation(coordinate: CLLocationCoordinate2D(latitude: CLLocationDegrees(lat + randomNumber / 10), longitude: CLLocationDegrees(lon + randomNumber1 / 10)), altitude: 2, horizontalAccuracy: accuracy, verticalAccuracy: 2, course: 2, speed: CLLocationSpeed(randomNumber), timestamp: viewController.viewModel.devices[row].coordinates.last!.timestamp + 1)
            
            //advertise onNext event with newly created CLLocation object
            viewController.publishCoordSubject.onNext(cll)
        }
    }
}
