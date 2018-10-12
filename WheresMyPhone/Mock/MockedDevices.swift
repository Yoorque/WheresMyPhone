//
//  MockedDevices.swift
//  WheresMyPhone
//
//  Created by Dusan Juranovic on 10/2/18.
//  Copyright © 2018 Dusan Juranovic. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class MockedDevices: DeviceProtocol {
    var name: String
    var uuid: String
    var coordinates: BehaviorRelay<[CoordinateProtocol]>
    var isSelected: Bool
    
    required init(name: String, uuid: String, coordinates: BehaviorRelay<[CoordinateProtocol]>, isSelected: Bool) {
        self.name = name
        self.uuid = uuid
        self.coordinates = coordinates
        self.isSelected = isSelected
    }
    
    convenience init(name: String, uuid: String, coordinates: BehaviorRelay<[CoordinateProtocol]>, isSelected: Bool, timeInterval: TimeInterval) {
        self.init(name: name, uuid: uuid, coordinates: coordinates, isSelected: isSelected)
        self.name = name
        self.uuid = uuid
        self.coordinates = coordinates
        
        let timer = Timer.scheduledTimer(withTimeInterval: timeInterval, repeats: true) { _ in
            let randomNumber = Double(arc4random_uniform(7) + 1)
            let randomNumber2 = Double(arc4random_uniform(7) + 1)
            
            let newCoordinates = Coordinates(latitude: self.coordinates.value.last!.latitude + randomNumber / 100, longitude: self.coordinates.value.last!.longitude + randomNumber2 / 100, timestamp: self.coordinates.value.last!.timestamp + randomNumber, accuracy: self.coordinates.value.last!.accuracy + randomNumber)
            self.coordinates.accept(coordinates.value + [newCoordinates])
        }
        timer.fire()
    }
}
