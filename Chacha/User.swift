//
//  User.swift
//  Chacha
//
//  Created by Daniel Jones on 2/28/16.
//  Copyright © 2016 Chong500Productions. All rights reserved.
//

import UIKit
import Parse
import CoreLocation

class User: PFUser {
    
    //MARK- NSManaged properies
    @NSManaged var fullName: String
    @NSManaged var lowercaseFullName: String?
    @NSManaged var lowercaseUsername: String?
    @NSManaged var birthDate: NSDate?
    @NSManaged var avatarImage: PFFile?
    @NSManaged var info: String?
    @NSManaged var website: String?
    @NSManaged var userDescription: String?
    @NSManaged var phone: String?
    @NSManaged var gender: String?
    @NSManaged var blockedUsers: [String]?
    
    @NSManaged private var emailVerified: Bool
    var isEmailVerified: Bool {
        return objectForKey("emailVerified") as? Bool ?? false
    }
    
    @NSManaged private var privatePosts: Bool
    var isPrivatePosts : Bool {
        get { return self["privatePosts"] as? Bool ?? false }
        set { self["privatePosts"] = newValue }
    }
    
    @NSManaged private var socialLogin: NSNumber?
    var isSocialLogin : Bool {
        get {
            if self.dataAvailable == false {
                return false
            }
            return self["socialLogin"] as? Bool ?? false
        }
        set { self["socialLogin"] = newValue }
    }
    
    
}

