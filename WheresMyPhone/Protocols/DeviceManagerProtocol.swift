//
//  DeviceManagerProtocol.swift
//  WheresMyPhone
//
//  Created by Dusan Juranovic on 10/2/18.
//  Copyright © 2018 Dusan Juranovic. All rights reserved.
//

import Foundation
import RxSwift

///Adopting to this Protocol ensures that the central device will have the necessary methods for fetching data from the connected devices.
protocol DeviceManagerProtocol {
    ///Requests date range for a selected device.
    ///- Parameter device: Represents selected device.
    ///- Parameter startDate: Start of a date range.
    ///- Parameter endDate: End of a date range.
    ///- Returns: Observable sequence of CoordinateProtocol objects within given `Date` range.
    func getDateRangeFor(_ device: DeviceProtocol, startDate: Date, endDate: Date) -> (Observable<CoordinateProtocol>, Int)
    
    ///Initiates scanning for peripherals.
    func scanForPeripherals() -> Observable<(name: String, uuid: String)>
    
    ///Stops scanning for peripherals.
    func stopScanForPeripherals()
    /**
    Connects to a selected peripheral by its `name` parameter.
    - Parameter name: Name of a device we wish to connect to.
    - Note: You can also use `UUID` to connect to a device, with `connectTo(uuid:)` optional method.
    ```
    func connectTo(_ uuid: String)
    ```
    */
    func connectTo(_ name: String)
    
    ///Requests all of the coordinates data from a connected device.
    ///- Note: This is an `Optional` method.
    ///- Parameter device: Device that provides the data.
    ///- Warning: Calling this method might cause large amount of data to be transferred, which can be time consuming.
    ///- Returns: Observable sequence of CoordinateProtocol objects.
    func syncDataFor(_ device: DeviceProtocol) -> (Observable<CoordinateProtocol>, Int)
}

extension DeviceManagerProtocol {
    ///Connects to a selected peripheral by its `UUID` parameter.
    ///- Parameter uuid: UUID of a device we wish to connect to.
    func connectTo(_ uuid: String){}
}


