//
//  ListGroceriesViewController.swift
//  HelpOthers
//
//  Created by Nitya Tarakad on 3/24/20.
//  Copyright © 2020 Nitya Tarakad. All rights reserved.
//

import Foundation
import UIKit

class ListGroceriesViewController: UIViewController {
    
    @IBOutlet weak var listGroceries: UITextView!
    @IBOutlet weak var labelGroceries: UILabel!
    @IBOutlet weak var nextButton: UIButton!
    
    static var listOfGroceries = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        labelGroceries.center.x = self.view.center.x
        
        listGroceries.isScrollEnabled = true
        listGroceries.center.x = self.view.center.x
        listGroceries.layer.borderColor = CGColor(genericGrayGamma2_2Gray: 1.0, alpha: 1.0)
        listGroceries.layer.borderWidth = 1.0
    }
    
    @IBAction func toTimeOfDeliveryScreen(_ sender: Any) {
        ListGroceriesViewController.listOfGroceries = listGroceries.text
        print("groceries are: \(ListGroceriesViewController.listOfGroceries)")
        print("going to time of delivery screen")
    }
}


