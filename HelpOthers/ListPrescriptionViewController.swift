//
//  ListPrescriptionViewController.swift
//  HelpOthers
//
//  Created by Nitya Tarakad on 3/26/20.
//  Copyright © 2020 Nitya Tarakad. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class ListPrescriptionViewController: UIViewController {
    
    @IBOutlet weak var listPrescription: UITextView!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var labelPrescrption: UILabel!
    @IBOutlet weak var noteLabel: UILabel!
    
    
    static var listOfPrescriptions = ""
    
    var databaseRef: DatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let transitionButtonNormal = UIImage(named: "transition_button_bkgd")
        let transitionButtonClicked = UIImage(named: "transition_button_clicked_bkgd")
        
        listPrescription.isScrollEnabled = true
        listPrescription.center.x = self.view.center.x
        listPrescription.layer.borderColor = CGColor(genericGrayGamma2_2Gray: 1.0, alpha: 1.0)
        listPrescription.layer.borderWidth = 1.0
        
        self.listPrescription.addDoneButton(title: "Done", target: self, selector: #selector(doneWritingList(sender:)))
        
        databaseRef = Database.database().reference()
        
        /* AUTO LAYOUT */
        // groceries label
        labelPrescrption.translatesAutoresizingMaskIntoConstraints = false
        labelPrescrption.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        labelPrescrption.topAnchor.constraint(equalTo: view.topAnchor, constant: 100).isActive = true
        labelPrescrption.widthAnchor.constraint(equalToConstant: 400).isActive = true
        labelPrescrption.heightAnchor.constraint(equalToConstant: 100).isActive = true
        labelPrescrption.textAlignment = .center
        labelPrescrption.adjustsFontSizeToFitWidth = true
        
        // note label
        noteLabel.translatesAutoresizingMaskIntoConstraints = false
        noteLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        noteLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 130).isActive = true
        noteLabel.widthAnchor.constraint(equalToConstant: 250).isActive = true
        noteLabel.heightAnchor.constraint(equalToConstant: 100).isActive = true
        noteLabel.textAlignment = .center
        noteLabel.adjustsFontSizeToFitWidth = true
        
        // text view
        listPrescription.translatesAutoresizingMaskIntoConstraints = false
        listPrescription.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        listPrescription.topAnchor.constraint(equalTo: view.topAnchor, constant: 200).isActive = true
        listPrescription.widthAnchor.constraint(equalToConstant: 360).isActive = true
        listPrescription.heightAnchor.constraint(equalToConstant: 380).isActive = true
        listPrescription.textAlignment = .left
        listPrescription.layer.borderColor = CGColor(srgbRed: 58/255, green: 193/255, blue: 236/255, alpha: 1.0)
        listPrescription.layer.borderWidth = 2.0
        
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
    }
    
    @objc func doneWritingList(sender: Any) {
        self.view.endEditing(true)
    }
    
    @IBAction func toTimeOfDeliveryScreen(_ sender: Any) {
        if (listPrescription.text.count == 0) {
            print("list of prescription not written")
            
            let alertController = UIAlertController(title: "Empty List!", message:
                "Enter the prescription items you need", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "Dismiss", style: .default))

            self.present(alertController, animated: true, completion: nil)
        } else {
            ListPrescriptionViewController.listOfPrescriptions = listPrescription.text
            print("prescriptions are: \(ListPrescriptionViewController.listOfPrescriptions)")
        
            let addListPrescriptions = ["username" : WantHelpViewController.userName,
                                    "want_help_with" : WantHelpViewController.helpWith,
                                "list_of_items" : ListPrescriptionViewController.listOfPrescriptions]
        
            let updateWithListGroceries = ["/wantHelp_user/\(WantHelpViewController.userUUID)" : addListPrescriptions]
        
            self.databaseRef.updateChildValues(updateWithListGroceries)
        
            print("going to time of delivery screen")
            let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let newViewController = storyBoard.instantiateViewController(withIdentifier: "timeofdelivery") as! TimeOfDeliveryViewController
            newViewController.modalPresentationStyle = .fullScreen
            self.present(newViewController, animated: true, completion: nil)
        }
    }
    
}
