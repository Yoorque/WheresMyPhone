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

struct Device: Comparable, CommunicationProtocol {
    //MARK: - properties -
    let name: String
    var uuid: String
    var coordinates: [CoordinateProtocol]
    let image: UIImage
    
    //MARK: - init -
    init(name: String, uuid: UUID, coordinates: [CoordinateProtocol]) {
        self.name = name
        self.uuid = UIDevice.current.identifierForVendor!.uuidString
        self.coordinates = coordinates
        self.image = UIImage(named: "iPhone")!.scaleImageTo(CGSize(width: 35, height: 40))
    }
    
    func fetchDataBetween(_ startDate: Date, and endDate: Date) -> Data {
        print("Fetching data")
        return Data()
    }
    
    
    //satisfying Comparable protocol
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
