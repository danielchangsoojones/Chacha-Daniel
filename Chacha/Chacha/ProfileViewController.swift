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
    
    @IBAction func followerPressed(sender: AnyObject) {
        state = tableState.follower
        self.tableView.reloadData()
    }
    
    @IBAction func followingPressed(sender: AnyObject) {
        state = tableState.following
        self.tableView.reloadData()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setProfile()
        createQuestionArray()
        createAnswerArray()
        createFollowerArray()
        createFollowingArray()
        
        tableView.registerNib(UINib(nibName: "AnswerCell", bundle: nil), forCellReuseIdentifier: "answerCell")
        tableView.registerNib(UINib(nibName: "UserCell", bundle: nil), forCellReuseIdentifier: "userCell")
        
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
            return followers.count
        case .following:
            return following.count
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let currentRow = indexPath.row
        switch state {
        case .question:
            let currentQuestion = questions[currentRow]
            return createQuestionCells(currentQuestion, currentRow: currentRow)
        case .answer:
            let currentAnswer = answers[currentRow]
            let cell = self.tableView.dequeueReusableCellWithIdentifier("answerCell")! as! ActivityTableViewCell
            cell.fullNameText.text = currentAnswer.createdBy?.fullName
            cell.questionText.text = currentAnswer.answer
            return cell
        case .follower:
            let currentFollower = followers[currentRow]
            let cell = self.tableView.dequeueReusableCellWithIdentifier("userCell")! as! UserTableViewCell
            cell.fullName.text = currentFollower.fullName
            cell.username.text = currentFollower.username
            if let userImage = currentFollower.avatarImage {
                cell.profileImage.file = userImage
                cell.profileImage.loadInBackground()
            }
            return cell
        case .following:
            let currentFollowing = following[currentRow]
            let cell = self.tableView.dequeueReusableCellWithIdentifier("userCell")! as! UserTableViewCell
            cell.fullName.text = currentFollowing.fullName
            cell.username.text = currentFollowing.username
            if let userImage = currentFollowing.avatarImage {
                cell.profileImage.file = userImage
                cell.profileImage.loadInBackground()
            }
            return cell
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        rowTapped = indexPath.row
        let profileStoryBoard = UIStoryboard(name: "Profile", bundle: nil)
        let destVC = profileStoryBoard.instantiateViewControllerWithIdentifier("profilePage") as! ProfileViewController
        
        switch state {
        case .question:
            performSegueWithIdentifier(.answerPageSegue, sender: self)
        case .following:
            destVC.user = following[rowTapped!]
            self.navigationController?.pushViewController(destVC, animated: true)
        case .follower:
            destVC.user = followers[rowTapped!]
            self.navigationController?.pushViewController(destVC, animated: true)
        default:
            break
        }
        
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
        query?.whereKey("leader", equalTo: user!)
        query!.includeKey("follower")
        query?.findObjectsInBackgroundWithBlock({ (objects, error) -> Void in
            if let userConnections = objects as? [UserConnection] {
                for userConnection in userConnections {
                    self.followers.append(userConnection.follower!)
                }
                self.tableView.reloadData()
            }
        })
    }
    
    func createFollowingArray() {
        let query = UserConnection.query()
        query?.whereKey("follower", equalTo: user!)
        query?.includeKey("leader")
        query?.findObjectsInBackgroundWithBlock({ (objects, error) -> Void in
            if let userConnections = objects as? [UserConnection] {
                for userConnection in userConnections {
                    self.following.append(userConnection.leader!)
                }
                self.tableView.reloadData()
            }
        })
    }
}

