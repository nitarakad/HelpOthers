//
//  ListPrescriptionViewController.swift
//  HelpOthers
//
//  Created by Nitya Tarakad on 3/25/20.
//  Copyright © 2020 Nitya Tarakad. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class ListPrescriptionViewController: UIViewController {
    
    @IBOutlet weak var listPrescription: UITextView!
    @IBOutlet weak var nextButton: UIButton!
    
    static var listOfPrescriptions = ""
    
    var databaseRef: DatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        listPrescription.isScrollEnabled = true
        listPrescription.center.x = self.view.center.x
        listPrescription.layer.borderColor = CGColor(genericGrayGamma2_2Gray: 1.0, alpha: 1.0)
        listPrescription.layer.borderWidth = 1.0
        
        databaseRef = Database.database().reference()
    }
    
    @IBAction func toTimeOfDeliveryScreen(_ sender: Any) {
        ListPrescriptionViewController.listOfPrescriptions = listPrescription.text
        print("prescriptions are: \(ListPrescriptionViewController.listOfPrescriptions)")
        
        let addListPrescriptions = ["username" : WantHelpViewController.userName,
                                    "want_help_with" : WantHelpViewController.helpWith,
                                "list_of_items" : ListPrescriptionViewController.listOfPrescriptions]
        
        let updateWithListGroceries = ["/wantHelp_user/\(WantHelpViewController.userUUID)" : addListPrescriptions]
        
        self.databaseRef.updateChildValues(updateWithListGroceries)
        
        print("going to time of delivery screen")
    }
    
}
