//
//  Utilities.swift
//  WeekPlan
//
//  Created by Luong Minh Hiep on 7/13/17.
//  Copyright © 2017 Luong Minh Hiep. All rights reserved.
//

import Foundation
import UIKit

import ReachabilitySwift

struct Util {
    
    static func generatedId() -> String {
        return "\(UUID().uuidString)-\(Date().timeIntervalSince1970)".replacingOccurrences(of: ".", with: "")
    }
    
    static func isPhone() -> Bool {
        return UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiom.phone
    }
    
    static func isPad() -> Bool {
        return UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiom.pad
    }
    
    /**
     Convert angle in degree to radian
     - returns: radian
     */
    static func degreeToRadian(degree: Float) -> Float {
        return degree * Float.pi / 180.0
    }
    
    /**
     Retrieve the new unique string.
     - returns:  unique string.
     */
    static func newGuide() -> String {
        return UUID().uuidString
    }
    
    /**
     Retrieve the UUID.
     - returns:  The UUID of the device.
     */
    static func deviceUUID() -> String {
        return UIDevice.current.identifierForVendor!.uuidString
    }
    
    /**
     Check if network reachable
     */
    static let reachability = Reachability()!
    static func isNetworkReachable() -> Bool {
        return reachability.isReachable
    }
    
    /**
     Retrieve the Date from string.
     - returns:  date.
     */
    static func frenchLocale() -> Locale {
        return Locale(identifier: "fr_FR")
    }
    
    /**
     Get Library Directory Path
     */
    static func applicationLibraryDirectoryPath() -> URL {
        let libraryDirectoryURL = FileManager.default.urls(for: .libraryDirectory, in: .userDomainMask)[0]
        return libraryDirectoryURL
    }
    
    /**
     Get Document Directory Path
     */
    static func applicationDocumentDirectoryPath() -> URL {
        let documentDirectoryURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        return documentDirectoryURL
    }
    
    /**
     Get excluded from iCloud back up path from given directory path
     */
    static func excludedDirectoryFromiCloudBackup(forDirectoryURL directoryURL: URL) -> URL {
        // Mark downloads folders excluding from iCloud backup
        var downloadPath = directoryURL
        do {
            var resourceValues = URLResourceValues()
            resourceValues.isExcludedFromBackup = true
            try downloadPath.setResourceValues(resourceValues)
        } catch _ {
            // do nothing
        }
        return downloadPath
    }
    
    /**
     Retrieve the Date, Month and Year from string follow system format.
     - returns:  string represent of date and month.(eg: 22/11/2016)
     */
    static func dateMonthYearStringPresentation(fromDate date: Date, format: String = "dd/MM/yyyy", locale: Locale = Locale.current) -> String {
        
        /*
            Format could be: "dd/MM, HH'h'mm", "d MMMM yyyy", "d MMMM", "MMMM yyyy"
        */
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        dateFormatter.locale = locale
        dateFormatter.timeZone = TimeZone.current
        let dateMonthString = dateFormatter.string(from: date)
        return dateMonthString
    }
    
    /**
     Retrieve the money string from price in Double and unit (if need).
     - description: If price >= 1 euros then use the format xx€xx. If price < 1 euros then use the format : x,xx € (Ex: 0,13 €). If the value is whole number, return x € without "00" in the end.
     - returns:  string represent of price and unit.
     */
    static func moneyPresentation(fromPrice price: Double, unit: String? = nil) -> String {
        var priceString = ""
        if price == 0 {
            priceString = "0 €"
        } else if price < 1 {
            let numberFormatter = NumberFormatter()
            numberFormatter.decimalSeparator = ","
            numberFormatter.positiveFormat = "0.00 €"
            numberFormatter.negativeFormat = "0.00 €"
            priceString = numberFormatter.string(from: NSNumber(value: price)) ?? "0 €"
        } else {
            let intValue = Int(price)
            let remainer = price - Double(intValue)
            if remainer == 0 {
                priceString = "\(intValue)€"
            } else {
                let numberFormatter = NumberFormatter()
                numberFormatter.decimalSeparator = "€"
                numberFormatter.positiveFormat = "0.00"
                numberFormatter.negativeFormat = "0.00"
                priceString = numberFormatter.string(from: NSNumber(value: price)) ?? "0 €"
            }
        }
        
        var result = ""
        if let `unit` = unit {
            result = "\(priceString) /\(unit)"
        } else {
            result = priceString
        }
        
        return result
    }
    
