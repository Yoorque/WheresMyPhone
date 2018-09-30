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
     Converts meters represented as a number, into *String*.
     - Author:
     Dusan Juranovic
     - Remark:
        * Numbers < 1000 are represented in meters
        * Numbers > 1000 are represented in km
     - Note:
     This is an extension of the CLLocationDistance *class*.
     */
    var toKm: String {
        return self > 1000 ? "\(self.rounded() / 1000) km" : "\(Int(self.rounded())) meters"
    }
}
