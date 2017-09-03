//
//  MainTabController.swift
//  WeekPlan
//
//  Created by Luong Minh Hiep on 7/12/17.
//  Copyright © 2017 Luong Minh Hiep. All rights reserved.
//

import UIKit

class MainTabController: UITabBarController , UITabBarControllerDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        configTabbarAppearance()
    }
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        /*
         if let nav = viewController as? UINavigationController {
         nav.popToRootViewController(animated: false)
         }
         */
        return true
    }
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        if tabBarController.selectedIndex == 1 {
            if let _ = viewController as? UINavigationController {
            }
        }
    }
    
    private func configTabbarAppearance() {
        // Sets the default color of the icon of the selected UITabBarItem and Title
        UITabBar.appearance().tintColor = Color.tabbarTitleHighlight.value()
        
        // Sets the default color of the background of the UITabBar
        UITabBar.appearance().barTintColor = Color.tabbarBackground.value()
        
        UITabBar.appearance().barStyle = .default

        if #available(iOS 10.0, *) {
            UITabBar.appearance().unselectedItemTintColor = Color.tabbarTitleNormal.value()
        } else {
            // Fallback on earlier versions
        }
        
        //  Sets the background color of the selected UITabBarItem (using and plain colored UIImage with the width = 1/5 of the tabBar (if you have 5 items) and the height of the tabBar)
        /*
        UITabBar.appearance().selectionIndicatorImage = Color.tabbarTitleHighlight.makeImageWithSize(CGSize.init(width: tabBar.frame.width/5, height: tabBar.frame.height))
        */
        
        // Uses the original colors for your images, so they aren't not rendered as grey automatically.
        /*
        for item in self.tabBar.items! {
            if let image = item.image {
                item.image = image.withRenderingMode(.alwaysOriginal)
            }
        }
         */
    }
}

