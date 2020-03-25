//
//  WantToHelpViewController.swift
//  HelpOthers
//
//  Created by Nitya Tarakad on 3/24/20.
//  Copyright © 2020 Nitya Tarakad. All rights reserved.
//

import Foundation
import UIKit

class WantToHelpViewController: UIViewController {
    
    @IBOutlet weak var nameInputField: UITextField!
    @IBOutlet weak var groceriesButton: UIButton!
    @IBOutlet weak var prescriptionButton: UIButton!
    
    static var allNames = Array<String>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nameInputField.delegate = self
        nameInputField.center.x = self.view.center.x
        groceriesButton.center.x = self.view.center.x
    }
    
    @IBAction func toWantToHelpGroceriesScreen(_ sender: Any) {
        print("user wants to help with groceries")
    }
    
    @IBAction func toWantToHelpPrescriptionScreen(_ sender: Any) {
        print("user wants to help with prescription")
    }
    
}

extension WantToHelpViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        nameInputField.resignFirstResponder()
        
        guard let name = nameInputField.text, name.count > 0 else {
            print("no name given")
            return false
        }
        
        WantToHelpViewController.allNames.append(name)
        print("user inputted name")
        return true
        
    }
}
