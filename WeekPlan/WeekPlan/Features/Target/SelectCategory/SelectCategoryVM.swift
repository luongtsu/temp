//
//  SelectCategoryVM.swift
//  WeekPlan
//
//  Created by Luong Minh Hiep on 8/6/17.
//  Copyright © 2017 Luong Minh Hiep. All rights reserved.
//

import UIKit

protocol SelectCategoryPresenter: class {
    
    func updateSelectedColorOption()
    func reloadCollectionViewItems(indexPaths: [IndexPath])
    func reloadCollectionView()
    func deselectItem(indexPath: IndexPath)
}

class SelectCategoryVM: BaseViewControllerPresentable {
    
    weak var presenter: SelectCategoryPresenter?
    var completion: SelectCategoryCompletion?
    
    var tintColor: UIColor?
    var iconName: String?
    var items: [TargetCategory] = TargetCategory.allValues()
    
    var lastSelectedIndexPath: IndexPath!
    
    init(tintColor: UIColor?, iconName: String?, presenter: SelectCategoryPresenter?, completion: SelectCategoryCompletion?) {
        self.tintColor = tintColor
        self.iconName = iconName
        self.presenter = presenter
        self.completion = completion
        
        // update selected index
        var resultFound: Bool = false
        if let iconNameValue = iconName {
            let listOfItem = TargetCategory.allValues()
            let total = listOfItem.count - 1
            
            for index in 0...total {
                let item = listOfItem[index]
                if item.info().iconName == iconNameValue {
                    lastSelectedIndexPath = IndexPath(item: index, section: 0)
                    if tintColor == nil {
                        self.tintColor = item.info().tintColor
                    }
                    resultFound = true
                    break
                }
            }
        }
        
        // get default value
        if !resultFound {
            let firstItem = TargetCategory.allValues()[0]
            self.tintColor = firstItem.info().tintColor
            self.iconName = firstItem.info().iconName
            self.lastSelectedIndexPath = IndexPath(item: 0, section: 0)
        }
    }
    
    func updateSelectedItem() {
        guard let `completion` = completion, let `tintColor` = tintColor, let `iconName` = iconName else {
            return
        }
        completion(tintColor, iconName)
    }
    
    func pageTitle() -> String {
        return "Select icon & color"
    }

    func viewDidLoad() {
        presenter?.reloadCollectionView()
    }
}

extension SelectCategoryVM {
    
    func numberOfSections() -> Int {
        return 1
    }
    
    func collectionView(numberOfItemsInSection section: Int) -> Int {
        return items.count
    }

    func viewModelForItem(indexPath: IndexPath) -> Any? {
        
        guard items.count > indexPath.item else {
            return nil
        }
        
        let category = items[indexPath.item]
        
        let cellVM = Style1CollectionCellVM(imageName: category.info().iconName, tintColor: category.info().tintColor)
        if category.info().iconName == iconName {
            cellVM.isSelected = true
            if lastSelectedIndexPath == nil {
                lastSelectedIndexPath = indexPath
            }
        }
        
        return cellVM
    }
    
    func didSelectItem(indexPath: IndexPath) {
        
        guard items.count > indexPath.item, indexPath != lastSelectedIndexPath else {
            return
        }
        
        iconName = items[indexPath.item].info().iconName
        tintColor = items[indexPath.item].info().tintColor
        presenter?.updateSelectedColorOption()
        
        defer {
            presenter?.deselectItem(indexPath: indexPath)
        }
        
        presenter?.reloadCollectionViewItems(indexPaths: [indexPath, lastSelectedIndexPath])
        lastSelectedIndexPath = indexPath
        
    }
}
