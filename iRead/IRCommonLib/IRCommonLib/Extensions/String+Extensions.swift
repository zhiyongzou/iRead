//
//  String+Extensions.swift
//  IRCommonLib
//
//  Created by zzyong on 2020/11/24.
//  Copyright © 2020 zzyong. All rights reserved.
//

import Foundation

public extension String {

    static let formateter: DateFormatter = {
        let formatter = DateFormatter()
        return formatter
    }()
    
    static let calendar = Calendar.init(identifier: .gregorian)
    
    static func formateTimeIntervalToString1(timeInterval: TimeInterval) -> String {
        let today = Date()
        let targetDate = Date.init(timeIntervalSince1970: timeInterval)
        let todayComp = calendar.dateComponents([.year, .month, .day], from: today)
        let dateComp = calendar.dateComponents([.year, .month, .day], from: targetDate)
        var dateFormat: String
        
        if todayComp.year == dateComp.year {
            if todayComp.month == dateComp.month && todayComp.day == dateComp.day {
                dateFormat = "HH:mm"
            } else {
                dateFormat = "MM-dd"
            }
        } else {
            dateFormat = "yyyy-MM-dd"
        }

        formateter.dateFormat = dateFormat
        return formateter.string(from: targetDate)
    }
    
    /// yyyy-MM-dd
    static var currentDateString: String {
        get {
            formateter.dateFormat = "yyyy-MM-dd"
            return formateter.string(from: Date())
        }
    }
}
