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
        
        let buttonBackgroundNormal = UIImage(named: "regular_button_bkgd")
        let buttonBackgroundClicked = UIImage(named: "regular_button_clicked_bkgd")
        
        let bigStar = UIImage(named: "big_star")
        let smallStar = UIImage(named: "small_star")
        let smallerStar = UIImage(named: "smaller_star")
        
        let bigStarImageView = UIImageView(image: bigStar)
        let smallStarImageView = UIImageView(image: smallStar)
        let smallerStarImageView = UIImageView(image: smallerStar)
        view.addSubview(bigStarImageView)
        view.addSubview(smallStarImageView)
        view.addSubview(smallerStarImageView)
        
        bigStarImageView.translatesAutoresizingMaskIntoConstraints = false
        bigStarImageView.bottomAnchor.constraint(equalTo: view.topAnchor, constant: 400).isActive = true
        bigStarImageView.rightAnchor.constraint(equalTo: view.leftAnchor, constant: 300).isActive = true
        bigStarImageView.widthAnchor.constraint(equalToConstant: 500).isActive = true
        bigStarImageView.heightAnchor.constraint(equalToConstant: 500).isActive = true

        smallStarImageView.translatesAutoresizingMaskIntoConstraints = false
        smallStarImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 80).isActive = true
        smallStarImageView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 250).isActive = true
        smallStarImageView.widthAnchor.constraint(equalToConstant: 260).isActive = true
        smallStarImageView.heightAnchor.constraint(equalToConstant: 234).isActive = true
        
        smallerStarImageView.translatesAutoresizingMaskIntoConstraints = false
        smallerStarImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 250).isActive = true
        smallerStarImageView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 190).isActive = true
        smallerStarImageView.widthAnchor.constraint(equalToConstant: 116).isActive = true
        smallerStarImageView.heightAnchor.constraint(equalToConstant: 100).isActive = true
        
        // welcome label auto layout
        welcomeLabel.translatesAutoresizingMaskIntoConstraints = false
        welcomeLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        welcomeLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 160).isActive = true
        welcomeLabel.widthAnchor.constraint(equalToConstant: 300).isActive = true
        welcomeLabel.heightAnchor.constraint(equalToConstant: 100).isActive = true
        welcomeLabel.textAlignment = .center
        welcomeLabel.font = UIFont.systemFont(ofSize: 55)
        
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
        wantHelpButton.widthAnchor.constraint(equalToConstant: 240).isActive = true
        wantHelpButton.heightAnchor.constraint(equalToConstant: 80).isActive = true
        wantHelpButton.setBackgroundImage(buttonBackgroundNormal, for: .normal)
        wantHelpButton.setBackgroundImage(buttonBackgroundClicked, for: .highlighted)
        wantHelpButton.titleLabel?.textAlignment = .center
        wantHelpButton.titleLabel?.adjustsFontSizeToFitWidth = true
        wantHelpButton.setTitleColor(UIColor(red: 227/255, green: 227/255, blue: 1.0, alpha: 1.0), for: .normal)
        
        // wantToHelp button auto layout
        wantToHelpButton.translatesAutoresizingMaskIntoConstraints = false
        wantToHelpButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        wantToHelpButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 500).isActive = true
        wantToHelpButton.widthAnchor.constraint(equalToConstant: 240).isActive = true
        wantToHelpButton.heightAnchor.constraint(equalToConstant: 80).isActive = true
        wantToHelpButton.setBackgroundImage(buttonBackgroundNormal, for: .normal)
        wantToHelpButton.setBackgroundImage(buttonBackgroundClicked, for: .highlighted)
        wantToHelpButton.titleLabel?.textAlignment = .center
        wantToHelpButton.titleLabel?.adjustsFontSizeToFitWidth = true
        wantToHelpButton.setTitleColor(UIColor(red: 227/255, green: 227/255, blue: 1.0, alpha: 1.0), for: .normal)
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

