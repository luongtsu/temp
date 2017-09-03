//
//  TableHeaderFooterVM.swift
//  WeekPlan
//
//  Created by Luong Minh Hiep on 7/15/17.
//  Copyright © 2017 Luong Minh Hiep. All rights reserved.
//

import UIKit

struct TableHeaderFooterVM {
    
    let title: String
    var image: UIImage?
    
    init(title: String = "", image: UIImage? = nil) {
        self.title = title
        self.image = image
    }
}
