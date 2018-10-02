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

class Device: Comparable, DeviceProtocol {
    //MARK: - Properties -
    let name: String
    var uuid: String
    var coordinates: [CoordinateProtocol]

    //MARK: - Init -
    required init(name: String, uuid: String, coordinates: [CoordinateProtocol]) {
        self.name = name
        self.uuid = uuid
        self.coordinates = coordinates
    }
    
    //Satisfying Comparable protocol
    static func == (lhs: Device, rhs: Device) -> Bool {
        return lhs.name == rhs.name
    }
    
    static func < (lhs: Device, rhs: Device) -> Bool {
        return lhs.name < rhs.name
    }
}

struct Coordinates: CoordinateProtocol {
    var latitude: Double
    var longitude: Double
    var timestamp: Date
    var accuracy: Double
    
    init(latitude: Double, longitude: Double, timestamp: Date, accuracy: Double) {
        self.latitude = latitude
        self.longitude = longitude
        self.timestamp = timestamp
        self.accuracy = accuracy
    }
}
