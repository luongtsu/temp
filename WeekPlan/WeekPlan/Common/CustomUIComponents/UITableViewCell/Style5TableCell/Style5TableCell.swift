//
//  Style5TableCell.swift
//  WeekPlan
//
//  Created by Luong Minh Hiep on 8/5/17.
//  Copyright © 2017 Luong Minh Hiep. All rights reserved.
//

import UIKit

protocol Style5TableCellPresentable: class {
    var title: String { get set }
    var iconName: String { get set }
    var tintColor: UIColor? { get set }
    var selectable: Bool { get set }
}

class Style5TableCell: BaseTableViewCell {

    static let cellHeightNormal: CGFloat = 44
    
    @IBOutlet weak var iconImageView: UIImageView!
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
        TextStyle.config(label: titleLabel, style: .title)
        
        tintColor = Color.themeColor.value()
    
        super.config(viewModel: cellVM)
    }
    
    override func updateUI() {
        super.updateUI()
        
        guard let dataSource = cellVM as? Style5TableCellPresentable else {
            return
        }
        selectionStyle = dataSource.selectable ? .default : .none
        titleLabel.text = dataSource.title
        if let tintColor = dataSource.tintColor {
            iconImageView.image = UIImage(named: dataSource.iconName)?.maskWithColor(color: tintColor)
        } else {
            iconImageView.image = UIImage(named: dataSource.iconName)
        }
        self.layoutIfNeeded()
    }
    
    override func updateComponentUI() {
        super.updateComponentUI()
        guard let dataSource = cellVM as? Style5TableCellPresentable else {
            return
        }
        if let tintColor = dataSource.tintColor {
            iconImageView.image = UIImage(named: dataSource.iconName)?.maskWithColor(color: tintColor)
        } else {
            iconImageView.image = UIImage(named: dataSource.iconName)
        }
        self.layoutIfNeeded()
    }
}
