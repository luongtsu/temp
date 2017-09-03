//
//  BaseCollectionCell.swift
//  WeekPlan
//
//  Created by Luong Minh Hiep on 8/6/17.
//  Copyright © 2017 Luong Minh Hiep. All rights reserved.
//

import UIKit

protocol UICollectionViewCellRegisterable: class {
    static func nibName() -> String
    static func identifier() -> String
    static func register(to collectionView: UICollectionView)
}

extension UICollectionViewCellRegisterable {
    static func nibName() -> String {
        return String(describing: self)
    }
    
    static func identifier() -> String {
        return nibName()
    }
}

extension UICollectionViewCellRegisterable where Self: UICollectionViewCell {
    static func register(to collectionView: UICollectionView) {
        collectionView.register(UINib(nibName: nibName(), bundle: nil), forCellWithReuseIdentifier: identifier())
    }
    
    static func dequeue(from collectionView: UICollectionView, indexPath: IndexPath) -> Self? {
        return collectionView.dequeueReusableCell(withReuseIdentifier: identifier(), for: indexPath) as? Self
    }
    
    static func newCell() -> Self {
        let nibs = Bundle.main.loadNibNamed(nibName(), owner: self, options: nil)
        let cell = nibs?.first as? Self
        return cell!
    }
}


class BaseCollectionCell: UICollectionViewCell, UICollectionViewCellRegisterable {
    
}
