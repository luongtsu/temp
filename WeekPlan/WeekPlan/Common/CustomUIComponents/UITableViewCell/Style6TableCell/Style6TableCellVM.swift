//
//  Style6TableCellVM.swift
//  WeekPlan
//
//  Created by Luong Minh Hiep on 8/5/17.
//  Copyright © 2017 Luong Minh Hiep. All rights reserved.
//

import UIKit

class Style6TableCellVM: BaseTableCellVM, Style6TableCellPresentable {
    
    var title: String
    var font: UIFont
    var textColor: UIColor
    var textAlignment: NSTextAlignment
    var selectable: Bool
    
    init(title: String = "", font: UIFont = Font.title, textColor: UIColor = Color.themeColor.value(), textAlignment: NSTextAlignment = NSTextAlignment.center, selectable: Bool = false, separatorStyle: TableViewSeparatorStyle = .noLine) {
        self.title = title
        self.font = font
        self.textColor = textColor
        self.textAlignment = textAlignment
        self.selectable = selectable
        super.init()
        self.separatorStyle = separatorStyle
    }
}
