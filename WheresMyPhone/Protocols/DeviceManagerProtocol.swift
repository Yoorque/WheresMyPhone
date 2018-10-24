//
//  DeviceManagerProtocol.swift
//  WheresMyPhone
//
//  Created by Dusan Juranovic on 10/22/18.
//  Copyright © 2018 Dusan Juranovic. All rights reserved.
//

import Foundation

///This protocol provides methods for retrieval of data from connected devices.
protocol DeviceManagerProtocol {
    ///Syncs all of the available data from a connected device.
    ///- Returns: Array of coordinates from a connected device.
    func syncDataFor(_ device: DeviceProtocol) -> ([CoordinateProtocol], Int)
    
    ///Fetches data from a connected device, between specified dates.
    ///- Returns: Array of coordinates from a connected device.
    func getDataBetween(_ startDate: Date, and endDate: Date) -> ([CoordinateProtocol], Int)
}
