//
//  WelcomVC.swift
//  ComCastTest
//
//  Created by Bruce Burgess on 8/10/16.
//  Copyright © 2016 Red Raven Computing Studios. All rights reserved.
//

import UIKit

class WelcomeVC: UIViewController {
    @IBOutlet weak var usernameLabel: UILabel!
    
    var username: String!

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpNavigatioBar()
        self.usernameLabel.text = username
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func yessPressed(sender: UIButton) {
        performSegueWithIdentifier("TableSegue", sender: nil)
    }
    
    @IBAction func logoutPressed(sender: UIBarButtonItem) {
        sendAlert()
    }
    
    func sendAlert() {
        
        let alert = UIAlertController(title: "Goodbye", message: "Goodbye \(username)", preferredStyle: UIAlertControllerStyle.Alert)
        let goodbyeAction = UIAlertAction(title: "Bye", style: .Default) { (alertAction:UIAlertAction) in
            self.navigationController?.popToRootViewControllerAnimated(true)
        }
        
        alert.addAction(goodbyeAction)
        self.presentViewController(alert, animated: true, completion: nil)
        
    }
    
    func setUpNavigatioBar(){
        self.navigationController?.navigationBarHidden = false
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: UIBarMetrics.Default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.translucent = true
    }

    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    

}
