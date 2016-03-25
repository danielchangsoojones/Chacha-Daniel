//
//  QuestionTableViewCell.swift
//  Chacha
//
//  Created by Daniel Jones on 3/9/16.
//  Copyright © 2016 Chong500Productions. All rights reserved.
//

import UIKit
import Parse
import ParseUI

class QuestionTableViewCell: ActivityTableViewCell {

    @IBOutlet weak var questionImage: PFImageView!
    @IBOutlet weak var answerTextField: UITextField!
    
    var questionImageHidden = true
    var submitButtonHidden = false
    
    var question: Question? {
        didSet {
            if let question = question {
                fullNameText.text = question.createdBy?.fullName
                questionText.text = question.question
                if let questionImage = question.questionImage {
                    self.questionImage.file = questionImage
                    self.questionImage.loadInBackground()
                }
                likeCount = question.likeCount
                likeCountLabel.text = "\(question.likeCount)"
                isQuestion = true
                answerCount = question.answerCount
                answerCountLabel.text =  "\(answerCount)"
                let timeStamp = NSDate().hoursFrom(question.createdAt!)
                timestampCount.text = "\(timeStamp)h"
            }
        }
    }
    
    var questionDelegate : QuestionTableViewCellDelegate?
    
    @IBAction func submitAnswer(sender: AnyObject) {
        if let delegate = questionDelegate {
            delegate.createAnswer(answerTextField.text!, questionObject: question!)
        }
        answerCount += 1
        answerCountLabel.text =  "\(answerCount)"
        question?.answerCount = answerCount
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
