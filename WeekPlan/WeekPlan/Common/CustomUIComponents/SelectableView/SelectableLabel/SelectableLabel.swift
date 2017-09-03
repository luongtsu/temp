//
//  SelectableLabel.swift
//  WeekPlan
//
//  Created by Luong Minh Hiep on 8/21/17.
//  Copyright © 2017 Luong Minh Hiep. All rights reserved.
//

import UIKit

protocol SelectableLabelObservable: class {
    
    func didTapOnView(view: SelectableLabel)
}

class SelectableLabel: UINibView {

    @IBOutlet weak var label: UILabel!
    
    weak var observer: SelectableLabelObservable? = nil
    
    var isSelected: Bool = false {
        didSet {
            updateUI()
        }
    }
    
    private var colorNormal: UIColor = UIColor.clear
    private var colorHighlight: UIColor = Color.selectedItemBackground.value()
    
    func config(title: String, textColor: UIColor = Color.themeColor.value(), colorNormal: UIColor = UIColor.clear, colorHighlight: UIColor = Color.selectedItemBackground.value(), cornerRadius: CGFloat = 5) {
        self.layer.cornerRadius = cornerRadius
        self.backgroundColor = UIColor.clear
        self.colorNormal = colorNormal
        self.colorHighlight = colorHighlight
        label.text = title
        label.textColor = textColor
        label.backgroundColor = UIColor.clear
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapGestureAction(sender:)))
        self.addGestureRecognizer(tapGesture)
        layoutIfNeeded()
    }
    
    @objc private func tapGestureAction(sender: Any) {
        observer?.didTapOnView(view: self)
    }
    
    func updateUI() {
        if self.isSelected {
            self.backgroundColor = colorHighlight
        } else {
            self.backgroundColor = colorNormal
        }
    }
}
