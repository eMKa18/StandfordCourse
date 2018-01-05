//
//  ViewController.swift
//  Calculator
//
//  Created by Monika Koschel on 26.06.2016.
//  Copyright © 2016 Monika Koschel. All rights reserved.
//

import UIKit

class ViewController: UIViewController
{
    
    @IBOutlet var buttons: [UIButton]!
    @IBOutlet private weak var display: UILabel!
    @IBOutlet weak var hidableStackView: UIStackView!
    
    private var userIsInTheMiddleOfFloatNumberTyping: Bool = false
    
    private var userIsInTheMiddleOfTyping: Bool = false {
        didSet {
            if !userIsInTheMiddleOfTyping {
                userIsInTheMiddleOfFloatNumberTyping = false
            }
        }
    }
    
    private var displayValue: Double {
        get {
            return Double(display.text!)!
        }
        set {
            display.text = String(newValue)
        }
    }
    
    private var brain = CalculatorBrain()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let deviceOrientation = traitCollection.horizontalSizeClass == .Compact && traitCollection.verticalSizeClass == .Regular
        adjustButtonLayout(deviceOrientation)
    }
    
    override func willTransitionToTraitCollection(newCollection: UITraitCollection, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        super.willTransitionToTraitCollection(newCollection, withTransitionCoordinator: coordinator)
        let deviceOrientation = traitCollection.horizontalSizeClass == .Compact && traitCollection.verticalSizeClass == .Regular
        adjustButtonLayout(deviceOrientation)
    }
    
    @IBAction private func touchedDigit(sender: UIButton)
    {
        var digit = sender.currentTitle!
        let textCurrentlyInDisplay = display.text!
        if digit == "." {
            if userIsInTheMiddleOfFloatNumberTyping {
                return
            }
            if !userIsInTheMiddleOfTyping {
                digit = "0."
            }
            userIsInTheMiddleOfFloatNumberTyping = true
        }
        if userIsInTheMiddleOfTyping
        {
            display.text = textCurrentlyInDisplay + digit
        }
        else
        {
            display.text = digit
        }
        userIsInTheMiddleOfTyping = true
        
    }
    
    
    @IBAction private func performOperation(sender: UIButton)
    {
        if userIsInTheMiddleOfTyping
        {
            brain.setOperand(displayValue)
            userIsInTheMiddleOfTyping = false
        }
        if let mathematicalSymbol = sender.currentTitle
        {
            brain.performOperation(mathematicalSymbol)
        }
        displayValue = brain.result
    }
    
    private func adjustButtonLayout(isDeviceInPortraitMode: Bool) {
        hidableStackView.hidden = !isDeviceInPortraitMode
        for button in buttons {
            if let button = button as? PortraitButton {
                button.hidden = !isDeviceInPortraitMode
            } else if let button = button as? LandscapeButton {
                button.hidden = isDeviceInPortraitMode
            }
        }
    }
}

