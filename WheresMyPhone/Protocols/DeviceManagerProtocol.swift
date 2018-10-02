//
//  DeviceManagerProtocol.swift
//  WheresMyPhone
//
//  Created by Dusan Juranovic on 10/2/18.
//  Copyright © 2018 Dusan Juranovic. All rights reserved.
//

import Foundation

///Adopting to this Protocol ensures that the central device will have the necessary methods for fetching data from the connected device.
protocol DeviceManagerProtocol {
    ///Requests date range for a selected device.
    ///- Parameter device: Represents selected device.
    ///- Parameter startDate: Start date of a date range.
    ///- Parameter endDate: End date of a date range.
    func getDateRangeFor(_ device: DeviceProtocol, startDate: Date, endDate: Date)
    
    ///Provides tracking of a connected device by drawing devices's current location on a map.
    ///- Parameter device: Tracked device
    mutating func liveTrack(_ device: DeviceProtocol)
}

extension DeviceManagerProtocol {
    ///Requests all of the coordinates data from a connected device.
    ///- Parameter device: Device that provides the data
    ///- Warning: Calling this method might cause large amount of data to be transferred, which can be time consuming.
    func syncDataFor(_ device: DeviceProtocol){}
}
