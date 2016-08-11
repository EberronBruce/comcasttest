//
//  WelcomVC.swift
//  ComCastTest
//
//  Created by Bruce Burgess on 8/10/16.
//  Copyright © 2016 Red Raven Computing Studios. All rights reserved.
//

/*
 This view controller manages the Welcome screen
 */

import UIKit

class WelcomeVC: UIViewController {
    @IBOutlet weak var usernameLabel: UILabel!
    
    var username: String!

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpNavigatioBar()
        self.usernameLabel.text = username
    }
    
    @IBAction func yessPressed(sender: UIButton) {
        performSegueWithIdentifier("TableSegue", sender: nil)
    }
    
    @IBAction func logoutPressed(sender: UIBarButtonItem) {
        sendAlert()
    }
    
    //Mark: - Sends an alert to the user and sets the screen back to the root view controller
    func sendAlert() {
        let alert = UIAlertController(title: "Goodbye", message: "Goodbye \(username)", preferredStyle: UIAlertControllerStyle.Alert)
        let goodbyeAction = UIAlertAction(title: "Bye", style: .Default) { (alertAction:UIAlertAction) in
            self.navigationController?.popToRootViewControllerAnimated(true)
        }
        
        alert.addAction(goodbyeAction)
        self.presentViewController(alert, animated: true, completion: nil)
        
    }
    
    //Mark:- This sets up a navigation bar that is invisible and sets up the back buttons to become white
    func setUpNavigatioBar(){
        self.navigationController?.navigationBarHidden = false
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: UIBarMetrics.Default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.translucent = true
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
    }

}
