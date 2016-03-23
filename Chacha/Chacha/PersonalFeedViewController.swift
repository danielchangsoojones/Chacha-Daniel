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
    var likeIsSaving = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //for making cells grow and shrink with cell size content
        self.tableView.estimatedRowHeight = 278
        self.tableView.rowHeight = UITableViewAutomaticDimension
        
        tableView.registerNib(UINib(nibName: "QuestionCell", bundle: nil), forCellReuseIdentifier: "questionCell")
        
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
                        if let parentObjectId = like.postParent!.objectId {
                         self.alreadyLikedDictionary.updateValue(like, forKey: parentObjectId)
                        }
                    }
                    self.tableView.reloadData()
                }
            }
        })
    }
    
    func createLike(postParent: PFObject) {
        let like = likeHelper(postParent)
        likeIsSaving = true
        like.saveInBackgroundWithBlock { (success, error) -> Void in
            self.likeIsSaving = false
            if error == nil {
                if let questionParent = postParent as? Question {
                    // post is a question
                    questionParent.incrementLikeCount()
                }
                else if let answerParent = postParent as? Answer {
                    // post is an answer
                    answerParent.incrementLikeCount()
                }
                self.alreadyLikedDictionary.updateValue(like, forKey: (postParent.objectId)!)
            } else {
                print(error)
            }
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
        
        let cell = self.tableView.dequeueReusableCellWithIdentifier("questionCell")! as! ActivityTableViewCell
           // cell.fullNameText.text = currentQuestion.createdBy?.fullName
           cell.questionText.text = currentQuestion.question
//            if let questionImage = currentQuestion.questionImage {
//                cell.questionImageHidden = false
//                cell.questionImage.file = questionImage
//                cell.questionImage.loadInBackground()
//            }
//            cell.likeButtonImage.imageView!.image = UIImage(named: "vibe-off")
//            if let alreadyLiked = alreadyLikedDictionary[currentQuestion.objectId!] {
//                cell.alreadyLiked = alreadyLiked
//                cell.likeButtonImage.imageView!.image = UIImage(named: "vibe-on")
//            }
//            cell.likeCountLabel.tag = currentRow
//            cell.likeCount = currentQuestion.likeCount
//            cell.likeCountLabel.text = "\(currentQuestion.likeCount)"
//            cell.activityDelegate = self
//            cell.questionDelegate = self
            return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        rowTapped = indexPath.row
        performSegueWithIdentifier(.answerPageSegue, sender: self)
    }
    
}

extension PersonalFeedViewController: ActivityTableViewCellDelegate {
    func updateLike(likeCountTag: Int, isQuestion: Bool) {
        if isQuestion {
            let currentQuestion = questions[likeCountTag]
            if let currentLike = alreadyLikedDictionary[currentQuestion.objectId!] {
                //delete the like
                currentLike.deleteInBackgroundWithBlock({ (success, error) -> Void in
                    if success && error == nil {
                        self.alreadyLikedDictionary.removeValueForKey(currentQuestion.objectId!)
                        currentQuestion.decrementLikeCount()
                    }
                })
            } else {
                //create the like
                if !likeIsSaving {
                    //not currently saving any likes
                    createLike(currentQuestion)
                }
            }
        }
    }
}

extension PersonalFeedViewController: QuestionTableViewCellDelegate {
    func createAnswer(answer: String) {
        
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
