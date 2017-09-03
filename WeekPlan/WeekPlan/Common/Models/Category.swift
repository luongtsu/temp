//
//  Category.swift
//  WeekPlan
//
//  Created by Luong Minh Hiep on 8/7/17.
//  Copyright © 2017 Luong Minh Hiep. All rights reserved.
//

import UIKit

enum TargetCategory: Int {
    case business = 0
    case casino
    case childCare
    case childFriendly
    case dateRange
    case directionsBike
    case directionsRun
    case directionsWalk
    case edit
    case favorite
    case fitnessCenter
    case freeBreakfast
    case golfCourse
    case headset
    case hotTub
    case kitchen
    case laptopMac
    case myLocation
    case pets
    case phoneiPhone
    case pool
    case publicWorld
    case school
    case spa
    case theaters
    case tv
    case work
    
    static func allValues() -> [TargetCategory] {
        var items = [TargetCategory]()
        for index in 0...30 {
            if let enumItem = TargetCategory(rawValue: index) {
                items.append(enumItem)
            }
        }
        return items
    }
    
    static func categoryOfIconName(_ iconName: String) -> TargetCategory {
        let allItems = TargetCategory.allValues()
        for item in allItems where item.info().iconName == iconName {
            return item
        }
        return self.spa
    }
    
    func index() -> Int {
        let allItems = TargetCategory.allValues()
        let counter = allItems.count - 1
        for index in 0...counter {
            let item = allItems[index]
            if item == self {
                return index
            }
        }
        return counter
    }
    
    func info() -> (tintColor: UIColor, iconName: String) {
        switch self {
        case .business: return (Color.categoryColor1.value(), "ic_business_center_48pt")
        case .casino: return (Color.categoryColor2.value(), "ic_casino_48pt")
        case .childCare: return (Color.categoryColor3.value(), "ic_child_care_48pt")
        case .childFriendly: return (Color.categoryColor4.value(), "ic_child_friendly_48pt")
        case .dateRange: return (Color.categoryColor5.value(), "ic_date_range_48pt")
        case .directionsBike: return (Color.categoryColor6.value(), "ic_directions_bike_48pt")
        case .directionsRun: return (Color.categoryColor2.value(), "ic_directions_run_48pt")
        case .directionsWalk: return (Color.categoryColor4.value(), "ic_directions_walk_48pt")
        case .edit: return (Color.categoryColor1.value(), "ic_edit_48pt")
        case .favorite: return (Color.categoryColor3.value(), "ic_favorite_48pt")
        case .fitnessCenter: return (Color.categoryColor5.value(), "ic_fitness_center_48pt")
        case .freeBreakfast: return (Color.categoryColor6.value(), "ic_free_breakfast_48pt")
        case .golfCourse: return (Color.categoryColor4.value(), "ic_golf_course_48pt")
        case .headset: return (Color.categoryColor3.value(), "ic_headset_48pt")
        case .hotTub: return (Color.categoryColor2.value(), "ic_hot_tub_48pt")
        case .kitchen: return (Color.categoryColor1.value(), "ic_kitchen_48pt")
        case .laptopMac: return (Color.categoryColor5.value(), "ic_laptop_mac_48pt")
        case .myLocation: return (Color.categoryColor2.value(), "ic_my_location_48pt")
        case .pets: return (Color.categoryColor4.value(), "ic_pets_48pt")
        case .phoneiPhone: return (Color.categoryColor6.value(), "ic_phone_iphone_48pt")
        case .pool: return (Color.categoryColor1.value(), "ic_pool_48pt")
        case .publicWorld: return (Color.categoryColor2.value(), "ic_public_48pt")
        case .school: return (Color.categoryColor5.value(), "ic_school_48pt")
        case .spa: return (Color.categoryColor4.value(), "ic_spa_48pt")
        case .theaters: return (Color.categoryColor6.value(), "ic_theaters_48pt")
        case .tv: return (Color.categoryColor1.value(), "ic_tv_48pt")
        case .work: return (Color.categoryColor2.value(), "ic_work_48pt")
        }
    }
}
