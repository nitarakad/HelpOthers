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
    @IBOutlet weak var updateLabel: UILabel!
    
    var databaseRef: DatabaseReference!
    var timerRetrieved = Timer()
    var timerDelivered = Timer()
    let retrievedTimeInteral = 5.0 // in seconds (make bigger eventually)
    let deliveredTimeInterval = 5.0 // in seconds (make bigger eventually)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        databaseRef = Database.database().reference()
        
        setNameOfHelperWithDatabase()
        
        checkIfRetrievedTimer()
        
        checkifDeliveredTimer()
        
    
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
