//
//  LoginVC.swift
//  ComCastTest
//
//  Created by Bruce Burgess on 8/10/16.
//  Copyright © 2016 Red Raven Computing Studios. All rights reserved.
//

import UIKit

class LoginVC: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    var activeField: UITextField?
    
    var password: String!
    var username: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        registerForKeyboardNotifications()
        
        self.usernameTextField.delegate = self
        self.passwordTextField.delegate = self
        self.passwordTextField.secureTextEntry = true
        
        let constant = privateConstants()
        self.username = constant.USERNAME
        self.password = constant.PASSWORD
    }
    
    override func viewWillAppear(animated: Bool) {
        setUpNavigatioBar()
        usernameTextField.text = ""
        passwordTextField.text = ""
    }
    
    @IBAction func SignInPressed(sender: UIButton) {
        var enterUsername = usernameTextField.text
        let enterPassword = passwordTextField.text
        
        enterUsername = enterUsername?.lowercaseString

        if enterUsername == username && enterPassword == password {
            self.view.endEditing(true)
            performSegueWithIdentifier("WelcomeSegue", sender: username)
        } else {
            sendAlert()
        }
    }
    
    func sendAlert(){
        let alert = UIAlertController(title: "Auth", message: "Error - Authentication not valid", preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
        
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    func registerForKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(LoginVC.keyboardWillShow(_:)), name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(LoginVC.keyboardWillHide(_:)), name: UIKeyboardWillHideNotification, object: nil)
    }
    
    
    func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue() {
            if view.frame.origin.y == 0 {
                self.view.frame.origin.y -= keyboardSize.height
            } else {
                
            }
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue() {
            if view.frame.origin.y != 0 {
                self.view.frame.origin.y += keyboardSize.height
            } else {
                
            }
        }
    }
    
    func setUpNavigatioBar(){
        self.navigationController?.navigationBarHidden = true
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "WelcomeSegue" {
            if let welcomeVC = segue.destinationViewController as? WelcomeVC {
                if let username = sender as? String {
                    welcomeVC.username = username
                }
            }
        }
    }
    

}
