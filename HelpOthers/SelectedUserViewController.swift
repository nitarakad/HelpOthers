//
//  SelectedUserViewController.swift
//  HelpOthers
//
//  Created by Nitya Tarakad on 3/26/20.
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
    @IBOutlet weak var returnToMainScreen: UIButton!
    
    var databaseRef: DatabaseReference!
    
    static var currentStatus = "none"
    
    override func viewDidLoad() {
        
        // TODO: display address
        
        super.viewDidLoad()
        
        databaseRef = Database.database().reference()
        
        updateWantToHelpUserDatabaseWithUserSelected()
        updateHelpUserDatabaseWithHelperPaired()
        
        readyButton.isEnabled = false
        returnToMainScreen.isEnabled = false
        
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
        itemsTextView.textColor = UIColor.gray
        itemsTextView.font = UIFont.systemFont(ofSize: 30)
        itemsTextView.isEditable = false
        self.view.addSubview(itemsTextView)
        
        let observeDB = databaseRef.child("wantHelp_user").child(ListUsersHelpViewController.buttonSelectedUUID).observeSingleEvent(of: .value) { (snapshot) in
            
            let allInfo = snapshot.value as! Dictionary<String, String>
            
            guard let listOfItems = allInfo["list_of_items"] else {
                print("no list found")
                return
            }
            
            print("**items in textview now displayed**")
            self.itemsTextView.text = listOfItems
        }
        
    }
    
    @IBAction func retrievedButtonClicked(_ sender: Any) {
        SelectedUserViewController.currentStatus = "retrieved"
        updateWantToHelpUserDatabaseWithRetrieved()
        updateHelpUserDatabaseWithRetrieved()
        print("items retreived!")
        readyButton.isEnabled = true
    }
    
    @IBAction func readyButtonClicked(_ sender: Any) {
        SelectedUserViewController.currentStatus = "delivered"
        updateWantToHelpUserDatabaseWithDelivered()
        updateWantHelpUserDatabaseWithDelivered()
        print("item at doorstep!")
        returnToMainScreen.isEnabled = true
    }
    
    @IBAction func mainScreenButtonClicked(_ sender: Any) {
        // TODO: when user hits button to go back to original screen, it deletes their info
        let uuid = WantToHelpViewController.userUUID
        self.databaseRef.child("wantToHelp_user").child(uuid).removeValue()
        
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "mainscreen") as! ViewController
        newViewController.modalPresentationStyle = .fullScreen
        self.present(newViewController, animated: true, completion: nil)
    }
    
    func updateWantToHelpUserDatabaseWithDelivered() {
        let addStatus = ["username" : WantToHelpViewController.userName,
                         "user_selected_uuid" : ListUsersHelpViewController.buttonSelectedUUID,
                         "status" : SelectedUserViewController.currentStatus]
        
        let updateWithStatus = ["/wantToHelp_user/\(WantToHelpViewController.userUUID)" : addStatus]
        
        self.databaseRef.updateChildValues(updateWithStatus)
        
        print("**updated database with status delivered (WANT TO HELP USER)**")
    }
    
    func updateWantHelpUserDatabaseWithDelivered() {
        let uuid = ListUsersHelpViewController.buttonSelectedUUID
               print(uuid)
               let observeData = databaseRef.child("wantHelp_user").child(uuid).child("status").observeSingleEvent(of: .value) { (snapshot) in
                   let status = snapshot.value as? String ?? ""
                   if status == "" {
                       print("no status found")
                       return
                   }
                   
                   self.databaseRef.child("wantHelp_user").child(uuid).updateChildValues(["status" : SelectedUserViewController.currentStatus])
                   print("**updated database with status delivered (WANT HELP USER)**")
               }
    }
    
    func updateWantToHelpUserDatabaseWithRetrieved() {
        let addStatus = ["username" : WantToHelpViewController.userName,
                         "user_selected_uuid" : ListUsersHelpViewController.buttonSelectedUUID,
                         "status" : SelectedUserViewController.currentStatus]
        
        let updateWithStatus = ["/wantToHelp_user/\(WantToHelpViewController.userUUID)" : addStatus]
        
        self.databaseRef.updateChildValues(updateWithStatus)
        
        print("**updated database with status retrieved (WANT TO HELP USER)**")
    }
    
    func updateHelpUserDatabaseWithRetrieved() {
        let uuid = ListUsersHelpViewController.buttonSelectedUUID
        print(uuid)
        let observeData = databaseRef.child("wantHelp_user").child(uuid).child("status").observeSingleEvent(of: .value) { (snapshot) in
            let status = snapshot.value as? String ?? ""
            if status == "" {
                print("no status found")
                return
            }
            
            self.databaseRef.child("wantHelp_user").child(uuid).updateChildValues(["status" : SelectedUserViewController.currentStatus])
            print("**updated database with status retrieved (WANT HELP USER)**")
        }
    }
    
    func updateWantToHelpUserDatabaseWithUserSelected() {
        let addUserSelected = ["username" : WantToHelpViewController.userName,
                               "user_selected_uuid" : ListUsersHelpViewController.buttonSelectedUUID,
                               "status" : SelectedUserViewController.currentStatus]
        
        let updateWithUserSelected = ["/wantToHelp_user/\(WantToHelpViewController.userUUID)" : addUserSelected]
        
        self.databaseRef.updateChildValues(updateWithUserSelected)
        
        print("**updated database with user selected to help (WANT TO HELP USER)**")
    }
    
    func updateHelpUserDatabaseWithHelperPaired() {
        let uuid = ListUsersHelpViewController.buttonSelectedUUID
        
        databaseRef.child("users_being_helped").child(uuid).setValue(["helped" : "yes"])
        
        let observeDB = databaseRef.child("wantHelp_user").child(uuid).observeSingleEvent(of: .value) { (snapshot) in
            
            let allInfo = snapshot.value as! Dictionary<String, String>
            
            guard let username = allInfo["username"],
                        let helpWith = allInfo["want_help_with"],
                            let timeOfDelivery = allInfo["time_of_delivery"],
                                let listOfItems = allInfo["list_of_items"],
                                    let address = allInfo["address"],
                                        let latitude = allInfo["latitude"],
                                            let longitude = allInfo["longitude"] else {
                print("selected user not found")
                return
            }
            let addHelperPaired = ["username" : username,
                                    "want_help_with" : helpWith,
                                    "list_of_items" : listOfItems,
                                    "time_of_delivery" : timeOfDelivery,
                                    "address" : address,
                                    "helper_paired_uuid" : WantToHelpViewController.userUUID,
                                    "status" : SelectedUserViewController.currentStatus,
                                    "latitude" : latitude,
                                    "longitude" : longitude]
            
            let updateWithHelperPaired = ["/wantHelp_user/\(uuid)" : addHelperPaired]

            self.databaseRef.updateChildValues(updateWithHelperPaired)

            print("**updated database with helper paired with (WANT HELP USER)**")
            
        }
        
    }
    
}
