//
//  DeviceProtocol.swift
//  WheresMyPhone
//
//  Created by Dusan Juranovic on 10/22/18.
//  Copyright © 2018 Dusan Juranovic. All rights reserved.
//

import Foundation
import RxCocoa

///In order to be eligible, a device needs to conform to this protocol and subsequently, CoordinateProtocol
protocol DeviceProtocol {
    ///Name of the device.
    var name: String {get set}
    ///UUID of the device.
    var uuid: String {get set}
    ///Coordinates of the device.
    ///- Note: Coordinates need to conform to CoordinateProtocol.
    var coordinates: BehaviorRelay<[CoordinateProtocol]> {get set}
}
