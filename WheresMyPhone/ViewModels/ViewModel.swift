//
//  DeviceViewModel.swift
//  WheresMyPhone
//
//  Created by Dusan Juranovic on 10/15/18.
//  Copyright © 2018 Dusan Juranovic. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class ViewModel {
    var devices = BehaviorRelay<[(name: String, uuid: String)]>(value: [])
    
    func addDevice(_ device: (name: String, uuid: String)) {
        devices.accept(devices.value + [(device.name, device.uuid)])
    }
    
    func removeDevice(AtIndex row: Int) {
        var temp = devices.value
        temp.remove(at: row)
        devices.accept(temp)
    }
}
