//
//  NotificationTableViewCell.swift
//  Chacha
//
//  Created by Daniel Jones on 3/28/16.
//  Copyright © 2016 Chong500Productions. All rights reserved.
//

import UIKit

class NotificationTableViewCell: UITableViewCell {
    
    @IBOutlet weak var theFullName: UILabel!
    @IBOutlet weak var theProfileImage: UIButton!
    @IBOutlet weak var theNotificationDescription: UILabel!
    
    var notification: Notification? {
        didSet {
            theFullName.text = notification?.sender?.fullName
            
                
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
