//
//  MockData.swift
//  WheresMyPhone
//
//  Created by Dusan Juranovic on 9/13/18.
//  Copyright © 2018 Dusan Juranovic. All rights reserved.
//

import UIKit
import RxCocoa

class MockData {
    let mockDevice = Device(name: "First: ".appending(UIDevice.current.name), uuid: UIDevice.current.identifierForVendor!.uuidString, coordinates: BehaviorRelay<[CoordinateProtocol]>(value: [Coordinate(latitude: 30, longitude: 20, accuracy: 0, timestamp: Date()), Coordinate(latitude: 30.5, longitude: 20.5, accuracy: 0, timestamp: Date() + 5)]))
    let mockDevice2 = Device(name: "Second: ".appending(UIDevice.current.name), uuid: UIDevice.current.identifierForVendor!.uuidString, coordinates: BehaviorRelay<[CoordinateProtocol]>(value: [Coordinate(latitude: 40, longitude: 30, accuracy: 0, timestamp: Date()), Coordinate(latitude: 45, longitude: 35, accuracy: 0, timestamp: Date())]))
    let mockDevice3 = Device(name: "Third: ".appending(UIDevice.current.name), uuid: UIDevice.current.identifierForVendor!.uuidString, coordinates: BehaviorRelay<[CoordinateProtocol]>(value: [Coordinate(latitude: 50, longitude: 40, accuracy: 0, timestamp: Date()), Coordinate(latitude: 55, longitude: 45, accuracy: 0, timestamp: Date())]))
    let mockDevice4 = Device(name: "Fourth: ".appending(UIDevice.current.name), uuid: UIDevice.current.identifierForVendor!.uuidString, coordinates: BehaviorRelay<[CoordinateProtocol]>(value: [Coordinate(latitude: 60, longitude: 50, accuracy: 0, timestamp: Date()), Coordinate(latitude: 65, longitude: 55, accuracy: 0, timestamp: Date())]))
}
