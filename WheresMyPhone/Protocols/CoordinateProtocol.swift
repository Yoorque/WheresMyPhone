//
//  CoordinateProtocol.swift
//  WheresMyPhone
//
//  Created by Dusan Juranovic on 10/22/18.
//  Copyright © 2018 Dusan Juranovic. All rights reserved.
//

import Foundation

///This protocol ensures that all of the eligible devices will provide needed data.
protocol CoordinateProtocol {
    ///Latitude of the device coordinate.
    var latitude: Double {get set}
    ///Longitude of the device coordinate.
    var longitude: Double {get set}
    ///Accuracy of the device coordinate.
    var accuracy: Double {get set}
    ///Timestamp of the device coordinate.
    var timestamp: Date {get set}
}
