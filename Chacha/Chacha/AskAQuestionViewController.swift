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
    @IBOutlet weak var questionDescriptionTextBox: UITextView!
    @IBOutlet weak var questionImage: UIImageView!
    
    let descriptionPlaceHolderText = "Optional Description..."
    let questionPlaceHolderText = "Ask Your Question..."
    
    @IBAction func addQuestionImage(sender: AnyObject) {
        let imgPicker = UIImagePickerController()
        imgPicker.delegate = self
        imgPicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary;
        imgPicker.allowsEditing = true
        self.presentViewController(imgPicker, animated: true, completion: nil)
    }
    
    //Backend Swap
    @IBAction func askQuestion(sender: AnyObject) {
        let newQuestion = Question()
        newQuestion.question = questionTextBox.text
        newQuestion.questionDescription = questionDescriptionTextBox.text
        if let image = questionImage.image {
            let file = PFFile(name: "questionImage.jpg",data: UIImageJPEGRepresentation(image, 0.6)!)
            newQuestion.questionImage = file
        }
        newQuestion.saveInBackgroundWithBlock { (success, error) -> Void in
            let _ = Alert(title: "Question Asked!", subtitle: "Your question is now being answered by the Chacha Universe", closeButtonTitle: "Awesome!", type: .Success)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        questionDescriptionTextBox.delegate = self
        questionTextBox.delegate = self
        
        questionTextBox.textColor = UIColor.lightGrayColor()
        questionDescriptionTextBox.textColor = UIColor.lightGrayColor()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}

extension AskAQuestionViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage!, editingInfo: [NSObject : AnyObject]!)
    {
        if image != nil {
            let img = image.resizeImage(CGSize(width:256,height:256))
            self.questionImage.image = img
        }
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}

extension AskAQuestionViewController: UITextViewDelegate {
    func textViewDidBeginEditing(textView: UITextView) {
       editingBeginsTextView(textView)
    }
    
    func textViewDidEndEditing(textView: UITextView) {
        if textView == questionDescriptionTextBox {
            editingEndedTextView(textView, placeHolderText: descriptionPlaceHolderText)
        } else if textView == questionTextBox {
            editingEndedTextView(textView, placeHolderText: questionPlaceHolderText)
        }
        
    }
}
