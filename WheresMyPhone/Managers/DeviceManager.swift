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

enum Error: String {
    case NoCoordinatesError = "No avaliable coordinates"
    case TransferError = "TransferError"
}

class DeviceManager: DeviceManagerProtocol {
    var devices = BehaviorRelay<[DeviceProtocol]>(value: [])
    let mapManager = MapManager.sharedInstance
    
    func getDateRangeFor(_ device: DeviceProtocol, startDate: Date, endDate: Date) -> (Observable<CoordinateProtocol>, Int) {
        let filteredCoordinates = device.coordinates.value.filter {$0.timestamp >= startDate && $0.timestamp <= endDate}
        return fetchDataFor(filteredCoordinates)
    }
    
    func liveTrack(_ device: DeviceProtocol) -> Observable<DeviceProtocol> {
        let observable = Observable<DeviceProtocol>.just(device)
        return observable
    }
    
    func fetchDataFor(_ coordinates: [CoordinateProtocol]) -> (Observable<CoordinateProtocol>, Int) {
        let publish = PublishSubject<CoordinateProtocol>()
        let queue = DispatchQueue.init(label: "TemoSerialQueue")
        
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
    
    func addDevice(_ device: DeviceProtocol) {
        devices.accept(devices.value + [device])
    }
    
    func removeDevice(at indexPath: IndexPath) {
        var temp = devices.value
        temp.remove(at: indexPath.row)
        devices.accept(temp)
    }
}
