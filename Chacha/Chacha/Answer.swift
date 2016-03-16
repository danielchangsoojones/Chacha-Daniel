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
    
    init(likeCount: Int, answerCount: Int) {
        super.init()
        self.likeCount = 0
        self.answerCount = 0
    }
    
    func incrementLikeCount() {
        likeCount += 1
        self.saveInBackground()
    }
    
    func decrementLikeCount() {
        likeCount -= 1
        self.saveInBackground()
    }
    
    func incrementAnswerCount() {
        answerCount += 1
        self.saveInBackground()
    }
    
}