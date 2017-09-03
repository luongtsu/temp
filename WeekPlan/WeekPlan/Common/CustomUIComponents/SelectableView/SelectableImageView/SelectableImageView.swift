//
//  SelectableImageView.swift
//  WeekPlan
//
//  Created by Luong Minh Hiep on 8/20/17.
//  Copyright © 2017 Luong Minh Hiep. All rights reserved.
//

import UIKit

protocol SelectableImageViewObservable: class {
    
    func didTapOnView(view: SelectableImageView)
}

class SelectableImageView: UINibView {

    weak var observer: SelectableImageViewObservable? = nil
    
    @IBOutlet weak var imageView: UIImageView!
    var imageColor: UIColor = UIColor.clear
    
    var isSelected: Bool = false {
        didSet {
            updateUI()
        }
    }
    
    func config(iconName: String, tintColor: UIColor?) {
        if let color = tintColor {
            imageView.image = UIImage(named: iconName)?.maskWithColor(color: color)
            self.imageColor = color
        } else {
            imageView.image = UIImage(named: iconName)
        }
        self.backgroundColor = UIColor.clear
        self.layer.cornerRadius = 5
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapGestureAction(sender:)))
        self.addGestureRecognizer(tapGesture)
    }
    
    @objc private func tapGestureAction(sender: Any) {
        observer?.didTapOnView(view: self)
    }
    
    func updateUI() {
        if self.isSelected {
            self.backgroundColor = Color.selectionItemBackgroundSelected.value()
        } else {
            self.backgroundColor = UIColor.clear
        }
    }
}
