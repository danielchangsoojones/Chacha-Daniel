//
//  SignUpViewController.swift
//  Chacha
//
//  Created by Daniel Jones on 2/24/16.
//  Copyright © 2016 Chong500Productions. All rights reserved.
//

import UIKit
import Foundation
import Parse
import SCLAlertView

class SignUpViewController: UITableViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var datePicker:UIDatePicker!
    
    private var theGenderText: String!
    @IBOutlet weak var theUsername: UITextField!
    @IBOutlet weak var theEmail: UITextField!
    @IBOutlet weak var thePassword: UITextField!
    @IBOutlet weak var thePasswordConfirm: UITextField!
    @IBOutlet weak var theBirthDate: UITextField!
    @IBOutlet weak var theMaleButton: UIButton!
    @IBOutlet weak var theFemaleButton: UIButton!
    @IBOutlet weak var theFullName: UITextField!
    @IBOutlet weak var theSpinner: UIActivityIndicatorView!
    @IBOutlet weak var theAvatarButton: UIButton!
    @IBOutlet weak var theAvatarImage: UIImageView!
    @IBOutlet weak var avatarPlusLabel: UILabel!
    @IBOutlet weak var avatarView: UIView!
    @IBOutlet weak var usernameView: UIView!
    @IBOutlet weak var otherView: UIView!
    
    @IBAction func tapSignUp(sender: AnyObject) {
        if allValidates() {
            signUp()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = ChachaTeal
        
        applyShadow(avatarView)
        applyShadow(usernameView)
        applyBorder(otherView)
        applyShadow(otherView)
        
        addDatePicker()
        configurePicker()
        tableView.backgroundView = UIImageView(image: UIImage(named: "login background"))
        navigationItem.rightBarButtonItem?.setTitleTextAttributes(
            [NSFontAttributeName: UIFont(name: "Lucida Grande", size: 9)!], forState: .Normal)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBarHidden = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK:- methods
    
    func configurePicker()
    {
        datePicker.maximumDate = NSDate()
        
    }
    
    //BackendSwap
    func signUp()
    {
        let newUser = User()
        newUser.fullName = theFullName.text!
        newUser.lowercaseFullName = theFullName.text!.lowercaseString
        newUser.username = theUsername.text!.lowercaseString
        newUser.lowercaseUsername = theUsername.text!.lowercaseString
        newUser.email = theEmail.text
        newUser.password = thePassword.text
        newUser.gender = theGenderText
        if (theBirthDate.text != "") {
            newUser.birthDate = datePicker.date
        }
        if let image = theAvatarImage.image {
            let file = PFFile(name: "avatar.jpg",data: UIImageJPEGRepresentation(image, 0.6)!)
            newUser.avatarImage = file
        }
        newUser.gender? = theGenderText
        self.view.userInteractionEnabled = false
        theSpinner.startAnimating()
        
        newUser.signUpInBackgroundWithBlock { (success, error) -> Void in
            self.view.userInteractionEnabled = true
            self.theSpinner.stopAnimating()
            if success {
                self.performSegueWithIdentifier("SignUpSuccessSegue", sender: self)
                let installation = PFInstallation.currentInstallation()
                installation["user"] = PFUser.currentUser()
                installation.saveInBackground()
            }
            else {
                if error != nil {
                    let code = error!.code
                    if code == PFErrorCode.ErrorInvalidEmailAddress.rawValue {
                         _ = Alert(title: "Invalid Email Address", subtitle: "Please enter a valid email address.", closeButtonTitle: "Okay", type: .Error)
                    }
                    else if code == PFErrorCode.ErrorUsernameTaken.rawValue {
                        _ = Alert(title: "Problem Signing Up", subtitle: "Username not available.", closeButtonTitle: "Okay", type: .Error)
                    }
                    else if code == PFErrorCode.ErrorUserEmailTaken.rawValue {
                         _ = Alert(title: "Problem Signing Up", subtitle: "Email already being used by another user, please use a differnet one.", closeButtonTitle: "Okay", type: .Error)
                    }
                    _ = Alert(title: "Problem Signing Up", subtitle: "error:\(error!.code)", closeButtonTitle: "Okay", type: .Error)
                }
            }
        }
    }
    
    
    func allRequiredFieldsComplete() -> Bool
    {
        if self.theUsername.text!.isEmpty
            || self.theFullName.text!.isEmpty
            || self.theEmail.text!.isEmpty
            || self.thePassword.text!.isEmpty
            || self.thePasswordConfirm.text!.isEmpty
        {
            return false
        }
        else
        {
            return true
        }
    }
    
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if textField===self.theUsername
        {
            self.theFullName.becomeFirstResponder()
        }
        else if textField===self.theFullName
        {
            self.theEmail.becomeFirstResponder()
        }
        else if textField===self.theEmail
        {
            self.thePassword.becomeFirstResponder()
        }
        else if textField===self.thePassword
        {
            self.thePasswordConfirm.becomeFirstResponder()
        }
        else if textField===self.thePasswordConfirm
        {
            self.theBirthDate.becomeFirstResponder()
        }
        else if textField===self.theBirthDate
        {
            if self.allValidates() == true
            {
                if !self.allRequiredFieldsComplete()
                {
                    self.theUsername.becomeFirstResponder()
                }
            }
        }
        return true
    }
    
    func allValidates() -> Bool
    {
        theUsername.text = theUsername.text?.stringByReplacingOccurrencesOfString(" ", withString: "")
        if theUsername.text!.isEmpty {
            let alert = Alert()
            alert.addButton("Okay", closeButtonHidden: true, buttonAction: { () -> Void in
                alert.closeAlert()
                self.theUsername.becomeFirstResponder()
            })
            alert.createAlert("Username is Required", subtitle: "Please enter a username.", closeButtonTitle: "", type: .Error)
            return false
        }
        else if theUsername.text!.characters.count < 3 {
            let alert = Alert()
            alert.addButton("Okay", closeButtonHidden: true, buttonAction: { () -> Void in
                alert.closeAlert()
                self.theUsername.becomeFirstResponder()
            })
            alert.createAlert("Username must be at least 3 characters.", subtitle: "", closeButtonTitle: "", type: .Error)
            return false
        }
        else if theFullName.text!.isEmpty {
            let alert = Alert()
            alert.addButton("Okay", closeButtonHidden: true, buttonAction: { () -> Void in
                alert.closeAlert()
                self.theFullName.becomeFirstResponder()
            })
            alert.createAlert("Full Name is Required", subtitle: "Please enter your full name.", closeButtonTitle: "", type: .Error)
            return false
        }
        else if theEmail.text!.isEmpty {
            let alert = Alert()
            alert.addButton("Okay", closeButtonHidden: true, buttonAction: { () -> Void in
                alert.closeAlert()
                self.theEmail.becomeFirstResponder()
            })
            alert.createAlert("Email is Required", subtitle: "Please enter an email address.", closeButtonTitle: "", type: .Error)
            return false
        }
        else if isValidEmail(theEmail.text!) == false {let alert = Alert()
            alert.addButton("Okay", closeButtonHidden: true, buttonAction: { () -> Void in
                alert.closeAlert()
                self.theEmail.becomeFirstResponder()
            })
            alert.createAlert("Invalid Email", subtitle: "Please enter a valid email address", closeButtonTitle: "", type: .Error)
            return false
        }
        else if thePassword.text!.isEmpty {
            let alert = Alert()
            alert.addButton("Okay", closeButtonHidden: true, buttonAction: { () -> Void in
                alert.closeAlert()
                self.thePassword.becomeFirstResponder()
            })
            alert.createAlert("Password is Required", subtitle: "Please enter a password.", closeButtonTitle: "", type: .Error)
            return false
        }
        else if thePasswordConfirm.text!.isEmpty {
            let alert = Alert()
            alert.addButton("Okay", closeButtonHidden: true, buttonAction: { () -> Void in
                alert.closeAlert()
                self.thePassword.becomeFirstResponder()
            })
            alert.createAlert("Confirmed Password is Required", subtitle: "Please enter your Confirmed Password", closeButtonTitle: "", type: .Error)
            return false
        }
        else if thePasswordConfirm.text != thePassword.text {
            let alert = Alert()
            alert.addButton("Okay", closeButtonHidden: true, buttonAction: { () -> Void in
                alert.closeAlert()
                self.thePassword.becomeFirstResponder()
            })
            alert.createAlert("Password Error", subtitle: "Passwords do not match.", closeButtonTitle: "", type: .Error)
            return false
        }
        else if validBirthdate() == false {
            let alert = Alert()
            alert.addButton("Okay", closeButtonHidden: true, buttonAction: { () -> Void in
                alert.closeAlert()
                self.theBirthDate.becomeFirstResponder()
            })
            alert.createAlert("Invalid Birth Date", subtitle: "Please enter a valid Birth Date", closeButtonTitle: "", type: .Error)
            return false
        }
            //     Commented because these are optional fields, but this code treats them as required
            //        else if theBirthDate.text.isEmpty {
            //            iLikeyAlert(self, "", "Birth Date is required") {
            //                self.theBirthDate.becomeFirstResponder()
            //            }
            //            return false
            //        }
            //        else if theMaleButton.selected == false && theFemaleButton.selected == false {
            //            iLikeyAlert(self, "", "Must select gender", nil)
            //            return false
            //        }
        else if theAvatarImage.image == nil {
            _ = Alert(title: "Avatar Image required", subtitle: "Please pick an avatar image", closeButtonTitle: "Okay", type: .Error)
            return false
        }
        else {
            return true
        }
    }
    
    //MARK: birthDate
    
    func validBirthdate() -> Bool
    {
        if (datePicker.date.compare(NSDate()) == NSComparisonResult.OrderedAscending) {
            return true
        }
        else {
            return false
        }
    }
    
    func updateBirthDate()
    {
        theBirthDate.text = datePicker.date.toShortDate()
    }
    
    func tapDone()
    {
        updateBirthDate()
        theBirthDate.resignFirstResponder()
    }
    
    func tapClear()
    {
        self.theBirthDate.text = ""
        theBirthDate.resignFirstResponder()
    }
    
    func addDatePicker()
    {
        datePicker = UIDatePicker()
        let cal = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)
        let dateComps = NSDateComponents()
        dateComps.year = -18
        guard let theCal = cal else { return }
        guard let newDate = theCal.dateByAddingComponents(dateComps, toDate: NSDate(), options: NSCalendarOptions())  else { return }
        datePicker.date = newDate
        datePicker.addTarget(self, action: "updateBirthDate", forControlEvents: .ValueChanged)
        theBirthDate.inputView = datePicker
        datePicker.datePickerMode = UIDatePickerMode.Date
        
        let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: 320, height: 34))
        toolbar.setItems([UIBarButtonItem(title: "Clear/Cancel", style: .Plain, target: self, action: "tapClear"),UIBarButtonItem(barButtonSystemItem: .FlexibleSpace, target:nil, action:nil),
            UIBarButtonItem(title: "Done", style: .Plain, target: self, action: "tapDone")], animated: false)
        theBirthDate.inputAccessoryView = toolbar
        
        theBirthDate.delegate = self
    }
    
    @IBAction func tapMale(sender: AnyObject) {
        theFemaleButton.selected = false
        theMaleButton.selected = true
        theMaleButton.layer.borderWidth = 1
        theFemaleButton.layer.borderWidth = 0
        theMaleButton.backgroundColor = iLikeyBlue
        theFemaleButton.backgroundColor = iLikeyGrayMercury
        theGenderText = "Male"
    }
    
    @IBAction func tapFemale(sender: AnyObject) {
        theFemaleButton.selected = true
        theMaleButton.selected = false
        theMaleButton.layer.borderWidth = 0
        theFemaleButton.layer.borderWidth = 1
        theMaleButton.backgroundColor = iLikeyGrayMercury
        theFemaleButton.backgroundColor = iLikeyPink
        theGenderText = "Female"
    }
   
    @IBAction func tapAvatar(sender: AnyObject) {
        let imgPicker = UIImagePickerController()
        imgPicker.delegate = self
        imgPicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary;
        imgPicker.allowsEditing = true
        self.presentViewController(imgPicker, animated: true, completion: nil)
    }
    
    //MARK:- UIImagePickerControllerDelegate
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage!, editingInfo: [NSObject : AnyObject]!)
    {
        if image != nil {
            let img = image.resizeImage(CGSize(width:256,height:256))
            theAvatarImage.image = img
        }
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func isValidEmail(email:String) -> Bool {
        let emailRegex = "[A-Z0-9._%+-]+@[A-Z0-9.-]+.[A-Z0-9._%+-]{1,100}";
        let emailTest = NSPredicate(format: "SELF MATCHES[c] %@", emailRegex)
        return emailTest.evaluateWithObject(email)
    }
    
}
