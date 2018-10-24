//
//  UIColor+extension.swift
//  WheresMyPhone
//
//  Created by Dusan Juranovic on 10/23/18.
//  Copyright © 2018 Dusan Juranovic. All rights reserved.
//

import UIKit

extension UIColor {
    ///Extends UIColor class object to return `UIColor` depending on `speed` specified as a parameter and converts speed expressed in `m/s` into `km/h`.
    ///- Parameter speed: Speed by which color will be determined.
    ///- Returns: `UIColor` calculated from entered `speed`.
    static func colorForSpeed(_ speed: Double) -> UIColor {
        switch speed * 3.6 {
        case 0..<60:
            return .blue
        case 60..<80:
            return .green
        case 80..<100:
            return .orange
        case 100..<120:
            return .red
        case 120..<150:
            return .purple
        default:
            return .black
        }
    }
}
