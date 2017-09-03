//
//  TargetListVC.swift
//  WeekPlan
//
//  Created by Luong Minh Hiep on 7/14/17.
//  Copyright © 2017 Luong Minh Hiep. All rights reserved.
//

import UIKit

protocol TargetListPresentable {
    
    func addNewTargetButtonPressed()
}

class TargetListVC: BaseViewController {

    @IBOutlet weak var contentTableView: UITableView!
    
    var mainVM: TargetListVM!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mainVM = TargetListVM(presenter: self)
        setupUI()
        
        self.title = mainVM.pageTitle()
        //mainVM.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    private func configTableView() {
        Style1TableCell.register(to: contentTableView)
        Style6TableCell.register(to: contentTableView)
        TableHeaderFooterView.register(to: contentTableView)
        contentTableView.separatorStyle = .none
        contentTableView.backgroundColor = Color.gray237.value()
    }
    
    private func setupUI() {
        let addButtonInfo = BarButtonItemInfo(title: "", iconName: "ic_add_white", target: self, action: #selector(addButtonPressed(sender:)), style: .plain, barButtonSystemItem: nil)
        setNavigationBarRightItems(items: [addButtonInfo])
        configTableView()
    }
    
    @objc private func addButtonPressed(sender: Any) {
        mainVM.addNewTargetButtonPressed()
    }
}

// MARK: - TargetListPresenter

extension TargetListVC: TargetListPresenter {
    
    func updateTableViewCellHeight() {
        DispatchQueue.main.async { [weak self] in
            guard let `self` = self else { return }
            self.contentTableView.beginUpdates()
            self.contentTableView.endUpdates()
        }
    }
    
    func reloadTableView() {
        DispatchQueue.main.async { [weak self] in
            guard let `self` = self else { return }
            self.contentTableView.reloadData()
        }
    }
    
    func deselectRow(indexPath: IndexPath) {
        DispatchQueue.main.async { [weak self] in
            guard let `self` = self else { return }
            self.contentTableView.deselectRow(at: indexPath, animated: true)
        }
    }
    
    func makeRowVisible(indexPath: IndexPath) {
        DispatchQueue.main.async { [weak self] in
            guard let `self` = self else { return }
            self.contentTableView.scrollRectToVisible(self.contentTableView.rectForRow(at: indexPath), animated: true)
        }
    }
    
    func gotoAddNewTargetScreen(observer: TargetListUpdatable) {
        DispatchQueue.main.async { [weak self] in
            guard let `self` = self else { return }
            let vcToPresent = EditTargetVC.newVC(observer: observer)
            self.navigationController?.pushViewController(vcToPresent, animated: true)
        }
    }
    
    func gotoEditTargetScreen(observer: TargetListUpdatable, target: Target) {
        DispatchQueue.main.async { [weak self] in
            guard let `self` = self else { return }
            let vcToPresent = EditTargetVC.newVC(observer: observer, target: target)
            self.navigationController?.pushViewController(vcToPresent, animated: true)
        }
    }
    
    
    func gotoAddTimeToTargetScreen(observer: TargetListUpdatable, target: Target) {
        DispatchQueue.main.async {
            //[weak self] in
            //guard let `self` = self else { return }
            //let vcToPresent = AddTimeToTargetVC.newVC(observer: observer, target: target)
            //self.navigationController?.pushViewController(vcToPresent, animated: true)
        }
    }
}

// MARK: - UITableViewmainVM, UITableViewDelegate

extension TargetListVC: UITableViewDataSource, UITableViewDelegate {
    
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
            return cell
        }
        
        if let cellVM = cellViewModel as? Style6TableCellVM {
            guard let cell = Style6TableCell.dequeue(from: tableView) else {
                assertionFailure("Need config Style6TableCell")
                return UITableViewCell()
            }
            cell.config(viewModel: cellVM)
            cell.selectionStyle = .none
            return cell
        }
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        mainVM.didSelectRow(indexPath: indexPath)
    }
}
