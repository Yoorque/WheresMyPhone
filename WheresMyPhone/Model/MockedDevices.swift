//
//  MockedDevices.swift
//  WheresMyPhone
//
//  Created by Dusan Juranovic on 10/2/18.
//  Copyright © 2018 Dusan Juranovic. All rights reserved.
//

import Foundation

class MockedDevices {
    static let mock1 = Device(name: "Dusan's phone" , uuid: "D-u-s-a-n", coordinates: [Coordinates(latitude: 40.0, longitude: 30.0, timestamp: Date(), accuracy: 0),
                                                                       Coordinates(latitude: 40.5, longitude: 30.5, timestamp: Date(), accuracy: 0),
                                                                       Coordinates(latitude: 41.0, longitude: 31.0, timestamp: Date(), accuracy: 0)])
    static let mock2 = Device(name: "Marko's iWatch", uuid: "M-a-r-k-o", coordinates: [Coordinates(latitude: 42.0, longitude: 32.0, timestamp: Date(), accuracy: 0),
                                                                       Coordinates(latitude: 42.5, longitude: 32.5, timestamp: Date(), accuracy: 0),
                                                                       Coordinates(latitude: 43.0, longitude: 32.0, timestamp: Date(), accuracy: 0)])
    
    static func mockMovementFor(vc: ViewController)  {
        Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            let selectedDevice = vc.deviceManager.devices.value[vc.selectedRow!]
            let randomNumber = Double(arc4random_uniform(7) + 1)
            let randomNumber2 = Double(arc4random_uniform(7) + 1)
            
            let newCoordinates = Coordinates(latitude: selectedDevice.coordinates.last!.latitude + randomNumber / 100, longitude: selectedDevice.coordinates.last!.longitude + randomNumber2 / 100, timestamp: selectedDevice.coordinates.last!.timestamp + randomNumber, accuracy: selectedDevice.coordinates.last!.accuracy + randomNumber)
            vc.newCoordinates.onNext(newCoordinates)
        }.fire()
    }
}
