//
//  DeviceViewModel.swift
//  WheresMyPhone
//
//  Created by Dusan Juranovic on 8/31/18.
//  Copyright © 2018 Dusan Juranovic. All rights reserved.
//

import UIKit
import RxSwift
import GoogleMaps

//DeviceViewModel can accept any data type that adopts DeviceProtocol and subsequently CoordinateProtocol as one of the requirements for 'devices' array

class DeviceViewModel {
    
    //MARK: - Properties -
    var devices: [Device]

    //MARK: - Init -
    init(devices: [Device]) {
        self.devices = devices
    }
    
    //MARK: - Helper methods -
    //Add device method
    func addDevice(_ device: Device) -> Bool {
        if !devices.contains(where: {$0.name == device.name}) {
            print("Adding \(device.name)")
            devices.append(device)
            return true
        } else {
            print("\(device.name) is already added.")
            return false
        }
    }
    
    //Remove device methods
    func removeLastDevice() {
        if !devices.isEmpty { //Check is the array is empty
            print("Removed \(devices.last!.name)")
            devices.removeLast() //Remove last item in the array
        }
    }
    
     func removeDevice(named name: String) {
        for (index, device) in devices.enumerated() { //Enumerate devices array to get the index of each element
            if !devices.isEmpty { //Check if the array is empty
                if device.name == name { //Compare device.name with passed in name
                    print("Removing \(device.name)")
                    //devices[index].coordinates = []
                    
                    devices.remove(at: index) //Remove element with matching name if it exists in the array
                }
            }
        }
    }
}

