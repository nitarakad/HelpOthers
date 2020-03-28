//
//  ListGroceriesViewController.swift
//  HelpOthers
//
//  Created by Nitya Tarakad on 3/26/20.
//  Copyright © 2020 Nitya Tarakad. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class ListGroceriesViewController: UIViewController {
    
    @IBOutlet weak var listGroceries: UITextView!
    @IBOutlet weak var labelGroceries: UILabel!
    @IBOutlet weak var noteLabel: UILabel!
    @IBOutlet weak var nextButton: UIButton!
    
    static var listOfGroceries = ""
    
    var databaseRef: DatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let transitionButtonNormal = UIImage(named: "transition_button_bkgd")
        let transitionButtonClicked = UIImage(named: "transition_button_clicked_bkgd")
        
        labelGroceries.center.x = self.view.center.x
        
        listGroceries.isScrollEnabled = true
        listGroceries.center.x = self.view.center.x
        
        self.listGroceries.addDoneButton(title: "Done", target: self, selector: #selector(doneWritingList(sender:)))
        
        /* AUTO LAYOUT */
        // groceries label
        labelGroceries.translatesAutoresizingMaskIntoConstraints = false
        labelGroceries.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        labelGroceries.topAnchor.constraint(equalTo: view.topAnchor, constant: 100).isActive = true
        labelGroceries.widthAnchor.constraint(equalToConstant: 400).isActive = true
        labelGroceries.heightAnchor.constraint(equalToConstant: 100).isActive = true
        labelGroceries.textAlignment = .center
        labelGroceries.adjustsFontSizeToFitWidth = true
        
        // note label
        noteLabel.translatesAutoresizingMaskIntoConstraints = false
        noteLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        noteLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 130).isActive = true
        noteLabel.widthAnchor.constraint(equalToConstant: 250).isActive = true
        noteLabel.heightAnchor.constraint(equalToConstant: 100).isActive = true
        noteLabel.textAlignment = .center
        noteLabel.adjustsFontSizeToFitWidth = true
        
        // text view
        listGroceries.translatesAutoresizingMaskIntoConstraints = false
        listGroceries.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        listGroceries.topAnchor.constraint(equalTo: view.topAnchor, constant: 200).isActive = true
        listGroceries.widthAnchor.constraint(equalToConstant: 360).isActive = true
        listGroceries.heightAnchor.constraint(equalToConstant: 380).isActive = true
        listGroceries.textAlignment = .left
        listGroceries.layer.borderColor = CGColor(srgbRed: 58/255, green: 193/255, blue: 236/255, alpha: 1.0)
        listGroceries.layer.borderWidth = 2.0
        
        // submit button
        nextButton.translatesAutoresizingMaskIntoConstraints = false
        nextButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 590).isActive = true
        nextButton.widthAnchor.constraint(equalToConstant: 120).isActive = true
        nextButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
        nextButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 248).isActive = true
        nextButton.setBackgroundImage(transitionButtonNormal, for: .normal)
        nextButton.setBackgroundImage(transitionButtonClicked, for: .highlighted)
        nextButton.titleLabel?.adjustsFontSizeToFitWidth = true
        nextButton.titleLabel?.textAlignment = .center
        nextButton.setTitleColor(UIColor(red: 232/255, green: 232/255, blue: 232/255, alpha: 1.0), for: .normal)
        
        databaseRef = Database.database().reference()
    }
    
    @objc func doneWritingList(sender: Any) {
        self.view.endEditing(true)
    }
    
    @IBAction func toTimeOfDeliveryScreen(_ sender: Any) {
        ListGroceriesViewController.listOfGroceries = listGroceries.text
        print("groceries are: \(ListGroceriesViewController.listOfGroceries)")
        
        let addListGroceries = ["username" : WantHelpViewController.userName,
                                "want_help_with" : "groceries",
                                "list_of_items" : ListGroceriesViewController.listOfGroceries]
        
        let updateWithListGroceries = ["/wantHelp_user/\(WantHelpViewController.userUUID)" : addListGroceries]
        
        self.databaseRef.updateChildValues(updateWithListGroceries)
        
        //self.databaseRef.child("wantHelp_user").child(WantHelpViewController.userUUID).setValue(["list_of_groceries" : listGroceries.text])
        
        print("going to time of delivery screen")
        
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "timeofdelivery") as! TimeOfDeliveryViewController
        newViewController.modalPresentationStyle = .fullScreen
        self.present(newViewController, animated: true, completion: nil)
    }
}

// found on swiftdevcenter
extension UITextView {
    func addDoneButton(title: String, target: Any, selector: Selector) {
        
        let toolBar = UIToolbar(frame: CGRect(x: 0.0,
                                              y: 0.0,
                                              width: UIScreen.main.bounds.size.width,
                                              height: 44.0))//1
        let flexible = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)//2
        let barButton = UIBarButtonItem(title: title, style: .plain, target: target, action: selector)//3
        toolBar.setItems([flexible, barButton], animated: false)//4
        self.inputAccessoryView = toolBar//5
    }
}


