//
//  ViewController.swift
//  HelpOthers
//
//  Created by Nitya Tarakad on 3/24/20.
//  Copyright © 2020 Nitya Tarakad. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var welcomeLabel: UILabel!
    @IBOutlet weak var selectEitherLabel: UILabel!
    @IBOutlet weak var wantHelpButton: UIButton!
    @IBOutlet weak var wantToHelpButton: UIButton!
    
    static var userStatus = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        // welcome label auto layout
        welcomeLabel.translatesAutoresizingMaskIntoConstraints = false
        welcomeLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        welcomeLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 100).isActive = true
        welcomeLabel.widthAnchor.constraint(equalToConstant: 200).isActive = true
        welcomeLabel.heightAnchor.constraint(equalToConstant: 100).isActive = true
        welcomeLabel.textAlignment = .center
        
        // selectEither label auto layout
        selectEitherLabel.translatesAutoresizingMaskIntoConstraints = false
        selectEitherLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        selectEitherLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 300).isActive = true
        selectEitherLabel.widthAnchor.constraint(equalToConstant: 400).isActive = true
        selectEitherLabel.heightAnchor.constraint(equalToConstant: 100).isActive = true
        selectEitherLabel.textAlignment = .center
        
        // wantHelp button auto layout
        wantHelpButton.translatesAutoresizingMaskIntoConstraints = false
        wantHelpButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        wantHelpButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 400).isActive = true
        wantHelpButton.widthAnchor.constraint(equalToConstant: 400).isActive = true
        wantHelpButton.heightAnchor.constraint(equalToConstant: 100).isActive = true
        
        // wantToHelp button auto layout
        wantToHelpButton.translatesAutoresizingMaskIntoConstraints = false
        wantToHelpButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        wantToHelpButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 500).isActive = true
        wantToHelpButton.widthAnchor.constraint(equalToConstant: 400).isActive = true
        wantToHelpButton.heightAnchor.constraint(equalToConstant: 100).isActive = true
    }
    
    @IBAction func toWantHelpScreen(_ sender: Any) {
        print("user wants help")
        ViewController.userStatus = "help"
        
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "wanthelp") as! WantHelpViewController
        
        newViewController.modalPresentationStyle = .fullScreen
        self.present(newViewController, animated: true, completion: nil)
    }
    
    @IBAction func toWantToHelpScreen(_ sender: Any) {
        print("user is helping")
        ViewController.userStatus = "helping"
        
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "wanttohelp") as! WantToHelpViewController
        
        newViewController.modalPresentationStyle = .fullScreen
        self.present(newViewController, animated: true, completion: nil)
    }


}

