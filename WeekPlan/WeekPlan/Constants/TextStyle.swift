//
//  TextStyle.swift
//  WeekPlan
//
//  Created by Luong Minh Hiep on 8/20/17.
//  Copyright © 2017 Luong Minh Hiep. All rights reserved.
//

import UIKit

enum TextStyle {
    
    case titleBold
    case title
    case titleLight
    case subTitleBold
    case subTitle
    case subTitleLight
    case smallTextBold
    case smallText
    case smallTextLight
    
    static func config(label: UILabel, style: TextStyle) {
        switch style {
        case .titleBold:
            label.textColor = Color.themeColor.value()
            label.font = Font.titleBold
        case .title:
            label.textColor = Color.themeColor.value()
            label.font = Font.title
        case .titleLight:
            label.textColor = Color.themeColorHaflAlpha.value()
            label.font = Font.title
        case .subTitleBold:
            label.textColor = Color.themeColor.value()
            label.font = Font.subTitleBold
        case .subTitle:
            label.textColor = Color.themeColor.value()
            label.font = Font.subTitle
        case .subTitleLight:
            label.textColor = Color.themeColorHaflAlpha.value()
            label.font = Font.subTitle
        case .smallTextBold:
            label.textColor = Color.themeColor.value()
            label.font = Font.smallTextBold
        case .smallText:
            label.textColor = Color.themeColor.value()
            label.font = Font.smallText
        case .smallTextLight:
            label.textColor = Color.themeColorHaflAlpha.value()
            label.font = Font.smallText
        }
    }
}
