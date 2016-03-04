//
//  QuestionWithPictureTableViewCell.swift
//  Chacha
//
//  Created by Daniel Jones on 3/4/16.
//  Copyright © 2016 Chong500Productions. All rights reserved.
//

import UIKit

class QuestionWithPictureTableViewCell: UITableViewCell {
    
    @IBOutlet weak var fullName: UILabel!
    @IBOutlet weak var askedOrAnswerText: UILabel!
    @IBOutlet weak var questionText: UILabel!
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
