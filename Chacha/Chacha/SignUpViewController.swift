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
        let file = PFFile(name: "avatar.jpg",data: UIImageJPEGRepresentation(theAvatarImage.image!, 0.6)!)
        newUser.avatarImage = file
        newUser.gender? = theGenderText
        self.view.userInteractionEnabled = false
        theSpinner.startAnimating()
        
        newUser.signUpInBackgroundWithBlock { (success, error) -> Void in
            self.view.userInteractionEnabled = true
            self.theSpinner.stopAnimating()
            if success {
                
                let installation = PFInstallation.currentInstallation()
                installation["user"] = PFUser.currentUser()
                installation.saveInBackground()
                self.dismissViewControllerAnimated(true, completion:nil)
            }
            else {
                if error != nil {
                    let code = error!.code
                    if code == PFErrorCode.ErrorInvalidEmailAddress.rawValue {
                        //iLikeyAlert(self, title: "", message: "Please enter a valid email address.", completion: nil)
                        
                    }
                    else if code == PFErrorCode.ErrorUsernameTaken.rawValue {
                        //iLikeyAlert(self, title: "Problem Signing Up", message: "Username not available.", completion: nil)
                    }
                    else if code == PFErrorCode.ErrorUserEmailTaken.rawValue {
                        //iLikeyAlert(self, title: "Problem Signing Up", message: "Email already being used by another user, please use a differnet one.", completion: nil)
                    }
                    //iLikeyAlert(self, title: "Problem Signing Up", message: "error:\(error!.code)", completion: nil)
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
//        theUsername.text = theUsername.text?.stringByReplacingOccurrencesOfString(" ", withString: "")
//        if theUsername.text!.isEmpty {
//            iLikeyAlert(self, title: "", message: "Username is required") {
//                self.theUsername.becomeFirstResponder()
//            }
//            return false
//        }
//        else if theUsername.text!.characters.count < 3 {
//            iLikeyAlert(self, title: "", message: "Username must be at least 3 characters") {
//                self.theUsername.becomeFirstResponder()
//            }
//            return false
//        }
//        else if theFullName.text!.isEmpty {
//            iLikeyAlert(self, title: "", message: "Full Name is required") {
//                self.theFullName.becomeFirstResponder()
//            }
//            return false
//        }
//        else if theEmail.text!.isEmpty {
//            iLikeyAlert(self, title: "", message: "Email is required") {
//                self.theEmail.becomeFirstResponder()
//            }
//            return false
//        }
//        else if isValidEmail(theEmail.text!) == false {
//            iLikeyAlert(self, title: "", message: "Please enter valid email address") {
//                self.theEmail.becomeFirstResponder()
//            }
//            return false
//        }
//        else if thePassword.text!.isEmpty {
//            iLikeyAlert(self, title: "", message: "Password is required") {
//                self.thePassword.becomeFirstResponder()
//            }
//            return false
//        }
//        else if thePasswordConfirm.text!.isEmpty {
//            iLikeyAlert(self, title: "", message: "Confirm Password is required"){
//                self.thePasswordConfirm.becomeFirstResponder()
//            }
//            return false
//        }
//        else if thePasswordConfirm.text != thePassword.text {
//            iLikeyAlert(self, title: "", message: "Passwords do not match") {
//                self.thePasswordConfirm.becomeFirstResponder()
//            }
//            return false
//        }
//        else if validBirthdate() == false {
//            iLikeyAlert(self, title: "", message: "Birth Date not valid.") {
//                self.theBirthDate.becomeFirstResponder()
//            }
//            return false
//        }
//            //     Commented because these are optional fields, but this code treats them as required
//            //        else if theBirthDate.text.isEmpty {
//            //            iLikeyAlert(self, "", "Birth Date is required") {
//            //                self.theBirthDate.becomeFirstResponder()
//            //            }
//            //            return false
//            //        }
//            //        else if theMaleButton.selected == false && theFemaleButton.selected == false {
//            //            iLikeyAlert(self, "", "Must select gender", nil)
//            //            return false
//            //        }
//        else if theAvatarImage.image == nil {
//            iLikeyAlert(self, title: "", message: "Must pick your avatar image.", completion: nil)
//            return false
//        }
//        else {
//            return true
//        }
        return true
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
    
}
