//
//  UINibButton.swift
//  WeekPlan
//
//  Created by Luong Minh Hiep on 7/17/17.
//  Copyright © 2017 Luong Minh Hiep. All rights reserved.
//

import UIKit

class UINibButton: UIButton {
    
    private var view: UIView!
    
    // MARK: - Inits
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.loadFromNib()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.loadFromNib()
    }
    
    // MARK: - Private Methods
    
    private func loadFromNib() {
        let nibName = String(describing: type(of: self))
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: nibName, bundle: bundle)
        
        guard let view = nib.instantiate(withOwner: self, options: nil).first as? UIView else {
            return
        }
        
        view.frame = bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        self.view = view
        self.addSubview(view)
    }
}
