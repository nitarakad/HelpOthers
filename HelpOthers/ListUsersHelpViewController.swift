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
    
    @IBOutlet weak var listLabel: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    
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
                
                var TOD = ""
                if timeOfDelivery == "ASAP" {
                    TOD = "ASAP"
                } else if timeOfDelivery == "next_hour" {
                    TOD = "In 1 hour"
                } else if timeOfDelivery == "next_two_hours" {
                    TOD = "In 2 hours"
                } else if timeOfDelivery == "next_three_hours" {
                    TOD = "In 3 hours"
                } else if timeOfDelivery == "next_four_hours" {
                    TOD = "In 4 hours"
                } else {
                    TOD = "unknown"
                }
                
                usernames[currUID] = username
                helpWiths[currUID] = wantHelpWith
                listItems[currUID] = listOfItems
                timeOfDeliveries[currUID] = TOD
                addresses[currUID] = address
            }
            
            
            print(usernames)
            print(helpWiths)
            print(listItems)
            print(timeOfDeliveries)
            print(addresses)
            
            var currY = self.scrollView.bounds.origin.y + 50
            let currX = self.scrollView.bounds.minX
            
            for uid in userUIDs {
                
                let currButton = UIButton()
                currButton.frame = CGRect(x: currX, y: currY, width: self.view.frame.width, height: 60)
                currButton.setTitle("\(usernames[uid]!): ", for: .normal)
                currButton.setTitleColor(UIColor.systemBlue, for: .normal)
                currButton.titleLabel?.font = UIFont.systemFont(ofSize: 40)
                self.scrollView.addSubview(currButton)
                
                currY = currY + 70
                let helpWithLabel = UILabel()
                helpWithLabel.frame = CGRect(x: currX, y: currY, width: self.view.frame.width, height: 60)
                helpWithLabel.text = "Help With: \(helpWiths[uid]!)"
                helpWithLabel.textColor = UIColor.systemPurple
                helpWithLabel.font = UIFont.systemFont(ofSize: 30)
                helpWithLabel.center.x = self.scrollView.center.x
                self.scrollView.addSubview(helpWithLabel)
                
                currY = currY + 70
                let TODLabel = UILabel()
                TODLabel.frame = CGRect(x: currX, y: currY, width: self.view.frame.width, height: 60)
                TODLabel.text = "Time: \(timeOfDeliveries[uid]!)"
                TODLabel.textColor = UIColor.systemPurple
                TODLabel.font = UIFont.systemFont(ofSize: 30)
                TODLabel.center.x = self.scrollView.center.x
                self.scrollView.addSubview(TODLabel)
                
                currY = currY + 70
                let addressLabel = UILabel()
                addressLabel.frame = CGRect(x: currX, y: currY, width: self.view.frame.width, height: 100)
                addressLabel.text = "Address: \(addresses[uid]!)"
                addressLabel.lineBreakMode = .byWordWrapping
                addressLabel.numberOfLines = 0
                addressLabel.textColor = UIColor.systemPurple
                addressLabel.font = UIFont.systemFont(ofSize: 30)
                addressLabel.center.x = self.scrollView.center.x
                self.scrollView.addSubview(addressLabel)
                
                currY = currY + 100
            }
            
            self.scrollView.contentSize = CGSize(width: self.view.frame.width, height: currY + 100)
            self.view.addSubview(self.scrollView)
            
        }
        
    }
}
