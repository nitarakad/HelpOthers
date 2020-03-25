//
//  TimeOfDeliveryViewController.swift
//  HelpOthers
//
//  Created by Nitya Tarakad on 3/25/20.
//  Copyright © 2020 Nitya Tarakad. All rights reserved.
//

import Foundation
import UIKit

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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
    }
    
    @IBAction func nextHourClicked(_ sender: Any) {
        print("user wants groceries in next hour")
    }
    
    @IBAction func nextTwoHoursClicked(_ sender: Any) {
        print("user wants groceries in next two hours")
    }
    
    @IBAction func nextThreeHoursClicked(_ sender: Any) {
        print("user wants groceries in next three hours")
    }
    
    @IBAction func nextFourHoursClicked(_ sender: Any) {
        print("user wants groceries in next four hours")
    }
    
    @IBAction func submitButtonClicked(_ sender: Any) {
        print("user submitted")
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
        
        guard let address = textField.text, address.count > 0 else {
            print("user didn't input address")
            return false
        }
        
        print("user inputted address: \(address)")
        
        TimeOfDeliveryViewController.address = address
        scrollView.isScrollEnabled = true
        scrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
        submitButton.isHidden = false
        
        return true
    }
    
}
