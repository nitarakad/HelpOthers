//
//  TimeOfDeliveryViewController.swift
//  HelpOthers
//
//  Created by Nitya Tarakad on 3/25/20.
//  Copyright © 2020 Nitya Tarakad. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class TimeOfDeliveryViewController: UIViewController {
    
    @IBOutlet weak var timeOfDeliveryLabel: UILabel!
    @IBOutlet weak var inputAddressLabel: UILabel!
    
    @IBOutlet weak var asapButton: UIButton!
    @IBOutlet weak var nextHourButton: UIButton!
    @IBOutlet weak var nextTwoHoursButton: UIButton!
    @IBOutlet weak var nextThreeHoursButton: UIButton!
    @IBOutlet weak var nextFourHoursButton: UIButton!
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var addressInput: UITextField!
    
    @IBOutlet weak var submitButton: UIButton!
    
    static var address = ""
    static var TOD = ""
    
    var databaseRef: DatabaseReference!
    var buttonColor: UIColor!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        databaseRef = Database.database().reference()
        
        let df = DateFormatter()
        
        df.dateStyle = .none
        df.timeStyle = .short
        
        buttonColor = asapButton.currentTitleColor
        
        var date = Date()
        print(df.string(from: date))
        let firstHour = df.string(from: date)
        date = date.addingTimeInterval(3600)
        print(df.string(from: date))
        let secondHour = df.string(from: date)
        let nextHourText = "\(firstHour) - \(secondHour)"
        
        date = date.addingTimeInterval(3600)
        let thirdHour = df.string(from: date)
        let twoHoursText = "\(secondHour) - \(thirdHour)"
        
        date = date.addingTimeInterval(3600)
        let fourthHour = df.string(from: date)
        let threeHoursText = "\(thirdHour) - \(fourthHour)"
        
        date = date.addingTimeInterval(3600)
        let fifthHour = df.string(from: date)
        let fourHoursText = "\(fourthHour) - \(fifthHour)"
        
        nextHourButton.setTitle(nextHourText, for: .normal)
        nextTwoHoursButton.setTitle(twoHoursText, for: .normal)
        nextThreeHoursButton.setTitle(threeHoursText, for: .normal)
        nextFourHoursButton.setTitle(fourHoursText, for: .normal)
        
        scrollView.addSubview(timeOfDeliveryLabel)
        scrollView.addSubview(inputAddressLabel)
        scrollView.addSubview(asapButton)
        scrollView.addSubview(nextHourButton)
        scrollView.addSubview(nextTwoHoursButton)
        scrollView.addSubview(nextThreeHoursButton)
        scrollView.addSubview(nextFourHoursButton)
        scrollView.addSubview(addressInput)
        submitButton.isHidden = true
        scrollView.addSubview(submitButton)
        addressInput.delegate = self
        scrollView.contentSize = CGSize(width: view.frame.width, height: view.frame.height+100)
        
    }
    
    @IBAction func asapButtonClicked(_ sender: Any) {
        print("user wants groceries asap")
        updateDatabaseWithTODOf(timeOfDelivery: "ASAP")
        
        asapButton.setTitleColor(UIColor.gray, for: .normal)
        nextHourButton.setTitleColor(buttonColor, for: .normal)
        nextTwoHoursButton.setTitleColor(buttonColor, for: .normal)
        nextThreeHoursButton.setTitleColor(buttonColor, for: .normal)
        nextFourHoursButton.setTitleColor(buttonColor, for: .normal)
    }
    
    @IBAction func nextHourClicked(_ sender: Any) {
        print("user wants groceries in next hour")
        updateDatabaseWithTODOf(timeOfDelivery: "next_hour")
        
        asapButton.setTitleColor(buttonColor, for: .normal)
        nextHourButton.setTitleColor(UIColor.gray, for: .normal)
        nextTwoHoursButton.setTitleColor(buttonColor, for: .normal)
        nextThreeHoursButton.setTitleColor(buttonColor, for: .normal)
        nextFourHoursButton.setTitleColor(buttonColor, for: .normal)
    }
    
    @IBAction func nextTwoHoursClicked(_ sender: Any) {
        print("user wants groceries in next two hours")
        updateDatabaseWithTODOf(timeOfDelivery: "next_two_hours")
        
        asapButton.setTitleColor(buttonColor, for: .normal)
        nextHourButton.setTitleColor(buttonColor, for: .normal)
        nextTwoHoursButton.setTitleColor(UIColor.gray, for: .normal)
        nextThreeHoursButton.setTitleColor(buttonColor, for: .normal)
        nextFourHoursButton.setTitleColor(buttonColor, for: .normal)
    }
    
    @IBAction func nextThreeHoursClicked(_ sender: Any) {
        print("user wants groceries in next three hours")
        updateDatabaseWithTODOf(timeOfDelivery: "next_three_hours")
        
        asapButton.setTitleColor(buttonColor, for: .normal)
        nextHourButton.setTitleColor(buttonColor, for: .normal)
        nextTwoHoursButton.setTitleColor(buttonColor, for: .normal)
        nextThreeHoursButton.setTitleColor(UIColor.gray, for: .normal)
        nextFourHoursButton.setTitleColor(buttonColor, for: .normal)
    }
    
    @IBAction func nextFourHoursClicked(_ sender: Any) {
        print("user wants groceries in next four hours")
        updateDatabaseWithTODOf(timeOfDelivery: "next_four_hours")
        
        asapButton.setTitleColor(buttonColor, for: .normal)
        nextHourButton.setTitleColor(buttonColor, for: .normal)
        nextTwoHoursButton.setTitleColor(buttonColor, for: .normal)
        nextThreeHoursButton.setTitleColor(buttonColor, for: .normal)
        nextFourHoursButton.setTitleColor(UIColor.gray, for: .normal)
    }
    
    @IBAction func submitButtonClicked(_ sender: Any) {
        if let address = addressInput.text, address.count == 0 {
            print("user did not input an address")
            
            let alertController = UIAlertController(title: "Input Address", message:
                "Enter your address for pairing!", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "Dismiss", style: .default))

            self.present(alertController, animated: true, completion: nil)
        } else {
            // TODO: connect with user wanting to help
            
            var listOfItems = ""
            if WantHelpViewController.helpWith == "groceries" {
                listOfItems = ListGroceriesViewController.listOfGroceries
            } else {
                listOfItems = ListPrescriptionViewController.listOfPrescriptions
            }
            
            let addAddress = ["username" : WantHelpViewController.userName,
                "want_help_with" : WantHelpViewController.helpWith,
            "list_of_items" : listOfItems,
            "time_of_delivery" : TimeOfDeliveryViewController.TOD,
            "address" : TimeOfDeliveryViewController.address]
            
            let updateAddress = ["/wantHelp_user/\(WantHelpViewController.userUUID)" : addAddress]
            
            self.databaseRef.updateChildValues(updateAddress)
            
            print("updated with address of user wanting help")
            
            print("user submitted")
            
            let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let newViewController = storyBoard.instantiateViewController(withIdentifier: "helperpairedload") as! HelperPairedLoadViewController
            self.present(newViewController, animated: true, completion: nil)
            
        }
    }
    
    func updateDatabaseWithTODOf(timeOfDelivery: String) {
        
        TimeOfDeliveryViewController.TOD = timeOfDelivery
        
        var listOfItems = ""
        if WantHelpViewController.helpWith == "groceries" {
            listOfItems = ListGroceriesViewController.listOfGroceries
        } else {
            listOfItems = ListPrescriptionViewController.listOfPrescriptions
        }
        
        let addTimeOfDelivery = ["username" : WantHelpViewController.userName,
            "want_help_with" : WantHelpViewController.helpWith,
        "list_of_items" : listOfItems,
        "time_of_delivery" : timeOfDelivery]
        
        let updateTOD = ["/wantHelp_user/\(WantHelpViewController.userUUID)" : addTimeOfDelivery]
        
        self.databaseRef.updateChildValues(updateTOD)
        
        print("updated time of delivery")
    }
}

extension TimeOfDeliveryViewController: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        print("user begins entering address")
        var point = textField.frame.origin
        point.y = point.y - 100
        scrollView.setContentOffset(point, animated: true)
        scrollView.isScrollEnabled = false
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        print("user hit enter")
        
//        guard let address = textField.text, address.count > 0 else {
//            print("user didn't input address")
//            return false
//        }
        
        let addressText = textField.text!
        
        print("user inputted address: \(addressText)")
        
        TimeOfDeliveryViewController.address = addressText
        
        scrollView.isScrollEnabled = true
        scrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
        submitButton.isHidden = false
        
        return true
    }
    
}
