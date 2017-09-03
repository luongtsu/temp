//
//  BaseViewController.swift
//  WeekPlan
//
//  Created by Luong Minh Hiep on 7/13/17.
//  Copyright © 2017 Luong Minh Hiep. All rights reserved.
//

import UIKit

struct BarButtonItemInfo {
    
    var title: String?
    var iconName: String?
    var target: UIViewController?
    var action: Selector?
    var style: UIBarButtonItemStyle = .plain
    var barButtonSystemItem: UIBarButtonSystemItem?
    
    func barButtonItem() -> UIBarButtonItem {
        var barButtonItem: UIBarButtonItem
        if let `barButtonSystemItem` = barButtonSystemItem {
            barButtonItem = UIBarButtonItem(barButtonSystemItem: barButtonSystemItem, target: target, action: action)
        } else {
            if let `iconName` =  iconName {
                barButtonItem = UIBarButtonItem(image: UIImage(named: iconName), style: style, target: target, action: action)
            } else {
                barButtonItem = UIBarButtonItem(title: title, style: style, target: target, action: action)
            }
        }
        barButtonItem.tintColor = Color.whiteColor.value()
        return barButtonItem
    }
}

class BaseViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.backBarButtonItem?.tintColor = UIColor.white
        self.navigationItem.hidesBackButton = true
        
        self.navigationController?.navigationBar.barTintColor = Color.themeColor.value()
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: Color.whiteColor.value()]
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UIApplication.shared.statusBarStyle = .lightContent
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    // BACK button for child view controller which is pushed to navigation controller
    func addBackButtonOnNavigationBar() {
        self.navigationItem.hidesBackButton = false
        let backButton = UIBarButtonItem(image: UIImage(named: "ic_keyboard_arrow_left_white"), style: .plain, target: self, action: #selector(BaseViewController.backButtonTapped(sender:)))
        backButton.tintColor = Color.whiteColor.value()
        self.navigationItem.leftBarButtonItem = backButton
    }
    
    func backButtonTapped(sender: UIBarButtonItem) {
        self.view.endEditing(true)
        _ = navigationController?.popViewController(animated: true)
    }
    
    // Add right navigation bar button item with given type
    func addNavigationBarRightButton(buttonType: UIBarButtonSystemItem) {
        let doneButton = UIBarButtonItem(barButtonSystemItem: buttonType, target: self, action: #selector(BaseViewController.rightNavigationBarButtonTapped(sender:)))
        doneButton.tintColor = Color.whiteColor.value()
        self.navigationItem.rightBarButtonItem = doneButton
    }
    
    func rightNavigationBarButtonTapped(sender: UIBarButtonItem) {
       // do nothing
    }
    
    /**
     let okButton = BarButtonItemInfo(title: "global_ok".localized, iconName: nil, target: self, action: #selector(okButtonPressed(sender:)), style: .plain, barButtonSystemItem: nil)
     self.setNavigationBarRightItems(items: [okButton])
     */
    // Set left bar items
    func setNavigationBarLeftItems(items: [BarButtonItemInfo]) {
        var barItems = [UIBarButtonItem]()
        for barButtunInfo in items {
            barItems.append(barButtunInfo.barButtonItem())
        }
        self.navigationItem.leftBarButtonItems = barItems
    }
    
    // Set right bar items
    func setNavigationBarRightItems(items: [BarButtonItemInfo]) {
        var barItems = [UIBarButtonItem]()
        for barButtunInfo in items {
            barItems.append(barButtunInfo.barButtonItem())
        }
        self.navigationItem.rightBarButtonItems = barItems
    }
    
    deinit {
        print("Dealloc \(String(describing: type(of: self)))")
    }
}
