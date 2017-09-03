//
//  StoryBoard.swift
//  WeekPlan
//
//  Created by Luong Minh Hiep on 7/12/17.
//  Copyright © 2017 Luong Minh Hiep. All rights reserved.
//

import UIKit

enum StoryBoard: String {
    case main = "Main"
    case common = "Common"
    
    var storyboard: UIStoryboard {
        return UIStoryboard(name: self.rawValue, bundle: Bundle.main)
    }
    
    func viewController(classType: AnyClass) -> UIViewController {
        return self.storyboard.instantiateViewController(withIdentifier: "\(classType)")
    }
}




