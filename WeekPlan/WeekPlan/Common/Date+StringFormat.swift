//
//  Date+StringFormat.swift
//  WeekPlan
//
//  Created by Luong Minh Hiep on 8/29/17.
//  Copyright © 2017 Luong Minh Hiep. All rights reserved.
//

import UIKit

var defaultDateFormatter: DateFormatter?

extension Date {
    
    static func dateFormatter() -> DateFormatter {
        guard defaultDateFormatter != nil else {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "Y/M/d"
            defaultDateFormatter = dateFormatter
            return defaultDateFormatter!
        }
        return defaultDateFormatter!
    }
    
    func toString() -> String {
        return Date.dateFormatter().string(from: self)
    }
}

extension String {
    
    func toDate() -> Date? {
        return Date.dateFormatter().date(from: self)
    }
}
