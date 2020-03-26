//
//  HelperPairedLoadViewController.swift
//  HelpOthers
//
//  Created by Nitya Tarakad on 3/26/20.
//  Copyright © 2020 Nitya Tarakad. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class HelperPairedLoadViewController: UIViewController {
    
    var databaseRef: DatabaseReference!
    var timer = Timer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        databaseRef = Database.database().reference()
    
        checkDatabaseWithTimer()

    }

    func checkDatabaseWithTimer() {
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(checkIfHelperPaired), userInfo: nil, repeats: true)
    }

    @objc func checkIfHelperPaired() {
        databaseRef.child("wantHelp_user").child(WantHelpViewController.userUUID).child("helper_paired_uuid").observe(.value) { (snapshot) in
            if !snapshot.exists() {
                print("doesn't exist --> user hasnt been paired yet")
            } else {
                self.timer.invalidate()
                print("does exist --> user has been paired")
            }
        }
    }
}
