//
//  Style7TableCell.swift
//  WeekPlan
//
//  Created by Luong Minh Hiep on 8/21/17.
//  Copyright © 2017 Luong Minh Hiep. All rights reserved.
//

import UIKit

protocol Style7TableCellPresentable: class {
    var items: [String] { get set }
    var font: UIFont { get set }
    var textColor: UIColor { get set }
    var bgColorNormal: UIColor { get set }
    var bgColorSelected: UIColor { get set }
    
    var isMultipleChoice: Bool { get set }
    var selectedIndex: [Int] { get set }
    
    var stackLayout: Style7StackLayout { get set }
    
    func selectedOptionDidChange()
}

class Style7TableCell: BaseTableViewCell {

    static let cellHeightNormal: CGFloat = 44
    static let cellHeightDynamic: CGFloat = UITableViewAutomaticDimension
    
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var leadingStackViewToLeft: NSLayoutConstraint!
    @IBOutlet weak var topStackViewMargin: NSLayoutConstraint!
    
    @IBOutlet weak var item1: SelectableLabel!
    @IBOutlet weak var item2: SelectableLabel!
    @IBOutlet weak var item3: SelectableLabel!
    @IBOutlet weak var item4: SelectableLabel!
    @IBOutlet weak var item5: SelectableLabel!
    @IBOutlet weak var item6: SelectableLabel!
    @IBOutlet weak var item7: SelectableLabel!
    
    @IBOutlet weak var widthItem1: NSLayoutConstraint!
    @IBOutlet weak var widthItem2: NSLayoutConstraint!
    @IBOutlet weak var widthItem3: NSLayoutConstraint!
    @IBOutlet weak var widthItem4: NSLayoutConstraint!
    @IBOutlet weak var widthItem5: NSLayoutConstraint!
    @IBOutlet weak var widthItem6: NSLayoutConstraint!
    @IBOutlet weak var widthItem7: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    override func config(viewModel cellVM: BaseTableCellVM) {
        layoutMargins = UIEdgeInsets.zero
        backgroundColor = UIColor.clear
        contentView.backgroundColor = UIColor.clear
        selectionStyle = .none
        
        super.config(viewModel: cellVM)
        
        let itemToConfigs = [item1, item2, item3, item4, item5, item6, item7]
        for item in itemToConfigs {
            item?.observer = self
        }
        
        guard let dataSource = cellVM as? Style7TableCellPresentable else {
            return
        }
        
        var itemToHide = [item1, item2, item3, item4, item5, item6, item7]
        var widthItems = [widthItem1, widthItem2, widthItem3, widthItem4, widthItem5, widthItem6, widthItem7]
        let total = min(itemToConfigs.count, dataSource.items.count) - 1
        
        // Config needed items
        for index in 0...total {
            let title = dataSource.items[index]
            if let item = itemToConfigs[index] {
                item.config(title: title, textColor: dataSource.textColor, colorNormal: dataSource.bgColorNormal, colorHighlight: dataSource.bgColorSelected, cornerRadius: 5)
                itemToHide.removeFirst()
                
                if let widthConstraint = widthItems.removeFirst() {
                    if index < dataSource.stackLayout.itemWidths.count {
                        widthConstraint.constant = dataSource.stackLayout.itemWidths[index]
                    } else {
                        widthConstraint.constant = dataSource.stackLayout.defaultItemWidth
                    }
                }
                
                if dataSource.selectedIndex.contains(index) {
                    item.isSelected = true
                } else {
                    item.isSelected = false
                }
            }
        }
        
        // Reset zero width & Hide unused items
        for item in widthItems {
            if let widthConstraint = item {
                widthConstraint.constant = 0
            }
        }
        
        for item in itemToHide {
            item?.isHidden = true
        }
        
        topStackViewMargin.constant = dataSource.stackLayout.top
        leadingStackViewToLeft.constant = dataSource.stackLayout.left
        
        layoutIfNeeded()
    }
    
    override func updateUI() {
        super.updateUI()
        
        // Updat selected state
        guard let dataSource = cellVM as? Style7TableCellPresentable else {
            return
        }
        
        let total = dataSource.items.count - 1
        let itemToConfigs = [item1, item2, item3, item4, item5, item6, item7]
        
        for index in 0...total {
            if let item = itemToConfigs[index] {
                if dataSource.selectedIndex.contains(index) {
                    item.isSelected = true
                } else {
                    item.isSelected = false
                }
            }
        }
        
        self.layoutIfNeeded()
    }
}

extension Style7TableCell: SelectableLabelObservable {
    
    func didTapOnView(view: SelectableLabel) {
        var index = 0
        switch view {
        case item1: index = 0
        case item2: index = 1
        case item3: index = 2
        case item4: index = 3
        case item5: index = 4
        case item6: index = 5
        case item7: index = 6
        default: break
        }
        
        print("Select \(index)")
        
        guard let dataSource = cellVM as? Style7TableCellPresentable else {
            return
        }
        
        let itemToConfigs = [item1, item2, item3, item4, item5, item6, item7]
        if dataSource.isMultipleChoice {
            if let selectedItem = itemToConfigs[index] {
                if selectedItem.isSelected  && dataSource.selectedIndex.count > 1 {
                    selectedItem.isSelected = false
                    dataSource.selectedIndex = dataSource.selectedIndex.filter({ (compIndex) -> Bool in
                        return compIndex != index
                    })
                    dataSource.selectedOptionDidChange()
                } else if !selectedItem.isSelected {
                    selectedItem.isSelected = true
                    dataSource.selectedIndex.append(index)
                    dataSource.selectedOptionDidChange()
                }
            }
        } else {
            for item in itemToConfigs {
                item?.isSelected = false
            }
            let selectedItem = itemToConfigs[index]
            selectedItem?.isSelected = true
            
            if let previousIndex = dataSource.selectedIndex.first, previousIndex != index {
                dataSource.selectedOptionDidChange()
            }
            dataSource.selectedIndex = [index]
        }
        
    }
}
