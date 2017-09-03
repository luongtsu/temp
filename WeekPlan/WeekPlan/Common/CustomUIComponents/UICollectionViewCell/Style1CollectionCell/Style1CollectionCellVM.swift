//
//  Style1CollectionCellVM.swift
//  WeekPlan
//
//  Created by Luong Minh Hiep on 8/6/17.
//  Copyright © 2017 Luong Minh Hiep. All rights reserved.
//

import UIKit

protocol Style1CollectionCellPresenter: class {
    
    func updateSelectionState()
}

class Style1CollectionCellVM {
    
    var imageName: String
    var tintColor: UIColor
    var isSelected: Bool {
        didSet {
            presenter?.updateSelectionState()
        }
    }
    
    weak var presenter: Style1CollectionCellPresenter?
    
    init(imageName: String = "", tintColor: UIColor = Color.categoryColor1.value(), isSelected: Bool = false) {
        self.imageName = imageName
        self.tintColor = tintColor
        self.isSelected = isSelected
    }
}
