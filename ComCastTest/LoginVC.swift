//
//  LoginVC.swift
//  ComCastTest
//
//  Created by Bruce Burgess on 8/10/16.
//  Copyright © 2016 Red Raven Computing Studios. All rights reserved.
//

/*
 This view controller controls the login screen.
 
 */

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
    
    //Resets the text fields when the view appears
    override func viewWillAppear(animated: Bool) {
        setUpNavigatioBar()
        usernameTextField.text = ""
        passwordTextField.text = ""
    }
    
    @IBAction func SignInPressed(sender: UIButton) {
        var enterUsername = usernameTextField.text
        let enterPassword = passwordTextField.text
        
        enterUsername = enterUsername?.lowercaseString //sets the username to all lower case, easy for testing

        //Check for username and password
        if enterUsername == username && enterPassword == password {
            self.view.endEditing(true)
            performSegueWithIdentifier("WelcomeSegue", sender: username)
        } else {
            sendAlert()
        }
    }
    
    //Mark: - This function sends and alert when the username and password is wrong
    func sendAlert(){
        let alert = UIAlertController(title: "Auth", message: "Error - Authentication not valid", preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
        
    }
    
    //Ends the keyboard when enter is pressed
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    //Used to send notifications for keyboard
    func registerForKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(LoginVC.keyboardWillShow(_:)), name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(LoginVC.keyboardWillHide(_:)), name: UIKeyboardWillHideNotification, object: nil)
    }
    
    //Mark: - This function moves the view when the keyboard is displayed to show both text fields
    func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue() {
            if view.frame.origin.y == 0 {
                self.view.frame.origin.y -= keyboardSize.height
            } else {
                
            }
        }
    }
    //Mark: - This function moves the view down when the keyboard is dismissed
    func keyboardWillHide(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue() {
            if view.frame.origin.y != 0 {
                self.view.frame.origin.y += keyboardSize.height
            } else {
                
            }
        }
    }
    
    //Mark: - this hides the navigation bar.
    private func setUpNavigatioBar(){
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
