//
//  DeviceProtocol.swift
//  WheresMyPhone
//
//  Created by Dusan Juranovic on 9/17/18.
//  Copyright © 2018 Dusan Juranovic. All rights reserved.
//

import Foundation
import UIKit

///Adopting this protocol ensures that the connected device contains required data.
protocol DeviceProtocol {
    ///Name of the device
    var name: String {get}
    ///UUID used for identifying device
    var uuid: String {get}
    ///Type of the device
    var deviceType: DeviceType {get}
    ///Array of coordinates for a selected device
    var coordinates: [CoordinateProtocol] {get set}
    ///Required initializer for a device
   // init(name: String, uuid: String, coordinates: [CoordinateProtocol])
}







