//
//  Post.swift
//  Chacha
//
//  Created by Daniel Jones on 3/2/16.
//  Copyright © 2016 Chong500Productions. All rights reserved.
//

import Foundation
import Parse

class Post: PFObject, PFSubclassing {
    class func parseClassName() -> String {
        return "Post"
    }
    
    @NSManaged var createdBy: User?
    @NSManaged var postImage: PFFile?
    @NSManaged var answerCount: Int
    @NSManaged var likeCount: Int
    @NSManaged var question: String
    @NSManaged var optionalQuestionDescription: String
    
    override init() {
        super.init()
    }
    
    func updateLikeCount() {
        likeCount += 1
        self.saveInBackground()
    }
    
    func updateAnswerCount() {
        answerCount += 1
        self.saveInBackground()
    }
    
}