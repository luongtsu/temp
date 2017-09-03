//
//  Target.swift
//  WeekPlan
//
//  Created by Luong Minh Hiep on 8/7/17.
//  Copyright © 2017 Luong Minh Hiep. All rights reserved.
//

import UIKit
import Firebase

class Target {
    
    // generated id
    var key: String = Util.generatedId()
    
    // info
    var name: String
    var iconName: String
    var note: String
    var tintColor: Color
    var dateStarted: Date = Date()
    
    // schedule
    var schedule: Schedule = .defaultWeekDay()

    // records
    var records: [String:RecordStatus] = [:]
    var bestStreak: Int = 0
    
    init(key: String = Util.generatedId(), name: String, iconName: String, note: String, tintColor: Color, dateStarted: Date = Date(), schedule: Schedule = .defaultWeekDay(), bestStreak: Int = 0) {
        self.key = key
        self.name = name
        self.iconName = iconName
        self.note = note
        self.tintColor = tintColor
        self.dateStarted = dateStarted
        self.schedule = schedule
        self.bestStreak = bestStreak
    }
    
    init(snapshot: DataSnapshot) {
        key = snapshot.key
        let snapshotValue = snapshot.value as! [String: AnyObject]
        
        name = snapshotValue["name"] as? String ?? "Unknow"
        iconName = snapshotValue["iconName"] as? String ?? TargetCategory.fitnessCenter.info().iconName
        note = snapshotValue["note"] as? String ?? ""
        tintColor = Color(rawValue: snapshotValue["tintColor"] as? Int ?? 0) ?? .categoryColor1
        dateStarted =  (snapshotValue["dateStarted"] as? String ?? "").toDate() ?? Date()
        bestStreak = snapshotValue["bestStreak"] as? Int ?? 0
        schedule = Schedule(data: snapshotValue["schedule"] as? [String: Any] ?? [:])
        records = Target.objectToRecords(object: snapshotValue["records"] as? [String: Int] ?? [:])
    }
    
    func toAnyObject() -> Any {
        var dict = [
            "name": name,
            "iconName": iconName,
            "tintColor": tintColor.rawValue,
            "dateStarted": dateStarted.toString(),
            "bestStreak": bestStreak,
            "schedule": schedule.toAnyObject(),
            "records": recordToObject()
        ]
        if !note.isEmpty {
            dict["note"] = note
        }
        return dict
    }
    
    func recordToObject() -> Any {
        var dictResult: [String:Int] = [:]
        for (key, value) in records {
            dictResult[key] = value.rawValue
        }
        return dictResult
    }
    
    static func objectToRecords(object: [String: Int]) -> [String: RecordStatus] {
        var fetchedRecords: [String: RecordStatus] = [:]
        for (key, value) in object {
            fetchedRecords[key] = RecordStatus(rawValue: value)
        }
        return fetchedRecords
    }
}

extension Target {

    // MARK: - STREAK
    
    func currentStreak() -> Int {
        var doneRecords = records
        for (key, value) in records where value != RecordStatus.done {
            doneRecords.removeValue(forKey: key)
        }
        let dateStrings = doneRecords.keys
        let dayIntervalInSecond: TimeInterval = -24*60*60
        var lastDate = Date.init(timeIntervalSinceNow: dayIntervalInSecond)
        var streakCounter = 0
        var shouldContinue = true
        if dateStrings.contains(Date().toString()) {
            streakCounter += 1
        }
        while shouldContinue {
            if dateStrings.contains(lastDate.toString()) {
                streakCounter += 1
                lastDate = Date(timeInterval: dayIntervalInSecond, since: lastDate)
            } else {
                shouldContinue = false
            }
        }
        return streakCounter
    }
    
    func currentStreakDescription() -> String {
        let streakNumber = currentStreak()
        if streakNumber > 1 {
            return "\(streakNumber) streaks in a row"
        }
        if streakNumber == 1 {
            return "\(streakNumber) streak in a row"
        }
        if Calendar.current.isDate(dateStarted, inSameDayAs: Date()) {
            return "New track"
        } else {
            return "Overdue"
        }
    }
    
    // MARK: - Weekly done status
    
    func weekDoneStatusDates(givenDate: Date) -> [Int] {
        let recordStates = recordStateForWeek(givenDate: givenDate)
        var doneDateIndexes: [Int] = []
        for index in 0...6 {
            let status = recordStates[index]
            if status == .done {
                doneDateIndexes.append(index)
            }
        }
        return doneDateIndexes
    }
    
    // MARK: - RecordStatus
    
    func recordStatusForGivenDate(date: Date) -> RecordStatus {
        let dateString = date.toString()
        guard let recordStatus = records[dateString] else {
            return .unknow
        }
        return recordStatus
    }
    
    func recordStateForWeek(givenDate: Date) -> [RecordStatus] {
        let dates = Util.datesOfWeek(givenDate: givenDate)
        let status = dates.map { (date) -> RecordStatus in
            return recordStatusForGivenDate(date: date)
        }
        return status
    }
    
    func recordStateForMonth(givenDate: Date) -> [RecordStatus] {
        let dates = Util.datesOfMonth(givenDate: givenDate)
        let status = dates.map { (date) -> RecordStatus in
            return recordStatusForGivenDate(date: date)
        }
        return status
    }
    
    func todayRecordStatus() -> RecordStatus {
        let status = recordStatusForGivenDate(date: Date())
        guard status == .unknow else {
            return status
        }
        
        switch schedule.type {
        case .week:
            let numberDone = recordStateForWeek(givenDate: Date()).filter { $0 == RecordStatus.done }
            if numberDone.count <= schedule.timesPerWeek {
                return .open
            } else {
                return .unknow
            }
        case .month:
            let numberDone = recordStateForMonth(givenDate: Date()).filter { $0 == RecordStatus.done }
            if numberDone.count <= schedule.timesPerMonth {
                return .open
            } else {
                return .unknow
            }
        case .weekDay:
            if schedule.weekDays.contains(WeekDay.weekDayFromDate(date: Date()).rawValue) {
                return .open
            } else {
                return .unknow
            }
        }
    }
}
