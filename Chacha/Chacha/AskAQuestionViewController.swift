//
//  AskAQuestionViewController.swift
//  Chacha
//
//  Created by Daniel Jones on 3/2/16.
//  Copyright © 2016 Chong500Productions. All rights reserved.
//

import UIKit
import Parse

class AskAQuestionViewController: UIViewController {
    
    @IBOutlet weak var questionTextBox: UITextView!
    @IBOutlet weak var bottomComposeBarConstraint: NSLayoutConstraint!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    @IBOutlet weak var composeBarView: UIView!
    @IBOutlet weak var cameraButton: UIButton!
    @IBOutlet weak var anonymousButton: UIButton!
    
    let descriptionPlaceHolderText = "Optional Description..."
    let questionPlaceHolderText = "Ask Your Question..."
    
    var anonymousQuestion = false
    
    @IBAction func anonymousPressed(sender: AnyObject) {
        anonymousQuestion = !anonymousQuestion
        if anonymousQuestion {
            self.title = "Anonymous"
            anonymousButton.setImage(UIImage(named: "Anonymous-Clicked"), forState: .Normal)
        } else {
            self.title = "Ask a Question"
            anonymousButton.setImage(UIImage(named: "Anonymous-Unclicked"), forState: .Normal)
        }
    }
    
    @IBAction func addQuestionImage(sender: AnyObject) {
        setImagePickerDelegate()
    }
    
    @IBAction func cancel(sender: AnyObject) {
        resetUI()
    }
    
    //Backend Swap
    @IBAction func askQuestion(sender: AnyObject) {
        let newQuestion = Question(likeCount: 0, answerCount: 0)
        newQuestion.question = questionTextBox.text
        //newQuestion.questionDescription = questionDescriptionTextBox.text
        if let image = cameraButton.imageView!.image {
            let file = PFFile(name: "questionImage.jpg",data: UIImageJPEGRepresentation(image, 0.6)!)
            newQuestion.questionImage = file
            newQuestion.questionImageHeight = image.size.height
            newQuestion.questionImageWidth = image.size.width
        }
        newQuestion.createdBy = User.currentUser()
        if anonymousQuestion {
            newQuestion.anonymous = true
        }
        spinner.hidden = false
        spinner.startAnimating()
        newQuestion.saveInBackgroundWithBlock { (success, error) -> Void in
            self.spinner.stopAnimating()
            self.resetUI()
            let _ = Alert(title: "Question Asked!", subtitle: "Your question is now being answered by the Chacha Universe", closeButtonTitle: "Awesome!", type: .Success)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //questionDescriptionTextBox.delegate = self
        questionTextBox.delegate = self
        
        questionTextBox.textColor = UIColor.lightGrayColor()
        //questionDescriptionTextBox.textColor = UIColor.lightGrayColor()
        composeBarView.layer.borderWidth = 0.5
        composeBarView.layer.borderColor = UIColor.lightGrayColor().CGColor
        cameraButton.imageView!.contentMode = UIViewContentMode.ScaleAspectFit
        anonymousButton.imageView!.contentMode = UIViewContentMode.ScaleAspectFit
        
        // Keyboard notifications
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillShow:"), name:UIKeyboardWillShowNotification, object: nil);
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillHide:"), name:UIKeyboardWillHideNotification, object: nil);
        
        //questionTextBox.becomeFirstResponder()
        
    }
    
    override func viewWillAppear(animated: Bool) {
        questionTextBox.becomeFirstResponder()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func resetUI() {
        self.questionTextBox.resignFirstResponder()
        cameraButton.setImage(UIImage(named: "camera"), forState: .Normal)
        cameraButton.imageView!.contentMode = UIViewContentMode.ScaleAspectFit
        self.questionTextBox.text = "Ask a question..."
        questionTextBox.textColor = UIColor.lightGrayColor()
        anonymousButton.setImage(UIImage(named: "Anonymous-Unclicked"), forState: .Normal)
        self.title = "Ask a Question"
        anonymousQuestion = false
    }

}

//keyboard notification
extension AskAQuestionViewController {
    func keyboardWillShow(notification: NSNotification) {
        guard let bottomConstraint = bottomComposeBarConstraint else { return }
        if let userInfo = notification.userInfo {
            if let keyboardSize = (userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.CGRectValue() {
                //tab bar height is default by Apple at 49
                let tabBarHeight = CGFloat(49)
                bottomConstraint.constant = keyboardSize.height - tabBarHeight
                UIView.animateWithDuration(0.3, animations: { () -> Void in
                    self.view.layoutIfNeeded()
                })
            }
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        guard let bottomConstraint = bottomComposeBarConstraint else { return }
        bottomConstraint.constant = 0
        self.view.layoutIfNeeded()
        UIView.animateWithDuration(0.3, animations: { () -> Void in
            self.view.layoutIfNeeded()
        })
    }
}

extension AskAQuestionViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func setImagePickerDelegate() {
        let imgPicker = UIImagePickerController()
        imgPicker.delegate = self
        imgPicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary;
        imgPicker.allowsEditing = true
        self.presentViewController(imgPicker, animated: true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage!, editingInfo: [NSObject : AnyObject]!)
    {
        if image != nil {
            cameraButton.imageView!.contentMode = UIViewContentMode.ScaleAspectFill
            cameraButton.imageView?.clipsToBounds = true
            let img = image.resizeImage(CGSize(width:23,height:23))
            self.cameraButton.setImage(img, forState: .Normal)
        }
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}

extension AskAQuestionViewController: UITextViewDelegate {
    func textViewDidBeginEditing(textView: UITextView) {
       editingBeginsTextView(textView)
    }
    
    func textViewDidEndEditing(textView: UITextView) {
//        if textView == questionDescriptionTextBox {
//            editingEndedTextView(textView, placeHolderText: descriptionPlaceHolderText)
//        } else if textView == questionTextBox {
            editingEndedTextView(textView, placeHolderText: questionPlaceHolderText)
        //}
        
    }
}
