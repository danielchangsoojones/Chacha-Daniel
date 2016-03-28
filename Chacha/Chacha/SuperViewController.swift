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
        
        tableView.registerNib(UINib(nibName: "QuestionCell", bundle: nil), forCellReuseIdentifier: "questionCell")
        tableView.registerNib(UINib(nibName: "QuestionCellWithoutPicture", bundle: nil), forCellReuseIdentifier: "questionCellWithoutPicture")
        
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
                        if let questionParent = like.questionParent {
                            self.alreadyLikedDictionary.updateValue(like, forKey: questionParent.objectId!)
                        } else if let answerParent = like.answerParent {
                            self.alreadyLikedDictionary.updateValue(like, forKey: answerParent.objectId!)
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
    
    func createQuestionCells(currentQuestion: Question, currentRow: Int) -> QuestionTableViewCell {
        if let _ = currentQuestion.questionImage {
            let cell = self.tableView.dequeueReusableCellWithIdentifier("questionCell")! as! QuestionTableViewCell
            cell.question = currentQuestion
            cell.likeButtonImage.imageView!.image = UIImage(named: "vibe-off")
            if let alreadyLiked = alreadyLikedDictionary[currentQuestion.objectId!] {
                cell.alreadyLiked = alreadyLiked
                cell.likeButtonImage.imageView!.image = UIImage(named: "vibe-on")
            }
            cell.likeCountLabel.tag = currentRow
            cell.activityDelegate = self
            cell.questionDelegate = self
            return cell
        } else {
            let cell = self.tableView.dequeueReusableCellWithIdentifier("questionCellWithoutPicture")! as! QuestionTableViewCell
            cell.question = currentQuestion
            cell.likeButtonImage.imageView!.image = UIImage(named: "vibe-off")
            if let alreadyLiked = alreadyLikedDictionary[currentQuestion.objectId!] {
                cell.alreadyLiked = alreadyLiked
                cell.likeButtonImage.imageView!.image = UIImage(named: "vibe-on")
            }
            cell.likeCountLabel.tag = currentRow
            cell.activityDelegate = self
            cell.questionDelegate = self
            return cell
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
        } else {
            let currentAnswer = answers[likeCountTag]
            if let currentLike = alreadyLikedDictionary[currentAnswer.objectId!] {
                //delete the like
                currentLike.deleteInBackgroundWithBlock({ (success, error) -> Void in
                    if success && error == nil {
                    self.alreadyLikedDictionary.removeValueForKey(currentAnswer.objectId!)
                        currentAnswer.decrementLikeCount()
                    }
                })
            } else {
                //create the like
                if !likeIsSaving {
                    //not currently saving any likes
                    createLike(currentAnswer)
                }
            }
        }
    }
    
    func segueToProfile(row: Int) {
        rowTapped = row
        performSegueWithIdentifier(.profileSegue, sender: self)
    }
}

protocol QuestionTableViewCellDelegate {
    func createAnswer(answer: String, questionObject: Question)
}

extension SuperViewController: QuestionTableViewCellDelegate {
    func createAnswer(answer: String, questionObject: Question) {
        let newAnswer = createNewAnswer(answer, questionObject: questionObject)
        newAnswer.saveInBackgroundWithBlock { (success, error) -> Void in
            if success {
                self.answers.append(newAnswer)
                self.tableView.reloadData()
                let _ = Alert(title: "Answer Created!", subtitle: "You answered a question!", closeButtonTitle: "Awesome!", type: .Success)
            } else {
                print(error)
            }
        }
    }
}

extension SuperViewController: SegueHandlerType {
    enum SegueIdentifier: String {
        // THESE CASES WILL ALL MATCH THE IDENTIFIERS YOU CREATED IN THE STORYBOARD
        case answerPageSegue
        case profileSegue
        case moreSegue
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        switch segueIdentifierForSegue(segue) {
        case .answerPageSegue:
            let question = questions[rowTapped!]
            let destinationVC = segue.destinationViewController as! AnswerViewController
                destinationVC.questionObject = question
        case .profileSegue:
            let question = questions[rowTapped!]
            let destinationVC = segue.destinationViewController as! ProfileViewController
            destinationVC.user = question.createdBy
        default:
            break
        }
    }
}


