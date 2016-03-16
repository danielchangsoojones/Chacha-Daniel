//
//  ProfileViewController.swift
//  Chacha
//
//  Created by Daniel Jones on 3/15/16.
//  Copyright © 2016 Chong500Productions. All rights reserved.
//

import UIKit
import Parse
import ParseUI

class ProfileViewController: UIViewController {
    
    @IBOutlet weak var fullName: UILabel!
    @IBOutlet weak var profileImage: PFImageView!
    @IBOutlet weak var tableView: UITableView!
    
    let currentUser = User.currentUser()
    var questions = [Question]()
    var answers = [Answer]()
    var alreadyLikedDictionary: [String : Like] = [:]
    
    enum tableState {
        case answer, question, follower, following
    }
    var state = tableState.question
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setProfile()
        createQuestionArray()
        
        tableView.registerNib(UINib(nibName: "QuestionCell", bundle: nil), forCellReuseIdentifier: "questionCell")
        
        //for making cells grow and shrink with cell size content
        self.tableView.estimatedRowHeight = 278
        self.tableView.rowHeight = UITableViewAutomaticDimension
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

extension ProfileViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch state {
        case .question:
            return questions.count
        case .answer:
            return answers.count
        case .follower:
            return 3
        case .following:
            return 3
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let currentRow = indexPath.row
        let currentQuestion = questions[currentRow]
        switch state {
        case .question:
            let cell = self.tableView.dequeueReusableCellWithIdentifier("questionCell")! as! QuestionTableViewCell
            cell.fullNameText.text = currentQuestion.createdBy?.fullName
            cell.questionText.text = currentQuestion.question
            if let questionImage = currentQuestion.questionImage {
                cell.questionImageHidden = false
                cell.questionImage.file = questionImage
                cell.questionImage.loadInBackground()
            }
            if let alreadyLiked = alreadyLikedDictionary[currentQuestion.objectId!] {
                cell.alreadyLiked = alreadyLiked
            }
            cell.likeCountLabel.tag = currentRow
            cell.activityDelegate = self
            cell.questionDelegate = self
            return cell
        case .answer:
            return UITableViewCell()
        case .follower:
            return UITableViewCell()
        case .following:
            return UITableViewCell()
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
//        rowTapped = indexPath.row
//        performSegueWithIdentifier(.answerPageSegue, sender: self)
    }
}

//loading the page and queries
extension ProfileViewController {
    func setProfile() {
        fullName.text = currentUser?.fullName
        if let profilePicture = currentUser?.avatarImage {
            profileImage.file = profilePicture
            profileImage.loadInBackground()
        }
    }
    
    func createQuestionArray() {
        let query = populateQuestionArray()
        query.whereKey("createdBy", equalTo: currentUser!)
        query.findObjectsInBackgroundWithBlock({ (objects, error) -> Void in
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
                            self.alreadyLikedDictionary[parentObjectId] = like
                        }
                    }
                    self.tableView.reloadData()
                }
            }
        })
    }
    
}

extension ProfileViewController: ActivityTableViewCellDelegate, QuestionTableViewCellDelegate {
    func updateLike(likeCountTag: Int) {
        
    }
    
    func createAnswer(answer: String) {
        
    }
}

