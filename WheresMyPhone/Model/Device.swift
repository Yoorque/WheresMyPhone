//
//  Device.swift
//  WheresMyPhone
//
//  Created by Dusan Juranovic on 8/31/18.
//  Copyright © 2018 Dusan Juranovic. All rights reserved.
//

import RxSwift
import GoogleMaps

class Device: Comparable, DeviceProtocol {
    
    //MARK: - Properties -
    var name: String
    var uuid: String
    var coordinates: Variable<[CoordinateProtocol]>
    var timer = Timer()
    
    //MARK: - Init -
    required init(name: String, uuid: String, coordinates: Variable<[CoordinateProtocol]>) {
        self.name = name
        self.uuid = uuid
        self.coordinates = coordinates
    }
    
    convenience init(name: String, uuid: String, coordinates: Variable<[CoordinateProtocol]>, timeInterval: TimeInterval) {
        self.init(name: name, uuid: uuid, coordinates: coordinates)
        self.name = name
        self.uuid = uuid
        self.coordinates = coordinates
        timer = Timer.scheduledTimer(withTimeInterval: timeInterval, repeats: true) { _ in
            let randomNumber = Double(arc4random_uniform(7) + 1)
            let randomNumber2 = Double(arc4random_uniform(7) + 1)
            
        let newCoordinates = Coordinates(latitude: self.coordinates.value.last!.latitude + randomNumber / 100, longitude: self.coordinates.value.last!.longitude + randomNumber2 / 100, timestamp: self.coordinates.value.last!.timestamp + randomNumber, accuracy: self.coordinates.value.last!.accuracy + randomNumber)
            self.coordinates.value.append(newCoordinates)
            }
        timer.fire()
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
