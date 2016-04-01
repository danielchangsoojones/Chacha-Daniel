//
//  Globals.swift
//  Chacha
//
//  Created by Daniel Jones on 2/24/16.
//  Copyright © 2016 Chong500Productions. All rights reserved.
//

import Foundation
import UIKit
import Parse

//Custom colors
let ChachaTeal = UIColor(rgba: "#48AFA8")
let ChachaGrayBackground = UIColor(rgba: "#E6E6E6")
let ChachaGray = UIColor(rgba: "EBEBEB")
let iLikeyPink =  UIColor(rgba: "#E91E63")
let iLikeyPinkLight = UIColor(rgba: "#FA6FEB")
let iLikeyPinkDark =  UIColor(rgba: "#cc0066")
let iLikeyBlue =  UIColor(rgba: "#4e92e0")
let iLikeyGrayBorders =  UIColor(rgba: "#8c8c8c")
let iLikeyGrayControls =  UIColor(rgba: "#757575")
let iLikeyGrayBackground =  UIColor(rgba: "#ebebeb")
let iLikeyGrayMercury =  UIColor(rgba: "#F8F8F8")
let iLikeyGrayMedium =  UIColor(rgba: "#4A4A4A")
let iLikeyGrayDark =  UIColor(rgba: "#cdcdcd")
let iLikeyWhite =  UIColor(rgba: "#ffffff")
let iLikeyFacebookBlue = UIColor(rgba: "#5e9de6")
let iLikeyTwitterBlue = UIColor(rgba: "#4a90e0")
let iLikeyClearColor = UIColor(rgba: "#000000")

//UI effects
func applyShadow(view:UIView) {
    view.layer.shadowRadius = 2.5
    view.layer.shadowOffset = CGSizeMake(0, 1)
    view.layer.shadowColor = UIColor(rgba: "#555").CGColor
    view.layer.shadowOpacity = 2.0
}

func applyBorder(view:UIView) {
    view.layer.borderColor = UIColor(rgba: "#BBB").CGColor
    view.layer.borderWidth = 0.5
}

//Text View methods
func editingBeginsTextView(textView: UITextView) {
    if textView.textColor == UIColor.lightGrayColor() {
        textView.text = nil
        textView.textColor = UIColor.blackColor()
    }
}

func editingEndedTextView(textView: UITextView, placeHolderText: String) {
    if textView.text.isEmpty {
        textView.text = placeHolderText
        textView.textColor = UIColor.lightGrayColor()
    }
}

func resetTextView(textView: UITextView, placeHolderText: String) {
    textView.text = placeHolderText
    textView.textColor = UIColor.lightGrayColor()
}

//queries
func populateQuestionArray() -> PFQuery {
    let query = Question.query()
    query?.orderByDescending("createdAt")
    query?.includeKey("createdBy")
    query?.includeKey("createdAt")
    return query!
}

func likeHelper(postParent: PFObject) -> Like {
    let like = Like()
    if let questionParent = postParent as? Question {
        like.questionParent = questionParent
    } else if let answerParent = postParent as? Answer {
        like.answerParent = answerParent
    }
    like.createdBy = User.currentUser()
    return like
}

func populateAnswerArray() -> PFQuery {
    let query = Answer.query()
    query?.orderByDescending("createdAt")
    query?.includeKey("createdBy")
    query?.includeKey("createdAt")
    return query!
}

func createUserConnection(leader: User) -> UserConnection {
    let userConnection = UserConnection(isRequesting: true)
    userConnection.follower = User.currentUser()
    userConnection.leader = leader
    return userConnection
}

func createNewAnswer(answer: String, questionObject: Question) -> Answer {
    let newAnswer = Answer(likeCount: 0, answerCount: 0)
    newAnswer.answer = answer
    newAnswer.createdBy = User.currentUser()
    newAnswer.questionParent = questionObject
    return newAnswer
}

extension NSDate {
    func yearsFrom(date:NSDate) -> Int{
        return NSCalendar.currentCalendar().components(.Year, fromDate: date, toDate: self, options: []).year
    }
    func monthsFrom(date:NSDate) -> Int{
        return NSCalendar.currentCalendar().components(.Month, fromDate: date, toDate: self, options: []).month
    }
    func weeksFrom(date:NSDate) -> Int{
        return NSCalendar.currentCalendar().components(.WeekOfYear, fromDate: date, toDate: self, options: []).weekOfYear
    }
    func daysFrom(date:NSDate) -> Int{
        return NSCalendar.currentCalendar().components(.Day, fromDate: date, toDate: self, options: []).day
    }
    func hoursFrom(date:NSDate) -> Int{
        return NSCalendar.currentCalendar().components(.Hour, fromDate: date, toDate: self, options: []).hour
    }
    func minutesFrom(date:NSDate) -> Int{
        return NSCalendar.currentCalendar().components(.Minute, fromDate: date, toDate: self, options: []).minute
    }
}


