//
//  EditTargetVM.swift
//  WeekPlan
//
//  Created by Luong Minh Hiep on 8/5/17.
//  Copyright © 2017 Luong Minh Hiep. All rights reserved.
//

import UIKit

protocol EditTargetPresenter: class {
    func updateTableViewCellHeight()
    func reloadTableView()
    func reloadTableViewRow(indexPaths: [IndexPath])
    func deselectRow(indexPath: IndexPath)
    
    func backToPreviousScreen()
    func gotoSelectCategoryBlock(tintColor: UIColor?, iconName: String?, completion: SelectCategoryCompletion?)
}

class EditTargetVM: BaseViewControllerPresentable {
    
    fileprivate let weekDayTextTitles = ["I will do it on these days", "Number of days I will do in a week", "Number of days I will do in a month"]
    
    var target: Target? = nil
    weak var presenter: EditTargetPresenter?
    weak var observer: TargetListUpdatable?
    
    var selectedCategory: TargetCategory = .fitnessCenter
    var selectedTintColor: UIColor = Color.categoryColor1.value()
    
    fileprivate var nameCellVM: Style2TableCellVM!
    fileprivate var iconCellVM: Style5TableCellVM!
    fileprivate var scheduleTypeCellVM: Style7TableCellVM!
    fileprivate var weekDayCellVMs: [Style7TableCellVM] = []
    fileprivate var noteCellVM: Style3TableCellVM!
    fileprivate var deleteCellVM: Style6TableCellVM!
    
    func pageTitle() -> String {
        if isOnEdittingMode() {
            return "Edit target"
        } else {
            return "Add new target"
        }
    }
    
    func viewDidLoad() {
        presenter?.reloadTableView()
    }
    
    required init(observer: TargetListUpdatable? = nil, target: Target? = nil, presenter: EditTargetPresenter?) {
        self.observer = observer
        self.target = target
        self.presenter = presenter
        
        if let `target` = target {
            selectedCategory = TargetCategory.categoryOfIconName(target.iconName)
        }
        
        initCellVMs()
    }
    
    fileprivate func isOnEdittingMode() -> Bool {
        guard target != nil else {
            return false
        }
        return true
    }
    
    private func initCellVMs() {
        
        nameCellVM = Style2TableCellVM(title: "Name(*): ", textFieldContent: nil, textFieldPlaceHolder: "Enter target's name here", separatorStyle: .fullLine)
        iconCellVM = Style5TableCellVM(title: "Icon & color", iconName: selectedCategory.info().iconName, tintColor: selectedTintColor, selectable: true, separatorStyle: .fullLine)
        
        var scheduleStackLayout = Style7StackLayout(top: -5, left: 30, defaultItemWidth: 80, itemWidths: [])
        if Util.isPad() {
            scheduleStackLayout.left = 100
            scheduleStackLayout.defaultItemWidth = 160
        }
        
        scheduleTypeCellVM = Style7TableCellVM(items: ["Daily", "Weekly", "Monthly"], font: Font.title, textColor: Color.themeColor.value(), bgColorNormal: Color.selectionItemBackgroundNormal.value(), bgColorSelected: Color.selectionItemBackgroundSelected.value(), isMultipleChoice: false, selectedIndex: [0], stackLayout: scheduleStackLayout, optionChangeObservable: self, separatorStyle: .noLine)
        
        var weekStackLayout = Style7StackLayout(top: -5, left: 16, defaultItemWidth: 40, itemWidths: [])
        if Util.isPad() {
            weekStackLayout.left = 100
            weekStackLayout.defaultItemWidth = 60
        }
        
        var daysOfWeek = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]
        if Calendar.current.firstWeekday == 2 {
            daysOfWeek = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"]
        }
        
        let weekDayCellVM_1 = Style7TableCellVM(items: daysOfWeek, font: Font.title, textColor: Color.themeColor.value(), bgColorNormal: Color.selectionItemBackgroundNormal.value(), bgColorSelected: Color.selectionItemBackgroundSelected.value(), isMultipleChoice: true, selectedIndex: [0], stackLayout: weekStackLayout, separatorStyle: .noLine)
        
