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

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
