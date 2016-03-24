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
