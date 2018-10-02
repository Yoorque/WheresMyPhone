//
//  MockedDevices.swift
//  WheresMyPhone
//
//  Created by Dusan Juranovic on 10/2/18.
//  Copyright © 2018 Dusan Juranovic. All rights reserved.
//

import Foundation
import CoreLocation

class MockedDevices {

    static let mock1 = Device(name: "Dusan", uuid: "D-u-s-a-n", deviceType: .CellPhone, coordinates: [Coordinates(latitude: 40.0, longitude: 30.0, timestamp: Date(), accuracy: 0),
                                                                       Coordinates(latitude: 40.5, longitude: 30.5, timestamp: Date(), accuracy: 0),
                                                                       Coordinates(latitude: 41.0, longitude: 31.0, timestamp: Date(), accuracy: 0)])
    static let mock2 = Device(name: "Marko", uuid: "M-a-r-k-o", deviceType: .SmartWatch, coordinates: [Coordinates(latitude: 42.0, longitude: 32.0, timestamp: Date(), accuracy: 0),
                                                                       Coordinates(latitude: 42.5, longitude: 32.5, timestamp: Date(), accuracy: 0),
                                                                       Coordinates(latitude: 43.0, longitude: 32.0, timestamp: Date(), accuracy: 0)])
}
