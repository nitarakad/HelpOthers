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
    
    @IBOutlet weak var nameField: UITextField!
    
    static var allNames = Array<String>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
}

extension WantToHelpViewController: UITextFieldDelegate {
    
}
