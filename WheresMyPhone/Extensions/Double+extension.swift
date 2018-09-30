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
     Converts m/s into *String* representation od km/h.
     - Author:
     Dusan Juranovic
     - Note:
     This is an extension of the *Double* class.
     */
    var toStringOfKPH: String {
        return "\((self * 3.6).rounded()) km/h"
    }
}
