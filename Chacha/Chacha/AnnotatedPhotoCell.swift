//
//  AnnotatedPhotoCell.swift
//  Chacha
//
//  Created by Daniel Jones on 3/1/16.
//  Copyright © 2016 Chong500Productions. All rights reserved.
//

import UIKit

class AnnotatedPhotoCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var imageViewHeightLayoutConstraint: NSLayoutConstraint!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var fullName: UILabel!
    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var questionText: UILabel!
    
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

