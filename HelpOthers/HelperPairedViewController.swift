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
    
    var databaseRef: DatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        databaseRef = Database.database().reference()
        
        setNameOfHelperWithDatabase()
    
    }
    
    func setNameOfHelperWithDatabase() {
        let uuid = WantHelpViewController.userUUID
        
        databaseRef.child("wantHelp_user").child(uuid).child("helper_paired_uuid").observe(.value) { (snapshot) in
            print(snapshot.value)
        }
        
    }
    
}
