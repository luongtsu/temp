//
//  CustomMenuView.swift
//  WeekPlan
//
//  Created by Luong Minh Hiep on 7/15/17.
//  Copyright © 2017 Luong Minh Hiep. All rights reserved.
//

import UIKit
import WCLShineButton

protocol ButtonIconTextResponsible: class {
    
    func optionButtonIsPressed(type: ButtonMenuType)
}

enum ButtonMenuType: String {
    case done = "Done"
    case cancel = "Cancel"
    case skip = "Skip"
    case undo = "Undo"
    case trend = "Trend"
    case edit = "Edit"
    
    func icon() -> UIImage? {
        switch self {
        case .edit: return UIImage(named: "ic_mode_edit_ex_36pt")
        case .done: return UIImage(named: "ic_done_ex_36pt")
        case .cancel: return UIImage(named: "ic_cancel_ex_36pt")
        case .skip: return UIImage(named: "ic_skip_next_ex_36pt")
        case .undo: return UIImage(named: "ic_undo_ex_36pt")
        case .trend: return UIImage(named: "ic_show_chart_ex_36pt")
        }
    }
    
    func color() -> UIColor {
        switch self {
        case .edit: return Color.categoryColor3.value()
        case .done: return Color.categoryColor2.value()
        case .cancel: return Color.categoryColor1.value()
        case .skip: return Color.categoryColor6.value()
        case .undo: return Color.themeColor.value()
        case .trend: return Color.themeColor.value()
        }
    }
}


class CustomMenuView: UINibView {

    @IBOutlet weak var button1: WCLShineButton!
    @IBOutlet weak var button2: WCLShineButton!
    @IBOutlet weak var button3: WCLShineButton!
    @IBOutlet weak var button4: WCLShineButton!
    @IBOutlet weak var button5: WCLShineButton!
    @IBOutlet weak var button1extra: WCLShineButton!
    
    @IBOutlet weak var label1: UILabel!
    @IBOutlet weak var label2: UILabel!
    @IBOutlet weak var label3: UILabel!
    @IBOutlet weak var label4: UILabel!
    @IBOutlet weak var label5: UILabel!
    @IBOutlet weak var label1extra: UILabel!
    
    var doneStatus: RecordStatus = .open {
        didSet {
            updateUI()
        }
    }
    
    func updateUI() {
        var shouldShowUndoButton = true
        var shouldShowDoneButton = true
        
        switch doneStatus {
        case .open:
            shouldShowDoneButton = true
            shouldShowUndoButton = false
        case .done, .cancel, .skip:
            shouldShowDoneButton = false
            shouldShowUndoButton = true
        case .unknow:
            shouldShowDoneButton = false
            shouldShowUndoButton = false
        }
        
        button1extra.isHidden = !shouldShowUndoButton
        label1extra.isHidden = !shouldShowUndoButton
        
        button1.isHidden = !shouldShowDoneButton
        label1.isHidden = !shouldShowDoneButton

        button2.isHidden = !shouldShowDoneButton
        label2.isHidden = !shouldShowDoneButton

        button3.isHidden = !shouldShowDoneButton
        label3.isHidden = !shouldShowDoneButton
        
        layoutIfNeeded()
    }
    
    @IBAction func button1Pressed(_ sender: Any) {
        buttonPressed(sender)
    }
    
    @IBAction func button2Pressed(_ sender: Any) {
        buttonPressed(sender)
    }
    
    @IBAction func button3Pressed(_ sender: Any) {
        buttonPressed(sender)
    }
    
    @IBAction func button4Pressed(_ sender: Any) {
        buttonPressed(sender)
    }
    
    @IBAction func button5Pressed(_ sender: Any) {
        buttonPressed(sender)
    }
    
    @IBAction func button1extraPressed(_ sender: Any) {
        buttonPressed(sender)
    }
    
    private func buttonPressed(_ sender: Any) {
        guard let button = sender as? WCLShineButton else {
            return
        }
        switch button {
        case button1:
            print("1")
            actionResponder?.optionButtonIsPressed(type: .done)
        case button2:
            print("2")
            actionResponder?.optionButtonIsPressed(type: .cancel)
        case button3:
            print("3")
            actionResponder?.optionButtonIsPressed(type: .skip)
        case button4:
            print("4")
            actionResponder?.optionButtonIsPressed(type: .trend)
        case button5:
            print("5")
            actionResponder?.optionButtonIsPressed(type: .edit)
        case button1extra:
            print("1Etra")
            actionResponder?.optionButtonIsPressed(type: .undo)
        default: print("0")
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] _ in
            guard let `self` = self else { return }
            self.button1.isSelected = false
            self.button2.isSelected = false
            self.button3.isSelected = false
            self.button4.isSelected = false
            self.button5.isSelected = false
            self.button1extra.isSelected = false
            self.layoutIfNeeded()
        }
        
    }
    
    weak var actionResponder: ButtonIconTextResponsible?
    
    func config(actionResponder: ButtonIconTextResponsible?) {
        self.actionResponder = actionResponder
        configUI()
    }
    
    func configButton(btn: WCLShineButton, type: ButtonMenuType) {
        var params = WCLShineParams()
        params.allowRandomColor = true
        params.enableFlashing = false
        
        btn.backgroundColor = UIColor.clear
        btn.fillColor = Color.categoryColor5.value()
        btn.color = type.color()
        btn.params = params
        btn.image = WCLShineImage.custom(type.icon()!)
        btn.isSelected = false
    }
    
    func configButtonLabel(label: UILabel, type: ButtonMenuType) {
        TextStyle.config(label: label, style: .smallText)
        label.text = type.rawValue
        label.textColor = type.color()
    }
    
    private func configUI() {
        
        configButton(btn: button1, type: .done)
        configButton(btn: button2, type: .cancel)
        configButton(btn: button3, type: .skip)
        configButton(btn: button4, type: .trend)
        configButton(btn: button5, type: .edit)
        configButton(btn: button1extra, type: .undo)
        
        configButtonLabel(label: label1, type: .done)
        configButtonLabel(label: label2, type: .cancel)
        configButtonLabel(label: label3, type: .skip)
        configButtonLabel(label: label4, type: .trend)
        configButtonLabel(label: label5, type: .edit)
        configButtonLabel(label: label1extra, type: .undo)
        
        layoutIfNeeded()
    }
}



