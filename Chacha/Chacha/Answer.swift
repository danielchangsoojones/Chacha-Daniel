//
//  Answer.swift
//  Chacha
//
//  Created by Daniel Jones on 3/7/16.
//  Copyright © 2016 Chong500Productions. All rights reserved.
//

import Foundation
import Parse

class Answer: PFObject, PFSubclassing {
    class func parseClassName() -> String {
        return "Answer"
    }
    
    @NSManaged var createdBy: User?
    @NSManaged var questionImage: PFFile?
    @NSManaged var answerCount: Int
    @NSManaged var likeCount: Int
    @NSManaged var answer: String
    @NSManaged var questionParent: Question?
    
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