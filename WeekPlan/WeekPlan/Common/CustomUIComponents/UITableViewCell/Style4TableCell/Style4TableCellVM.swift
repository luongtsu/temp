//
//  Style4TableCellVM.swift
//  WeekPlan
//
//  Created by Luong Minh Hiep on 8/5/17.
//  Copyright © 2017 Luong Minh Hiep. All rights reserved.
//

import UIKit

protocol Style4TableCellPresenter {
    
    func updateTimeCounterIndicator()
    func updatePickedDateIndicator()
}

class Style4TableCellVM: BaseTableCellVM, Style4TableCellPresentable {
    
    var pickerMode: UIDatePickerMode
    
    var leftTitle: String
    var rightImageNameNormal: String
    var rightImageNameSelected: String
    
    var isSelected: Bool {
        didSet {
            presenter?.updateUI()
        }
    }
    
    var countDownDurationInSecond: TimeInterval = 300.0 {
        didSet {
            guard let style4Presenter = presenter as? Style4TableCellPresenter else {
                return
            }
            style4Presenter.updateTimeCounterIndicator()
        }
    }

    var pickedDate: Date = Date() {
        didSet {
            guard let style4Presenter = presenter as? Style4TableCellPresenter else {
                return
            }
            style4Presenter.updatePickedDateIndicator()
        }
    }
    
    init(pickerMode: UIDatePickerMode, leftTitle: String = "", countDownDurationInSecond: TimeInterval = 0, pickedDate: Date = Date(), rightImageNameNormal: String = "ic_arrow_drop_down", rightImageNameSelected: String = "ic_arrow_drop_up", isSelected: Bool = false, separatorStyle: TableViewSeparatorStyle = .noLine) {
        self.pickerMode = pickerMode
        self.leftTitle = leftTitle
        self.countDownDurationInSecond = countDownDurationInSecond
        self.pickedDate = pickedDate
        self.rightImageNameNormal = rightImageNameNormal
        self.rightImageNameSelected = rightImageNameSelected
        self.isSelected = isSelected
        
        super.init()
        self.separatorStyle = separatorStyle
    }
}
