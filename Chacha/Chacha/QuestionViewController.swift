//
//  QuestionViewController.swift
//  Chacha
//
//  Created by Daniel Jones on 3/23/16.
//  Copyright © 2016 Chong500Productions. All rights reserved.
//

import UIKit
import EFTools

class QuestionViewController: SuperViewController {
    
    var questions = [Question]()
    var rowTapped : Int?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //for making cells grow and shrink with cell size content
        self.tableView.estimatedRowHeight = 278
        
        tableView.registerNib(UINib(nibName: "QuestionCell", bundle: nil), forCellReuseIdentifier: "questionCell")
        
        createQuestionArray()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

//creating every question array
extension QuestionViewController {
    func createQuestionArray() {
        populateQuestionArray().findObjectsInBackgroundWithBlock({ (objects, error) -> Void in
            if let objects = objects as? [Question] {
                self.questions = objects
                self.tableView.reloadData()
                self.fillAlreadyLikedDictionary()
            }
        })
    }
}

//tableView Delegate Methods
extension QuestionViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return questions.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let currentRow = indexPath.row
        let currentQuestion = questions[currentRow]
        
        let cell = self.tableView.dequeueReusableCellWithIdentifier("questionCell")! as! QuestionTableViewCell
        cell.fullNameText.text = currentQuestion.createdBy?.fullName
        cell.questionText.text = currentQuestion.question
        if let questionImage = currentQuestion.questionImage {
            cell.questionImageHidden = false
            cell.questionImage.file = questionImage
            cell.questionImage.loadInBackground()
        }
        cell.likeButtonImage.imageView!.image = UIImage(named: "vibe-off")
        if let alreadyLiked = alreadyLikedDictionary[currentQuestion.objectId!] {
            cell.alreadyLiked = alreadyLiked
            cell.likeButtonImage.imageView!.image = UIImage(named: "vibe-on")
        }
        cell.likeCountLabel.tag = currentRow
        cell.likeCount = currentQuestion.likeCount
        cell.likeCountLabel.text = "\(currentQuestion.likeCount)"
        cell.activityDelegate = self
        cell.questionDelegate = self
        return cell
    }
    
}

extension QuestionViewController: ActivityTableViewCellDelegate {
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

extension QuestionViewController: SegueHandlerType {
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
