//
//  Style6TableCell.swift
//  WeekPlan
//
//  Created by Luong Minh Hiep on 8/5/17.
//  Copyright © 2017 Luong Minh Hiep. All rights reserved.
//

import UIKit

protocol Style6TableCellPresentable: class {
    var title: String { get set }
    var font: UIFont { get set }
    var textColor: UIColor { get set }
    var textAlignment: NSTextAlignment { get set }
    var selectable: Bool { get set }
}

class Style6TableCell: BaseTableViewCell {
    
    static let cellHeightNormal: CGFloat = 44
    static let cellHeightDynamic: CGFloat = UITableViewAutomaticDimension
    
    @IBOutlet weak var titleLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    override func config(viewModel cellVM: BaseTableCellVM) {
        layoutMargins = UIEdgeInsets.zero
        backgroundColor = UIColor.clear
        super.config(viewModel: cellVM)
    }
    
    override func updateUI() {
        super.updateUI()
        
        guard let dataSource = cellVM as? Style6TableCellPresentable else {
            return
        }
        titleLabel.text = dataSource.title
        titleLabel.textColor = dataSource.textColor
        titleLabel.textAlignment = dataSource.textAlignment
        titleLabel.font = dataSource.font
        selectionStyle = dataSource.selectable ? .default : .none
        self.layoutIfNeeded()
    }
}
