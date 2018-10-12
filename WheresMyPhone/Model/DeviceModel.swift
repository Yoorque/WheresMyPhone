//
//  Device.swift
//  WheresMyPhone
//
//  Created by Dusan Juranovic on 8/31/18.
//  Copyright © 2018 Dusan Juranovic. All rights reserved.
//

import RxSwift
import GoogleMaps

class DeviceModel: Comparable {
    
    //MARK: - Properties -
    var name: BehaviorSubject<String>
    var uuid: BehaviorSubject<String>
    
    var coordinates: BehaviorSubject<[CoordinateProtocol]>
    
    //MARK: - Init -
    required init(name: BehaviorSubject<String>, uuid: BehaviorSubject<String>, coordinates: BehaviorSubject<[CoordinateProtocol]>) {
        self.name = name
        self.uuid = uuid
        self.coordinates = coordinates
    }
    
    
    //Satisfying Comparable protocol
    static func == (lhs: DeviceModel, rhs: DeviceModel) -> Bool {
        return try! lhs.name.value() == rhs.name.value()
    }
    
    static func < (lhs: DeviceModel, rhs: DeviceModel) -> Bool {
        return try! lhs.name.value() < rhs.name.value()
    }
}

