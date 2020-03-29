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
    
    @IBOutlet weak var thanksLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var listItemsLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var itemsTextView: UITextView!
    @IBOutlet weak var retrievedButton: UIButton!
    @IBOutlet weak var readyButton: UIButton!
    @IBOutlet weak var returnToMainScreen: UIButton!
    
    var databaseRef: DatabaseReference!
    
    static var currentStatus = "none"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let buttonBackgroundNormal = UIImage(named: "regular_button_bkgd")
        let buttonBackgroundNormalClicked = UIImage(named: "regular_button_clicked_bkgd")
        
        databaseRef = Database.database().reference()
        
        updateWantToHelpUserDatabaseWithUserSelected()
        updateHelpUserDatabaseWithHelperPaired()
        
        readyButton.isEnabled = false
        returnToMainScreen.isEnabled = false
        
        let name = ListUsersHelpViewController.buttonSelectedName
        
        nameLabel.text = "\(String(name))!"
        nameLabel.adjustsFontSizeToFitWidth = true
        
        itemsTextView.isScrollEnabled = true
        itemsTextView.font = UIFont.systemFont(ofSize: 30)
        itemsTextView.isEditable = false
        self.view.addSubview(itemsTextView)
        
        /* AUTO LAYOUT*/
        thanksLabel.translatesAutoresizingMaskIntoConstraints = false
        thanksLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        thanksLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 100).isActive = true
        thanksLabel.widthAnchor.constraint(equalToConstant: 400).isActive = true
        thanksLabel.heightAnchor.constraint(equalToConstant: 80).isActive = true
        thanksLabel.textAlignment = .center
        thanksLabel.adjustsFontSizeToFitWidth = true
        
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        nameLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 140).isActive = true
        nameLabel.widthAnchor.constraint(equalToConstant: 400).isActive = true
        nameLabel.heightAnchor.constraint(equalToConstant: 80).isActive = true
        nameLabel.textAlignment = .center
        nameLabel.adjustsFontSizeToFitWidth = true
        
        listItemsLabel.translatesAutoresizingMaskIntoConstraints = false
        listItemsLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        listItemsLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 190).isActive = true
        listItemsLabel.widthAnchor.constraint(equalToConstant: 400).isActive = true
        listItemsLabel.heightAnchor.constraint(equalToConstant: 80).isActive = true
        listItemsLabel.textAlignment = .center
        listItemsLabel.adjustsFontSizeToFitWidth = true
        
        itemsTextView.translatesAutoresizingMaskIntoConstraints = false
        itemsTextView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        itemsTextView.topAnchor.constraint(equalTo: view.topAnchor, constant: 260).isActive = true
        itemsTextView.widthAnchor.constraint(equalToConstant: 360).isActive = true
        itemsTextView.heightAnchor.constraint(equalToConstant: 300).isActive = true
        itemsTextView.textAlignment = .left
        itemsTextView.layer.borderColor = CGColor(srgbRed: 58/255, green: 193/255, blue: 236/255, alpha: 1.0)
        itemsTextView.layer.borderWidth = 2.0

        addressLabel.translatesAutoresizingMaskIntoConstraints = false
        addressLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        addressLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 570).isActive = true
        addressLabel.widthAnchor.constraint(equalToConstant: 300).isActive = true
        addressLabel.heightAnchor.constraint(equalToConstant: 80).isActive = true
        addressLabel.textAlignment = .center
        addressLabel.adjustsFontSizeToFitWidth = true
        addressLabel.lineBreakMode = .byClipping
        addressLabel.numberOfLines = 3
        
        retrievedButton.translatesAutoresizingMaskIntoConstraints = false
        retrievedButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        retrievedButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 660).isActive = true
        retrievedButton.widthAnchor.constraint(equalToConstant: 200).isActive = true
        retrievedButton.heightAnchor.constraint(equalToConstant: 90).isActive = true
        retrievedButton.titleLabel?.textAlignment = .center
        retrievedButton.titleLabel?.adjustsFontSizeToFitWidth = true
        retrievedButton.setBackgroundImage(buttonBackgroundNormal, for: .normal)
        retrievedButton.setBackgroundImage(buttonBackgroundNormalClicked, for: .highlighted)
        retrievedButton.setTitleColor(UIColor(red: 227/255, green: 227/255, blue: 1.0, alpha: 1.0), for: .normal)

        readyButton.translatesAutoresizingMaskIntoConstraints = false
        readyButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        readyButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 660).isActive = true
        readyButton.widthAnchor.constraint(equalToConstant: 200).isActive = true
        readyButton.heightAnchor.constraint(equalToConstant: 90).isActive = true
        readyButton.titleLabel?.textAlignment = .center
        readyButton.titleLabel?.adjustsFontSizeToFitWidth = true
        readyButton.isHidden = true
        readyButton.setBackgroundImage(buttonBackgroundNormal, for: .normal)
        readyButton.setBackgroundImage(buttonBackgroundNormalClicked, for: .highlighted)
        readyButton.setTitleColor(UIColor(red: 227/255, green: 227/255, blue: 1.0, alpha: 1.0), for: .normal)
        
        returnToMainScreen.translatesAutoresizingMaskIntoConstraints = false
        returnToMainScreen.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        returnToMainScreen.topAnchor.constraint(equalTo: view.topAnchor, constant: 660).isActive = true
        returnToMainScreen.widthAnchor.constraint(equalToConstant: 300).isActive = true
        returnToMainScreen.heightAnchor.constraint(equalToConstant: 90).isActive = true
        returnToMainScreen.titleLabel?.textAlignment = .center
        returnToMainScreen.titleLabel?.adjustsFontSizeToFitWidth = true
        returnToMainScreen.isHidden = true
        returnToMainScreen.setBackgroundImage(buttonBackgroundNormal, for: .normal)
        returnToMainScreen.setBackgroundImage(buttonBackgroundNormalClicked, for: .highlighted)
        returnToMainScreen.setTitleColor(UIColor(red: 227/255, green: 227/255, blue: 1.0, alpha: 1.0), for: .normal)
        
        let observeDB = databaseRef.child("wantHelp_user").child(ListUsersHelpViewController.buttonSelectedUUID).observeSingleEvent(of: .value) { (snapshot) in
            
            let allInfo = snapshot.value as! Dictionary<String, String>
            
            guard let listOfItems = allInfo["list_of_items"] else {
                print("no list found")
                return
            }
            
            guard let address = allInfo["address"] else {
                print("no address found")
                return
            }
            
            guard let name = allInfo["username"] else {
                print("no name found")
                return
            }
            print("**items in textview now displayed**")
            self.itemsTextView.text = listOfItems
            let addressLabelText = "\(name)'s Address: \(address)"
            self.addressLabel.text = addressLabelText

        }
        
    }
    
    @IBAction func retrievedButtonClicked(_ sender: Any) {
        //SelectedUserViewController.currentStatus = "retrieved"
        updateWantToHelpUserDatabaseWithRetrieved()
        updateHelpUserDatabaseWithRetrieved()
        print("items retreived!")
        readyButton.isEnabled = true
        readyButton.isHidden = false
        retrievedButton.isEnabled = false
        retrievedButton.isHidden = true
    }
    
    @IBAction func readyButtonClicked(_ sender: Any) {
        //SelectedUserViewController.currentStatus = "delivered"
        updateWantToHelpUserDatabaseWithDelivered()
        updateWantHelpUserDatabaseWithDelivered()
        print("item at doorstep!")
        returnToMainScreen.isEnabled = true
        returnToMainScreen.isHidden = false
        readyButton.isEnabled = false
        readyButton.isHidden = true
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
                         "status" : "delivered"]
        
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
                   
                   self.databaseRef.child("wantHelp_user").child(uuid).updateChildValues(["status" : "delivered"])
                   print("**updated database with status delivered (WANT HELP USER)**")
               }
    }
    
    func updateWantToHelpUserDatabaseWithRetrieved() {
        let addStatus = ["username" : WantToHelpViewController.userName,
                         "user_selected_uuid" : ListUsersHelpViewController.buttonSelectedUUID,
                         "status" : "retrieved"]
        
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
            
            self.databaseRef.child("wantHelp_user").child(uuid).updateChildValues(["status" : "retrieved"])
            print("**updated database with status retrieved (WANT HELP USER)**")
        }
    }
    
    func updateWantToHelpUserDatabaseWithUserSelected() {
        let addUserSelected = ["username" : WantToHelpViewController.userName,
                               "user_selected_uuid" : ListUsersHelpViewController.buttonSelectedUUID,
                               "status" : "none"]
        
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
                                    "status" : "none",
                                    "latitude" : latitude,
                                    "longitude" : longitude]
            
            let updateWithHelperPaired = ["/wantHelp_user/\(uuid)" : addHelperPaired]

            self.databaseRef.updateChildValues(updateWithHelperPaired)

            print("**updated database with helper paired with (WANT HELP USER)**")
            
        }
        
    }
    
}
