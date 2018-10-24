//
//  WMPError.swift
//  WheresMyPhone
//
//  Created by Dusan Juranovic on 10/23/18.
//  Copyright © 2018 Dusan Juranovic. All rights reserved.
//

import Foundation

enum WMPError: Error, LocalizedError {
    case deviceNotFound
    case noNewCoordinates
    case deviceNotSelected
    case unknownError(Error)
    
    var recoveryInstruction: String? {
        switch self {
        case .deviceNotFound:
            return "No available devices."
        case .noNewCoordinates:
            return "Device has no new coordinates."
        case .deviceNotSelected:
            return "Select the device from the list first."
        case .unknownError(let error):
            return "Unknown error \(error)"
        }
    }
}
