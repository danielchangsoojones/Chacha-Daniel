//
//  PersonalFeedViewController.swift
//  Chacha
//
//  Created by Daniel Jones on 3/3/16.
//  Copyright © 2016 Chong500Productions. All rights reserved.
//

import UIKit
import Parse
import EFTools

class PersonalFeedViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    var rowTapped : Int?
    
    var withPicture: Bool = false
    var questions = [Question]()
    var alreadyLikedDictionary: [String : Like] = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //for making cells grow and shrink with cell size content
        self.tableView.estimatedRowHeight = 80
        self.tableView.rowHeight = UITableViewAutomaticDimension
        
        createQuestionArray()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

//queries
extension PersonalFeedViewController {
    func createQuestionArray() {
        populateQuestionArray().findObjectsInBackgroundWithBlock({ (objects, error) -> Void in
            if let objects = objects as? [Question] {
                self.questions = objects
                self.tableView.reloadData()
                self.fillAlreadyLikedDictionary()
            }
        })
    }
    
    func fillAlreadyLikedDictionary() {
        let query = Like.query()
        query?.whereKey("createdBy", equalTo: User.currentUser()!)
        query?.findObjectsInBackgroundWithBlock({ (objects, error) -> Void in
            if error == nil {
                if let objects = objects as! [Like]? {
                    //sets the ones that actually have likes to true
                    for like in objects {
                        if let questionParentObjectId = like.questionParent!.objectId {
                         self.alreadyLikedDictionary.updateValue(like, forKey: questionParentObjectId)
                        }
                    }
                    self.tableView.reloadData()
                }
            }
        })
    }
    
    func createLike(questionParent: Question) {
        let like = Like()
        like.questionParent = questionParent
        like.createdBy = User.currentUser()
        like.saveInBackgroundWithBlock { (success, error) -> Void in
            questionParent.incrementLikeCount()
            self.alreadyLikedDictionary.updateValue(like, forKey: (like.questionParent?.objectId)!)
        }
    }
    
}

//tableView Delegate Methods
extension PersonalFeedViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return questions.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let currentRow = indexPath.row
        let currentQuestion = questions[currentRow]
        
        if let questionImage = currentQuestion.questionImage {
            let cell = self.tableView.dequeueReusableCellWithIdentifier("QuestionCellWithPicture")! as! QuestionWithPictureTableViewCell
            cell.questionImage.file = questionImage
            cell.questionImage.loadInBackground()
            cell.fullNameText.text = currentQuestion.createdBy?.fullName
            cell.questionText.text = currentQuestion.question
            return cell
        } else {
            let cell = self.tableView.dequeueReusableCellWithIdentifier("QuestionCellNoPicture")! as! QuestionNoPictureTableViewCell
            cell.fullNameText.text = currentQuestion.createdBy?.fullName
            cell.questionText.text = currentQuestion.question
            cell.passedLikeCount = currentQuestion.likeCount
            cell.passedAnswerCount = currentQuestion.answerCount
            cell.likeCount.tag = currentRow
            if let alreadyLiked = alreadyLikedDictionary[currentQuestion.objectId!] {
                cell.alreadyLiked = alreadyLiked
            }
            cell.delegate = self
            return cell
        }
        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        rowTapped = indexPath.row
        performSegueWithIdentifier(.answerPageSegue, sender: self)
    }
}

extension PersonalFeedViewController: QuestionNoPictureTableViewCellDelegate {
    func createAnswer(answer: String) {
        
    }
    
    func updateLike(likeCountTag: Int) {
        let currentQuestion = questions[likeCountTag]
        let currentLike = alreadyLikedDictionary[currentQuestion.objectId!]
        if let currentLike = currentLike {
            //delete the like
            currentLike.deleteInBackgroundWithBlock({ (success, error) -> Void in
                self.alreadyLikedDictionary.removeValueForKey(currentQuestion.objectId!)
                currentQuestion.decrementLikeCount()
            })
        } else {
            //create the like
            createLike(currentQuestion)
        }
    }
}

extension PersonalFeedViewController: SegueHandlerType {
    enum SegueIdentifier: String {
        // THESE CASES WILL ALL MATCH THE IDENTIFIERS YOU CREATED IN THE STORYBOARD
        case answerPageSegue
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        switch segueIdentifierForSegue(segue) {
        case .answerPageSegue:
            let destinationVC = segue.destinationViewController as! AnswerViewController
            if let rowTapped = rowTapped {
                let question = questions[rowTapped]
                destinationVC.question = question.question
                destinationVC.createdBy = question.createdBy
                destinationVC.questionObject = question
            }
        }
    }
}
