//
//  HelperPairedViewController.swift
//  HelpOthers
//
//  Created by Nitya Tarakad on 3/26/20.
//  Copyright © 2020 Nitya Tarakad. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class HelperPairedViewController: UIViewController {
    
    @IBOutlet weak var nameOfHelperLabel: UILabel!
    @IBOutlet weak var helpingYouLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var updateLabel: UILabel!
    @IBOutlet weak var mainScreenButton: UIButton!
    
    var databaseRef: DatabaseReference!
    var timerRetrieved = Timer()
    var timerDelivered = Timer()
    let retrievedTimeInteral = 5.0 // in seconds (make bigger eventually)
    let deliveredTimeInterval = 5.0 // in seconds (make bigger eventually)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let buttonBackgroundNormal = UIImage(named: "regular_button_bkgd")
        let buttonBackgroundClicked = UIImage(named: "regular_button_clicked_bkgd")
        
        databaseRef = Database.database().reference()
        
        mainScreenButton.isEnabled = false
        mainScreenButton.isHidden = true
        
        /* AUTO LAYOUT */
        nameOfHelperLabel.translatesAutoresizingMaskIntoConstraints = false
        nameOfHelperLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        nameOfHelperLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 100).isActive = true
        nameOfHelperLabel.widthAnchor.constraint(equalToConstant: 400).isActive = true
        nameOfHelperLabel.heightAnchor.constraint(equalToConstant: 80).isActive = true
        nameOfHelperLabel.textAlignment = .center
        nameOfHelperLabel.adjustsFontSizeToFitWidth = true
        
        helpingYouLabel.translatesAutoresizingMaskIntoConstraints = false
        helpingYouLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        helpingYouLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 140).isActive = true
        helpingYouLabel.widthAnchor.constraint(equalToConstant: 400).isActive = true
        helpingYouLabel.heightAnchor.constraint(equalToConstant: 80).isActive = true
        helpingYouLabel.textAlignment = .center
        helpingYouLabel.adjustsFontSizeToFitWidth = true
        
        statusLabel.translatesAutoresizingMaskIntoConstraints = false
        statusLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        statusLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -25).isActive = true
        statusLabel.widthAnchor.constraint(equalToConstant: 400).isActive = true
        statusLabel.heightAnchor.constraint(equalToConstant: 80).isActive = true
        statusLabel.textAlignment = .center
        statusLabel.adjustsFontSizeToFitWidth = true
        
        updateLabel.translatesAutoresizingMaskIntoConstraints = false
        updateLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        updateLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 25).isActive = true
        updateLabel.widthAnchor.constraint(equalToConstant: 400).isActive = true
        updateLabel.heightAnchor.constraint(equalToConstant: 80).isActive = true
        updateLabel.textAlignment = .center
        updateLabel.adjustsFontSizeToFitWidth = true
        
        mainScreenButton.translatesAutoresizingMaskIntoConstraints = false
        mainScreenButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        mainScreenButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 660).isActive = true
        mainScreenButton.widthAnchor.constraint(equalToConstant: 300).isActive = true
        mainScreenButton.heightAnchor.constraint(equalToConstant: 90).isActive = true
        mainScreenButton.titleLabel?.textAlignment = .center
        mainScreenButton.titleLabel?.adjustsFontSizeToFitWidth = true
        mainScreenButton.isHidden = true
        mainScreenButton.setBackgroundImage(buttonBackgroundNormal, for: .normal)
        mainScreenButton.setBackgroundImage(buttonBackgroundClicked, for: .highlighted)
        mainScreenButton.setTitleColor(UIColor(red: 227/255, green: 227/255, blue: 1.0, alpha: 1.0), for: .normal)
        
        setNameOfHelperWithDatabase()
        
        checkIfRetrievedTimer()
        
        checkifDeliveredTimer()
    }
    
    @IBAction func mainScreenButtonClicked(_ sender: Any) {
        print("**user going back to main screen**")
        
        let uuid = WantHelpViewController.userUUID
        
        self.databaseRef.child("users_being_helped").child(uuid).removeValue()
        self.databaseRef.child("wantHelp_user").child(uuid).removeValue()
        
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "mainscreen") as! ViewController
        newViewController.modalPresentationStyle = .fullScreen
        self.present(newViewController, animated: true, completion: nil)
    }
    
    func checkIfRetrievedTimer() {
        timerRetrieved = Timer.scheduledTimer(timeInterval: retrievedTimeInteral, target: self, selector: #selector(checkStatusAsRetrieved), userInfo: nil, repeats: true)
    }
    
    @objc func checkStatusAsRetrieved() {
        let uuid = WantHelpViewController.userUUID
        databaseRef.child("wantHelp_user").child(uuid).child("status").observeSingleEvent(of: .value) { (snapshot) in
            let status = snapshot.value as? String ?? ""
            if (status == "retrieved") {
                print("**helper has retrieved items**")
                self.updateLabel.text = "Retrieved!"
                
                let alertController = UIAlertController(title: "Status Update!", message:
                    "Items have been picked up!", preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "Dismiss", style: .default))

                self.present(alertController, animated: true, completion: nil)
                
                self.timerRetrieved.invalidate()
                
            } else {
                print("**helper hasn't retrieved items yet**")
            }
        }
    }
    
    func checkifDeliveredTimer() {
        timerDelivered = Timer.scheduledTimer(timeInterval: deliveredTimeInterval, target: self, selector: #selector(checkStatusAsDelivered), userInfo: nil, repeats: true)
    }
    
    @objc func checkStatusAsDelivered() {
        let uuid = WantHelpViewController.userUUID
        databaseRef.child("wantHelp_user").child(uuid).child("status").observeSingleEvent(of: .value) { (snapshot) in
            let status = snapshot.value as? String ?? ""
            if (status == "delivered") {
                print("**helper has delivered items**")
                
                self.updateLabel.text = "Delivered"
                
                let alertController = UIAlertController(title: "Status Update!", message:
                    "Items have been delivered!", preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "Dismiss", style: .default))

                self.present(alertController, animated: true, completion: nil)
                
                self.timerDelivered.invalidate()
                
                self.mainScreenButton.isHidden = false
                self.mainScreenButton.isEnabled = true
                
            } else {
                print("**helper hasn't delivered items yet**")
            }
        }
    }
    
    func setNameOfHelperWithDatabase() {
        let uuid = WantHelpViewController.userUUID
        
        databaseRef.child("wantHelp_user").child(uuid).child("helper_paired_uuid").observeSingleEvent(of: .value) { (snapshot) in
            let helperUUID = snapshot.value as? String ?? ""
            
            print("**user helping has UUID \(helperUUID)**")
            
            self.databaseRef.child("wantToHelp_user").child(helperUUID).child("username").observeSingleEvent(of: .value) { (snap) in
                let helperName = snap.value as? String ?? ""
                
                DispatchQueue.main.async {
                    self.nameOfHelperLabel.text = helperName
                    print("**user helping out name is displayed**")
                }
            }
            
        }
        
    }
    
}
