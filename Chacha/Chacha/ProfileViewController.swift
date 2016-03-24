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

class ProfileViewController: SuperViewController {
    
    @IBOutlet weak var fullName: UILabel!
    @IBOutlet weak var profileImage: PFImageView!
    @IBOutlet weak var followButton: UIButton!
    
    var followers = [User]()
    var following = [User]()
    
    var user = User.currentUser()
    
    @IBAction func followPressed(sender: AnyObject) {
        let userConnection = createUserConnection(user!)
        userConnection.saveInBackgroundWithBlock { (success, error) -> Void in
            if success {
                self.followButton.setTitle("Requesting...", forState: .Normal)
            } else {
                let _ = Alert(title: "Error", subtitle: "Could Not Follow User", closeButtonTitle: "Try Again Later", type: .Error)
            }
        }
    }
    
    
    enum tableState {
        case answer, question, follower, following
    }
    var state = tableState.question
    
    @IBAction func questionStatePressed(sender: AnyObject) {
        state = tableState.question
        self.tableView.reloadData()
    }
    
    @IBAction func answerStatePressed(sender: AnyObject) {
        state = tableState.answer
        self.tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setProfile()
        createQuestionArray()
        createAnswerArray()
        createFollowerArray()
        createFollowingArray()
        
        tableView.registerNib(UINib(nibName: "QuestionCell", bundle: nil), forCellReuseIdentifier: "questionCell")
        tableView.registerNib(UINib(nibName: "AnswerCell", bundle: nil), forCellReuseIdentifier: "answerCell")
        
        self.tableView.estimatedRowHeight = 278
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

extension ProfileViewController {
    
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
        switch state {
        case .question:
            let currentQuestion = questions[currentRow]
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
            let currentAnswer = answers[currentRow]
            let cell = self.tableView.dequeueReusableCellWithIdentifier("answerCell")! as! ActivityTableViewCell
            cell.fullNameText.text = currentAnswer.createdBy?.fullName
            cell.questionText.text = currentAnswer.answer
            return cell
        case .follower:
            return UITableViewCell()
        case .following:
            return UITableViewCell()
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        rowTapped = indexPath.row
        performSegueWithIdentifier(.answerPageSegue, sender: self)
    }
}

//loading the page and queries
extension ProfileViewController {
    func setProfile() {
        if user?.objectId == currentUser?.objectId {
            followButton.hidden = true
        }
        fullName.text = user!.fullName
        if let profilePicture = user!.avatarImage {
            profileImage.file = profilePicture
            profileImage.loadInBackground()
        }
    }
    
    func createQuestionArray() {
        let query = populateQuestionArray()
        query.whereKey("createdBy", equalTo: user!)
        query.findObjectsInBackgroundWithBlock({ (objects, error) -> Void in
            if let objects = objects as? [Question] {
                self.questions = objects
                self.tableView.reloadData()
                self.fillAlreadyLikedDictionary()
            }
        })
    }
    
    func createAnswerArray() {
        let query = populateAnswerArray()
        query.whereKey("createdBy", equalTo: user!)
        query.findObjectsInBackgroundWithBlock({ (objects, error) -> Void in
            if let objects = objects as? [Answer] {
                for answer in objects {
                    self.answers.append(answer)
                }
                self.tableView.reloadData()
            }
        })
    }
    
    func createFollowerArray() {
        let query = UserConnection.query()
        query?.whereKey("leader", equalTo: user!.objectId!)
        query?.findObjectsInBackgroundWithBlock({ (objects, error) -> Void in
            if let followers = objects as? [User] {
                self.followers = followers
            }
        })
    }
    
    func createFollowingArray() {
        let query = UserConnection.query()
        query?.whereKey("follower", equalTo: user!.objectId!)
        query?.findObjectsInBackgroundWithBlock({ (objects, error) -> Void in
            if let leaders = objects as? [User] {
                self.following = leaders
            }
        })
    }
}

