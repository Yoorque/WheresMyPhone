//
//  CommunicationProtocol.swift
//  WheresMyPhone
//
//  Created by Dusan Juranovic on 9/17/18.
//  Copyright © 2018 Dusan Juranovic. All rights reserved.
//

import Foundation
import UIKit

protocol CommunicationProtocol {
    var name: String {get}
    var uuid: String {get}
    var coordinates: [CoordinateProtocol] {get}
    
    func fetchDataBetween(_ startDate: Date, and endDate: Date) -> Data
}

protocol CoordinateProtocol {
    var latitude: Double {get}
    var longitude: Double {get}
    var timestamp: Date {get}
    var accuracy: Double {get}
}



