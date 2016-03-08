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
    var alreadyLikedDictionary: [Question : Bool] = [:]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //for making cells grow and shrink with cell size content
        self.tableView.estimatedRowHeight = 80
        self.tableView.rowHeight = UITableViewAutomaticDimension
        
        createQuestionArray()
        //         populateQuestionArray(withPicture, questionArray: questions, tableView: tableView)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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

//queries
extension PersonalFeedViewController {
    func createQuestionArray() {
        populateQuestionArray().findObjectsInBackgroundWithBlock({ (objects, error) -> Void in
            if let objects = objects as? [Question] {
                self.questions = objects
                self.tableView.reloadData()
            }
        })
    }
    
    func likedAlready() {
        let query = Like.query()
        query?.whereKey("questionParent", containedIn: questions)
        query?.findObjectsInBackgroundWithBlock({ (objects, error) -> Void in
            if let objects = objects as! [Like]? {
                for like in objects {
                    print(like)
                   self.alreadyLikedDictionary[like.questionParent!] = true
                }
                self.tableView.reloadData()
            }
        })
    }
    
    func createLike(questionParent : Question) {
        let like = Like()
        like.questionParent = questionParent
        like.createdBy = User.currentUser()
        like.saveInBackground()
    }
    
    func deleteLike(questionParent : Question) {
        let query = Like.query()
        query?.whereKey("questionParent", equalTo: questionParent)
        query?.whereKey("createdBy", equalTo: User.currentUser()!)
        query?.findObjectsInBackgroundWithBlock({ (objects, error) -> Void in
            if error == nil {
                if let objects = objects as! [Like]? {
                    for like in objects {
                        like.deleteInBackground()
                    }
                }
            }
        })
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
            cell.alreadyLiked = alreadyLikedDictionary[currentQuestion]!
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
    
    func updateLikeCount(row: Int, alreadyLiked: Bool) {
        if alreadyLiked {
            questions[row].decrementLikeCount()
            deleteLike(questions[row])
        } else {
            questions[row].incrementLikeCount()
            createLike(questions[row])
        }
    }
    
    func updateAnswerCount() {
        
    }
}

extension PersonalFeedViewController: SegueHandlerType {
    enum SegueIdentifier: String {
        // THESE CASES WILL ALL MATCH THE IDENTIFIERS YOU CREATED IN THE STORYBOARD
        case answerPageSegue
    }
}
