//
//  Like.swift
//  Chacha
//
//  Created by Daniel Jones on 3/7/16.
//  Copyright © 2016 Chong500Productions. All rights reserved.
//

import Foundation
import Parse

class Like: PFObject, PFSubclassing {
    class func parseClassName() -> String {
        return "Like"
    }
    
    @NSManaged var createdBy: User?
    @NSManaged var questionParent: Question?
    @NSManaged var answerParent: Answer?
    
    override init() {
        super.init()
    }
    
}

