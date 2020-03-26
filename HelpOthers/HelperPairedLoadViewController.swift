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
                print("does exist --> user has been paired")
                let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                let newViewController = storyBoard.instantiateViewController(withIdentifier: "helperpaired") as! HelperPairedViewController
                self.present(newViewController, animated: true, completion: nil)
                self.timer.invalidate()
            }
        }
    }
}
