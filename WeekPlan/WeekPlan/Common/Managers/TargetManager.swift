//
//  TargetManager.swift
//  WeekPlan
//
//  Created by Luong Minh Hiep on 8/11/17.
//  Copyright © 2017 Luong Minh Hiep. All rights reserved.
//

import Foundation
import Firebase

class TargetManager {
    
    static let notifyATargetIsChanged = "NotifyATargetIsChanged"
    static let notifyListOfTargetIsChanged = "NotifyListOfTargetIsChanged"
    
    private let keyToSaveData: String = "ScheduleManager_SaveDataKey"
    
    static let shared = TargetManager()
    
    var allTargets: [Target] = []
    var todayTargetOpen: [Target] = []
    var todayTargetDone: [Target] = []
    var todayTargetCancel: [Target] = []
    var todayTargetSkip: [Target] = []
    var otherTargetAll: [Target] = []
    
    var rootRef: DatabaseReference
    var targetRef: DatabaseReference
    
    private var observerKey: UInt = 0
    
    init() {
        rootRef = Database.database().reference(withPath: "week-plan")
        targetRef = rootRef.child("target")
        observerKey = observerTargetChanges()
    }

    func updateTargetLists() {
        otherTargetAll.removeAll()
        todayTargetDone.removeAll()
        todayTargetOpen.removeAll()
        todayTargetSkip.removeAll()
        todayTargetCancel.removeAll()
        
        for item in allTargets {
            switch item.todayRecordStatus() {
            case .open: todayTargetOpen.append(item)
            case .done: todayTargetDone.append(item)
            case .cancel: todayTargetCancel.append(item)
            case .skip: todayTargetSkip.append(item)
            case .unknow: otherTargetAll.append(item)
            }
        }
    }
    
    private func observerTargetChanges() -> UInt {
        let handler = targetRef.observe(.value, with: { [weak self] (snapShot) in
            guard let `self` = self else { return }
            var fetchedTargets: [Target] = []
            for item in snapShot.children {
                let target = Target(snapshot: item as! DataSnapshot)
                fetchedTargets.append(target)
            }
            self.allTargets = fetchedTargets
            self.didLoadData()
        })
        return handler
    }
    
    private func didLoadData() {
        targetRef.removeObserver(withHandle: observerKey)
        updateTargetLists()
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: TargetManager.notifyListOfTargetIsChanged), object: nil, userInfo: nil)
    }
}

extension TargetManager {
    
    func didEditTarget(target: Target) {

        // Update to FireBase
        targetRef.updateChildValues(["\(target.key)" : target.toAnyObject()])
        
        updateTargetLists()
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: TargetManager.notifyListOfTargetIsChanged), object: target, userInfo: nil)
    }

    func addNewTarget(target: Target) {
        
        // Add to FireBase
        let createdTargetRef = targetRef.child(target.key)
        createdTargetRef.setValue(target.toAnyObject())
        
        allTargets.append(target)
        updateTargetLists()
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: TargetManager.notifyListOfTargetIsChanged), object: target, userInfo: nil)
    }
    
    func removeTarget(target: Target) {
       
        // Remove from FireBase
        let createdTargetRef = targetRef.child(target.key)
        createdTargetRef.removeValue()
        
        allTargets = allTargets.filter({ (item) -> Bool in
            return item.key != target.key
        })
        updateTargetLists()
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: TargetManager.notifyListOfTargetIsChanged), object: target, userInfo: nil)
    }
    
    func updateTargetStatus(target: Target, type: ButtonMenuType) {
        let recordKey = Date().toString()
        switch type {
        case .done: target.records[recordKey] = RecordStatus.done
        case .cancel: target.records[recordKey] = RecordStatus.cancel
        case .skip: target.records[recordKey] = RecordStatus.skip
        case .undo: target.records.removeValue(forKey: recordKey)
        default: break
        }
        
        // Update to FireBase
        let targetR = targetRef.child(target.key)
        targetR.updateChildValues(["records" : target.recordToObject()])
        
        updateTargetLists()
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: TargetManager.notifyListOfTargetIsChanged), object: target, userInfo: nil)
    }
}
