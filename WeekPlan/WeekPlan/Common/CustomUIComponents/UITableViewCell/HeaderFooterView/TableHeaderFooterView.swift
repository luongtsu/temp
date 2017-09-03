//
//  TableHeaderFooterView.swift
//  WeekPlan
//
//  Created by Luong Minh Hiep on 7/15/17.
//  Copyright © 2017 Luong Minh Hiep. All rights reserved.
//

import UIKit

class TableHeaderFooterView: UITableViewHeaderFooterView, UITableViewCellRegisterable {

    static let defaultHeight: CGFloat = 40
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var leftSaparatorLine: UIView!
    @IBOutlet weak var rightSaparatorLine: UIView!
    
    @IBOutlet weak var imageViewWidth: NSLayoutConstraint!
    @IBOutlet weak var leadingLabelToImageView: NSLayoutConstraint!
    
    var cellVM: TableHeaderFooterVM!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configUI()
    }
    
    private func configUI() {
        contentView.backgroundColor = UIColor.rgb(237, 237, 237, 0.7)
        leftSaparatorLine.backgroundColor = Color.themeColorHaflAlpha.value()
        rightSaparatorLine.backgroundColor = Color.themeColorHaflAlpha.value()
        TextStyle.config(label: titleLabel, style: .titleLight)
    }

    func config(cellVM: TableHeaderFooterVM) {
        self.cellVM = cellVM
        updateUI()
    }
    
    func updateUI() {
        titleLabel.text = cellVM.title
        if let image = cellVM.image {
            imageView.image = image
            imageViewWidth.constant = 20
            leadingLabelToImageView.constant = 4
        } else {
            imageView.image = nil
            imageViewWidth.constant = 0
            leadingLabelToImageView.constant = 0
        }
    }
}
