//
//  UITableViewCellRegistable.swift
//  WeekPlan
//
//  Created by Luong Minh Hiep on 7/14/17.
//  Copyright © 2017 Luong Minh Hiep. All rights reserved.
//

import UIKit

protocol UITableViewCellRegisterable: class {
    static func nibName() -> String
    static func identifier() -> String
    static func register(to tableView: UITableView)
}

extension UITableViewCellRegisterable {
    static func nibName() -> String {
        return String(describing: self)
    }
    
    static func identifier() -> String {
        return nibName()
    }
}

extension UITableViewCellRegisterable where Self: UITableViewCell {
    static func register(to tableView: UITableView) {
        tableView.register(UINib(nibName: nibName(), bundle: nil), forCellReuseIdentifier: identifier())
    }
    
    static func dequeue(from tableView: UITableView) -> Self? {
        return tableView.dequeueReusableCell(withIdentifier: identifier()) as? Self
    }
    
    static func newCell() -> Self {
        let nibs = Bundle.main.loadNibNamed(nibName(), owner: self, options: nil)
        let cell = nibs?.first as? Self
        return cell!
    }
}

extension UITableViewCellRegisterable where Self: UITableViewHeaderFooterView {
    static func register(to tableView: UITableView) {
        tableView.register(UINib(nibName: nibName(), bundle: nil), forHeaderFooterViewReuseIdentifier: identifier())
    }
    
    static func dequeue(from tableView: UITableView) -> Self? {
        return tableView.dequeueReusableHeaderFooterView(withIdentifier: identifier()) as? Self
    }
}
