//
//  Date+extension.swift
//  WheresMyPhone
//
//  Created by Dusan Juranovic on 9/20/18.
//  Copyright © 2018 Dusan Juranovic. All rights reserved.
//

import Foundation
extension Date {
    func formatDate() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM HH:mm:ss"
        let formatedDate = dateFormatter.string(from: self)
        return formatedDate
    }
    
    func formatForTime() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "mm:ss"
        let formatedDate = dateFormatter.string(from: self)
        return formatedDate
    }
}
