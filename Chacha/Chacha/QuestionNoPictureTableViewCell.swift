//
//  QuestionNoPictureTableViewCell.swift
//  Chacha
//
//  Created by Daniel Jones on 3/3/16.
//  Copyright © 2016 Chong500Productions. All rights reserved.
//

import UIKit

class QuestionNoPictureTableViewCell: UITableViewCell {
    
    @IBOutlet weak var fullNameText: UILabel!
    @IBOutlet weak var askedOrAnsweredText: UILabel!
    @IBOutlet weak var questionText: UILabel!
    @IBOutlet weak var answerTextField: UITextField!
    @IBOutlet weak var likeStackView: UIStackView!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var likeCount: UILabel!
    @IBOutlet weak var questionCount: UILabel!
    
    var passedLikeCount = 0
    var passedAnswerCount = 0
    
    var alreadyLiked = false
    
    var delegate: QuestionNoPictureTableViewCellDelegate?
    
    @IBAction func submit(sender: AnyObject) {
        passedAnswerCount += 1
        if let delegate = delegate {
             delegate.createAnswer(answerTextField.text!)
        }
    }
    
    @IBAction func likePressed(sender: AnyObject) {
        if alreadyLiked {
            passedLikeCount -= 1
        } else {
            passedLikeCount += 1
        }
        likeCount.text = "\(passedLikeCount)"
        if let delegate = delegate {
            delegate.updateLikeCount(likeCount.tag, alreadyLiked: alreadyLiked)
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
    
}
