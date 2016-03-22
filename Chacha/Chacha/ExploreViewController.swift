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
    

    var photos = Photo.allPhotos()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //for if I want an image as the background
//        if let patternImage = UIImage(named: "Pattern") {
//            view.backgroundColor = UIColor(patternImage: patternImage)
//        }
        
        view.backgroundColor = ChachaGrayBackground
        
        collectionView!.contentInset = UIEdgeInsets(top: 23, left: 5, bottom: 10, right: 5)
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
                        if let parentObjectId = like.postParent!.objectId {
                            self.alreadyLikedDictionary.updateValue(like, forKey: parentObjectId)
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
        return photos.count
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("AnnotatedPhotoCell", forIndexPath: indexPath) as! AnnotatedPhotoCell
        cell.photo = photos[indexPath.item]
        return cell
    }
    
}

extension ExploreViewController: ExploreLayoutDelegate {
    
    func collectionView(collectionView: UICollectionView, heightForPhotoAtIndexPath indexPath: NSIndexPath, withWidth width: CGFloat) -> CGFloat {
        let photo = photos[indexPath.item]
        let boundingRect = CGRect(x: 0, y: 0, width: width, height: CGFloat(MAXFLOAT))
        let rect = AVMakeRectWithAspectRatioInsideRect(photo.image.size, boundingRect)
        return rect.height
    }
    
    func collectionView(collectionView: UICollectionView, heightForAnnotationAtIndexPath indexPath: NSIndexPath, withWidth width: CGFloat) -> CGFloat {
        let photo = photos[indexPath.item]
        let font = UIFont(name: "HelveticaNeue", size: 10)!
        let commentHeight = photo.heightForQuestion(font, width: width)
        let activityBarHeight: CGFloat = 15
        let profileViewHeight : CGFloat = 34
        let padding: CGFloat = 4
        let height = profileViewHeight + padding + commentHeight + padding + activityBarHeight + padding
        return height
    }
    
}

