//
//  PersonalFeedViewController.swift
//  Chacha
//
//  Created by Daniel Jones on 3/3/16.
//  Copyright © 2016 Chong500Productions. All rights reserved.
//

import UIKit
import Parse

class PersonalFeedViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    var rowTapped : Int?
    
    var withPicture: Bool = false
    var questions = [Question]()
    
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
        if segue.identifier == "answerPageSegue" {
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
                let query = Question.query()
                query?.orderByAscending("createdAt")
                //query?.includeKey("answerCount")
                query?.includeKey("createdBy")
                //query?.includeKey("likeCount")
                //query?.includeKey("question")
                //query?.includeKey("questionDescription")
                query?.includeKey("createdAt")
                //query?.includeKey("questionImage")
                query?.findObjectsInBackgroundWithBlock({ (objects, error) -> Void in
                    if let objects = objects as? [Question] {
                        for question in objects {
                            self.questions.append(question)
                        }
                        self.tableView.reloadData()
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
            return cell
        }
        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        rowTapped = indexPath.row
        performSegueWithIdentifier("answerPageSegue", sender: self)
    }
}
