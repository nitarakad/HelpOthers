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
import CoreLocation

class ListUsersHelpViewController: UIViewController {
    
    @IBOutlet weak var listLabel: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    
    var databaseRef: DatabaseReference!
    var buttonsUUID: Dictionary<UIButton, String>!
    static var buttonSelectedName = ""
    static var buttonSelectedUUID = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        databaseRef = Database.database().reference()
        
        print("**in list: latitude \(WantToHelpViewController.latitude)")
        print("**in list: longitude \(WantToHelpViewController.longitude)")
        
        buttonsUUID = Dictionary<UIButton, String>()
        
        retrieveAndShowUsers()
    }
    
    @objc func buttonClicked(sender: UIButton!) {
        guard let name = sender.titleLabel?.text else {
            print("no name")
            return
        }
        
        ListUsersHelpViewController.buttonSelectedName = name
        
        guard let uuid = buttonsUUID[sender] else {
            print("no uuid")
            return
        }
        
        ListUsersHelpViewController.buttonSelectedUUID = uuid
        print("selected user to help")
        
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "selecteduser") as! SelectedUserViewController
        newViewController.modalPresentationStyle = .fullScreen
        self.present(newViewController, animated: true, completion: nil)
    }
    
    func retrieveAndShowUsers() {
        
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
                
                guard let latitude = info["latitude"] else {
                    print("no latitude")
                    return
                }
                
                guard let longitude = info["longitude"] else {
                    print("no longitude")
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
                
                guard let latitudeWantToHelp = Double(WantToHelpViewController.latitude), let longitudeWantToHelp = Double(WantToHelpViewController.longitude) else {
                    print("invalid coordinates for want to help user")
                    return
                }
                
                guard let latitudeHelp = Double(latitude), let longitudeHelp = Double(longitude) else {
                    print("invalid coordinates for want help users")
                    return
                }
                let wantToHelpCoord = CLLocation(latitude: latitudeWantToHelp, longitude: longitudeWantToHelp)
                let wantHelpCoord = CLLocation(latitude: latitudeHelp, longitude: longitudeHelp)
                
                let distanceInMetersAbs = abs(wantHelpCoord.distance(from: wantToHelpCoord))
                
                // want to append to the list if the user is in range
                // 10 miles = 16093.4 meters (about)
                if (distanceInMetersAbs < 16095) {
                    userUIDs.append(currUID)
                }
            }
            
            var currY = self.scrollView.bounds.origin.y + 50
            let currX = self.scrollView.bounds.minX
            
            var currentlyBeingHelpedUUID = [String]()
            let beingHelped = allUsers["users_being_helped"]
            
            if beingHelped != nil {
                let currentlyBeingHelpedDict = beingHelped as! Dictionary<String, Dictionary<String, String>>
                for user in currentlyBeingHelpedDict {
                    let uid = user.key
                    currentlyBeingHelpedUUID.append(uid)
                }
            }
            
            for uid in userUIDs {
                if (!currentlyBeingHelpedUUID.contains(uid)) {
                    let currButton = UIButton()
                    currButton.frame = CGRect(x: currX, y: currY, width: self.view.frame.width, height: 60)
                    currButton.setTitle("\(usernames[uid]!): ", for: .normal)
                    currButton.setTitleColor(UIColor.systemBlue, for: .normal)
                    currButton.titleLabel?.font = UIFont.systemFont(ofSize: 40)
                    currButton.addTarget(self, action: #selector(self.buttonClicked(sender:)), for: .touchUpInside)
                    self.buttonsUUID[currButton] = uid
                
                    self.scrollView.addSubview(currButton)
                
                    currY = currY + 70
                    let helpWithLabel = UILabel()
                    helpWithLabel.frame = CGRect(x: currX, y: currY, width: self.view.frame.width, height: 60)
                    helpWithLabel.text = "Help With: \(helpWiths[uid]!)"
                    helpWithLabel.textColor = UIColor.systemGray
                    helpWithLabel.font = UIFont.systemFont(ofSize: 30)
                    helpWithLabel.center.x = self.scrollView.center.x
                    self.scrollView.addSubview(helpWithLabel)
                
                    currY = currY + 70
                    let TODLabel = UILabel()
                    TODLabel.frame = CGRect(x: currX, y: currY, width: self.view.frame.width, height: 60)
                    TODLabel.text = "Time: \(timeOfDeliveries[uid]!)"
                    TODLabel.textColor = UIColor.systemGray
                    TODLabel.font = UIFont.systemFont(ofSize: 30)
                    TODLabel.center.x = self.scrollView.center.x
                    self.scrollView.addSubview(TODLabel)
                
                    currY = currY + 70
                    let addressLabel = UILabel()
                    addressLabel.frame = CGRect(x: currX, y: currY, width: self.view.frame.width, height: 100)
                    addressLabel.text = "Address: \(addresses[uid]!)"
                    addressLabel.lineBreakMode = .byWordWrapping
                    addressLabel.numberOfLines = 0
                    addressLabel.textColor = UIColor.systemGray
                    addressLabel.font = UIFont.systemFont(ofSize: 30)
                    addressLabel.center.x = self.scrollView.center.x
                    self.scrollView.addSubview(addressLabel)
                
                    currY = currY + 100
                }
            }
            
            self.scrollView.contentSize = CGSize(width: self.view.frame.width, height: currY + 100)
            self.view.addSubview(self.scrollView)
            
        }
    }
}
