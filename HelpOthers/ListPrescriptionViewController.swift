//
//  ListPrescriptionViewController.swift
//  HelpOthers
//
//  Created by Nitya Tarakad on 3/26/20.
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
        
        self.listPrescription.addDoneButton(title: "Done", target: self, selector: #selector(doneWritingList(sender:)))
        
        databaseRef = Database.database().reference()
    }
    
    @objc func doneWritingList(sender: Any) {
        self.view.endEditing(true)
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
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "timeofdelivery") as! TimeOfDeliveryViewController
        newViewController.modalPresentationStyle = .fullScreen
        self.present(newViewController, animated: true, completion: nil)
    }
    
}
