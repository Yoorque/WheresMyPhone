//
//  Date+extension.swift
//  WheresMyPhone
//
//  Created by Dusan Juranovic on 9/20/18.
//  Copyright © 2018 Dusan Juranovic. All rights reserved.
//

import Foundation
extension Date {
    /**
     Converts *Date* object to *String* representation
     - Author:
    Dusan Juranovic
     - Format:
        - "dd-MM HH:mm:ss" (days-months hours:minutes:seconds)
     - Example:
        - *21-08 14:23:57*
     */
    var stringOfDate: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM HH:mm:ss"
        let formatedDate = dateFormatter.string(from: self)
        return formatedDate
    }
    
    /**
     Converts *Date* object to *String* representation
     - Author:
     Dusan Juranovic
     - Format:
        - "mm:ss" (minutes:seconds)
     - Example:
        - *23:57*
     */
    
    var stringOfTime: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "mm:ss"
        let formatedDate = dateFormatter.string(from: self)
        return formatedDate
    }
}
