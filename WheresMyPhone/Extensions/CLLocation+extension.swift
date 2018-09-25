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
    var toKm: String {
        return self > 1000 ? "\(self.rounded() / 1000) km" : "\(Int(self.rounded())) meters"
    }
}
