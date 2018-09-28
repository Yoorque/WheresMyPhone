//
//  CLLocationDistance+extension.swift
//  WheresMyPhone
//
//  Created by Dusan Juranovic on 9/24/18.
//  Copyright © 2018 Dusan Juranovic. All rights reserved.
//

import UIKit
import CoreLocation

extension CLLocationDistance {
    /**
    Converts meters represented as Double into String
     - Author:
     Dusan Juranovic
     - Important:
         - Double < 1000 is represented in meters
         - Double > 1000 is represented in km
    */
    var toKm: String {
        return self > 1000 ? "\(self.rounded() / 1000) km" : "\(Int(self.rounded())) meters"
    }
}
