//
//  Color.swift
//  WeekPlan
//
//  Created by Luong Minh Hiep on 7/13/17.
//  Copyright © 2017 Luong Minh Hiep. All rights reserved.
//

import UIKit

enum Color: Int {
    case themeColor = 0
    case themeColorHaflAlpha
    case greenColor
    case redColor
    case whiteColor
    
    case categoryColor1
    case categoryColor2
    case categoryColor3
    case categoryColor4
    case categoryColor5
    case categoryColor6
    
    case tabbarBackground
    case tabbarTitleNormal
    case tabbarTitleHighlight
    
    case gray120
    case gray150
    case gray180
    case gray237
    case gray247
    
    // CollectionView item
    case selectedItemBackground
    
    // Custom Selection View
    case selectionItemBackgroundNormal
    case selectionItemBackgroundSelected
    
    // Custommenu
    case targetItemBackgroundOpen
    case targetItemBackgroundDone
    case targetItemBackgroundCancel
    case targetItemBackgroundSkip
    case targetItemBackgroundUnknow
    
    func value() -> UIColor {
        switch self {
        case .themeColor: return  UIColor.rgb(16, 114, 190)
        case .themeColorHaflAlpha: return  UIColor.rgb(23, 67, 119, 0.5)
        case .greenColor: return  UIColor.rgb(19, 144, 71)
        case .redColor: return  UIColor.rgb(199, 32, 37)
        case .whiteColor: return  UIColor.rgb(250, 250, 250)
            
        case .categoryColor1: return  UIColor.rgb(221, 64, 82)
        case .categoryColor2: return  UIColor.rgb(117, 190, 82)
        case .categoryColor3: return  UIColor.rgb(33,	166, 181)
        case .categoryColor4: return  UIColor.rgb(237, 201, 69)
        case .categoryColor5: return  UIColor.rgb(232, 130, 48)
        case .categoryColor6: return  UIColor.rgb(154, 128, 183)
            
        // Tabbar
        case .tabbarBackground: return  UIColor.rgb(250, 250, 250)
        case .tabbarTitleNormal: return  UIColor.rgb(120, 120, 120)
        case .tabbarTitleHighlight: return  UIColor.rgb(16, 114, 190)
            
        case .gray120 : return  UIColor.rgb(120, 120, 120)
        case .gray150 : return  UIColor.rgb(150, 150, 150)
        case .gray180 : return  UIColor.rgb(180, 180, 180)
        case .gray237 : return  UIColor.rgb(237, 237, 237)
        case .gray247 : return  UIColor.rgb(247, 247, 247)
            
        // CollectionView item
        case .selectedItemBackground: return  UIColor.rgb(200, 200, 200, 0.5)
            
        // Custom Selection View
        case .selectionItemBackgroundNormal: return  UIColor.rgb(200, 200, 200, 0.2)
        case .selectionItemBackgroundSelected: return  UIColor.rgb(19, 144, 71, 0.2)
            
        // Custommenu
        case .targetItemBackgroundOpen: return  UIColor.rgb(250, 250, 250)
        case .targetItemBackgroundDone: return  UIColor.rgb(19, 144, 71, 0.1)
        case .targetItemBackgroundCancel: return  UIColor.rgb(219, 66, 85, 0.1)
        case .targetItemBackgroundSkip: return  UIColor.rgb(154, 128, 183, 0.1)
        case .targetItemBackgroundUnknow: return  UIColor.rgb(120, 120, 120, 0.1)
        }
    }
    
    static func itemOfColor(givenColor: UIColor?) -> Color? {
        guard let `givenColor` = givenColor else {
            return nil
        }
        var colors: [Color] = []
        for index in 0...30 {
            if let color = Color.init(rawValue: index) {
                colors.append(color)
            }
        }
        for item in colors where item.value() == givenColor {
            return item
        }
        return nil
    }
}
