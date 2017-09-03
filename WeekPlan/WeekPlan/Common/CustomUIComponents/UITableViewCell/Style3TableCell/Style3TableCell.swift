//
//  Style3TableCell.swift
//  WeekPlan
//
//  Created by Luong Minh Hiep on 8/5/17.
//  Copyright © 2017 Luong Minh Hiep. All rights reserved.
//

import UIKit

protocol Style3TableCellPresentable: class {
    var title: String { get set }
    var textViewContent: String? { get set }
}

class Style3TableCell: BaseTableViewCell {

    static let cellHeightNormal: CGFloat = 128
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var textView: UITextView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    override func config(viewModel cellVM: BaseTableCellVM) {
        layoutMargins = UIEdgeInsets.zero
        backgroundColor = UIColor.clear
        textView.delegate = self
        textView.layer.borderWidth = 1.0
        textView.layer.cornerRadius = 5.0
        textView.layer.borderColor = UIColor.rgb(227, 227, 227).cgColor
        
        TextStyle.config(label: titleLabel, style: .title)
        textView.textColor = Color.themeColor.value()
        
        selectionStyle = .none
        super.config(viewModel: cellVM)
    }
    
    override func updateUI() {
        super.updateUI()
        
        guard let dataSource = cellVM as? Style3TableCellPresentable else {
            return
        }
        
        titleLabel.text = dataSource.title
        textView.text = dataSource.textViewContent
        
        self.layoutIfNeeded()
    }
}

extension Style3TableCell: UITextViewDelegate {
    
    func textViewDidChange(_ textView: UITextView) {
        guard let dataSource = cellVM as? Style3TableCellPresentable else {
            return
        }
        dataSource.textViewContent = textView.text
    }
}
