//
//  Device.swift
//  WheresMyPhone
//
//  Created by Dusan Juranovic on 8/31/18.
//  Copyright © 2018 Dusan Juranovic. All rights reserved.
//

import UIKit
import CoreLocation
import GoogleMaps

struct Device: Comparable {
    
    //MARK: - properties -
    let name: String
    var uuid: UUID
    var coordinates: [CLLocation]
    let image: UIImage
    
    //MARK: - init -
    init(name: String, uuid: UUID, coordinates: [CLLocation]) {
        self.name = name
        self.uuid = UIDevice.current.identifierForVendor!
        self.coordinates = coordinates
        self.image = UIImage(named: "iPhone")!.scaleImageTo(CGSize(width: 35, height: 40))
    }
    
    //satisfying Comparable protocol
    static func == (lhs: Device, rhs: Device) -> Bool {
        return lhs.name == rhs.name
    }
    
    static func < (lhs: Device, rhs: Device) -> Bool {
        return lhs.name < rhs.name
    }
}
