//
//  WantHelpViewController.swift
//  HelpOthers
//
//  Created by Nitya Tarakad on 3/24/20.
//  Copyright © 2020 Nitya Tarakad. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class WantHelpViewController: UIViewController {
    
    @IBOutlet weak var nameInputField: UITextField!
    @IBOutlet weak var groceriesButton: UIButton!
    @IBOutlet weak var prescriptionButton: UIButton!
    
    static var userName = ""
    static var userUUID = ""
    static var helpWith = ""
    
    var databaseRef: DatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nameInputField.delegate = self
        
        databaseRef = Database.database().reference()
    }
    
    @IBAction func toWantHelpGroceriesScreen(_ sender: Any) {
        
        if let name = nameInputField.text, name.count == 0 {
            print("user did not input a name")
            
            let alertController = UIAlertController(title: "Input name", message:
                "Enter your name to move on to next steps!", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "Dismiss", style: .default))

            self.present(alertController, animated: true, completion: nil)
            
        } else {
            print("user wants help with groceries")
            
            if let name = nameInputField.text, WantHelpViewController.userName == "" && name.count > 0 {
                WantHelpViewController.userName = name
                
                let uuid = UUID().uuidString
                print(uuid)
                WantHelpViewController.userUUID = uuid
                
                self.databaseRef.child("wantHelp_user").child(uuid).setValue(["username" : name])
                
                print("user inputted name")
            }
        
            WantHelpViewController.helpWith = "groceries"
        
            let addGroceriesHelp = ["username" : WantHelpViewController.userName,
                                  "want_help_with" : "groceries"]
            let updateWithGroceries = ["/wantHelp_user/\(WantHelpViewController.userUUID)" : addGroceriesHelp]
            self.databaseRef.updateChildValues(updateWithGroceries)
            
            let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let newViewController = storyBoard.instantiateViewController(withIdentifier: "groceries") as! ListGroceriesViewController
                    self.present(newViewController, animated: true, completion: nil)
        }
    }
    
    @IBAction func toWantHelpPrescriptionScreen(_ sender: Any) {
        
        if let name = nameInputField.text, name.count == 0 {
            print("user did not input a name")
            
            let alertController = UIAlertController(title: "Input Name", message:
                "Enter your name to move on to next steps!", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "Dismiss", style: .default))

            self.present(alertController, animated: true, completion: nil)
            
        } else {
            print("user wants help with prescription")
            
            if let name = nameInputField.text, WantHelpViewController.userName == "" && name.count > 0 {
                WantHelpViewController.userName = name
                
                let uuid = UUID().uuidString
                print(uuid)
                WantHelpViewController.userUUID = uuid
                
                self.databaseRef.child("wantHelp_user").child(uuid).setValue(["username" : name])
                
                print("user inputted name")
            }
        
            WantHelpViewController.helpWith = "prescription"
        
            let addPrescriptionHelp = ["username" : WantHelpViewController.userName,
                                  "want_help_with" : "prescription"]
            let updateWithPrescription = ["/wantHelp_user/\(WantHelpViewController.userUUID)" : addPrescriptionHelp]
            self.databaseRef.updateChildValues(updateWithPrescription)
            
            let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let newViewController = storyBoard.instantiateViewController(withIdentifier: "prescription") as! ListPrescriptionViewController
                    self.present(newViewController, animated: true, completion: nil)
        }
    }
}


extension WantHelpViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        nameInputField.resignFirstResponder()
        
        guard let name = nameInputField.text, name.count > 0 else {
            print("no name given")
            return false
        }
        
        WantHelpViewController.userName = name
        
        let uuid = UUID().uuidString
        print(uuid)
        WantHelpViewController.userUUID = uuid
        
        self.databaseRef.child("wantHelp_user").child(uuid).setValue(["username" : name])
        
        print("user inputted name")
        return true
        
    }
}
