//
//  CoordinateModel.swift
//  WheresMyPhone
//
//  Created by Dusan Juranovic on 10/12/18.
//  Copyright © 2018 Dusan Juranovic. All rights reserved.
//

import Foundation

struct Coordinates: CoordinateProtocol {
    var latitude: Double
    var longitude: Double
    var timestamp: Date
    var accuracy: Double
    
    init(latitude: Double, longitude: Double, timestamp: Date, accuracy: Double) {
        self.latitude = latitude
        self.longitude = longitude
        self.timestamp = timestamp
        self.accuracy = accuracy
    }
}
