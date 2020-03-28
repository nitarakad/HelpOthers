//
//  ListGroceriesViewController.swift
//  HelpOthers
//
//  Created by Nitya Tarakad on 3/26/20.
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
        
        self.listGroceries.addDoneButton(title: "Done", target: self, selector: #selector(doneWritingList(sender:)))
        
        databaseRef = Database.database().reference()
    }
    
    @objc func doneWritingList(sender: Any) {
        self.view.endEditing(true)
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
        
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "timeofdelivery") as! TimeOfDeliveryViewController
        newViewController.modalPresentationStyle = .fullScreen
        self.present(newViewController, animated: true, completion: nil)
    }
}

// found on swiftdevcenter
extension UITextView {
    func addDoneButton(title: String, target: Any, selector: Selector) {
        
        let toolBar = UIToolbar(frame: CGRect(x: 0.0,
                                              y: 0.0,
                                              width: UIScreen.main.bounds.size.width,
                                              height: 44.0))//1
        let flexible = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)//2
        let barButton = UIBarButtonItem(title: title, style: .plain, target: target, action: selector)//3
        toolBar.setItems([flexible, barButton], animated: false)//4
        self.inputAccessoryView = toolBar//5
    }
}


