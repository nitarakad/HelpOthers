//
//  ListUsersHelpViewController.swift
//  HelpOthers
//
//  Created by Nitya Tarakad on 3/26/20.
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
        
        /* AUTO LAYOUT */
        // select below label
        listLabel.translatesAutoresizingMaskIntoConstraints = false
        listLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        listLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 100).isActive = true
        listLabel.widthAnchor.constraint(equalToConstant: 400).isActive = true
        listLabel.heightAnchor.constraint(equalToConstant: 100).isActive = true
        listLabel.textAlignment = .center
        
        buttonsUUID = Dictionary<UIButton, String>()
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20).isActive = true;
        scrollView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 200).isActive = true;
        scrollView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20).isActive = true;
        scrollView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -20).isActive = true;
        
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
        
        databaseRef.child("wantHelp_user").child(uuid).observeSingleEvent(of: .value) { (snapshot) in
            let allInfo = snapshot.value as! Dictionary<String, String>
            
            // in alert, want to display what they need, time, and address
            guard let name = allInfo["username"],
                let address = allInfo["address"],
                let helpWith = allInfo["want_help_with"],
                let timeOfDelivery = allInfo["time_of_delivery"] else {
                    print(" incorrect format in firebase ")
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
            
            var helpWithCapital = ""
            if helpWith == "groceries" {
                helpWithCapital = "Groceries"
            } else if helpWith == "prescription" {
                helpWithCapital = "Prescription"
            }
            
            let alertMessage = "Help with: \(helpWithCapital)\nTime of Delivery: \(TOD)\nAddress: \(address)"
            
            let alertController = UIAlertController(title: name, message:
                alertMessage, preferredStyle: .alert)
            let selectUserAction = UIAlertAction(title: "Select", style: .default) { (action) in
                
                print("selected user to help")
                let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                let newViewController = storyBoard.instantiateViewController(withIdentifier: "selecteduser") as! SelectedUserViewController
                newViewController.modalPresentationStyle = .fullScreen
                self.present(newViewController, animated: true, completion: nil)
                
            }
            let chooseAnotherAction = UIAlertAction(title: "Dismiss", style: .default)
            
            alertController.addAction(chooseAnotherAction)
            alertController.addAction(selectUserAction)

            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    func retrieveAndShowUsers() {
        let usersWantHelp = databaseRef.observe(.value) { (snapshot) in
            let allUsers = snapshot.value as? [String: AnyObject] ?? [:]
            let usersWantHelp = allUsers["wantHelp_user"] as! Dictionary<String, Dictionary<String, String>>
            var userUIDs = Array<String>()
            var usernames = Dictionary<String, String>()
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
                
                guard let latitude = info["latitude"] else {
                    print("no latitude")
                    return
                }
                
                guard let longitude = info["longitude"] else {
                    print("no longitude")
                    return
                }

                usernames[currUID] = username
                
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
            var constantOfTopAnchor = 0.0
            
            var currentlyBeingHelpedUUID = [String]()
            let beingHelped = allUsers["users_being_helped"]
            
            if beingHelped != nil {
                let currentlyBeingHelpedDict = beingHelped as! Dictionary<String, Dictionary<String, String>>
                for user in currentlyBeingHelpedDict {
                    let uid = user.key
                    currentlyBeingHelpedUUID.append(uid)
                }
            }
            
            let buttonBackgroundNormal = UIImage(named: "regular_button_bkgd")
            let buttonBackgroundClicked = UIImage(named: "regular_button_clicked_bkgd")
            
            for uid in userUIDs {
                if (!currentlyBeingHelpedUUID.contains(uid)) {
                    print("**constant: \(constantOfTopAnchor)")
                    let frame = CGRect(x: currX, y: currY, width: 120.0, height: 50.0)
                    let currButton = UIButton(frame: frame)
                    currButton.setBackgroundImage(buttonBackgroundNormal, for: .normal)
                    currButton.setBackgroundImage(buttonBackgroundClicked, for: .highlighted)
                    currButton.setTitleColor(UIColor(red: 227/255, green: 227/255, blue: 1.0, alpha: 1.0), for: .normal)
                    self.scrollView.addSubview(currButton)
                    currButton.translatesAutoresizingMaskIntoConstraints = false
                    currButton.centerXAnchor.constraint(equalTo: self.scrollView.centerXAnchor).isActive = true
                    currButton.topAnchor.constraint(equalTo: self.scrollView.topAnchor, constant: CGFloat(constantOfTopAnchor)).isActive = true
                    currButton.setTitle("\(usernames[uid]!)", for: .normal)
                    currButton.titleLabel?.font = UIFont.systemFont(ofSize: 40)
                    currButton.titleLabel?.adjustsFontSizeToFitWidth = true
                    currButton.titleLabel?.textAlignment = .center
                    currButton.addTarget(self, action: #selector(self.buttonClicked(sender:)), for: .touchUpInside)
                    self.buttonsUUID[currButton] = uid
                
                    constantOfTopAnchor = constantOfTopAnchor + 120.0
                    currY = currY + 100
                }
            }
            self.scrollView.contentSize.height = currY + 50.0
        }
    }
}
