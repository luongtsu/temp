//
//  EditTargetVC.swift
//  WeekPlan
//
//  Created by Luong Minh Hiep on 8/5/17.
//  Copyright © 2017 Luong Minh Hiep. All rights reserved.
//

import UIKit

class EditTargetVC: BaseViewController {

    @IBOutlet weak var contentTableView: UITableView!
    
    var mainVM: EditTargetVM!
    
    class func newVC(observer: TargetListUpdatable, target: Target? = nil) -> EditTargetVC {
        let newVC = StoryBoard.main.viewController(classType: EditTargetVC.self) as? EditTargetVC
        newVC?.mainVM = EditTargetVM(observer: observer, target: target, presenter: newVC)
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
    
    private func setupUI() {
        
        let submitButtonInfo = BarButtonItemInfo(title: "Done", iconName: nil, target: self, action: #selector(doneButtonPressed(sender:)), style: .plain, barButtonSystemItem: nil)
        self.setNavigationBarRightItems(items: [submitButtonInfo])
        
        addBackButtonOnNavigationBar()
        
        configTableView()
    }

    private func configTableView() {
        Style2TableCell.register(to: contentTableView)
        Style3TableCell.register(to: contentTableView)
        Style5TableCell.register(to: contentTableView)
        Style6TableCell.register(to: contentTableView)
        Style7TableCell.register(to: contentTableView)
        contentTableView.separatorStyle = .none
        contentTableView.backgroundColor = Color.gray237.value()
    }
    
    @objc private func doneButtonPressed(sender: Any) {
        mainVM.doneButtonPressed()
    }
}

// MARK: - EditTargetPresenter

extension EditTargetVC: EditTargetPresenter {
    
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
    
    func reloadTableViewRow(indexPaths: [IndexPath]) {
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
    
    func backToPreviousScreen() {
        DispatchQueue.main.async { [weak self] in
            guard let `self` = self else { return }
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    func gotoSelectCategoryBlock(tintColor: UIColor?, iconName: String?, completion: SelectCategoryCompletion?) {
        DispatchQueue.main.async { [weak self] in
            guard let `self` = self else { return }
            let vcToPresent = SelectCategoryVC.newVC(tintColor: tintColor, iconName: iconName, completion: completion)
            self.navigationController?.pushViewController(vcToPresent, animated: true)
        }
    }
}

// MARK: - UITableViewmainVM, UITableViewDelegate

extension EditTargetVC: UITableViewDataSource, UITableViewDelegate {
    
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
        
        if let cellVM = cellViewModel as? Style2TableCellVM {
            guard let cell = Style2TableCell.dequeue(from: tableView) else {
                assertionFailure("Need config Style2TableCell")
                return UITableViewCell()
            }
            cell.config(viewModel: cellVM)
            return cell
        }
        
        if let cellVM = cellViewModel as? Style3TableCellVM {
            guard let cell = Style3TableCell.dequeue(from: tableView) else {
                assertionFailure("Need config Style3TableCell")
                return UITableViewCell()
            }
            cell.config(viewModel: cellVM)
            return cell
        }
        
        if let cellVM = cellViewModel as? Style5TableCellVM {
            guard let cell = Style5TableCell.dequeue(from: tableView) else {
                assertionFailure("Need config Style5TableCell")
                return UITableViewCell()
            }
            cell.config(viewModel: cellVM)
            cell.accessoryType = .disclosureIndicator
            return cell
        }
        
        if let cellVM = cellViewModel as? Style6TableCellVM {
            guard let cell = Style6TableCell.dequeue(from: tableView) else {
                assertionFailure("Need config Style6TableCell")
                return UITableViewCell()
            }
            cell.config(viewModel: cellVM)
            return cell
        }
        
        if let cellVM = cellViewModel as? Style7TableCellVM {
            guard let cell = Style7TableCell.dequeue(from: tableView) else {
                assertionFailure("Need config Style7TableCell")
                return UITableViewCell()
            }
            cell.config(viewModel: cellVM)
            return cell
        }
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        mainVM.didSelectRow(indexPath: indexPath)
    }
}

