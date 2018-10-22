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

//DeviceViewModel can accept any data type that conforms to to DeviceProtocol and subsequently CoordinateProtocol as one of the requirements for coordinates property.

struct DeviceViewModel {
    
    let deviceModel: DeviceProtocol
    
    //MARK: - properties -
    var name: String {
        return deviceModel.name
    }
    
    var uuid: String {
        return "UUID: \(deviceModel.uuid)"
    }
    
    var coordinates: [CoordinateViewModel] {
        var coordArray = [CoordinateViewModel]()
        for coordinate in deviceModel.coordinates.value {
            let coord = CoordinateViewModel(coordinateModel: coordinate)
            coordArray.append(coord)
        }
        return coordArray
    }
    
    
}

