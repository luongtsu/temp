//
//  BaseTableViewCell.swift
//  WeekPlan
//
//  Created by Luong Minh Hiep on 7/14/17.
//  Copyright © 2017 Luong Minh Hiep. All rights reserved.
//

import UIKit

enum TableViewSeparatorStyle {
    case fullLine
    case dynamic
    case noLine
}

enum SeparatorLine: CGFloat {
    case dynamicWithLeftImage = 48
    case dynamicWithoutLeftImage = 16
    case fullLine = -44
    case noLine = 10000
}

class BaseTableViewCell: UITableViewCell, UITableViewCellRegisterable, BaseTableViewCellPresenter {

    fileprivate(set) var cellVM: BaseTableCellVM!
    
    var separatorLine: UIView!
    var separatorLineLeadConstraint: NSLayoutConstraint!

    override func awakeFromNib() {
        super.awakeFromNib()
        
        separatorLine = UIView()
        contentView.addSubview(separatorLine)
        
        separatorLine.translatesAutoresizingMaskIntoConstraints = false
        separatorLine.backgroundColor = UIColor(red: 0.894, green: 0.894, blue: 0.894, alpha: 1)
        separatorLine.addHeightConstraint(height: 1)
        separatorLineLeadConstraint = separatorLine.addEdgeConstraint(edge: .left, superView: contentView, constant: 0)
        separatorLine.addEdgeConstraint(edge: .bottom, superView: contentView, constant: 0)
        separatorLine.addEdgeConstraint(edge: .right, superView: contentView, constant: 100)
    }
    
    func configSeparatorLine(separatorStyle: TableViewSeparatorStyle, shouldShowLeftImage: Bool = false) {
        switch separatorStyle {
        case .dynamic:
            separatorLineLeadConstraint.constant = shouldShowLeftImage ? SeparatorLine.dynamicWithLeftImage.rawValue : SeparatorLine.dynamicWithoutLeftImage.rawValue
            separatorLine.isHidden = false
        case .fullLine:
            separatorLineLeadConstraint.constant = SeparatorLine.fullLine.rawValue  // This nagative value is to fix issue in editting mode
            separatorLine.isHidden = false
        case .noLine:
            separatorLine.isHidden = true
        }
        
        layoutIfNeeded()
    }
    
    func updateSeparatorLine(targetCell: BaseTableViewCell) {
        var targetSeparatorStyle = TableViewSeparatorStyle.noLine
        let targetMargin = targetCell.separatorLineLeadConstraint.constant
        if targetMargin == SeparatorLine.dynamicWithLeftImage.rawValue || targetMargin == SeparatorLine.dynamicWithoutLeftImage.rawValue {
            targetSeparatorStyle = .dynamic
        } else if targetMargin == SeparatorLine.fullLine.rawValue {
            targetSeparatorStyle = .fullLine
        }
        
        let currMargin = separatorLineLeadConstraint.constant
        var shouldShowLeftImage = false
        if currMargin == SeparatorLine.dynamicWithLeftImage.rawValue && !separatorLine.isHidden {
            shouldShowLeftImage = true
        }
        
        configSeparatorLine(separatorStyle: targetSeparatorStyle, shouldShowLeftImage: shouldShowLeftImage)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func config(viewModel: BaseTableCellVM) {
        cellVM = viewModel
        cellVM.presenter = self
        updateUI()
    }
    
    func updateUI() {
        configSeparatorLine(separatorStyle: cellVM.separatorStyle, shouldShowLeftImage: false)
    }
    
    func updateComponentUI() {
        // do nothing
    }
}

