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
    @IBOutlet weak var questionImageHeight: NSLayoutConstraint!
    @IBOutlet weak var answerTextField: UITextField!
    @IBOutlet weak var submitButtonHeight: NSLayoutConstraint!
    
    var questionImageHidden = true
    var submitButtonHidden = false
    
    var questionDelegate : QuestionTableViewCellDelegate?
    
    @IBAction func submitAnswer(sender: AnyObject) {
        if let delegate = questionDelegate {
            delegate.createAnswer(answerTextField.text!)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func layoutSubviews() {
        if questionImageHidden {
            questionImageHeight.constant = 0
        }
        if submitButtonHidden {
            submitButtonHeight.constant = 0
        }
    }

}
