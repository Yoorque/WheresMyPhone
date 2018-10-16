//
//  CoordinateModel.swift
//  WheresMyPhone
//
//  Created by Dusan Juranovic on 10/12/18.
//  Copyright © 2018 Dusan Juranovic. All rights reserved.
//

import Foundation

struct Coordinates:Comparable, CoordinateProtocol {
    var latitude: Double
    var longitude: Double
    var timestamp: Date
    var accuracy: Double
    
    static func ==(lhs: Coordinates, rhs: Coordinates) -> Bool {
        return lhs.timestamp == rhs.timestamp
    }
    
    static func <(lhs: Coordinates, rhs: Coordinates) -> Bool {
        return lhs.timestamp < rhs.timestamp
    }
}
