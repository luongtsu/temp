//
//  Font.swift
//  WeekPlan
//
//  Created by Luong Minh Hiep on 7/19/17.
//  Copyright © 2017 Luong Minh Hiep. All rights reserved.
//

import UIKit

struct Font {
    
    static let applicationFontName = "Helvetica Neue"
    static let applicationFontNameMedium = "HelveticaNeue-Medium"

    // Prevent creating instances outside of struct.
    fileprivate init() {}
    
    /**
     Create a font with application font family with given size.
     - parameter size: Size of the font.
     */
    static func create(size: CGFloat, medium: Bool = false) -> UIFont {
        let fontName = medium ? applicationFontNameMedium : applicationFontName
        return UIFont(name: fontName, size: size)!
    }
    
    // Dedine common fonts occordingly to design guideline
    static let titleBold     = Font.create(size: 17, medium: true)
    static let title         = Font.create(size: 17)
    static let subTitleBold  = Font.create(size: 14, medium: true)
    static let subTitle      = Font.create(size: 14)
    static let smallTextBold = Font.create(size: 10, medium: true)
    static let smallText     = Font.create(size: 10)
}
