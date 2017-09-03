//
//  Style3TableCellVM.swift
//  WeekPlan
//
//  Created by Luong Minh Hiep on 8/5/17.
//  Copyright © 2017 Luong Minh Hiep. All rights reserved.
//

import Foundation

class Style3TableCellVM: BaseTableCellVM, Style3TableCellPresentable {
    
    var title: String
    var textViewContent: String?
    
    init(title: String = "", textViewContent: String? = nil, separatorStyle: TableViewSeparatorStyle = .noLine) {
        self.title = title
        self.textViewContent = textViewContent
        
        super.init()
        self.separatorStyle = separatorStyle
    }
}
