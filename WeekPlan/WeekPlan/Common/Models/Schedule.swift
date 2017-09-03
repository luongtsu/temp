//
//  Schedule.swift
//  WeekPlan
//
//  Created by Luong Minh Hiep on 8/21/17.
//  Copyright © 2017 Luong Minh Hiep. All rights reserved.
//

import Foundation

enum WeekDay: Int {
    case sunday = 0
    case monday
    case tuesday
    case wednesday
    case thursday
    case friday
    case saturday
    
    func shortName() -> String {
        let values = ["S", "M", "T", "W", "T", "F", "S"]
        return values[self.rawValue]
    }
    
    func fullName() -> String {
        let values = ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"]
        return values[self.rawValue]
    }
    
    static func weekDayFromDate(date: Date) -> WeekDay {
        // weekday start from 1-7, so we have to reduce 1
        let weekday = Calendar.current.component(.weekday, from: Date()) - 1
        return WeekDay(rawValue: weekday) ?? .sunday
    }
}

enum TypeOfSchedule: Int {
    
    case weekDay = 0
    case week
    case month
    
    func name() -> String {
        let values = ["Weekday", "Week", "Month"]
        return values[self.rawValue]
    }
}

class Schedule {
    
    var type: TypeOfSchedule
    var weekDays: [Int]
    var timesPerWeek: Int
    var timesPerMonth: Int
    
    init(type: TypeOfSchedule, weekDays: [Int] = [], timesPerWeek: Int = 0, timesPerMonth: Int = 0) {
        self.type = type
        self.weekDays = weekDays
        self.timesPerWeek = timesPerWeek
        self.timesPerMonth = timesPerMonth
    }
    
    class func defaultWeekDay() -> Schedule {
        return Schedule(type: .weekDay, weekDays: [1, 2, 3, 4, 5])
    }
    
    func indexes() -> (type: Int, items: [Int]) {
        switch type {
        case .weekDay: return (type.rawValue, weekDays)
        case .week: return (type.rawValue, [timesPerWeek])
        case .month: return (type.rawValue, [timesPerMonth])
        }
    }
    
    func update(typeIndex: Int, items: [Int]) {
        switch typeIndex {
        case 0:
            type = .weekDay
            if Calendar.current.firstWeekday == 2 {
                weekDays = items.map({ (index) -> Int in
                    return (index + 1) % 7
                })
            } else {
                weekDays = items
            }
        case 1:
            type = .week
            timesPerWeek = items.first ?? 1
        case 2:
            type = .month
            timesPerMonth = items.first ?? 1
        default:
            break
        }
    }
    
    func toAnyObject() -> Any {
        return [
            "type": type.rawValue,
            "weekDays": weekDays,
            "timesPerWeek": timesPerWeek,
            "timesPerMonth": timesPerMonth
        ]
    }
}