        let weekDayCellVM_2 = Style7TableCellVM(items: ["1", "2", "3", "4", "5", "6", "7"], font: Font.title, textColor: Color.themeColor.value(), bgColorNormal: Color.selectionItemBackgroundNormal.value(), bgColorSelected: Color.selectionItemBackgroundSelected.value(), isMultipleChoice: false, selectedIndex: [0], stackLayout: weekStackLayout, separatorStyle: .noLine)
        
        let weekDayCellVM_3 = Style7TableCellVM(items: ["1", "2", "3", "4", "5", "6", "7"], font: Font.title, textColor: Color.themeColor.value(), bgColorNormal: Color.selectionItemBackgroundNormal.value(), bgColorSelected: Color.selectionItemBackgroundSelected.value(), isMultipleChoice: false, selectedIndex: [0], stackLayout: weekStackLayout, separatorStyle: .noLine)
        
        noteCellVM = Style3TableCellVM(title: "Note:", textViewContent: nil, separatorStyle: .noLine)
        
        if isOnEdittingMode() {
            noteCellVM.separatorStyle = .fullLine
        }
        deleteCellVM = Style6TableCellVM(title: "Delete", font: Font.titleBold, textColor: UIColor.red, separatorStyle: .fullLine)
        
        if let `target` = target {
            nameCellVM.textFieldContent = target.name
            iconCellVM.iconName = target.iconName
            iconCellVM.tintColor = target.tintColor.value()
            
            scheduleTypeCellVM.selectedIndex = [target.schedule.indexes().type]
            let items = target.schedule.indexes().items
            switch scheduleTypeCellVM.selectedIndex[0] {
            case 0:
                if Calendar.current.firstWeekday == 2 {
                    weekDayCellVM_1.selectedIndex = items.map({ (index) -> Int in
                        if index > 0 {
                            return index - 1
                        } else {
                            return 6
                        }
                    })
                } else {
                    weekDayCellVM_1.selectedIndex = items
                }
            case 1: weekDayCellVM_2.selectedIndex = items
            default: weekDayCellVM_3.selectedIndex = items
            }
            
            noteCellVM.textViewContent = target.note
        }
        
        weekDayCellVMs = [weekDayCellVM_1, weekDayCellVM_2, weekDayCellVM_3]
        
    }
    
    func doneButtonPressed() {
        var scheduleModeIndex = 0
        if let index = scheduleTypeCellVM.selectedIndex.first {
            scheduleModeIndex = index % 3
        }
        
        if let `target` = target {
            target.name = nameCellVM.textFieldContent ?? "Unknow"
            target.note = noteCellVM.textViewContent ?? ""
            target.iconName = iconCellVM.iconName
            target.tintColor = Color.itemOfColor(givenColor: iconCellVM.tintColor) ?? Color.categoryColor1
            let scheduleSubItems = weekDayCellVMs[scheduleModeIndex].selectedIndex
            target.schedule.update(typeIndex: scheduleModeIndex, items: scheduleSubItems)
            observer?.didEditTarget(target: target)
            
            TargetManager.shared.noyifyAboutTargetChange(target: target)
        } else {
            let createdSchedule = Schedule.defaultWeekDay()
            let scheduleSubItems = weekDayCellVMs[scheduleModeIndex].selectedIndex
            createdSchedule.update(typeIndex: scheduleModeIndex, items: scheduleSubItems)
            
            let createdTarget = Target(name: nameCellVM.textFieldContent ?? "Unknow", iconName: iconCellVM.iconName, note: noteCellVM.textViewContent ?? "", tintColor: Color.itemOfColor(givenColor: iconCellVM.tintColor) ?? Color.categoryColor1, schedule: createdSchedule)
            observer?.addNewTarget(target: createdTarget)
            
            TargetManager.shared.noyifyAboutTargetChange(target: createdTarget)
        }
        presenter?.backToPreviousScreen()
    }
}

