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
        performSegue(withIdentifier: "TableSegue", sender: nil)
    }
    
    @IBAction func logoutPressed(sender: UIBarButtonItem) {
        sendAlert()
    }
    
    //Mark: - Sends an alert to the user and sets the screen back to the root view controller
    func sendAlert() {
        let alert = UIAlertController(title: "Goodbye", message: "Goodbye \(username ?? "UserName")", preferredStyle: UIAlertController.Style.alert)
        let goodbyeAction = UIAlertAction(title: "Bye", style: .default) { (alertAction:UIAlertAction) in
            self.navigationController?.popToRootViewController(animated: true)
        }
        
        alert.addAction(goodbyeAction)
        self.present(alert, animated: true, completion: nil)
        
    }
    
    //Mark:- This sets up a navigation bar that is invisible and sets up the back buttons to become white
    func setUpNavigatioBar(){
        self.navigationController?.isNavigationBarHidden = false
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.navigationBar.tintColor = UIColor.white
    }

}
