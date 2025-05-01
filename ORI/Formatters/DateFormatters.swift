//
//  DateFormat.swift
//  ORI
//
//  Created by Song Kim on 4/14/25.
//

import Foundation

class DateFormat {
    static func onlyDay(date: Date) -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let dateString = dateFormatter.string(from: date)
        return dateString
    }
    
    static func dayTime(str: String) -> String {
        let components = str.split(separator: "T")
        if components.count > 1 {
            let formattedString = components[0] + " " + components[1].prefix(5)
            return String(formattedString)
        }
        return ""
    }
}
