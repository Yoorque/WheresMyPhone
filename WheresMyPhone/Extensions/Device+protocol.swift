//
//  Device+protocol.swift
//  WheresMyPhone
//
//  Created by Dusan Juranovic on 9/7/18.
//  Copyright © 2018 Dusan Juranovic. All rights reserved.
//

import UIKit
import GoogleMaps
// 'Device' struct requires that any object that wants to be a 'Device' object, needs to adopt DeviceProtocol in order to provide neccesary properties.

//MARK: - protocol -
protocol DeviceProtocol {
    var name: String {get}
    var uuid: UUID {get}
    var coordinates: [CLLocation] {get set}
}

