//
//  SelectTargetVC.swift
//  WeekPlan
//
//  Created by Luong Minh Hiep on 8/11/17.
//  Copyright © 2017 Luong Minh Hiep. All rights reserved.
//

import UIKit

typealias SelectTargetCompletion = (_ selectedTarget: Target?) -> Void

class SelectTargetVC: BaseViewController {
    
    @IBOutlet weak var contentTableView: UITableView!
    
    var mainVM: SelectTargetVM!
    
    class func newVC(selectedTarget: Target? = nil, completion: SelectTargetCompletion?) -> SelectTargetVC {
        let newVC = StoryBoard.main.viewController(classType: SelectTargetVC.self) as? SelectTargetVC
        newVC?.mainVM = SelectTargetVM(selectedTarget: selectedTarget, presenter: newVC, completion: completion)
        return newVC!
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        
        self.title = mainVM.pageTitle()
        mainVM.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    private func configTableView() {
        Style1TableCell.register(to: contentTableView)
        contentTableView.separatorStyle = .none
        contentTableView.backgroundColor = Color.gray237.value()
    }
    
    private func setupUI() {
        
        let submitButtonInfo = BarButtonItemInfo(title: "Done", iconName: nil, target: self, action: #selector(doneButtonPressed(sender:)), style: .plain, barButtonSystemItem: nil)
        self.setNavigationBarRightItems(items: [submitButtonInfo])
        
        addBackButtonOnNavigationBar()
        
        configTableView()
    }
    
    @objc private func doneButtonPressed(sender: Any) {
        mainVM.updateSelectedTarget()
        self.navigationController?.popViewController(animated: true)
    }
}

// MARK: - SelectTargetPresenter

extension SelectTargetVC: SelectTargetPresenter {
    
    func reloadTableView() {
        DispatchQueue.main.async { [weak self] in
            guard let `self` = self else { return }
            self.contentTableView.reloadData()
        }
    }
    
    func reloadTableViewCells(indexPaths: [IndexPath]) {
        DispatchQueue.main.async { [weak self] in
            guard let `self` = self else { return }
            self.contentTableView.reloadRows(at: indexPaths, with: .automatic)
        }
    }
    
    func deselectRow(indexPath: IndexPath) {
        DispatchQueue.main.async { [weak self] in
            guard let `self` = self else { return }
            self.contentTableView.deselectRow(at: indexPath, animated: true)
        }
    }
}

// MARK: - UITableViewmainVM, UITableViewDelegate

extension SelectTargetVC: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return mainVM.numberOfSection()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mainVM.numberOfRows(inSection: section)
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return mainVM.heightForHeader(inSection: section)
    }
    
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let headerVM = mainVM.viewModelForHeader(inSection: section) as? TableHeaderFooterVM else {
            return nil
        }
        
        guard let headerView = TableHeaderFooterView.dequeue(from: tableView) else {
            return nil
        }
        
        headerView.config(cellVM: headerVM)
        return headerView
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return mainVM.heightForRow(atIndexPath: indexPath)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cellViewModel = mainVM.viewModelForCell(atIndexPath: indexPath) else {
            return UITableViewCell()
        }
        
        if let cellVM = cellViewModel as? Style1TableCellVM {
            guard let cell = Style1TableCell.dequeue(from: tableView) else {
                assertionFailure("Need config Style1TableCell")
                return UITableViewCell()
            }
            cell.config(viewModel: cellVM)
            cell.selectionStyle = .`default`
            cell.accessoryType = .checkmark
            
            let target = TargetManager.shared.allTargets[indexPath.row]
            if let selectedTarget = mainVM.selectedTarget, selectedTarget.key == target.key {
                //cell.accessoryType = .checkmark
                cell.tintColor = UIColor.blue
            } else {
                //cell.accessoryType = .none
                cell.tintColor = UIColor.clear
            }
            
            return cell
        }
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        mainVM.didSelectRow(indexPath: indexPath)
    }
}

