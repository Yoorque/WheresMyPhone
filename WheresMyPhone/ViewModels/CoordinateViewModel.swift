//
//  CoordinateViewModel.swift
//  WheresMyPhone
//
//  Created by Dusan Juranovic on 10/22/18.
//  Copyright © 2018 Dusan Juranovic. All rights reserved.
//

import Foundation

struct CoordinateViewModel {
    let coordinateModel: CoordinateProtocol
    
    var latitude: Double {
        return coordinateModel.latitude
    }
    
    var longitude: Double {
    return coordinateModel.longitude
    }
    
    var accuracy: Double {
        return coordinateModel.accuracy
    }
    
    var timestamp: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy. HH:mm:ss"
        return dateFormatter.string(from: coordinateModel.timestamp)
    }
    
    var time: String {
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "HH:mm:ss"
        return timeFormatter.string(from: coordinateModel.timestamp)
    }
}
