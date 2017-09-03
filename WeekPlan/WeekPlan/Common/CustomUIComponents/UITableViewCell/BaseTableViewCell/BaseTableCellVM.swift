//
//  BaseTableCellVM.swift
//  WeekPlan
//
//  Created by Luong Minh Hiep on 7/14/17.
//  Copyright © 2017 Luong Minh Hiep. All rights reserved.
//

import Foundation

typealias VoipBlock = () -> Void

protocol BaseTableViewCellPresenter: class {
    func updateUI()
    func updateComponentUI()
}

class BaseTableCellVM {
    var separatorStyle: TableViewSeparatorStyle = .noLine
    weak var presenter: BaseTableViewCellPresenter?
}
