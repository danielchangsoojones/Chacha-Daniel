//
//  UserConnection.swift
//  Chacha
//
//  Created by Daniel Jones on 3/23/16.
//  Copyright © 2016 Chong500Productions. All rights reserved.
//

import Foundation
import Parse

class UserConnection: PFObject, PFSubclassing {
    class func parseClassName() -> String {
        return "UserConnection"
    }
    
    @NSManaged var follower: User?
    //the person who is getting followed
    @NSManaged var leader: User?
    @NSManaged var isRequesting: Bool
    
    override init() {
        super.init()
    }
    
    init(isRequesting: Bool) {
        super.init()
        self.isRequesting = true
    }
    
}