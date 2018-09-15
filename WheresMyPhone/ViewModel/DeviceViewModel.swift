//
//  DeviceViewModel.swift
//  WheresMyPhone
//
//  Created by Dusan Juranovic on 8/31/18.
//  Copyright © 2018 Dusan Juranovic. All rights reserved.
//

import UIKit
import RxSwift

class DeviceLocationViewModel {
    
    public let subject = PublishSubject<DeviceLocation>()
    private let disposeBag = DisposeBag()
    
    func saveLocation() {
        BackgroundTaskManager.shared.new()
        let newLocation = Location(context: CoreDataManager.context)
        subject.subscribe(onNext: {
            newLocation.latitude = $0.latitude
            newLocation.longitude = $0.longitude
            newLocation.timestamp = $0.timestamp
            newLocation.deviceName = $0.deviceName
        
            CoreDataManager.saveContext()
            
        }).disposed(by: disposeBag)
    }
    
    
        
        
    
    
    
    
    
}

