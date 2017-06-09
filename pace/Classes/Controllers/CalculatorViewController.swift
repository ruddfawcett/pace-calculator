//
//  CalculatorViewController.swift
//  Pace
//
//  Created by Rudd Fawcett on 6/6/17.
//  Copyright © 2017 Rudd Fawcett. All rights reserved.
//

import UIKit

class CalculatorViewController: UIViewController {
    @IBOutlet weak var topView: UIView!
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var menuView: MenuView!
    
    var distanceEditor: DistanceEditor!
    var timeEditor: TimeEditor!
    var splitEditor: TimeEditor!
    
    @IBOutlet weak var keyboardUnderlay: UIView!
    @IBOutlet weak var keyboardUnderlayOverlay: UIView!
    var keyboardHeight: CGFloat = 0.0
    var showedKeyboard: Bool = false
    
    var mode: MenuItem! = .Distance
    var inputAccessoryToolbar: Toolbar!
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        splitEditor.minuteField.becomeFirstResponder()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.distanceEditor = instanceFromNib(name: "DistanceEditor") as! DistanceEditor
        self.timeEditor = instanceFromNib(name: "TimeEditor") as! TimeEditor
        self.splitEditor = instanceFromNib(name: "TimeEditor") as! TimeEditor
        
        self.distanceEditor.input.delegate = self
        self.timeEditor.minuteField.delegate = self
        self.timeEditor.secondField.delegate = self
        self.splitEditor.minuteField.delegate = self
        self.splitEditor.secondField.delegate = self
        
        self.inputAccessoryToolbar = instanceFromNib(name: "Toolbar") as! Toolbar
        
        splitEditor.label.text = "500m Split"
        timeEditor.label.text = "Time"
        
        topView.addSubview(splitEditor)
        bottomView.addSubview(timeEditor)
        
        menuView.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func instanceFromNib(name: String) -> UIView {
        let view = UINib(nibName: name, bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! UIView
        view.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: view.frame.height)
        return view
    }
}

extension CalculatorViewController: MenuDelegate {
    func didSelectItem(item: MenuItem) {
        distanceEditor.removeFromSuperview()
        splitEditor.removeFromSuperview()
        timeEditor.removeFromSuperview()
        
        switch item {
        case .Distance:
            inputAccessoryToolbar.leftLabel.text = "Distance"
            inputAccessoryToolbar.rightLabel.text = "Watts"
            
            topView.addSubview(splitEditor)
            splitEditor.minuteField.text = ""
            splitEditor.secondField.text = ""
            
            bottomView.addSubview(timeEditor)
            timeEditor.minuteField.text = ""
            timeEditor.secondField.text = ""
            
            mode = .Distance
            
            splitEditor.minuteField.becomeFirstResponder()
            break
        case .Split:
            inputAccessoryToolbar.leftLabel.text = "Split"
            inputAccessoryToolbar.rightLabel.text = "Watts"
            
            topView.addSubview(distanceEditor)
            distanceEditor.input.text = ""
            
            bottomView.addSubview(timeEditor)
            timeEditor.minuteField.text = ""
            timeEditor.secondField.text = ""
            
            mode = .Split
            
            distanceEditor.input.becomeFirstResponder()
            break
        case .Time:
            inputAccessoryToolbar.leftLabel.text = "Time"
            inputAccessoryToolbar.rightLabel.text = "Watts"
            
            topView.addSubview(distanceEditor)
            distanceEditor.input.text = ""
            
            bottomView.addSubview(splitEditor)
            splitEditor.minuteField.text = ""
            splitEditor.secondField.text = ""
            
            mode = .Time
            
            distanceEditor.input.becomeFirstResponder()
            break
        }
    }
    
    override var inputAccessoryView: UIView? {
        return self.inputAccessoryToolbar
    }
    
}

extension CalculatorViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        var watts: Float = 0.0
        
        if (mode == .Distance) {
            let split = textToTime(editor: splitEditor, textField: textField, range: range, replacementString: string)
            let time = textToTime(editor: timeEditor, textField: textField, range: range, replacementString: string)
            
            let distance = Calculator.distance(split: split, time: time)
            watts = Calculator.watts(split: split)
            
            self.inputAccessoryToolbar.leftLabel.text = "\(distance)m"
        }
        
        if (mode == .Split) {
            let distance = textToDistance(editor: distanceEditor, textField: textField, range: range, replacementString: string)
            let time = textToTime(editor: timeEditor, textField: textField, range: range, replacementString: string)
            let split = Calculator.split(distance: distance, time: time)
            watts = Calculator.watts(split: split)
            
            self.inputAccessoryToolbar.leftLabel.text = "\(split.description)"
        }
        
        if (mode == .Time) {
            let distance = textToDistance(editor: distanceEditor, textField: textField, range: range, replacementString: string)
            let split = textToTime(editor: splitEditor, textField: textField, range: range, replacementString: string)
            let time = Calculator.time(distance: distance, split: split)
            watts = Calculator.watts(split: split)
            
            self.inputAccessoryToolbar.leftLabel.text = "\(time.description)"
        }
        
        
        
        if !watts.isNaN && !watts.isInfinite {
            self.inputAccessoryToolbar.rightLabel.text = "\(watts)w"
        }
        else {
            self.inputAccessoryToolbar.rightLabel.text = "0w"
        }
        
        
        return true
    }
    
    func textToTime(editor: TimeEditor, textField: UITextField, range: NSRange, replacementString string: String) -> Time {
        var minuteString: NSString! = NSString()
        if textField == editor.minuteField {
            if let minString = editor.minuteField.text {
                minuteString = NSString(string: minString).replacingCharacters(in: range, with: string) as NSString
            }
        }
        else {
            if let minString = editor.minuteField.text {
                minuteString = minString as NSString
            }
        }
        
        var secondString: NSString! = NSString()
        if textField == editor.secondField {
            if let secString = editor.secondField.text {
                secondString = NSString(string: secString).replacingCharacters(in: range, with: string) as NSString
            }
        }
        else {
            if let secString = editor.secondField.text {
                secondString = secString as NSString
            }
        }
        
        return Time(minuteString.floatValue, secondString.floatValue)
    }
    
    func textToDistance(editor: DistanceEditor, textField: UITextField, range: NSRange, replacementString string: String) -> Float {
        var distanceString: NSString! = NSString()
        if textField == distanceEditor.input {
            if let distString = distanceEditor.input.text {
                distanceString = NSString(string: distString).replacingCharacters(in: range, with: string) as NSString
            }
        }
        else {
            if let distString = distanceEditor.input.text {
                distanceString = distString as NSString
            }
        }
        
        return distanceString.floatValue
    }
}

extension CalculatorViewController {
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
    }
    
    func keyboardWillShow(notification: NSNotification) {
        if showedKeyboard {
            return
        }
        
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            keyboardHeight = keyboardSize.height
            let duration = notification.userInfo?[UIKeyboardAnimationDurationUserInfoKey] as? Double
            UIView.animate(withDuration: duration!, animations: { 
                self.keyboardUnderlayOverlay.frame = CGRect(x: self.keyboardUnderlayOverlay.frame.origin.x, y: self.keyboardUnderlayOverlay.frame.origin.y, width: self.view.frame.width, height: 0)
            }, completion: { (complete: Bool) in
                self.keyboardUnderlayOverlay.removeFromSuperview()
                self.showedKeyboard = true
            })
        }
    }
}
