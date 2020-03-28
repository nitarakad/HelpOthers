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
