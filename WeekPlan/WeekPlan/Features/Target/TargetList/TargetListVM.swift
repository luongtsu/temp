//
//  TargetListVM.swift
//  WeekPlan
//
//  Created by Luong Minh Hiep on 7/14/17.
//  Copyright © 2017 Luong Minh Hiep. All rights reserved.
//

import UIKit

protocol TargetListPresenter: class {
    func updateTableViewCellHeight()
    func reloadTableView()
    func deselectRow(indexPath: IndexPath)
    func makeRowVisible(indexPath: IndexPath)
    
    func gotoAddTimeToTargetScreen(observer: TargetListUpdatable, target: Target)
    func gotoAddNewTargetScreen(observer: TargetListUpdatable)
    func gotoEditTargetScreen(observer: TargetListUpdatable, target: Target)
}

protocol TargetListUpdatable: class {
    func addNewTarget(target: Target)
    func didEditTarget(target: Target)
    func didRemoveTarget(target: Target)
    func didAddTimeToTarget(target: Target)
}

class TargetListVM: BaseViewControllerPresentable {
    
    weak var presenter: TargetListPresenter?
    fileprivate var currentSelectedIndexPath: IndexPath?
    
    func pageTitle() -> String {
        return "Targets"
    }
    
    func viewDidLoad() {
        presenter?.reloadTableView()
    }
    
    required init(presenter: TargetListPresenter?) {
        self.presenter = presenter
        registerNotification()
    }
    
    deinit {
        unregisterNotification()
    }
    
    private func registerNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(targetIsChanged(notification:)), name:NSNotification.Name(rawValue: TargetManager.notifyListOfTargetIsChanged), object: nil)
    }
    
    private func unregisterNotification() {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc private func targetIsChanged(notification: Notification) {
        self.presenter?.reloadTableView()
    }
    
    func didSelectMenuOption(type: ButtonMenuType, indexPath: IndexPath) {
        currentSelectedIndexPath = nil
        DispatchQueue.global().asyncAfter(deadline: .now() + 0.2) { [weak self] _ in
            guard let `self` = self else { return }
            var sectionItems: [Target]
            switch indexPath.section {
            case 0: sectionItems = TargetManager.shared.todayTargetOpen
            case 1: sectionItems = TargetManager.shared.todayTargetDone
            case 2: sectionItems = TargetManager.shared.todayTargetCancel
            case 3: sectionItems = TargetManager.shared.todayTargetSkip
            case 4: sectionItems = TargetManager.shared.otherTargetAll
            default: sectionItems = TargetManager.shared.allTargets
            }
            let item = sectionItems[indexPath.row % sectionItems.count]
            switch type {
            case .edit:  self.presenter?.gotoEditTargetScreen(observer: self, target: item)
            case .done, .cancel, .skip, .undo: TargetManager.shared.updateTargetStatus(target: item, type: type)
            default: break
            }
            self.presenter?.reloadTableView()
        }
    }
}

// MARK: - TargetListUpdatable

extension TargetListVM: TargetListUpdatable {

    func addNewTarget(target: Target) {
        currentSelectedIndexPath = nil
        TargetManager.shared.addNewTarget(target: target)
        presenter?.reloadTableView()
    }
    
    func didEditTarget(target: Target) {
        currentSelectedIndexPath = nil
        TargetManager.shared.didEditTarget(target: target)
        presenter?.reloadTableView()
    }
    
    func didRemoveTarget(target: Target) {
        currentSelectedIndexPath = nil
        TargetManager.shared.removeTarget(target: target)
        presenter?.reloadTableView()
    }
    
    func didAddTimeToTarget(target: Target) {
        currentSelectedIndexPath = nil
        // TODO: update time recorded to target
        presenter?.reloadTableView()
    }
}

// MARK: - TargetListPresentable

extension TargetListVM: TargetListPresentable {
    
    func addNewTargetButtonPressed() {
        presenter?.gotoAddNewTargetScreen(observer: self)
    }
}

// MARK: - TableViewPresentable

extension TargetListVM: TableViewPresentable {
    
    func numberOfSection() -> Int {
        return 6
    }
    
    func numberOfRows(inSection section: Int) -> Int {
        switch section {
        case 0: return TargetManager.shared.todayTargetOpen.count
        case 1: return TargetManager.shared.todayTargetDone.count
        case 2: return TargetManager.shared.todayTargetCancel.count
        case 3: return TargetManager.shared.todayTargetSkip.count
        case 4: return TargetManager.shared.otherTargetAll.count
        case 5: return TargetManager.shared.allTargets.isEmpty ? 1 : 0
        default: return 0
        }
    }
    
