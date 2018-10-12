//
//  DeviceProtocol.swift
//  WheresMyPhone
//
//  Created by Dusan Juranovic on 9/17/18.
//  Copyright © 2018 Dusan Juranovic. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

///Adopting this protocol ensures that the connected device contains required data.
///- Note: In order to fully adopt to this protocol, you must adopt to Coordinate protocol as well.
///- Requires: CoordinateProtocol

protocol DeviceProtocol {
    ///Name of the device
    var name: String {get}
    ///UUID used for identifying device
    var uuid: String {get}
    ///Array of coordinates for a selected device
    var coordinates: BehaviorRelay<[CoordinateProtocol]> {get set}
    ///Exposes `selected` state of an object.
    var isSelected: Bool {get set}
    ///Required initializer for a device
    init(name: String, uuid: String, coordinates: BehaviorRelay<[CoordinateProtocol]>, isSelected: Bool)
}







