//
//  SelectTargetVM.swift
//  WeekPlan
//
//  Created by Luong Minh Hiep on 8/11/17.
//  Copyright © 2017 Luong Minh Hiep. All rights reserved.
//

import UIKit

protocol SelectTargetPresenter: class {
    func reloadTableView()
    func reloadTableViewCells(indexPaths: [IndexPath])
    func deselectRow(indexPath: IndexPath)
}


class SelectTargetVM: BaseViewControllerPresentable {
    
    weak var selectedTarget: Target?
    weak var presenter: SelectTargetPresenter?
    var completion: SelectTargetCompletion?
    
    var lastSelectedIndexPath: IndexPath?
    
    required init(selectedTarget: Target?, presenter: SelectTargetPresenter?, completion: SelectTargetCompletion?) {
        self.selectedTarget = selectedTarget
        self.presenter = presenter
        self.completion = completion
        registerNotification()
    }
    
    deinit {
        unregisterNotification()
    }
    
    private func registerNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(targetIsChanged(notification:)), name:NSNotification.Name(rawValue: TargetManager.notifyListOfTargetIsChanged), object: nil)
    }
    
    private func unregisterNotification() {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc private func targetIsChanged(notification: Notification) {
        self.presenter?.reloadTableView()
    }
    
    func pageTitle() -> String {
        return "Select target"
    }
    
    func viewDidLoad() {
        presenter?.reloadTableView()
    }
    
    func updateSelectedTarget() {
        completion?(selectedTarget)
    }
}

// MARK: - TableViewPresentable

extension SelectTargetVM: TableViewPresentable {
    
    func numberOfSection() -> Int {
        return 1
    }
    
    func numberOfRows(inSection section: Int) -> Int {
        return TargetManager.shared.allTargets.count
    }
    
    func heightForHeader(inSection section: Int) -> CGFloat {
        return 0
    }
    
    func viewModelForHeader(inSection section: Int) -> Any? {
        return nil
    }
    
    func heightForRow(atIndexPath indexPath: IndexPath) -> CGFloat {
        return Style1TableCell.cellHeightNormal
    }
    
    func estimatedHeightForRow(atIndexPath indexPath: IndexPath) -> CGFloat {
        return heightForRow(atIndexPath: indexPath)
    }
    
    func viewModelForCell(atIndexPath indexPath: IndexPath) -> Any? {
        guard indexPath.row < TargetManager.shared.allTargets.count else {
            return nil
        }
        
        var separatorStyle: TableViewSeparatorStyle = .dynamic
        if indexPath.row == TargetManager.shared.allTargets.count - 1 {
            separatorStyle = .fullLine
        }
        
        let target = TargetManager.shared.allTargets[indexPath.row]
        if let `selectedTarget` = selectedTarget, selectedTarget.key == target.key {
            lastSelectedIndexPath = indexPath
        }
        
        return Style1TableCellVM(tintColor: target.tintColor.value(), leftImageName: target.iconName, topTitle: target.name, middleTitle: target.currentStreakDescription(), doneStatus: target.todayRecordStatus(), isSelected: false, shouldAlwaysHideMenuView: true, separatorStyle: separatorStyle)
    }
    
    func didSelectRow(indexPath: IndexPath) {
  
        presenter?.deselectRow(indexPath: indexPath)
        
        selectedTarget = TargetManager.shared.allTargets[indexPath.row]
        
        if let lastIndex = lastSelectedIndexPath {
            if lastIndex == indexPath {
                // do nothing
            } else {
                lastSelectedIndexPath = indexPath
                presenter?.reloadTableViewCells(indexPaths: [lastIndex, indexPath])
            }
        } else {
            lastSelectedIndexPath = indexPath
            presenter?.reloadTableViewCells(indexPaths: [indexPath])
        }
        
        
    }
}
