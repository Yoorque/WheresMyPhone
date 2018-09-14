//
//  Constants.swift
//  WheresMyPhone
//
//  Created by Marko Trajcevic on 9/12/18.
//  Copyright © 2018 Dusan Juranovic. All rights reserved.
//
import UIKit
import CoreBluetooth

let service_uuid = "921156EE-D5B1-4606-9882-EF08A0C5769C"
let characteristic_uuid = "CBB47E80-D2B9-4339-B5D6-0F41E31D8786"
let NOTIFY_MTU = 20
let deviceName = UIDevice.current.identifierForVendor!.uuidString

let serviceUUID = CBUUID(string: service_uuid)
let characteristicUUID = CBUUID(string: characteristic_uuid)

