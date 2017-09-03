//
//  Style5TableCellVM.swift
//  WeekPlan
//
//  Created by Luong Minh Hiep on 8/5/17.
//  Copyright © 2017 Luong Minh Hiep. All rights reserved.
//

import UIKit

protocol Style5TableCellPresenter: class {
    
    func updateIconImage()
}

class Style5TableCellVM: BaseTableCellVM, Style5TableCellPresentable {
    
    var title: String
    var iconName: String {
        didSet {
            presenter?.updateComponentUI()
        }
    }
    
    var tintColor: UIColor? = nil {
        didSet {
            presenter?.updateComponentUI()
        }
    }
    var selectable: Bool
    
    init(title: String = "", iconName: String = "", tintColor: UIColor? = nil, selectable: Bool = false, separatorStyle: TableViewSeparatorStyle = .noLine) {
        self.title = title
        self.iconName = iconName
        self.tintColor = tintColor
        self.selectable = selectable
        super.init()
        self.separatorStyle = separatorStyle
    }
}
