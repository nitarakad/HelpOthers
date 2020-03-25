//
//  ListGroceriesViewController.swift
//  HelpOthers
//
//  Created by Nitya Tarakad on 3/24/20.
//  Copyright © 2020 Nitya Tarakad. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class ListGroceriesViewController: UIViewController {
    
    @IBOutlet weak var listGroceries: UITextView!
    @IBOutlet weak var labelGroceries: UILabel!
    @IBOutlet weak var nextButton: UIButton!
    
    static var listOfGroceries = ""
    
    var databaseRef: DatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        labelGroceries.center.x = self.view.center.x
        
        listGroceries.isScrollEnabled = true
        listGroceries.center.x = self.view.center.x
        listGroceries.layer.borderColor = CGColor(genericGrayGamma2_2Gray: 1.0, alpha: 1.0)
        listGroceries.layer.borderWidth = 1.0
        
        databaseRef = Database.database().reference()
    }
    
    @IBAction func toTimeOfDeliveryScreen(_ sender: Any) {
        ListGroceriesViewController.listOfGroceries = listGroceries.text
        print("groceries are: \(ListGroceriesViewController.listOfGroceries)")
        
        let addListGroceries = ["username" : WantHelpViewController.userName,
                                "want_help_with" : "groceries",
                                "list_of_items" : ListGroceriesViewController.listOfGroceries]
        
        let updateWithListGroceries = ["/wantHelp_user/\(WantHelpViewController.userUUID)" : addListGroceries]
        
        self.databaseRef.updateChildValues(updateWithListGroceries)
        
        //self.databaseRef.child("wantHelp_user").child(WantHelpViewController.userUUID).setValue(["list_of_groceries" : listGroceries.text])
        
        print("going to time of delivery screen")
    }
}


