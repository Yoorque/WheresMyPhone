//
//  Coordinate.swift
//  WheresMyPhone
//
//  Created by Dusan Juranovic on 10/22/18.
//  Copyright © 2018 Dusan Juranovic. All rights reserved.
//

import Foundation

struct Coordinate: CoordinateProtocol {
    var latitude: Double
    var longitude: Double
    var accuracy: Double
    var timestamp: Date
}
