//
//  ExploreViewController.swift
//  Chacha
//
//  Created by Daniel Jones on 3/1/16.
//  Copyright © 2016 Chong500Productions. All rights reserved.
//

import UIKit
import AVFoundation
import Parse

class ExploreViewController: UICollectionViewController {
    
    var rowTapped : Int?
    
    var withPicture: Bool = false
    var questions = [Question]()
    var alreadyLikedDictionary: [String : Like] = [:]
    var likeIsSaving = false
    
    @IBAction func logOut(sender: AnyObject) {
        PFUser.logOut()
        performSegueWithIdentifier("LogOutSegue", sender: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //for if I want an image as the background
//        if let patternImage = UIImage(named: "Pattern") {
//            view.backgroundColor = UIColor(patternImage: patternImage)
//        }
        
        view.backgroundColor = ChachaGrayBackground
        
        collectionView!.contentInset = UIEdgeInsets(top: 5, left: 5, bottom: 10, right: 5)
        collectionView!.backgroundColor = UIColor.clearColor()
        
        let layout = collectionViewLayout as! ExploreLayout
        layout.delegate = self
        layout.cellPadding = 5
        layout.numberOfColumns = 2
        
        createQuestionArray()
    }
    
}

//creating arrays
extension ExploreViewController {
    func createQuestionArray() {
        populateQuestionArray().findObjectsInBackgroundWithBlock({ (objects, error) -> Void in
            if let objects = objects as? [Question] {
                self.questions = objects
                self.collectionView!.reloadData()
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
                        if let parentObjectId = like.questionParent {
                            self.alreadyLikedDictionary.updateValue(like, forKey: parentObjectId.objectId!)
                        } else if let parentObjectId = like.answerParent{
                            self.alreadyLikedDictionary.updateValue(like, forKey: parentObjectId.objectId!)
                        }
                    }
                    self.collectionView!.reloadData()
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



extension ExploreViewController {
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return questions.count
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("AnnotatedPhotoCell", forIndexPath: indexPath) as! AnnotatedPhotoCell
        
        let currentRow = indexPath.row
        let currentQuestion = questions[currentRow]
    
        cell.fullName.text = currentQuestion.createdBy?.fullName
        cell.questionText.text = currentQuestion.question
        if let questionImage = currentQuestion.questionImage {
            cell.imageView.file = questionImage
            cell.imageView.loadInBackground()
        }
        cell.likeImage.imageView!.image = UIImage(named: "vibe-off")
        if let alreadyLiked = alreadyLikedDictionary[currentQuestion.objectId!] {
            cell.alreadyLiked = alreadyLiked
            cell.likeImage.imageView!.image = UIImage(named: "vibe-on")
        }
        cell.likeCountLabel.tag = currentRow
        cell.likeCount = currentQuestion.likeCount
        cell.likeCountLabel.text = "\(currentQuestion.likeCount)"
        cell.activityDelegate = self
//        cell.questionDelegate = self
        return cell
    }
    
}

extension ExploreViewController: ExploreLayoutDelegate {
    
    func collectionView(collectionView: UICollectionView, heightForPhotoAtIndexPath indexPath: NSIndexPath, withWidth width: CGFloat) -> CGFloat {
        let currentQuestion = questions[indexPath.item]
        let boundingRect = CGRect(x: 0, y: 0, width: width, height: CGFloat(MAXFLOAT))
        if currentQuestion.questionImageHeight > 0 && currentQuestion.questionImageWidth > 0 {
            let rect = AVMakeRectWithAspectRatioInsideRect(CGSize(width: currentQuestion.questionImageHeight, height: currentQuestion.questionImageWidth), boundingRect)
            return rect.height
        } else {
            let rect = AVMakeRectWithAspectRatioInsideRect(CGSize(width: 50 , height: 40), boundingRect)
            return rect.height
        }
    }
    
    func collectionView(collectionView: UICollectionView, heightForAnnotationAtIndexPath indexPath: NSIndexPath, withWidth width: CGFloat) -> CGFloat {
        let question = questions[indexPath.item]
        let font = UIFont(name: "HelveticaNeue", size: 10)!
        let commentHeight = question.heightForQuestion(font, width: width)
        let activityBarHeight: CGFloat = 15
        let profileViewHeight : CGFloat = 34
        let padding: CGFloat = 4
        let height = profileViewHeight + padding + commentHeight + padding + activityBarHeight + padding
        return height
    }
}

extension ExploreViewController: ActivityTableViewCellDelegate {
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
    
    func segueToProfile(row: Int) {
        
    }
}

