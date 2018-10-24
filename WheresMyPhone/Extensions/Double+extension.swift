//
//  Double+extension.swift
//  WheresMyPhone
//
//  Created by Dusan Juranovic on 9/6/18.
//  Copyright © 2018 Dusan Juranovic. All rights reserved.
//

import Foundation

extension Double {
    func toStringOfkmPerHour() -> String {
        return "\((self * 3.6).rounded()) km/h"
    }
}
