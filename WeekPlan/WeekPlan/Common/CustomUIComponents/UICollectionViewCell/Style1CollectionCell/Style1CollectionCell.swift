//
//  Style1CollectionCell.swift
//  WeekPlan
//
//  Created by Luong Minh Hiep on 8/6/17.
//  Copyright © 2017 Luong Minh Hiep. All rights reserved.
//

import UIKit

class Style1CollectionCell: BaseCollectionCell {

    @IBOutlet weak var imageView: UIImageView!
    
    var cellVM: Style1CollectionCellVM!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func config(viewModel: Style1CollectionCellVM) {
        self.cellVM = viewModel
        self.cellVM.presenter = self
        
        configUI()
        updateSelectionState()
    }
    
    func configUI() {
        contentView.layer.cornerRadius = 5
        contentView.layer.borderColor = Color.selectionItemBackgroundSelected.value().cgColor
        imageView.tintColor = cellVM.tintColor
        imageView.image = UIImage(named: cellVM.imageName)?.maskWithColor(color: cellVM.tintColor)
    }
}

extension Style1CollectionCell: Style1CollectionCellPresenter {
    
    func updateSelectionState() {
        if cellVM.isSelected {
            contentView.backgroundColor = Color.selectionItemBackgroundSelected.value()
            contentView.layer.borderWidth = 1.0
        } else {
            contentView.backgroundColor = UIColor.clear
            contentView.layer.borderWidth = 0.0
        }
        layoutIfNeeded()
    }
}
