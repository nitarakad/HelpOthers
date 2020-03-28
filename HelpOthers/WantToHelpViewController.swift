//
//  WantToHelpViewController.swift
//  HelpOthers
//
//  Created by Nitya Tarakad on 3/26/20.
//  Copyright © 2020 Nitya Tarakad. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import CoreLocation

class WantToHelpViewController: UIViewController {
    
    @IBOutlet weak var nameInputField: UITextField!
    
    @IBOutlet weak var startHelpButton: UIButton!
    
    @IBOutlet weak var helloLabel: UILabel!
    
    @IBOutlet weak var nameQuestionLabel: UILabel!
    
    static var userName = ""
    static var userUUID = ""
    
    static var latitude = ""
    static var longitude = ""
    
    var databaseRef: DatabaseReference!
    
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        
        if(CLLocationManager.authorizationStatus() == .authorizedWhenInUse || CLLocationManager.authorizationStatus() == .authorizedAlways) {
               locationManager.requestLocation()
        }
        
        nameInputField.delegate = self
        nameInputField.center.x = self.view.center.x
        
        databaseRef = Database.database().reference()
        
        let buttonBackgroundNormal = UIImage(named: "regular_button_bkgd")
        let buttonBackgroundNormalClicked = UIImage(named: "regular_button_clicked_bkgd")
        
        /* AUTO LAYOUT */
        // hello button
        helloLabel.translatesAutoresizingMaskIntoConstraints = false
        helloLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        helloLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 100).isActive = true
        helloLabel.widthAnchor.constraint(equalToConstant: 400).isActive = true
        helloLabel.heightAnchor.constraint(equalToConstant: 100).isActive = true
        helloLabel.textAlignment = .center
        
        // name question label
        nameQuestionLabel.translatesAutoresizingMaskIntoConstraints = false
        nameQuestionLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        nameQuestionLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 200).isActive = true
        nameQuestionLabel.widthAnchor.constraint(equalToConstant: 400).isActive = true
        nameQuestionLabel.heightAnchor.constraint(equalToConstant: 100).isActive = true
        nameQuestionLabel.font = UIFont.systemFont(ofSize: 35)
        nameQuestionLabel.textAlignment = .center
        
        // nameInput field
        nameInputField.translatesAutoresizingMaskIntoConstraints = false
        nameInputField.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        nameInputField.topAnchor.constraint(equalTo: view.topAnchor, constant: 280).isActive = true
        nameInputField.widthAnchor.constraint(equalToConstant: 300).isActive = true
        nameInputField.heightAnchor.constraint(equalToConstant: 50).isActive = true
        nameInputField.textAlignment = .center
        nameInputField.adjustsFontSizeToFitWidth = true
        nameInputField.layer.borderColor = CGColor(srgbRed: 58/255, green: 193/255, blue: 236/255, alpha: 1.0)
        nameInputField.layer.borderWidth = 2.0
        nameInputField.adjustsFontSizeToFitWidth = true
        
        // lets go button
        startHelpButton.translatesAutoresizingMaskIntoConstraints = false
        startHelpButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        startHelpButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 430).isActive = true
        startHelpButton.widthAnchor.constraint(equalToConstant: 240).isActive = true
        startHelpButton.heightAnchor.constraint(equalToConstant: 80).isActive = true
        startHelpButton.setBackgroundImage(buttonBackgroundNormal, for: .normal)
        startHelpButton.setBackgroundImage(buttonBackgroundNormalClicked, for: .highlighted)
        startHelpButton.titleLabel?.textAlignment = .center
        startHelpButton.titleLabel?.adjustsFontSizeToFitWidth = true
        
    }
    
    @IBAction func startHelping(_ sender: Any) {
        if let name = nameInputField.text, name.count == 0 {
            
            print("user did not input a name")
            
            let alertController = UIAlertController(title: "Input name", message:
                "Enter your name to move on to next steps!", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "Dismiss", style: .default))

            self.present(alertController, animated: true, completion: nil)
            
        } else {
            
            if let name = nameInputField.text, WantToHelpViewController.userUUID == "" && name.count > 0 {
                WantToHelpViewController.userName = name
                
                let uuid = UUID().uuidString
                print(uuid)
                WantToHelpViewController.userUUID = uuid
                
                self.databaseRef.child("wantToHelp_user").child(uuid).setValue(["username" : WantToHelpViewController.userName])
            }
            
            print("user \(WantToHelpViewController.userName) starts helping")
            
            let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let newViewController = storyBoard.instantiateViewController(withIdentifier: "listusershelp") as! ListUsersHelpViewController
            newViewController.modalPresentationStyle = .fullScreen
            self.present(newViewController, animated: true, completion: nil)
        }
    }
    
}

extension WantToHelpViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        nameInputField.resignFirstResponder()
        
        guard let name = nameInputField.text, name.count > 0 else {
            print("no name given")
            return false
        }
        
        WantToHelpViewController.userName = name
        
        let uuid = UUID().uuidString
        print(uuid)
        WantToHelpViewController.userUUID = uuid
        
        self.databaseRef.child("wantToHelp_user").child(uuid).setValue(["username" : name])
        
        print("user inputted name")
        return true
        
    }
}

extension WantToHelpViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        print("location authorization status changed")
        if(status == .authorizedWhenInUse || status == .authorizedAlways){
          manager.startUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            WantToHelpViewController.latitude = String(location.coordinate.latitude)
            WantToHelpViewController.longitude = String(location.coordinate.longitude)
            print("latitude: \(WantToHelpViewController.latitude)")
            print("longitude: \(WantToHelpViewController.longitude)")
            manager.stopUpdatingLocation()
            print("**stop getting location because acquired**")
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
    }
    
}
