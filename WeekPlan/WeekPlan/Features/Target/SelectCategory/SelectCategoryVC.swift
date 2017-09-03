//
//  SelectCategoryVC.swift
//  WeekPlan
//
//  Created by Luong Minh Hiep on 8/6/17.
//  Copyright © 2017 Luong Minh Hiep. All rights reserved.
//

import UIKit

typealias SelectCategoryCompletion = (_ tintColor: UIColor,_ iconName: String) -> Void

class SelectCategoryVC: BaseViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var topTitleLabel: UILabel!
    @IBOutlet weak var middleTitleLabel: UILabel!
    @IBOutlet weak var colorContainerView: UIView!
    
    @IBOutlet weak var colorOption1: SelectableImageView!
    @IBOutlet weak var colorOption2: SelectableImageView!
    @IBOutlet weak var colorOption3: SelectableImageView!
    @IBOutlet weak var colorOption4: SelectableImageView!
    @IBOutlet weak var colorOption5: SelectableImageView!
    @IBOutlet weak var colorOption6: SelectableImageView!
    
    var itemsPerRow: CGFloat = 4
    let sectionInsets = UIEdgeInsets(top: 10.0, left: 10.0, bottom: 10.0, right: 10.0)
    
    var mainVM: SelectCategoryVM!
    
    class func newVC(tintColor: UIColor?, iconName: String?, completion: SelectCategoryCompletion?) -> SelectCategoryVC {
        let newVC = StoryBoard.main.viewController(classType: SelectCategoryVC.self) as? SelectCategoryVC
        newVC?.mainVM = SelectCategoryVM(tintColor: tintColor, iconName: iconName, presenter: newVC, completion: completion)
        return newVC!
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateNumberItemInARow()
        setupUI()
        
        self.title = mainVM.pageTitle()
        mainVM.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    private func updateNumberItemInARow() {
        guard Util.isPhone() else {
            itemsPerRow = 8
            return
        }
        itemsPerRow = 4
    }
    
    private func setupUI() {
        let submitButtonInfo = BarButtonItemInfo(title: "Done", iconName: nil, target: self, action: #selector(doneButtonPressed(sender:)), style: .plain, barButtonSystemItem: nil)
        self.setNavigationBarRightItems(items: [submitButtonInfo])
        
        addBackButtonOnNavigationBar()
        
        TextStyle.config(label: topTitleLabel, style: .title)
        TextStyle.config(label: middleTitleLabel, style: .title)
        
        topTitleLabel.text = "The icon color should be"
        middleTitleLabel.text = "Choose target's icon"
        
        configColorSelectionView()
        configCollectionView()
    }
    
    private func configColorSelectionView() {
        colorOption1.observer = self
        colorOption2.observer = self
        colorOption3.observer = self
        colorOption4.observer = self
        colorOption5.observer = self
        colorOption6.observer = self
        
        colorOption1.config(iconName: "Color1", tintColor: Color.categoryColor1.value())
        colorOption2.config(iconName: "Color1", tintColor: Color.categoryColor2.value())
        colorOption3.config(iconName: "Color1", tintColor: Color.categoryColor3.value())
        colorOption4.config(iconName: "Color1", tintColor: Color.categoryColor4.value())
        colorOption5.config(iconName: "Color1", tintColor: Color.categoryColor5.value())
        colorOption6.config(iconName: "Color1", tintColor: Color.categoryColor6.value())
        
        updateSelectedColorOption()
    }
    
    private func configCollectionView() {
        Style1CollectionCell.register(to: collectionView)
        collectionView.backgroundColor = Color.gray237.value()
    }
    
    @objc private func doneButtonPressed(sender: Any) {
        mainVM.updateSelectedItem()
        self.navigationController?.popViewController(animated: true)
    }
    
    func updateSelectedColorOption() {
        let allColors = [colorOption1, colorOption2, colorOption3, colorOption4, colorOption5, colorOption6]
        for item in allColors {
            if let itemColorOption = item, let mainColor = mainVM.tintColor {
                if itemColorOption.imageColor == mainColor {
                    itemColorOption.isSelected = true
                } else {
                    itemColorOption.isSelected = false
                }
            }
        }
    }
}


// MARK: - SelectCategoryPresenter

extension SelectCategoryVC: SelectableImageViewObservable {
    
    func didTapOnView(view: SelectableImageView) {
        mainVM.tintColor = view.imageColor
        updateSelectedColorOption()
    }
}

// MARK: - SelectCategoryPresenter

extension SelectCategoryVC: SelectCategoryPresenter {
    
    func reloadCollectionViewItems(indexPaths: [IndexPath]) {
        DispatchQueue.main.async { [weak self] _ in
            guard let `self` = self else { return }
            self.collectionView.reloadItems(at: indexPaths)
        }
    }
    
    func reloadCollectionView() {
        DispatchQueue.main.async { [weak self] _ in
            guard let `self` = self else { return }
            self.collectionView.reloadData()
        }
    }
    
    func deselectItem(indexPath: IndexPath) {
        DispatchQueue.main.async { [weak self] _ in
            guard let `self` = self else { return }
            self.collectionView.deselectItem(at: indexPath, animated: true)
        }
    }
}

// MARK: - UICollectionViewDataSource, UICollectionViewDelegate

extension SelectCategoryVC: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return mainVM.numberOfSections()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return mainVM.collectionView(numberOfItemsInSection: section)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cellViewModel = mainVM.viewModelForItem(indexPath: indexPath) else {
            return UICollectionViewCell()
        }
        
        if let cellVM = cellViewModel as? Style1CollectionCellVM {
            guard let cell = Style1CollectionCell.dequeue(from: collectionView, indexPath: indexPath) else {
                assertionFailure("Need config Style1CollectionCell")
                return UICollectionViewCell()
            }
            cell.config(viewModel: cellVM)
            return cell
        }

        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        mainVM.didSelectItem(indexPath: indexPath)
    }
}


// MARK: - UICollectionViewDelegateFlowLayout

extension SelectCategoryVC: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let paddingSpace = sectionInsets.left * (itemsPerRow + 1)
        let availableWidth = view.frame.width - paddingSpace
        let widthPerItem = availableWidth / itemsPerRow
        return CGSize(width: widthPerItem, height: widthPerItem)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsets
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return sectionInsets.left
    }
}