extension EditTargetVM: TableViewPresentable {
    
    func numberOfSection() -> Int {
        return 1
    }
    
    func numberOfRows(inSection section: Int) -> Int {
        if isOnEdittingMode() {
            return 8
        } else {
            return 7
        }
    }
    
    func heightForHeader(inSection section: Int) -> CGFloat {
        return 0
    }
    
    func viewModelForHeader(inSection section: Int) -> Any? {
        return nil
    }
    
    func heightForRow(atIndexPath indexPath: IndexPath) -> CGFloat {
        
        switch indexPath.row {
        case 0: return Style2TableCell.cellHeightNormal
        case 1: return Style5TableCell.cellHeightNormal
        case 2: return Style6TableCell.cellHeightNormal
        case 3: return Style7TableCell.cellHeightNormal
        case 4: return Style6TableCell.cellHeightNormal
        case 5: return Style7TableCell.cellHeightNormal
        case 6: return Style3TableCell.cellHeightNormal
        case 7: return Style6TableCell.cellHeightNormal
        default: return 0
        }
    }
    
    func estimatedHeightForRow(atIndexPath indexPath: IndexPath) -> CGFloat {
        return heightForRow(atIndexPath: indexPath)
    }
    
    func viewModelForCell(atIndexPath indexPath: IndexPath) -> Any? {
        switch indexPath.row {
        case 0: return nameCellVM
        case 1: return iconCellVM
        case 2: return Style6TableCellVM(title: "Schedule of habit", font: Font.title, textColor: Color.themeColor.value(), textAlignment: .left, separatorStyle: .noLine)
        case 3: return scheduleTypeCellVM
        case 4:
            var scheduleModeIndex = 0
            if let index = scheduleTypeCellVM.selectedIndex.first {
                scheduleModeIndex = index % 3
            }
            return Style6TableCellVM(title: weekDayTextTitles[scheduleModeIndex], font: Font.title, textColor: Color.themeColor.value(), textAlignment: .left, separatorStyle: .noLine)
        case 5:
            var scheduleModeIndex = 0
            if let index = scheduleTypeCellVM.selectedIndex.first {
                scheduleModeIndex = index % 3
            }
            return weekDayCellVMs[scheduleModeIndex]
        case 6: return noteCellVM
        case 7: return deleteCellVM
        default: return nil
        }
    }
    
    func didSelectRow(indexPath: IndexPath) {
        print("didSelectRow \(indexPath.description)")
        
        // update row height
        defer {
            presenter?.updateTableViewCellHeight()
        }
        
        // deselect previous selected row
        presenter?.deselectRow(indexPath: indexPath)
        
        if indexPath.row == 1 {
            presenter?.gotoSelectCategoryBlock(tintColor: selectedTintColor, iconName: selectedCategory.info().iconName, completion: { [weak self] (selectedCategory) in
                guard let `self` = self else { return }
                self.iconCellVM.iconName = selectedCategory.1
                self.iconCellVM.tintColor = selectedCategory.0
                self.selectedCategory = TargetCategory.categoryOfIconName(selectedCategory.1)
                self.selectedTintColor = selectedCategory.0
            })
        }
        
        if indexPath.row == 7, let `target` = target {
            Util.showCustomAlert(title: "Delete confirm", message: "Delete this item will remove all it's data. Are you sure?", parent: nil, completion: { [weak self] _ in
                guard let `self` = self else { return }
                self.observer?.didRemoveTarget(target: target)
                self.presenter?.backToPreviousScreen()
            })
            
        }
    }
}

extension EditTargetVM: Style7SelectionChangingObservable {
    
    func didChangeSelectedOption(cellVM: Style7TableCellVM) {
        if let scheduleTypeVM = scheduleTypeCellVM, cellVM == scheduleTypeVM {
            presenter?.reloadTableViewRow(indexPaths: [IndexPath(row: 4, section: 0), IndexPath(row: 5, section: 0)])
        }
    }
}