    /** Get rounded value to display for storage space
     Check it is shown on the middle of progress bar and the number should be rounded to 2 numbers after comma if exists (For instance: 5,25 Méga, 5 Méga, 200 Méga, 0.95 Giga
     */
    static func doubleNumberTwoFractionTruncatablePresentation(value: Double) -> String {
        let intValue = Int(value)
        let remainer = value - Double(intValue)
        if remainer > 0 {
            return String.init(format: "%.02f", value)
        } else {
            return "\(intValue)"
        }
    }
    
    static func secondToHourAndMinute(seconds: Int) -> String {
        let hours = seconds / 3600
        let minutes = (seconds / 60) % 60
        let seconds = seconds % 60
        var result = ""
        if hours > 0 {
            result += "\(hours)h"
        }
        if minutes > 0 {
            result += result.isEmpty ? "" : " "
            result += "\(minutes)m"
        }
        if seconds > 0 {
            result += result.isEmpty ? "" : " "
            result += "\(seconds)s"
        }
        return result
    }
    
    static func timeIntervalToString(timeDuration: TimeInterval) -> String {
        let seconds = Int(timeDuration)
        let hours = seconds / 3600
        let minutes = (seconds / 60) % 60
        let secondCount = seconds % 60
        var result = ""
        if hours > 0 {
            result += "\(hours)h"
        }
        if minutes > 0 {
            result += result.isEmpty ? "" : " "
            result += "\(minutes)m"
        }
        if secondCount > 0 {
            result += result.isEmpty ? "" : " "
            result += "\(secondCount)s"
        }
        result = result.isEmpty ? "0m" : result
        return result
    }
    
    typealias VoidCompletion = () -> Void
    static func showCustomAlert(title: String?, message: String, cancelTitle: String = "Cancel", confirmTitle: String = "OK", parent: UIViewController?, cancelHandler: VoidCompletion? = nil, completion: @escaping VoidCompletion) {
        let alert = UIAlertController(title: title ?? "", message: message, preferredStyle: .alert)
        if !cancelTitle.isEmpty {
            let dismissAction = UIAlertAction(title: cancelTitle, style: .cancel) { _ in
                if let `cancelHandler` = cancelHandler {
                    cancelHandler()
                }
            }
            alert.addAction(dismissAction)
        }
        
        let confirmAction = UIAlertAction(title: confirmTitle, style: .default) { _ in
            completion()
        }
        alert.addAction(confirmAction)
        
        let parentVC = parent ?? AppDelegate.share()?.window!.rootViewController!
        DispatchQueue.main.async {
            parentVC?.present(alert, animated: true, completion: nil)
        }
    }
    
    // MARK: - DATE TIME
    // First date of week or month is count from SUNDAY
    static func firstDateOfMonth(givenDate: Date) -> Date {
        let components = Calendar.current.dateComponents([.year, .month], from: givenDate)
        let startOfMonth = Calendar.current.date(from: components) ?? givenDate
        return startOfMonth
    }
    
    // From Sunday
    static func firstDateOfWeek(givenDate: Date) -> Date {
        let components = Calendar.current.dateComponents([.yearForWeekOfYear, .weekOfYear], from: givenDate)
        return Calendar.current.date(from: components) ?? givenDate
    }
    
    static func datesOfWeek(givenDate: Date) -> [Date] {
        let firstDate = Util.firstDateOfWeek(givenDate: givenDate)
        var dates = [firstDate]
        let dateInterval: TimeInterval = 24*60*60
        for index in 1...6 {
            let nextDate = Date(timeInterval: Double(index)*dateInterval, since: firstDate)
            dates.append(nextDate)
        }
        return dates
    }
    
    static func datesOfMonth(givenDate: Date) -> [Date] {
        let dateInterval: TimeInterval = 24*60*60
        let firstDate = Util.firstDateOfMonth(givenDate: givenDate)
        let firstDateNextMonth = Util.firstDateOfMonth(givenDate: Date.init(timeInterval: Double(32)*dateInterval, since: firstDate))
        var dates = [firstDate]
        for index in 1...30 {
            let nextDate = Date(timeInterval: Double(index)*dateInterval, since: firstDate)
            if nextDate < firstDateNextMonth && !Calendar.current.isDate(nextDate, inSameDayAs: firstDateNextMonth) {
                dates.append(nextDate)
            }
        }
        return dates
    }
}
