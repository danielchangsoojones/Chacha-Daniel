//
//  QuestionWithPictureTableViewCell.swift
//  Chacha
//
//  Created by Daniel Jones on 3/4/16.
//  Copyright © 2016 Chong500Productions. All rights reserved.
//

import UIKit
import Parse

class QuestionWithPictureTableViewCell: QuestionNoPictureTableViewCell {
    
    @IBOutlet weak var questionImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
