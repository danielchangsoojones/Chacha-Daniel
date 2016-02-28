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
    
    
    //MARK: - properies
    
//    private var followeeQuery = Follow.query()!
//    private var _cachedFollowees:[Follow]? = []
//    var cachedFollowees: [Follow]? {
//        get {
//            return _cachedFollowees
//        }
//    }
    
    
    //MARK: - PFSubclassing methods
    
    override class func currentUser() -> User? {
        let user = PFUser.currentUser() as! User?
        return user
    }
    
    
    //MARK: - methods
    
    func displayName() -> String {
        return self.username ?? ""
    }
    
//    func isFollowingUser(user:User, completion:((Bool) -> Void)) -> Void {
//        if (User.currentUser() === self && cachedFollowees != nil) {
//            let follow = cachedFollowees?.filter{ $0.followee.objectId == user.objectId}.first
//            let isfollowing = (follow != nil) ? true : false
//            completion(isfollowing)
//        }
//        else {
//            let follow = PFQuery(className: Follow.parseClassName())
//            follow.whereKey("followee", equalTo:user)
//            follow.whereKey("follower", equalTo:self)
//            follow.findObjectsInBackgroundWithBlock { (objects,  error) -> Void in
//                if let objects = objects where objects.count > 0 {
//                    completion(true)
//                }
//                else {
//                    completion(false)
//                }
//            }
//        }
//    }
//    
//    //TODO: need to add paging
//    func getFollowers(completion:((success:Bool, users:[User]?) -> Void)) -> Void {
//        let getPosts = PFQuery(className: "Follow")
//        getPosts.orderByDescending("createdAt")
//        getPosts.whereKey("followee", equalTo:self)
//        getPosts.limit = 1000
//        getPosts.findObjectsInBackgroundWithBlock { (objects,  error) -> Void in
//            if error == nil {
//                if let follows = objects as? [Follow] {
//                    var users:[User] = [User]()
//                    for var i = 0; i < follows.count; ++i {
//                        if users.contains((follows[i] as Follow).follower) == false {
//                            users.append(follows[i].follower)
//                        }
//                    }
//                    completion(success: true, users: users)
//                }
//                else {
//                    print("Error No Followers")
//                    completion(success: false, users: nil)
//                }
//            }
//            else {
//                print("Error: \(error) \(error!.userInfo)")
//                completion(success: false, users: nil)
//            }
//        }
//    }
//    
//    //TODO: need to add paging
//    func getFollowing(completion:((success:Bool, users:[User]?) -> Void)) -> Void {
//        let getPosts = PFQuery(className: "Follow")
//        getPosts.orderByDescending("createdAt")
//        getPosts.whereKey("follower", equalTo:self)
//        getPosts.limit = 1000
//        getPosts.findObjectsInBackgroundWithBlock { (objects,  error) -> Void in
//            if error == nil {
//                if let follows = objects as? [Follow] {
//                    var users:[User] = [User]()
//                    for var i = 0; i < follows.count; ++i {
//                        if users.contains((follows[i] as Follow).followee) == false {
//                            users.append(follows[i].followee)
//                        }
//                    }
//                    completion(success: true, users: users)
//                }
//                else {
//                    print("Error No Followers")
//                    completion(success: false, users: nil)
//                }
//            }
//            else {
//                print("Error: \(error) \(error!.userInfo)")
//                completion(success: false, users: nil)
//            }
//        }
//    }
//    
//    func getGeoLocation(completion:((location:PFGeoPoint?) -> Void))  {
//        if iLikeyLocationManager.shared.isAccessAllowed() == true {
//            PFGeoPoint.geoPointForCurrentLocationInBackground {
//                (geoPoint: PFGeoPoint?, error: NSError?) -> Void in
//                completion(location: geoPoint)
//            }
//        }
//        else {
//            completion(location: PFGeoPoint())
//        }
//    }
//    
//    func updateCachedFollowees(completion:(() -> Void)?) -> Void {
//        if let user = User.currentUser() {
//            followeeQuery.cancel()
//            followeeQuery.whereKey("follower", equalTo: user)
//            followeeQuery.includeKey("followee")
//            followeeQuery.limit = 1000 //TODO: What if user has more than 1000 followees?
//            followeeQuery.cancel()
//            followeeQuery.findObjectsInBackgroundWithBlock({ (objects, error) -> Void in
//                if error == nil {
//                    self._cachedFollowees?.removeAll()
//                    let objects = objects as! [Follow]
//                    for object in objects {
//                        self._cachedFollowees?.append(object)
//                    }
//                }
//                completion?()
//            })
//        }
//    }
    
}

