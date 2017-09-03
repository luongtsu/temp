//
//  Style7TableCellVM.swift
//  WeekPlan
//
//  Created by Luong Minh Hiep on 8/21/17.
//  Copyright © 2017 Luong Minh Hiep. All rights reserved.
//

import UIKit

protocol Style7SelectionChangingObservable: class {
    
    func didChangeSelectedOption(cellVM: Style7TableCellVM)
}

struct Style7StackLayout {
    
    var top: CGFloat = 0
    var left: CGFloat = 0
    var defaultItemWidth: CGFloat = 40
    var itemWidths: [CGFloat] = []
}

class Style7TableCellVM: BaseTableCellVM, Style7TableCellPresentable {
    
    fileprivate let id: String = Util.generatedId()
    
    var items: [String]
    var font: UIFont
    var textColor: UIColor
    var bgColorNormal: UIColor
    var bgColorSelected: UIColor
    
    var isMultipleChoice: Bool
    var selectedIndex: [Int]
    var stackLayout: Style7StackLayout
    
    weak var optionChangeObservable: Style7SelectionChangingObservable?
    
    init(items: [String], font: UIFont = Font.title, textColor: UIColor = Color.themeColor.value(), bgColorNormal: UIColor = UIColor.clear, bgColorSelected: UIColor = Color.selectedItemBackground.value(), isMultipleChoice: Bool = false, selectedIndex: [Int] = [0], stackLayout: Style7StackLayout, optionChangeObservable: Style7SelectionChangingObservable? = nil, separatorStyle: TableViewSeparatorStyle = .noLine) {
        self.items = items
        self.font = font
        self.textColor = textColor
        self.bgColorNormal = bgColorNormal
        self.bgColorSelected = bgColorSelected
        self.isMultipleChoice = isMultipleChoice
        self.selectedIndex = selectedIndex
        self.stackLayout = stackLayout
        self.optionChangeObservable = optionChangeObservable
        
        super.init()
        self.separatorStyle = separatorStyle
    }
    
    func selectedOptionDidChange() {
        optionChangeObservable?.didChangeSelectedOption(cellVM: self)
    }
}

extension Style7TableCellVM: Equatable {
    
    public static func ==(lhs: Style7TableCellVM, rhs: Style7TableCellVM) -> Bool {
        return lhs.id == rhs.id
    }
}
