//
//  Device.swift
//  WheresMyPhone
//
//  Created by Dusan Juranovic on 8/31/18.
//  Copyright © 2018 Dusan Juranovic. All rights reserved.
//

import UIKit

struct DeviceLocation: Codable {
    
    let deviceName: String
    let longitude: Double
    let latitude: Double
    let timestamp: Date

}
