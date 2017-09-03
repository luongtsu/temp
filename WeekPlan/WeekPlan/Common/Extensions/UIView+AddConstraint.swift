//
//  UIView+AddConstraint.swift
//  WeekPlan
//
//  Created by Luong Minh Hiep on 8/6/17.
//  Copyright © 2017 Luong Minh Hiep. All rights reserved.
//

import UIKit

extension UIView {
    
    // MARK: - Add to superview
    
    public func addFullFillTo(superView: UIView) {
        self.addWithPadding(superView: superView, top: 0, left: 0, bottom: 0, right: 0)
    }
    
    public func addWithPadding(superView: UIView, top: CGFloat, left: CGFloat, bottom: CGFloat, right: CGFloat) {
        self.translatesAutoresizingMaskIntoConstraints = false
        superView.addSubview(self)
        
        self.addEdgeConstraint(edge: .top, superView: superView, constant: top)
        self.addEdgeConstraint(edge: .left, superView: superView, constant: left)
        self.addEdgeConstraint(edge: .bottom, superView: superView, constant: bottom)
        self.addEdgeConstraint(edge: .right, superView: superView, constant: right)
        superView.updateConstraints()
    }
    
    @discardableResult
    public func addEdgeConstraint(edge: NSLayoutAttribute,
                                  superView: UIView,
                                  constant: CGFloat) -> NSLayoutConstraint {
        let constraint = NSLayoutConstraint(item: self, attribute: edge, relatedBy: .equal, toItem: superView, attribute: edge, multiplier: 1.0, constant: constant)
        superView.addConstraint(constraint)
        
        return constraint
    }
    
    @discardableResult
    public func addHeightConstraint(height: CGFloat) -> NSLayoutConstraint {
        let constraint = NSLayoutConstraint(item: self, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: height)
        self.addConstraint(constraint)
        
        return constraint
    }
}
