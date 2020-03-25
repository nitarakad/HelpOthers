//
//  ListUsersHelpViewController.swift
//  HelpOthers
//
//  Created by Nitya Tarakad on 3/25/20.
//  Copyright © 2020 Nitya Tarakad. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class ListUsersHelpViewController: UIViewController {
    
    var databaseRef: DatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        databaseRef = Database.database().reference()
        
        var dictHere = [String: AnyObject]()
        
        let usersWantHelp = databaseRef.observe(.value) { (snapshot) in
            let allUsers = snapshot.value as? [String: AnyObject] ?? [:]
            let usersWantHelp = allUsers["wantHelp_user"] as! Dictionary<String, Dictionary<String, String>>
            print(usersWantHelp)
        }
        
    }
}
