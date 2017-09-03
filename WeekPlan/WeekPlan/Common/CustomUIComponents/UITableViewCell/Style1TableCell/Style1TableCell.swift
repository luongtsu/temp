//
//  Style1TableCell.swift
//  WeekPlan
//
//  Created by Luong Minh Hiep on 7/15/17.
//  Copyright © 2017 Luong Minh Hiep. All rights reserved.
//

import UIKit
import GTProgressBar

typealias SelectMenuCompletion = (_ selectedOption: ButtonMenuType) -> Void

protocol Style1TableCellPresentable: class {
    var tintColor: UIColor { get set }
    var leftImageName: String { get set }
    var topTitle: String { get set }
    var middleTitle: String { get set }
    var isSelected: Bool { get set }
    var setOfActiveIndicator: [Int] { get set }
    var doneStatus: RecordStatus { get set }
    
    var shouldAlwaysHideMenuView: Bool { get set }
    var selectable: Bool { get set }
    
    var selectMenuCompletion: SelectMenuCompletion? { get set }
}

class Style1TableCell: BaseTableViewCell {

    static let cellHeightNormal: CGFloat = 80
    static let cellHeightExpanded: CGFloat = 80+86
    
    @IBOutlet weak var baseView: UIView!
    @IBOutlet weak var customMenuView: CustomMenuView!
    
    @IBOutlet weak var leftImageView: UIImageView!
    @IBOutlet weak var topTitleLabel: UILabel!
    @IBOutlet weak var middleLabel: UILabel!
    @IBOutlet weak var stepIndicatorView: StepIndicatorView!
    @IBOutlet weak var iconBGView: UIView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        guard let dataSource = cellVM as? Style1TableCellPresentable else {
            return
        }
        
        dataSource.isSelected = self.isSelected
    }
    
    override func config(viewModel cellVM: BaseTableCellVM) {
        customMenuView.config(actionResponder: cellVM as? ButtonIconTextResponsible)
        layoutMargins = UIEdgeInsets.zero
        backgroundColor = UIColor.clear
        stepIndicatorView.backgroundColor = UIColor.clear
        
        iconBGView.layer.borderWidth = 2
        iconBGView.layer.cornerRadius = iconBGView.bounds.size.width/2
        
        TextStyle.config(label: topTitleLabel, style: .title)
        TextStyle.config(label: middleLabel, style: .subTitleLight)
        
        tintColor = Color.themeColor.value()
        
        super.config(viewModel: cellVM)
        
        guard let dataSource = cellVM as? Style1TableCellPresentable else {
            return
        }
        iconBGView.layer.borderColor = dataSource.tintColor.cgColor
        if dataSource.doneStatus == .unknow {
            topTitleLabel.textColor = Color.themeColorHaflAlpha.value()
        } else {
            topTitleLabel.textColor = Color.themeColor.value()
        }
    }
    
    override func updateUI() {
        super.updateUI()
        
        guard let dataSource = cellVM as? Style1TableCellPresentable else {
            return
        }
        
        selectionStyle = dataSource.selectable ? .default : .none
        
        switch dataSource.doneStatus {
        case .open: baseView.backgroundColor = Color.targetItemBackgroundOpen.value()
        case .done: baseView.backgroundColor = Color.targetItemBackgroundDone.value()
        case .cancel: baseView.backgroundColor = Color.targetItemBackgroundCancel.value()
        case .skip: baseView.backgroundColor = Color.targetItemBackgroundSkip.value()
        case .unknow: baseView.backgroundColor = Color.targetItemBackgroundUnknow.value()
        }
        
        customMenuView.doneStatus = dataSource.doneStatus
        customMenuView.updateUI()
        
        leftImageView.image = UIImage(named: dataSource.leftImageName)?.maskWithColor(color: dataSource.tintColor)
        iconBGView.layer.borderColor = dataSource.tintColor.cgColor
        
        topTitleLabel.text = dataSource.topTitle
        middleLabel.text = dataSource.middleTitle
        stepIndicatorView.config(activeIndexes: dataSource.setOfActiveIndicator)
        
        if dataSource.doneStatus == .unknow {
            iconBGView.alpha = 0.5
            stepIndicatorView.alpha = 0.5
            stepIndicatorView.configColor(tintColor: Color.themeColorHaflAlpha.value())
        } else {
            iconBGView.alpha = 1
            stepIndicatorView.alpha = 1
        }


        if dataSource.shouldAlwaysHideMenuView {
            customMenuView.isHidden = true
        } else {
            if dataSource.isSelected {
                if customMenuView.isHidden {
                    customMenuView.isHidden = false
                    customMenuView.alpha = 0.0
                    UIView.animate(withDuration: 0.5, animations: {
                        self.customMenuView.alpha = 1.0
                    }, completion: { _ in
                        self.customMenuView.alpha = 1.0
                    })
                }
            } else {
                customMenuView.isHidden = true
            }
        }
        
        self.layoutIfNeeded()
    }
}
