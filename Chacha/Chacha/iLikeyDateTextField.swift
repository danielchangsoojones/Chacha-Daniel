//
//  iLikeyDateTextField.swift
//  Chacha
//
//  Created by Daniel Jones on 2/28/16.
//  Copyright © 2016 Chong500Productions. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable class iLikeyDateTextField: UITextField
{
    override func canPerformAction(action: Selector, withSender sender: AnyObject?) -> Bool {
        if action == "paste:" {
            return false
        }
        return super.canPerformAction(action, withSender:sender)
    }
}

