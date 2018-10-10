//
//  MockedDevices.swift
//  WheresMyPhone
//
//  Created by Dusan Juranovic on 10/2/18.
//  Copyright © 2018 Dusan Juranovic. All rights reserved.
//

import Foundation
import RxSwift

class MockedDevices {
    
    let mock1 = Device(name: "Dusan's phone" , uuid: "D-u-s-a-n", coordinates: Variable<[CoordinateProtocol]>([
        Coordinates(latitude: 40.0, longitude: 30.0, timestamp: Date(), accuracy: 0),
        Coordinates(latitude: 40.5, longitude: 30.5, timestamp: Date() + 30, accuracy: 0)]) , timeInterval: 1)
    
     let mock2 = Device(name: "Marko's iWatch", uuid: "M-a-r-k-o", coordinates: Variable<[CoordinateProtocol]>([
        Coordinates(latitude: 42.0, longitude: 32.0, timestamp: Date(), accuracy: 0),
        Coordinates(latitude: 42.5, longitude: 32.5, timestamp: Date() + 30, accuracy: 0)]), timeInterval: 2)
    
}
