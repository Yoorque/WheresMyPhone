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
     Converts *Date* object into a full date *String* representation.
     - Author:
     Dusan Juranovic
     - Remark:
     Output format will be "dd-MM HH:mm:ss" (days-months hours:minutes:seconds).
     For example *21-08 14:23:57*
     - Note:
     This is an extension of the *Date* class.
     */
        var stringOfDate: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM HH:mm:ss"
        let formatedDate = dateFormatter.string(from: self)
        return formatedDate
    }
    /**
     Converts *Date* object into a mm:ss *String* representation.
     - Author:
     Dusan Juranovic
     - Remark:
     Output format will be "mm:ss" (minutes:seconds).
     For example *23:57*
     - Note:
     This is an extension of the *Date* class.
     */
    var stringOfTime: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "mm:ss"
        let formatedDate = dateFormatter.string(from: self)
        return formatedDate
    }
}
