//
//  SelectedUserViewController.swift
//  HelpOthers
//
//  Created by Nitya Tarakad on 3/25/20.
//  Copyright © 2020 Nitya Tarakad. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class SelectedUserViewController: UIViewController {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var itemsTextView: UITextView!
    @IBOutlet weak var retrievedButton: UIButton!
    @IBOutlet weak var readyButton: UIButton!
    
    var databaseRef: DatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        databaseRef = Database.database().reference()
        
        updateWantToHelpUserDatabaseWithUserSelected()
        updateHelpUserDatabaseWithHelperPaired()
        
        let nameWithColon = ListUsersHelpViewController.buttonSelectedName
        let lengthJustName = nameWithColon.count - 2
        let index = nameWithColon.index(nameWithColon.startIndex, offsetBy: lengthJustName)
        let name = nameWithColon[..<index]
        
        nameLabel.text = "\(String(name))!"
        nameLabel.adjustsFontSizeToFitWidth = true
        
        itemsTextView.isScrollEnabled = true
        itemsTextView.center.x = self.view.center.x
        itemsTextView.layer.borderColor = CGColor(genericGrayGamma2_2Gray: 1.0, alpha: 1.0)
        itemsTextView.layer.borderWidth = 1.0
        itemsTextView.textColor = UIColor.white
        itemsTextView.font = UIFont.systemFont(ofSize: 30)
        self.view.addSubview(itemsTextView)
        
        databaseRef.observe(.value) { (snapshot) in
            
            let allUsers = snapshot.value as? [String: AnyObject] ?? [:]
            let usersWantHelp = allUsers["wantHelp_user"] as! Dictionary<String, Dictionary<String, String>>
            
            guard let selectedUser = usersWantHelp[ListUsersHelpViewController.buttonSelectedUUID] else {
                print("selected user not found")
                return
            }
            
            guard let listOfItems = selectedUser["list_of_items"] else {
                print("no list found")
                return
            }
            
            print(listOfItems)
            
            self.itemsTextView.text = listOfItems
        }
        
    }
    
    @IBAction func retrievedButtonClicked(_ sender: Any) {
        
        
        print("items retreived!")
    }
    
    @IBAction func readyButtonClicked(_ sender: Any) {
        print("item at doorstep!")
    }
    
    func updateWantToHelpUserDatabaseWithUserSelected() {
        let addUserSelected = ["username" : WantToHelpViewController.userName,
                               "user_selected_uuid" : ListUsersHelpViewController.buttonSelectedUUID]
        
        let updateWithUserSelected = ["/wantToHelp_user/\(WantToHelpViewController.userUUID)" : addUserSelected]
        
        self.databaseRef.updateChildValues(updateWithUserSelected)
        
        print("updated database with user selected to help (user who is helping)")
    }
    
    func updateHelpUserDatabaseWithHelperPaired() {
        let uuid = ListUsersHelpViewController.buttonSelectedUUID
        
        databaseRef.observe(.value) { (snapshot) in
        
            let allUsers = snapshot.value as? [String: AnyObject] ?? [:]
            let usersWantHelp = allUsers["wantHelp_user"] as! Dictionary<String, Dictionary<String, String>>
        
            guard let selectedUser = usersWantHelp[uuid],
                    let username = selectedUser["username"],
                        let helpWith = selectedUser["want_help_with"],
                            let timeOfDelivery = selectedUser["time_of_delivery"],
                                let listOfItems = selectedUser["list_of_items"],
                                    let address = selectedUser["address"] else {
                print("selected user not found")
                return
            }
            
            let addHelperPaired = ["username" : username,
                                    "want_help_with" : helpWith,
                                    "list_of_items" : listOfItems,
                                    "time_of_delivery" : timeOfDelivery,
                                    "address" : address,
                                    "helper_paired_uuid" : WantToHelpViewController.userUUID]
            
            let updateWithHelperPaired = ["/wantHelp_user/\(uuid)" : addHelperPaired]
            
            self.databaseRef.updateChildValues(updateWithHelperPaired)
            
            print("updated database with helper paired with (user who wants helped)")
            
            
        }
        
    }
    
}
