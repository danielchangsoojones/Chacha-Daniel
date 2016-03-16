//
//  ActivityTableViewCell.swift
//  Chacha
//
//  Created by Daniel Jones on 3/9/16.
//  Copyright © 2016 Chong500Productions. All rights reserved.
//

import UIKit

class ActivityTableViewCell: UITableViewCell {
    
    var alreadyLiked : Like?
    
    @IBOutlet weak var fullNameText: UILabel!
    @IBOutlet weak var profileImage: UIButton!
    @IBOutlet weak var askedOrUsernameText: UILabel!
    @IBOutlet weak var questionText: UILabel!
    @IBOutlet weak var timestampCount: UILabel!
    @IBOutlet weak var likeCountLabel: UILabel!
    @IBOutlet weak var likeButtonImage: UIButton!
    @IBOutlet weak var answerCountLabel: UILabel!
    
    var likeCount = 0
    var answerCount = 0
    
    var activityDelegate: ActivityTableViewCellDelegate?
    
    @IBAction func likeButtonPressed(sender: AnyObject) {
        activityDelegate?.updateLike(likeCountLabel.tag)
        if let _ = alreadyLiked {
            //delete like
            likeButtonImage.imageView!.image = UIImage(named: "vibe-off")
            alreadyLiked = nil
            likeCount -= 1
        } else {
            //create like
            likeButtonImage.imageView?.image = UIImage(named: "vibe-on")
            alreadyLiked = Like()
            likeCount += 1
        }
        likeCountLabel.text = "\(likeCount)"
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
