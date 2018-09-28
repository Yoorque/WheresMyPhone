//
//  Double+extension.swift
//  WheresMyPhone
//
//  Created by Dusan Juranovic on 9/6/18.
//  Copyright © 2018 Dusan Juranovic. All rights reserved.
//

import UIKit

extension Double {
    /**
     Converts m/s into *String* representation od km/h
     
     - Author:
     Dusan Juranovic
     */
    func toStringOfkPH() -> String {
        return "\((self * 3.6).rounded()) km/h"
    }
}
