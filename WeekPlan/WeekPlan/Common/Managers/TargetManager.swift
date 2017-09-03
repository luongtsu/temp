//
//  TargetManager.swift
//  WeekPlan
//
//  Created by Luong Minh Hiep on 8/11/17.
//  Copyright © 2017 Luong Minh Hiep. All rights reserved.
//

import Foundation

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
    
    init() {
        loadTargets()
    }
    
    func loadTargets() {
        // Load from UserDefault
        allTargets = []
        let loadedData = UserDefaults.standard.object(forKey: keyToSaveData) as? Data
        if let `loadedData` = loadedData {
            let items = NSKeyedUnarchiver.unarchiveObject(with: `loadedData`) as? [Target]
            if let `items` = items {
                allTargets.append(contentsOf: items)
            }
        }
        
        // Split into sub set
        updateTargetLists()
    }
    
    func saveCurrentData() {
        // Save to UserDefault
        let dataToSave = NSKeyedArchiver.archivedData(withRootObject: allTargets)
        UserDefaults.standard.set(dataToSave, forKey: keyToSaveData)
    }

    func updateTargetLists() {
        otherTargetAll.removeAll()
        todayTargetDone.removeAll()
        todayTargetOpen.removeAll()
        todayTargetSkip.removeAll()
        todayTargetCancel.removeAll()
        
        // TODO: rewrite this
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
}

extension TargetManager {
    
    func didEditTarget(target: Target) {
        //saveCurrentData()
        updateTargetLists()
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: TargetManager.notifyListOfTargetIsChanged), object: target, userInfo: nil)
    }

    func addNewTarget(target: Target) {
        allTargets.append(target)
        //saveCurrentData()
        updateTargetLists()
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: TargetManager.notifyListOfTargetIsChanged), object: target, userInfo: nil)
    }
    
    func removeTarget(target: Target) {
        allTargets = allTargets.filter({ (item) -> Bool in
            return item.key != target.key
        })
        //saveCurrentData()
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
        updateTargetLists()
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: TargetManager.notifyListOfTargetIsChanged), object: target, userInfo: nil)
    }
    
    func noyifyAboutTargetChange(target: Target) {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: TargetManager.notifyATargetIsChanged), object: target, userInfo: nil)
    }
}
