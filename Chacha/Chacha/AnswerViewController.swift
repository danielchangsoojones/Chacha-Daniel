//
//  AnswerViewController.swift
//  Chacha
//
//  Created by Daniel Jones on 3/7/16.
//  Copyright © 2016 Chong500Productions. All rights reserved.
//

import UIKit
import ParseUI
import EFTools

class AnswerViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var answers = [Answer]()
    
    var questionImage : PFFile?
    var question : String?
    var createdBy : User?
    var answerText: String?
    var questionObject: Question?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //for making cells grow and shrink with cell size content
        self.tableView.estimatedRowHeight = 80
        self.tableView.rowHeight = UITableViewAutomaticDimension
        
        tableView.registerNib(UINib(nibName: "QuestionCell", bundle: nil), forCellReuseIdentifier: "questionCell")
        tableView.registerNib(UINib(nibName: "AnswerCell", bundle: nil), forCellReuseIdentifier: "answerCell")
        
        createAnswerArray()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

//tableView Delegate Methods
extension AnswerViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //to account for the first question cell
        return answers.count + 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let currentRow = indexPath.row
        
        if currentRow == 0 {
                let cell = self.tableView.dequeueReusableCellWithIdentifier("questionCell")! as! QuestionTableViewCell
                cell.activityDelegate = self
                cell.questionDelegate = self
                cell.fullNameText.text = createdBy?.fullName
                cell.questionText.text = question
                if let questionImage = questionImage {
                    cell.questionImageHidden = false
                    cell.questionImage.file = questionImage
                    cell.questionImage.loadInBackground()
                }
                return cell
        } else {
            let currentAnswer = answers[currentRow - 1]
            let cell = self.tableView.dequeueReusableCellWithIdentifier("answerCell")! as! ActivityTableViewCell
            cell.fullNameText.text = currentAnswer.createdBy?.fullName
            cell.questionText.text = currentAnswer.answer
            return cell
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
    }
}

//queries
extension AnswerViewController {
    func createAnswerArray() {
        let query = Answer.query()
        query?.orderByAscending("createdAt")
        query?.includeKey("createdBy")
        query?.includeKey("createdAt")
        query?.whereKey("questionParent", equalTo: questionObject!)
        query?.findObjectsInBackgroundWithBlock({ (objects, error) -> Void in
            if let objects = objects as? [Answer] {
                for answer in objects {
                    self.answers.append(answer)
                }
                self.tableView.reloadData()
            }
        })
    }
}

extension AnswerViewController: ActivityTableViewCellDelegate {
    func updateLike(likeCountTag: Int) {
       
    }
}

extension AnswerViewController: QuestionTableViewCellDelegate {
    func createAnswer(answer: String) {
        let newAnswer = Answer()
        newAnswer.answer = answer
        newAnswer.createdBy = User.currentUser()
        newAnswer.questionParent = questionObject
        //        if let image = questionImage.image {
        //            let file = PFFile(name: "questionImage.jpg",data: UIImageJPEGRepresentation(image, 0.6)!)
        //            newQuestion.questionImage = file
        //        }
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

