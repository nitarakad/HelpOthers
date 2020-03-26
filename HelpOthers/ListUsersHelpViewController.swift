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
        
        let usersWantHelp = databaseRef.observe(.value) { (snapshot) in
            let allUsers = snapshot.value as? [String: AnyObject] ?? [:]
            let usersWantHelp = allUsers["wantHelp_user"] as! Dictionary<String, Dictionary<String, String>>
            var userUIDs = Array<String>()
            var usernames = Dictionary<String, String>()
            var addresses = Dictionary<String, String>()
            var listItems = Dictionary<String, String>()
            var helpWiths = Dictionary<String, String>()
            var timeOfDeliveries = Dictionary<String, String>()
            for userInfo in usersWantHelp {
                let currUID = userInfo.key
                userUIDs.append(currUID)
                guard let info = usersWantHelp[userInfo.key] else {
                    print("no users want help")
                    return
                }
                
                guard let username = info["username"] else {
                    print("no username saved")
                    return
                }
                
                guard let wantHelpWith = info["want_help_with"] else {
                    print("no category of help saved")
                    return
                }
                
                guard let listOfItems = info["list_of_items"] else {
                    print("no list of items needed saved")
                    return
                }
                
                guard let timeOfDelivery = info["time_of_delivery"] else {
                    print("no time of delivery saved")
                    return
                }
                
                guard let address = info["address"] else {
                    print("no address saved")
                    return
                }
                
                usernames[currUID] = username
                helpWiths[currUID] = wantHelpWith
                listItems[currUID] = listOfItems
                timeOfDeliveries[currUID] = timeOfDelivery
                addresses[currUID] = address
            }
            
            print(usernames)
            print(helpWiths)
            print(listItems)
            print(timeOfDeliveries)
            print(addresses)
            
        }
        
    }
}
