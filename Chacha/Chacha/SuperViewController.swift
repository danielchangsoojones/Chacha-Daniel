//
//  SuperViewController.swift
//  Chacha
//
//  Created by Daniel Jones on 3/23/16.
//  Copyright © 2016 Chong500Productions. All rights reserved.
//

import UIKit
import Parse
import EFTools

class SuperViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var withPicture: Bool = false
    var alreadyLikedDictionary: [String : Like] = [:]
    var likeIsSaving = false
    let currentUser = User.currentUser()
    
     var rowTapped : Int?
    
    var questions = [Question]()
    var answers = [Answer]()
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        //for making cells grow and shrink with cell size content
        self.tableView.rowHeight = UITableViewAutomaticDimension
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

//queries
extension SuperViewController {
    func fillAlreadyLikedDictionary() {
        let query = Like.query()
        query?.whereKey("createdBy", equalTo: currentUser!)
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

protocol ActivityTableViewCellDelegate {
    func updateLike(likeCountTag: Int, isQuestion: Bool)
    func segueToProfile(row: Int)
}

extension SuperViewController: ActivityTableViewCellDelegate {
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
    
    func segueToProfile(row: Int) {
        rowTapped = row
        performSegueWithIdentifier(.profileSegue, sender: self)
    }
}

extension SuperViewController: QuestionTableViewCellDelegate {
    func createAnswer(answer: String) {
        
    }
}

extension SuperViewController: SegueHandlerType {
    enum SegueIdentifier: String {
        // THESE CASES WILL ALL MATCH THE IDENTIFIERS YOU CREATED IN THE STORYBOARD
        case answerPageSegue
        case profileSegue
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let question = questions[rowTapped!]
        switch segueIdentifierForSegue(segue) {
        case .answerPageSegue:
            let destinationVC = segue.destinationViewController as! AnswerViewController
                destinationVC.question = question.question
                destinationVC.createdBy = question.createdBy
                destinationVC.questionObject = question
        case .profileSegue:
            let destinationVC = segue.destinationViewController as! ProfileViewController
            destinationVC.user = question.createdBy
        }
    }
}


