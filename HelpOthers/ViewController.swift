//
//  ViewController.swift
//  HelpOthers
//
//  Created by Nitya Tarakad on 3/24/20.
//  Copyright © 2020 Nitya Tarakad. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var wantHelpButton: UIButton!
    @IBOutlet weak var wantToHelpButton: UIButton!
    
    static var userStatus = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
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

