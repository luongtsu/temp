//
//  Record.swift
//  WeekPlan
//
//  Created by Luong Minh Hiep on 8/21/17.
//  Copyright © 2017 Luong Minh Hiep. All rights reserved.
//

import Foundation

enum RecordStatus: Int {
    case open = 0
    case done
    case cancel
    case skip
    case unknow
}
/*
class Record {

    var date: Date
    var status: RecordStatus
    
    init(date: Date = Date(), status: RecordStatus = .done) {
        self.date = date
        self.status = status
    }
    
    func toAnyObject() -> Any {
        return [
            "date": date.toString(),
            "status": status.rawValue
        ]
    }
    
    class func listRecordsToAnyObject(records: [Record]) -> Any {
        return records.map({ (record) -> Any in
            return record.toAnyObject()
        })
    }
}
*/
