//
//  DeviceManager.swift
//  WheresMyPhone
//
//  Created by Dusan Juranovic on 10/2/18.
//  Copyright © 2018 Dusan Juranovic. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

var mockArrayOfDevices = [
    MockedDevices(name: "Dusan's phone" , uuid: "D-u-s-a-n", coordinates: BehaviorRelay<[CoordinateProtocol]>(value: [
Coordinates(latitude: 40.0, longitude: 30.0, timestamp: Date(), accuracy: 0),
Coordinates(latitude: 40.5, longitude: 30.5, timestamp: Date() + 30, accuracy: 0)]), isSelected: BehaviorRelay<Bool>(value: false), timeInterval: 1),
    
    MockedDevices(name: "Marko's iWatch", uuid: "M-a-r-k-o", coordinates: BehaviorRelay<[CoordinateProtocol]>(value: [
Coordinates(latitude: 42.0, longitude: 32.0, timestamp: Date(), accuracy: 0),
Coordinates(latitude: 42.5, longitude: 32.5, timestamp: Date() + 30, accuracy: 0)]), isSelected: BehaviorRelay<Bool>(value: false), timeInterval: 2)]

enum WMPError: Error, LocalizedError {
    case deviceNotFound
    case noNewCoordinates
    case deviceNotSelected
    case unknownError(Error)
    
    var recoveryInstruction: String? {
        switch self {
        case .deviceNotFound:
            return "No available devices."
        case .noNewCoordinates:
            return "Device has no new coordinates."
        case .deviceNotSelected:
            return "Select the device from the list first."
        case .unknownError(let error):
            return "Unknown error \(error)"
        }
    }
}


class DeviceManager: DeviceManagerProtocol {
    var viewModel = ViewModel()
    
    func getDateRangeFor(_ device: DeviceProtocol, startDate: Date, endDate: Date) -> (Observable<CoordinateProtocol>, Int) {
        let filteredCoordinates = device.coordinates.value.filter {$0.timestamp >= startDate && $0.timestamp <= endDate}
        return fetchDataFor(filteredCoordinates)
    }
    
    func scanForPeripherals() -> Observable<DeviceProtocol> {
        let publish = PublishSubject<DeviceProtocol>()
        let queue = DispatchQueue.init(label: "TempSerialQueue")
        
        queue.async {
            mockArrayOfDevices.forEach({ (device) in
                Thread.sleep(forTimeInterval: 0.01)
                print("isSelected: \(device.isSelected.value)")
                publish.onNext(device)
            })
            publish.onCompleted()
        }
        return publish
    }
    
    func connectTo(_ peripheral: DeviceProtocol) -> Observable<DeviceProtocol>{
        return Observable.create { observer in
            observer.onNext(peripheral)
            return Disposables.create()
        }
    }
    
    func fetchDataFor(_ coordinates: [CoordinateProtocol]) -> (Observable<CoordinateProtocol>, Int) {
        let publish = PublishSubject<CoordinateProtocol>()
        let queue = DispatchQueue.init(label: "TempSerialQueue")
        
        queue.async {
            coordinates.forEach({ (coordinate) in
                Thread.sleep(forTimeInterval: 0.01)
                publish.onNext(coordinate)
            })
            publish.onCompleted()
        }
        return (publish, coordinates.count)
    }
    
    func syncDataFor(_ device: DeviceProtocol) -> (Observable<CoordinateProtocol>, Int) {
        return fetchDataFor(device.coordinates.value)
    }
}
