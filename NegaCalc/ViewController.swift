//
//  ViewController.swift
//  NegaCalc
//
//  Created by Raphael on 7/26/15.
//  Copyright (c) 2015 Skyleaf Design LLC. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.displayValue = nil
    }

    @IBOutlet weak var display: UILabel!
    
    @IBOutlet weak var register: UILabel!
    
    var userIsInTheMiddleOfTypingANumber: Bool = false
    
    var brain = CalculatorBrain()
    
    @IBAction func appendDigit(sender: UIButton) {
        let digit = sender.currentTitle!
        if userIsInTheMiddleOfTypingANumber {
            // Allow only one decimal point.
            if !(display.text!.rangeOfString(".") != nil && digit == ".") {
                display.text = display.text! + digit
            }
        }
        else {
            display.text = digit
            userIsInTheMiddleOfTypingANumber = true
        }
        register.text = "\(brain)"
        print("Digit = \(digit)")
    }
    

    @IBAction func removeDigit() {
        if userIsInTheMiddleOfTypingANumber {
            display.text = String((display.text!).characters.dropLast())
            if (display.text!).characters.count == 0 {
                display.text = "0"
                userIsInTheMiddleOfTypingANumber = false
            }
        }
    }
    
    @IBAction func clear() {
        brain.reset()
        userIsInTheMiddleOfTypingANumber = false
        displayValue = nil
        register.text = "0"
    }
    
    @IBAction func changeSign(sender: UIButton) {
        if userIsInTheMiddleOfTypingANumber {
            if let minusSignRange = display.text!.rangeOfString("-")   {
                display.text!.removeAtIndex(minusSignRange.startIndex)
            } else {
                display.text = "-" + display.text!
            }
        } else {
            operate(sender)
            print(sender.currentTitle)
        }
    }
 
    @IBAction func setVariable() {
        if userIsInTheMiddleOfTypingANumber {
            brain.variableValues["M"] = displayValue;
            print("\(brain.variableValues)")
            userIsInTheMiddleOfTypingANumber = false;
            displayValue = brain.evaluate()
            register.text = "\(brain) ="
        }
    }
    
    var displayValue: Double? {
        get {
            return NSNumberFormatter().numberFromString(display.text!)?.doubleValue
        }
        set {
            if let number = newValue {
                display.text = "\(number)"
            } else {
                display.text = "0"
            }
        }
    }
    
    @IBAction func enter() {
        userIsInTheMiddleOfTypingANumber = false
        if displayValue != nil {
            if let result = brain.pushOperand(displayValue!) {
                displayValue = result
            } else {
                displayValue = nil
            }
        } else {
            displayValue = nil
        }
        register.text = "\(brain) ="
    }
    
    
    @IBAction func operate(sender: UIButton) {
        if userIsInTheMiddleOfTypingANumber {
            enter()
        }
        if let operation = sender.currentTitle {
            if let result = brain.performOperation(operation) {
                displayValue = result
            } else {
                displayValue = nil
            }
        }
        register.text = "\(brain) ="
    }
}

