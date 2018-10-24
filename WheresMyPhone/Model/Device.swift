//
//  Device.swift
//  WheresMyPhone
//
//  Created by Dusan Juranovic on 8/31/18.
//  Copyright © 2018 Dusan Juranovic. All rights reserved.
//

import UIKit
import CoreLocation
import GoogleMaps
import RxCocoa

class Device: Comparable, DeviceProtocol {
    
    //MARK: - properties -
    var name: String
    var uuid: String
    var coordinates: BehaviorRelay<[CoordinateProtocol]>
    
    //MARK: - init -
    init(name: String, uuid: String, coordinates: BehaviorRelay<[CoordinateProtocol]>) {
        self.name = name
        self.uuid = UIDevice.current.identifierForVendor!.uuidString
        self.coordinates = coordinates
        
        //Used to mock arrival of new coordinates by appending it to the array.
        Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            let randomNumber = Double(arc4random_uniform(9)) - 3
            let randomNumber2 = Double(arc4random_uniform(9)) - 3
            let positiveTimeRandom = Double(arc4random_uniform(8) + 1)
            
            let newCoordinate = Coordinate(latitude: self.coordinates.value.last!.latitude + randomNumber / 1000, longitude: self.coordinates.value.last!.longitude + randomNumber2 / 1000, accuracy: 0, timestamp: self.coordinates.value.last!.timestamp + 7 * positiveTimeRandom)
            self.coordinates.accept(coordinates.value + [newCoordinate])
        }.fire()
    }
    
    //satisfying Comparable protocol
    static func == (lhs: Device, rhs: Device) -> Bool {
        return lhs.name == rhs.name
    }
    
    static func < (lhs: Device, rhs: Device) -> Bool {
        return lhs.name < rhs.name
    }
}
