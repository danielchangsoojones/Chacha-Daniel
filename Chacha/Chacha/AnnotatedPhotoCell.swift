//
//  AnnotatedPhotoCell.swift
//  Chacha
//
//  Created by Daniel Jones on 3/1/16.
//  Copyright © 2016 Chong500Productions. All rights reserved.
//

import UIKit
import ParseUI

class AnnotatedPhotoCell: UICollectionViewCell {
   
    @IBOutlet weak var imageView: PFImageView!
    @IBOutlet weak var imageViewHeightLayoutConstraint: NSLayoutConstraint!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var fullName: UILabel!
    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var questionText: UILabel!
    @IBOutlet weak var likeImage: UIButton!
    @IBOutlet weak var likeCountLabel: UILabel!
    @IBOutlet weak var answerCountLabel: UILabel!
    @IBOutlet weak var timeStampLabel: UILabel!
    
    var likeCount = 0
    var answerCount = 0
    
    var activityDelegate: ActivityTableViewCellDelegate?
    
    var alreadyLiked : Like?
    var currentQuestion: Question? {
        didSet {
            if let currentQuestion = currentQuestion {
                fullName.text = currentQuestion.createdBy?.fullName
                questionText.text = currentQuestion.question
                if let questionImage = currentQuestion.questionImage {
                    imageView.file = questionImage
                    imageView.loadInBackground()
                }
                likeCount = currentQuestion.likeCount
                likeCountLabel.text = "\(currentQuestion.likeCount)"
            }
        }
    }
    
    @IBAction func likeButtonPressed(sender: AnyObject) {
        activityDelegate?.updateLike(likeCountLabel.tag, isQuestion: true)
        if let _ = alreadyLiked {
            //delete like
            likeImage.imageView!.image = UIImage(named: "vibe-off")
            alreadyLiked = nil
            likeCount -= 1
        } else {
            //create like
            likeImage.imageView?.image = UIImage(named: "vibe-on")
            alreadyLiked = Like()
            likeCount += 1
        }
        likeCountLabel.text = "\(likeCount)"
    }
    
    
    override func applyLayoutAttributes(layoutAttributes: UICollectionViewLayoutAttributes) {
        super.applyLayoutAttributes(layoutAttributes)
        let attributes = layoutAttributes as! ExploreLayoutAttributes
        imageViewHeightLayoutConstraint.constant = attributes.photoHeight
    }
    
}

