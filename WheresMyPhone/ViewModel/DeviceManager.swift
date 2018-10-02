//
//  DeviceManager.swift
//  WheresMyPhone
//
//  Created by Dusan Juranovic on 10/2/18.
//  Copyright © 2018 Dusan Juranovic. All rights reserved.
//

import Foundation
import RxSwift

class DeviceManager: DeviceManagerProtocol {
    
    let devices = Variable<[DeviceProtocol]>([])
    let mapManager = MapManager.sharedInstance
    
    func getDateRangeFor(_ device: DeviceProtocol, startDate: Date, endDate: Date) {
        print("Fetching range between \(startDate) and \(endDate) for Device: \(device.name)")
    }
    
    func liveTrack(_ device: DeviceProtocol) {
        print("Live tracking \(device.name)")
        trackDevice(device)
    }
    
    private func trackDevice(_ device: DeviceProtocol) {
        mapManager.addMarkerFor(device)
        mapManager.drawPolylinesFor(device)
    }
    
    func addDevice(_ device: DeviceProtocol) {
        devices.value.append(device)
        mapManager.addMarkerFor(device)
    }
    
    func syncDataFor(_ device: DeviceProtocol) {
        print("Syncing data for \(device.name)")
    }
}
