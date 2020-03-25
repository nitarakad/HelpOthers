//
//  WantHelpViewController.swift
//  HelpOthers
//
//  Created by Nitya Tarakad on 3/24/20.
//  Copyright © 2020 Nitya Tarakad. All rights reserved.
//

import Foundation
import UIKit

class WantHelpViewController: UIViewController {
    
    @IBOutlet weak var nameInputField: UITextField!
    
    static var allNames = Array<String>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

extension WantHelpViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        nameInputField.resignFirstResponder()
        
        guard let name = nameInputField.text, name.count > 0 else {
            print("no name given")
            return false
        }
        
        WantHelpViewController.allNames.append(name)
        print("user inputted name")
        return true
        
    }
}
