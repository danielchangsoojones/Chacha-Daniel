//
//  Notification.swift
//  Chacha
//
//  Created by Daniel Jones on 3/28/16.
//  Copyright © 2016 Chong500Productions. All rights reserved.
//

import Parse

class Notification: PFObject, PFSubclassing {
    class func parseClassName() -> String {
        return "Notification"
    }
    
    @NSManaged var reciever : User?
    @NSManaged var sender : User?
    @NSManaged var read : Bool
    @NSManaged var notificationImage : PFFile?
    @NSManaged var like: Like?
    @NSManaged var question: Question?
    @NSManaged var answer: Answer?
    @NSManaged var userConnection: UserConnection?
    
    override init() {
        super.init()
    }
    
}
