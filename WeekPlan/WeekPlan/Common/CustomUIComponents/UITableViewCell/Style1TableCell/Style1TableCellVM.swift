//
//  Style1TableCellVM.swift
//  WeekPlan
//
//  Created by Luong Minh Hiep on 7/15/17.
//  Copyright © 2017 Luong Minh Hiep. All rights reserved.
//

import UIKit

class Style1TableCellVM: BaseTableCellVM, Style1TableCellPresentable {
    
    var tintColor: UIColor
    var leftImageName: String
    var topTitle: String
    var middleTitle: String
    var setOfActiveIndicator: [Int]
    var doneStatus: RecordStatus
    
    var isSelected: Bool {
        didSet {
            presenter?.updateUI()
        }
    }
    
    var shouldAlwaysHideMenuView: Bool
    var selectable: Bool
    
    var selectMenuCompletion: SelectMenuCompletion?
    
    init(tintColor: UIColor, leftImageName: String = "ic_question_48pt", topTitle: String = "Unknow", middleTitle: String = "unknow", setOfActiveIndicator: [Int] = [], doneStatus: RecordStatus, isSelected: Bool = false, shouldAlwaysHideMenuView: Bool = false, selectable: Bool = true, separatorStyle: TableViewSeparatorStyle = .noLine, selectMenuCompletion: SelectMenuCompletion? = nil) {
        self.tintColor = tintColor
        self.leftImageName = leftImageName
        self.topTitle = topTitle
        self.middleTitle = middleTitle
        self.setOfActiveIndicator = setOfActiveIndicator
        self.doneStatus = doneStatus
        self.isSelected = isSelected
        self.shouldAlwaysHideMenuView = shouldAlwaysHideMenuView
        self.selectable = selectable
        self.selectMenuCompletion = selectMenuCompletion
        
        super.init()
        self.separatorStyle = separatorStyle
    }
}

extension Style1TableCellVM: ButtonIconTextResponsible {
    
    func optionButtonIsPressed(type: ButtonMenuType) {
        print("optionButtonIsPressed \(type.rawValue)")
        guard let selectMenuOptionCompletion = selectMenuCompletion else {
            return
        }
        selectMenuOptionCompletion(type)
    }
}
