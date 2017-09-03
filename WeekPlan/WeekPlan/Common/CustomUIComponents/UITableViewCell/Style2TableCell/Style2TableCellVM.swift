//
//  Style2TableCellVM.swift
//  WeekPlan
//
//  Created by Luong Minh Hiep on 8/5/17.
//  Copyright © 2017 Luong Minh Hiep. All rights reserved.
//

import Foundation

class Style2TableCellVM: BaseTableCellVM, Style2TableCellPresentable {
    
    var title: String
    var textFieldContent: String?
    var textFieldPlaceHolder: String?
    
    init(title: String = "", textFieldContent: String? = nil, textFieldPlaceHolder: String? = nil, separatorStyle: TableViewSeparatorStyle = .noLine) {
        self.title = title
        self.textFieldContent = textFieldContent
        self.textFieldPlaceHolder = textFieldPlaceHolder
        
        super.init()
        self.separatorStyle = separatorStyle
    }
}
