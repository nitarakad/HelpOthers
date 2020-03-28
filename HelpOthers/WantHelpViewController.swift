//
//  WantHelpViewController.swift
//  HelpOthers
//
//  Created by Nitya Tarakad on 3/26/20.
//  Copyright © 2020 Nitya Tarakad. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class WantHelpViewController: UIViewController {
    
    @IBOutlet weak var nameInputField: UITextField!
    @IBOutlet weak var groceriesButton: UIButton!
    @IBOutlet weak var prescriptionButton: UIButton!
    @IBOutlet weak var helloThereLabel: UILabel!
    @IBOutlet weak var nameQuestionLabel: UILabel!
    @IBOutlet weak var helpWithLabel: UILabel!
    
    static var userName = ""
    static var userUUID = ""
    static var helpWith = ""
    
    var databaseRef: DatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // helloThereLabel auto layout
        helloThereLabel.translatesAutoresizingMaskIntoConstraints = false
        helloThereLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        helloThereLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 100).isActive = true
        helloThereLabel.widthAnchor.constraint(equalToConstant: 400).isActive = true
        helloThereLabel.heightAnchor.constraint(equalToConstant: 100).isActive = true
        helloThereLabel.textAlignment = .center
        
        // nameQuestionLabel auto layout
        nameQuestionLabel.translatesAutoresizingMaskIntoConstraints = false
        nameQuestionLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        nameQuestionLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 150).isActive = true
        nameQuestionLabel.widthAnchor.constraint(equalToConstant: 400).isActive = true
        nameQuestionLabel.heightAnchor.constraint(equalToConstant: 100).isActive = true
        nameQuestionLabel.font = UIFont.systemFont(ofSize: 35)
        nameQuestionLabel.textAlignment = .center
        
        // nameInputField auto layout
        nameInputField.translatesAutoresizingMaskIntoConstraints = false
        nameInputField.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        nameInputField.topAnchor.constraint(equalTo: view.topAnchor, constant: 230).isActive = true
        nameInputField.widthAnchor.constraint(equalToConstant: 300).isActive = true
        nameInputField.heightAnchor.constraint(equalToConstant: 50).isActive = true
        nameInputField.textAlignment = .center
        nameInputField.adjustsFontSizeToFitWidth = true
        
        // helpWithLabel auto layout
        helpWithLabel.translatesAutoresizingMaskIntoConstraints = false
        helpWithLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        helpWithLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 325).isActive = true
        helpWithLabel.widthAnchor.constraint(equalToConstant: 400).isActive = true
        helpWithLabel.heightAnchor.constraint(equalToConstant: 100).isActive = true
        helpWithLabel.textAlignment = .center
        
        // groceriesButton auto layout
        groceriesButton.translatesAutoresizingMaskIntoConstraints = false
        groceriesButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        groceriesButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 400).isActive = true
        groceriesButton.widthAnchor.constraint(equalToConstant: 400).isActive = true
        groceriesButton.heightAnchor.constraint(equalToConstant: 100).isActive = true
        
        // prescriptionButton auto layout
        prescriptionButton.translatesAutoresizingMaskIntoConstraints = false
        prescriptionButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        prescriptionButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 475).isActive = true
        prescriptionButton.widthAnchor.constraint(equalToConstant: 400).isActive = true
        prescriptionButton.heightAnchor.constraint(equalToConstant: 100).isActive = true
        
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
                
                if WantHelpViewController.userUUID == "" {
                    let uuid = UUID().uuidString
                    print(uuid)
                    WantHelpViewController.userUUID = uuid
                }
                
                self.databaseRef.child("wantHelp_user").child(WantHelpViewController.userUUID).setValue(["username" : name])
                
                print("user inputted name")
            }
        
            WantHelpViewController.helpWith = "groceries"
        
            let addGroceriesHelp = ["username" : WantHelpViewController.userName,
                                  "want_help_with" : "groceries"]
            let updateWithGroceries = ["/wantHelp_user/\(WantHelpViewController.userUUID)" : addGroceriesHelp]
            self.databaseRef.updateChildValues(updateWithGroceries)
            
            let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let newViewController = storyBoard.instantiateViewController(withIdentifier: "groceries") as! ListGroceriesViewController
            newViewController.modalPresentationStyle = .fullScreen
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
                
                if WantHelpViewController.userUUID == "" {
                    let uuid = UUID().uuidString
                    print(uuid)
                    WantHelpViewController.userUUID = uuid
                }
                
                self.databaseRef.child("wantHelp_user").child(WantHelpViewController.userUUID).setValue(["username" : name])
                
                print("user inputted name")
            }
        
            WantHelpViewController.helpWith = "prescription"
        
            let addPrescriptionHelp = ["username" : WantHelpViewController.userName,
                                  "want_help_with" : "prescription"]
            let updateWithPrescription = ["/wantHelp_user/\(WantHelpViewController.userUUID)" : addPrescriptionHelp]
            self.databaseRef.updateChildValues(updateWithPrescription)
            
            let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let newViewController = storyBoard.instantiateViewController(withIdentifier: "prescription") as! ListPrescriptionViewController
            newViewController.modalPresentationStyle = .fullScreen
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
        
        if WantHelpViewController.userUUID == "" {
            let uuid = UUID().uuidString
            print(uuid)
            WantHelpViewController.userUUID = uuid
        }
        
        self.databaseRef.child("wantHelp_user").child(WantHelpViewController.userUUID).setValue(["username" : name])
        
        print("user inputted name")
        return true
        
    }
}
