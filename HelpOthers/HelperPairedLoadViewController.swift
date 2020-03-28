//
//  HelperPairedLoadViewController.swift
//  HelpOthers
//
//  Created by Nitya Tarakad on 3/26/20.
//  Copyright © 2020 Nitya Tarakad. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class HelperPairedLoadViewController: UIViewController {
    
    @IBOutlet weak var pairingYouLabel: UILabel!
    @IBOutlet weak var dotOneImageView: UIImageView!
    @IBOutlet weak var dotTwoImageView: UIImageView!
    @IBOutlet weak var dotThreeImageView: UIImageView!
    
    var databaseRef: DatabaseReference!
    var timer = Timer()
    var dotOneTimer = Timer()
    var dotTwoTimer = Timer()
    var dotThreeTimer = Timer()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        databaseRef = Database.database().reference()
    
        checkDatabaseWithTimer()
        
        let dotImage = UIImage(named: "dot")
        dotOneImageView.image = dotImage
        dotTwoImageView.image = dotImage
        dotThreeImageView.image = dotImage
        
        /* AUTO LAYOUT */
        
        // pairing you label
        pairingYouLabel.translatesAutoresizingMaskIntoConstraints = false
        pairingYouLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        pairingYouLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 300).isActive = true
        pairingYouLabel.widthAnchor.constraint(equalToConstant: 300).isActive = true
        pairingYouLabel.heightAnchor.constraint(equalToConstant: 100).isActive = true
        pairingYouLabel.textAlignment = .center
        
        // dot one
        dotOneImageView.translatesAutoresizingMaskIntoConstraints = false
        dotOneImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        dotOneImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        dotOneImageView.widthAnchor.constraint(equalToConstant: 40).isActive = true
        dotOneImageView.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        // dot two
        dotTwoImageView.translatesAutoresizingMaskIntoConstraints = false
        dotTwoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: -80).isActive = true
        dotTwoImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        dotTwoImageView.widthAnchor.constraint(equalToConstant: 40).isActive = true
        dotTwoImageView.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        // dot three
        dotThreeImageView.translatesAutoresizingMaskIntoConstraints = false
        dotThreeImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 80).isActive = true
        dotThreeImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        dotThreeImageView.widthAnchor.constraint(equalToConstant: 40).isActive = true
        dotThreeImageView.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        dotLoadingAnimation()

    }
    
    func dotLoadingAnimation() {
        dotOneTimer = Timer.scheduledTimer(timeInterval: 0.7, target: self, selector: #selector(dotOneBlink), userInfo: nil, repeats: true)
        dotTwoTimer = Timer.scheduledTimer(timeInterval: 0.7, target: self, selector: #selector(dotTwoBlink), userInfo: nil, repeats: true)
        dotThreeTimer = Timer.scheduledTimer(timeInterval: 0.7, target: self, selector: #selector(dotThreeBlink), userInfo: nil, repeats: true)
    }
    
    
    @objc func dotOneBlink() {
        UIView.animate(withDuration: 0.7) {
            self.dotOneImageView.alpha = self.dotOneImageView.alpha == 1.0 ? 0.0 : 1.0
        }
    }
    
    
    @objc func dotTwoBlink() {
        UIView.animate(withDuration: 0.7) {
            self.dotTwoImageView.alpha = self.dotTwoImageView.alpha == 1.0 ? 0.0 : 1.0
        }
    }
    
    @objc func dotThreeBlink() {
        UIView.animate(withDuration: 0.7) {
            self.dotThreeImageView.alpha = self.dotThreeImageView.alpha == 1.0 ? 0.0 : 1.0
        }
    }

    func checkDatabaseWithTimer() {
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(checkIfHelperPaired), userInfo: nil, repeats: true)
    }

    @objc func checkIfHelperPaired() {
        databaseRef.child("wantHelp_user").child(WantHelpViewController.userUUID).child("helper_paired_uuid").observeSingleEvent(of: .value) { (snapshot) in
            if !snapshot.exists() {
                print("doesn't exist --> user hasnt been paired yet")
            } else {
                print("does exist --> user has been paired")
                let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                let newViewController = storyBoard.instantiateViewController(withIdentifier: "helperpaired") as! HelperPairedViewController
                newViewController.modalPresentationStyle = .fullScreen
                self.present(newViewController, animated: true, completion: nil)
                self.timer.invalidate()
                self.dotOneTimer.invalidate()
                self.dotTwoTimer.invalidate()
                self.dotThreeTimer.invalidate()
            }
        }
    }
}
