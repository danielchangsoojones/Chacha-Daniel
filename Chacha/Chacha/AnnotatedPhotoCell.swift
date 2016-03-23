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
    
    var alreadyLiked : Like?
   
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
    
//    var photo: Photo? {
//        didSet {
//            if let photo = photo {
//                imageView.image = photo.image
//                profileImage.image = photo.profileImage
//                fullName.text = photo.fullName
//                username.text = photo.username
//                questionText.text = photo.question
//            }
//        }
//    }
    
    override func applyLayoutAttributes(layoutAttributes: UICollectionViewLayoutAttributes) {
        super.applyLayoutAttributes(layoutAttributes)
        let attributes = layoutAttributes as! ExploreLayoutAttributes
        imageViewHeightLayoutConstraint.constant = attributes.photoHeight
    }
    
}