    func heightForHeader(inSection section: Int) -> CGFloat {
        switch section {
        case 0: return TargetManager.shared.todayTargetOpen.isEmpty ? 0 : TableHeaderFooterView.defaultHeight
        case 1:
            let totalTargetChecked = TargetManager.shared.todayTargetDone.count + TargetManager.shared.todayTargetSkip.count + TargetManager.shared.todayTargetCancel.count
            return totalTargetChecked == 0 ? 0 : TableHeaderFooterView.defaultHeight
        case 4: return TargetManager.shared.otherTargetAll.isEmpty ? 0 : TableHeaderFooterView.defaultHeight
        default: return 0
        }
    }
    
    func viewModelForHeader(inSection section: Int) -> Any? {
        switch section {
        case 0: return TargetManager.shared.todayTargetOpen.isEmpty ? nil : TableHeaderFooterVM(title: "Today tracks", image: UIImage(named: "ic_wb_sunny_36pt")?.maskWithColor(color: Color.categoryColor4.value()))
        case 1:
            let totalTargetChecked = TargetManager.shared.todayTargetDone.count + TargetManager.shared.todayTargetSkip.count + TargetManager.shared.todayTargetCancel.count
            return totalTargetChecked == 0 ? nil : TableHeaderFooterVM(title: "Checked", image: UIImage(named: "ic_done_36pt")?.maskWithColor(color: Color.categoryColor2.value()))
        case 4: return TargetManager.shared.otherTargetAll.isEmpty ? nil : TableHeaderFooterVM(title: "Others", image: UIImage(named: "ic_gps_fixed_36pt")?.maskWithColor(color: Color.categoryColor5.value()))
        default: return nil
        }
    }
    
    func heightForRow(atIndexPath indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 5 {
            return  TargetManager.shared.allTargets.isEmpty ? 150 : 0
        } else {
            guard let currentIndexPath = currentSelectedIndexPath else {
                return Style1TableCell.cellHeightNormal
            }
            if currentIndexPath == indexPath {
                return Style1TableCell.cellHeightExpanded
            } else {
                return Style1TableCell.cellHeightNormal
            }
        }
    }
    
    func estimatedHeightForRow(atIndexPath indexPath: IndexPath) -> CGFloat {
        return heightForRow(atIndexPath: indexPath)
    }
    
    func viewModelForCell(atIndexPath indexPath: IndexPath) -> Any? {
        
        guard indexPath.section < 5 else {
            return Style6TableCellVM(title: "There is no habit in track.\n It's time to plan your new habit and make it real now.\n JUST DO IT", font: Font.title, textColor: Color.themeColorHaflAlpha.value(), textAlignment: .center, separatorStyle: .noLine)
        }
        
        var foundTarget: Target?
        let index = indexPath.row
        switch indexPath.section {
        case 0: foundTarget =  TargetManager.shared.todayTargetOpen.count > index ? TargetManager.shared.todayTargetOpen[index] : nil
        case 1: foundTarget =  TargetManager.shared.todayTargetDone.count > index ? TargetManager.shared.todayTargetDone[index] : nil
        case 2: foundTarget = TargetManager.shared.todayTargetCancel.count > index ? TargetManager.shared.todayTargetCancel[index] : nil
        case 3: foundTarget = TargetManager.shared.todayTargetSkip.count > index ? TargetManager.shared.todayTargetSkip[index] : nil
        case 4: foundTarget = TargetManager.shared.otherTargetAll.count > index ? TargetManager.shared.otherTargetAll[index] : nil
        default: break
        }
        
        guard let target = foundTarget else {
            return nil
        }
        
        var isSelected = false
        if let selectedIndex = currentSelectedIndexPath, selectedIndex == indexPath {
            isSelected = true
        }
        
        return Style1TableCellVM(tintColor: target.tintColor.value(), leftImageName: target.iconName, topTitle: target.name, middleTitle: target.currentStreakDescription(), setOfActiveIndicator: target.weekDoneStatusDates(givenDate: Date()), doneStatus: target.todayRecordStatus(), isSelected: isSelected, shouldAlwaysHideMenuView: false, selectable: false) { [weak self] (type) in
            guard let `self` = self else { return }
            self.didSelectMenuOption(type: type, indexPath: indexPath)
        }
    }
    
    func didSelectRow(indexPath: IndexPath) {
        print("didSelectRow \(indexPath.description)")
        
        // update row height
        defer {
            presenter?.updateTableViewCellHeight()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.35) { [weak self] _ in
                guard let `self` = self else { return }
                self.presenter?.makeRowVisible(indexPath: indexPath)
            }
        }
        
        // nothing was selected before
        guard let currentIndexPath = currentSelectedIndexPath else {
            currentSelectedIndexPath = indexPath
            return
        }
        
        // deselect previous selected row
        presenter?.deselectRow(indexPath: currentIndexPath)
        
        // remember new indexPath
        if  currentIndexPath != indexPath {
            currentSelectedIndexPath = indexPath
        } else {
            currentSelectedIndexPath = nil
        }
    }
}
