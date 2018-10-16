//
//  Device.swift
//  WheresMyPhone
//
//  Created by Dusan Juranovic on 8/31/18.
//  Copyright © 2018 Dusan Juranovic. All rights reserved.
//

import RxSwift
import RxCocoa
import GoogleMaps

struct Device: Comparable, DeviceProtocol {
    
    //MARK: - Properties -
    var name: String
    var uuid: String
    var isSelected: BehaviorRelay<Bool>
    var coordinates: BehaviorRelay<[CoordinateProtocol]>
    
    //Satisfying Comparable protocol
    static func == (lhs: Device, rhs: Device) -> Bool {
        return lhs.name == rhs.name
    }
    
    static func < (lhs: Device, rhs: Device) -> Bool {
        return lhs.name < rhs.name
    }
}

