//
//  TableViewPresentable.swift
//  WeekPlan
//
//  Created by Luong Minh Hiep on 7/15/17.
//  Copyright © 2017 Luong Minh Hiep. All rights reserved.
//

import UIKit

protocol TableViewPresentable {
    
    func numberOfSection() -> Int
    func numberOfRows(inSection section: Int) -> Int
    
    func heightForHeader(inSection section: Int) -> CGFloat
    func viewModelForHeader(inSection section: Int) -> Any?
    
    func heightForRow(atIndexPath indexPath: IndexPath) -> CGFloat
    func estimatedHeightForRow(atIndexPath indexPath: IndexPath) -> CGFloat
    func viewModelForCell(atIndexPath indexPath: IndexPath) -> Any?
    
    func didSelectRow(indexPath: IndexPath)
}

extension TableViewPresentable {
    
    func numberOfSection() -> Int {
        return 0
    }
    
    func numberOfRows(inSection section: Int) -> Int {
        return 0
    }
    
    func heightForHeader(inSection section: Int) -> CGFloat {
        return 0
    }
    
    func viewModelForHeader(inSection section: Int) -> Any? {
        return nil
    }
    
    func heightForRow(atIndexPath indexPath: IndexPath) -> CGFloat {
        return 0
    }
    
    func estimatedHeightForRow(atIndexPath indexPath: IndexPath) -> CGFloat {
        return heightForRow(atIndexPath: indexPath)
    }
    
    func viewModelForCell(atIndexPath indexPath: IndexPath) -> Any? {
        return nil
    }
    
    func didSelectRow(indexPath: IndexPath) {}
}
