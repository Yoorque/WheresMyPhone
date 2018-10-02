//
//  CoordinateProtocol.swift
//  WheresMyPhone
//
//  Created by Dusan Juranovic on 10/2/18.
//  Copyright © 2018 Dusan Juranovic. All rights reserved.
//

import Foundation

///Ensures that the coordinates contained in the connected device coordinates property are of required type
protocol CoordinateProtocol {
    ///Latitude of the connected device's location
    var latitude: Double {get}
    ///Longitude of the connected device's location
    var longitude: Double {get}
    ///Timestamp of the connected device's location
    var timestamp: Date {get}
    ///Accuracy of the connected device's location
    var accuracy: Double {get}
}
