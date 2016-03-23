//
//  SuperViewController.swift
//  Chacha
//
//  Created by Daniel Jones on 3/23/16.
//  Copyright © 2016 Chong500Productions. All rights reserved.
//

import UIKit
import Parse

class SuperViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var withPicture: Bool = false
    var alreadyLikedDictionary: [String : Like] = [:]
    var likeIsSaving = false

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
        query?.whereKey("createdBy", equalTo: User.currentUser()!)
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

extension SuperViewController: QuestionTableViewCellDelegate {
    func createAnswer(answer: String) {
        
    }
}


