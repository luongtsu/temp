//
//  Style4TableCell.swift
//  WeekPlan
//
//  Created by Luong Minh Hiep on 8/5/17.
//  Copyright © 2017 Luong Minh Hiep. All rights reserved.
//

import UIKit

protocol Style4TableCellPresentable: class {
    var leftTitle: String { get set }
    var rightImageNameNormal: String { get set }
    var rightImageNameSelected: String { get set }
    
    var isSelected: Bool { get set }
    var countDownDurationInSecond: TimeInterval { get set }
    var pickedDate: Date { get set }
    
    var pickerMode: UIDatePickerMode { get set }
}

class Style4TableCell: BaseTableViewCell {

    static let cellHeightNormal: CGFloat = 44
    static let cellHeightSelected: CGFloat = 44 + 200
    
    @IBOutlet weak var leftTitleLabel: UILabel!
    @IBOutlet weak var rightTitleLabel: UILabel!
    @IBOutlet weak var rightImageView: UIImageView!
    
    @IBOutlet weak var bottomBaseView: UIView!
    @IBOutlet weak var dateTimePicker: UIDatePicker!
    @IBOutlet weak var bottomBaseViewHeight: NSLayoutConstraint!
    
    @IBAction func dateTimePickerValueChanged(_ sender: UIDatePicker) {
        guard let dataSource = cellVM as? Style4TableCellPresentable else {
            return
        }
        
        if sender.datePickerMode == .countDownTimer {
            dataSource.countDownDurationInSecond = dateTimePicker.countDownDuration
        } else {
            dataSource.pickedDate = dateTimePicker.date
        }
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
        super.config(viewModel: cellVM)
        
        TextStyle.config(label: leftTitleLabel, style: .title)
        TextStyle.config(label: rightTitleLabel, style: .titleLight)
        selectionStyle = .default
        
        guard let dataSource = cellVM as? Style4TableCellPresentable else {
            return
        }
        dateTimePicker.datePickerMode = dataSource.pickerMode
    }
    
    override func updateUI() {
        super.updateUI()
        
        guard let dataSource = cellVM as? Style4TableCellPresentable else {
            return
        }
        
        leftTitleLabel.text = dataSource.leftTitle
        
        if dataSource.pickerMode == .countDownTimer {
            rightTitleLabel.text = Util.secondToHourAndMinute(seconds: Int(dataSource.countDownDurationInSecond))
        } else {
            rightTitleLabel.text = Util.dateMonthYearStringPresentation(fromDate: dataSource.pickedDate)
        }
        
        dateTimePicker.countDownDuration = dataSource.countDownDurationInSecond
        
        if dataSource.isSelected {
            rightImageView.image = UIImage(named: dataSource.rightImageNameSelected)
        } else {
            rightImageView.image = UIImage(named: dataSource.rightImageNameNormal)
        }
        
        if dataSource.isSelected {
            bottomBaseView.isHidden = false
            
            // animate appearance
            bottomBaseView.alpha = 0
            UIView.animate(withDuration: 0.5, animations: { 
                self.bottomBaseView.alpha = 1.0
            }, completion: { _ in
                self.bottomBaseView.alpha = 1.0
            })
        } else {
            bottomBaseView.isHidden = true
        }
        
        self.layoutIfNeeded()
    }
}

extension Style4TableCell: Style4TableCellPresenter {
    
    func updateTimeCounterIndicator() {
        guard let dataSource = cellVM as? Style4TableCellPresentable else {
            return
        }
        rightTitleLabel.text = Util.secondToHourAndMinute(seconds: Int(dataSource.countDownDurationInSecond))
    }
    
    func updatePickedDateIndicator() {
        guard let dataSource = cellVM as? Style4TableCellPresentable else {
            return
        }
        rightTitleLabel.text = Util.dateMonthYearStringPresentation(fromDate: dataSource.pickedDate)
    }
}
