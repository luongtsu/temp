//
//  String+Localized.swift
//  WeekPlan
//
//  Created by Luong Minh Hiep on 7/13/17.
//  Copyright © 2017 Luong Minh Hiep. All rights reserved.
//

import UIKit

extension String {
    /**
     - Brief: Swift 2 friendly localization syntax, replaces NSLocalizedString
     - Returns: The localized string.
     */
    var localized: String {
        
        //Log.verbose(String(describing: type(of: self)), params: ["localized key: " : self as AnyObject])
        
        var preferredLanguage = ""
        if Bundle.main.preferredLocalizations.count > 0 {
            preferredLanguage = Bundle.main.preferredLocalizations.first!
        } else {
            // Prefered localization language is fr in case if isn't set in .plist file.
            preferredLanguage = "fr"
        }
        
        let baseLanguage = "Base"
        preferredLanguage = "fr"
        
        if let path = Bundle.main.path(forResource: preferredLanguage, ofType: "lproj"), let bundle = Bundle(path: path) {
            return bundle.localizedString(forKey: self, value: nil, table: nil)
        } else if let path = Bundle.main.path(forResource: baseLanguage, ofType: "lproj"), let bundle = Bundle(path: path) {
            return bundle.localizedString(forKey: self, value: nil, table: nil)
        }
        return self
    }
    
    /**
     - Brief: Swift 2 friendly localization syntax with format arguments, replaces String(format:NSLocalizedString)
     - Returns: The formatted localized string with arguments.
     */
    func localizedFormat(_ arguments: CVarArg...) -> String {
        return String(format: localized, arguments: arguments)
    }
    
    /**
     - Brief: Swift 2 friendly plural localization syntax with a format argument
     - parameter argument: Argument to determine pluralisation
     - returns: Pluralized localized string.
     */
    func localizedPlural(_ argument: CVarArg) -> String {
        return NSString.localizedStringWithFormat(localized as NSString, argument) as String
    }
}
