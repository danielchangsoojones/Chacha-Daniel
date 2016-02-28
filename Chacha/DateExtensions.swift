//
//  DateExtensions.swift
//  Chacha
//
//  Created by Daniel Jones on 2/28/16.
//  Copyright © 2016 Chong500Productions. All rights reserved.
//

import Foundation

extension NSDate {
    
    func toShortDate() -> String
    {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat =  "MM/dd/yyyy"
        let dateString = dateFormatter.stringFromDate(self)
        return dateString
    }
    
}
