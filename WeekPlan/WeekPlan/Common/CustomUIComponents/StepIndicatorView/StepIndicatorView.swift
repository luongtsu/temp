//
//  StepIndicatorView.swift
//  WeekPlan
//
//  Created by Luong Minh Hiep on 8/19/17.
//  Copyright © 2017 Luong Minh Hiep. All rights reserved.
//

import UIKit

class StepIndicatorView: UINibView {

    @IBOutlet weak var imageView1: UIImageView!
    @IBOutlet weak var imageView2: UIImageView!
    @IBOutlet weak var imageView3: UIImageView!
    @IBOutlet weak var imageView4: UIImageView!
    @IBOutlet weak var imageView5: UIImageView!
    @IBOutlet weak var imageView6: UIImageView!
    @IBOutlet weak var imageView7: UIImageView!
    
    func config(activeIndexes: [Int]) {
        let imageViewSet: [UIImageView] = [imageView1, imageView2, imageView3, imageView4, imageView5, imageView6, imageView7]
        for index in 0...6 {
            let imageView = imageViewSet[index]
            if activeIndexes.contains(index) {
                imageView.image = UIImage(named: "dot_green")
            } else {
                imageView.image = UIImage(named: "dot_green_empty")
            }
        }
    }
    
    func configColor(tintColor: UIColor) {
        let imageViewSet: [UIImageView] = [imageView1, imageView2, imageView3, imageView4, imageView5, imageView6, imageView7]
        for index in 0...6 {
            let imageView = imageViewSet[index]
            imageView.image = imageView.image?.maskWithColor(color: tintColor)
        }
    }
}
