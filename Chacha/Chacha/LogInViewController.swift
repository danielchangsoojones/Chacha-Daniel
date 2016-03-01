//
//  LogInViewController.swift
//  Chacha
//
//  Created by Daniel Jones on 2/28/16.
//  Copyright © 2016 Chong500Productions. All rights reserved.
//

import UIKit
import Parse

class LogInViewController: UIViewController {
    
    @IBOutlet weak var theLoginView: UIView!
    @IBOutlet weak var theUserName: UITextField!
    @IBOutlet weak var thePassword: UITextField!
    @IBOutlet weak var theSpinner: UIActivityIndicatorView!
    
    @IBAction func logIn(sender: AnyObject) {
        if allValidates() {
            logIn()
        }
    }
    
    @IBAction func logInWithFacebook(sender: AnyObject) {
        //TODO: facebook log in
    }
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBarHidden = false
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        theUserName.becomeFirstResponder()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func allRequiredFieldsComplete() -> Bool {
        if self.theUserName.text!.isEmpty
            || self.thePassword.text!.isEmpty
        {
            return false
        }
        else
        {
            return true
        }
    }
    
    
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if textField===self.theUserName
        {
            self.thePassword.becomeFirstResponder()
        }
        else if textField===self.thePassword
        {
            if self.allValidates() == true
            {
                if !self.allRequiredFieldsComplete()
                {
                }
            }
        }
        return true
    }
    
    
    func allValidates() -> Bool
    {
        if theUserName.text!.isEmpty {
            let alert = Alert()
            alert.addButton("Okay", closeButtonHidden: true, buttonAction: { () -> Void in
                alert.closeAlert()
                self.theUserName.becomeFirstResponder()
            })
            alert.createAlert("Username is Required", subtitle: "Please enter your username.", closeButtonTitle: "", type: .Error)
            return false
        }
        else if thePassword.text!.isEmpty {
            let alert = Alert()
            alert.addButton("Okay", closeButtonHidden: true, buttonAction: { () -> Void in
                alert.closeAlert()
                self.thePassword.becomeFirstResponder()
            })
            alert.createAlert("Password is Required", subtitle: "Please enter your password.", closeButtonTitle: "", type: .Error)
            return false
        }
        else {
            return true
        }
    }
    
    //Backend Swap
    func logIn() {
        view.userInteractionEnabled=false
        theSpinner.startAnimating()
        User.logInWithUsernameInBackground(theUserName.text!.lowercaseString, password: thePassword.text!) { (user, error) -> Void in
            self.theSpinner.stopAnimating()
            self.view.userInteractionEnabled=true
            
            if let error = error {
                let code = error.code
                if code == PFErrorCode.ErrorObjectNotFound.rawValue {
                    let alert = Alert()
                    alert.addButton("Okay", closeButtonHidden: true, buttonAction: { () -> Void in
                        alert.closeAlert()
                        self.theUserName.becomeFirstResponder()
                    })
                    alert.createAlert("Log In Problem", subtitle: "Username or Password is incorrect.", closeButtonTitle: "", type: .Error)
                }
                else {
                    _ = Alert(title: "Failed Login", subtitle: "Login failed at this time.", closeButtonTitle: "Okay", type: .Error)
                }
                return;
            }
            
            if user != nil {
                self.performSegueWithIdentifier("LogInSuccessSegue", sender: self)
                let installation = PFInstallation.currentInstallation()
                installation["user"] = PFUser.currentUser()
                installation.saveEventually(nil)
            }
        }
    }
    

}
