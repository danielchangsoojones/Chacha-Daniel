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
    
    var alreadyLiked : Like?
    
    var delegate: QuestionNoPictureTableViewCellDelegate?
    
    @IBAction func submit(sender: AnyObject) {
        if let delegate = delegate {
             delegate.createAnswer(answerTextField.text!)
        }
    }
    
    @IBAction func likePressed(sender: AnyObject) {
        delegate?.updateLike(likeCount.tag)
        if let _ = alreadyLiked {
            //delete like
            likeButton.imageView!.image = UIImage(named: "vibe-off")
            alreadyLiked = nil
            passedLikeCount -= 1
        } else {
            //create like
            likeButton.imageView!.image = UIImage(named: "vibe-on")
            alreadyLiked = Like()
            passedLikeCount += 1
        }
        likeCount.text = "\(passedLikeCount)"
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
