//
//  AnswerNoPictureTableViewCell.swift
//  Chacha
//
//  Created by Daniel Jones on 3/7/16.
//  Copyright © 2016 Chong500Productions. All rights reserved.
//

import UIKit

class AnswerNoPictureTableViewCell: UITableViewCell {
    
    @IBOutlet weak var fullNameText: UILabel!
    @IBOutlet weak var usernameText: UILabel!
    @IBOutlet weak var answerText: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
