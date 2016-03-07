//
//  PersonalFeedViewController.swift
//  Chacha
//
//  Created by Daniel Jones on 3/3/16.
//  Copyright © 2016 Chong500Productions. All rights reserved.
//

import UIKit

class PersonalFeedViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
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
            return cell
        } else {
            let cell = self.tableView.dequeueReusableCellWithIdentifier("QuestionCellNoPicture")! as! QuestionNoPictureTableViewCell
            cell.fullNameText.text = currentQuestion.createdBy?.fullName
            cell.questionText.text = currentQuestion.question
            return cell
        }
        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
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
