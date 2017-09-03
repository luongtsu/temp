//
//  Style2TableCell.swift
//  WeekPlan
//
//  Created by Luong Minh Hiep on 8/5/17.
//  Copyright © 2017 Luong Minh Hiep. All rights reserved.
//

import UIKit

protocol Style2TableCellPresentable: class {
    var title: String { get set }
    var textFieldContent: String? { get set }
    var textFieldPlaceHolder: String? { get set }
}

class Style2TableCell: BaseTableViewCell {

    static let cellHeightNormal: CGFloat = 78
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var textField: UITextField!
    
    @IBAction func textFieldContentDidChange(_ sender: Any) {
        guard let dataSource = cellVM as? Style2TableCellPresentable else {
            return
        }
        dataSource.textFieldContent = textField.text
    }

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
        selectionStyle = .none
        textField.addTarget(self, action: #selector(updateDatasourceText), for: UIControlEvents.editingChanged)
        super.config(viewModel: cellVM)
    }
    
    override func updateUI() {
        super.updateUI()
        
        guard let dataSource = cellVM as? Style2TableCellPresentable else {
            return
        }
        
        titleLabel.text = dataSource.title
        textField.text = dataSource.textFieldContent
        textField.placeholder = dataSource.textFieldPlaceHolder
        self.layoutIfNeeded()
    }
    
    func updateDatasourceText() {
        guard let dataSource = cellVM as? Style2TableCellPresentable else {
            return
        }
        dataSource.textFieldContent = textField.text
    }
}
