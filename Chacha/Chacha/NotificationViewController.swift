//
//  NotificationViewController.swift
//  Chacha
//
//  Created by Daniel Jones on 3/28/16.
//  Copyright © 2016 Chong500Productions. All rights reserved.
//

import UIKit
import EFTools

class NotificationViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    var notifications = [Notification]()

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.registerNib(UINib(nibName: "NotificationCell", bundle: nil), forCellReuseIdentifier: "notificationCell")
        
        createNotificationArray()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

//tableView Delegate Methods
extension NotificationViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return notifications.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let currentRow = indexPath.row
        let currentNotification = notifications[currentRow]
        
        let cell = self.tableView.dequeueReusableCellWithIdentifier("notificationCell")! as! NotificationTableViewCell
        
        return cell
    }
    
}

//queries
extension NotificationViewController {
    func createNotificationArray() {
        let query = Notification.query()
        query?.whereKey("reciever", equalTo: User.currentUser()!)
        query?.findObjectsInBackgroundWithBlock({ (objects, error) -> Void in
            if let notifications = objects as? [Notification] {
                for notification in notifications {
                    self.notifications.append(notification)
                }
                self.tableView.reloadData()
            }
        })
    }
}

extension NotificationViewController: SegueHandlerType {
    enum SegueIdentifier: String {
        // THESE CASES WILL ALL MATCH THE IDENTIFIERS YOU CREATED IN THE STORYBOARD
        case answerPageSegue
        case profileSegue
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        switch segueIdentifierForSegue(segue) {
        case .answerPageSegue: break
//            let question = questions[rowTapped!]
//            let destinationVC = segue.destinationViewController as! AnswerViewController
//            destinationVC.questionObject = question
        case .profileSegue: break
//            let question = questions[rowTapped!]
//            let destinationVC = segue.destinationViewController as! ProfileViewController
//            destinationVC.user = question.createdBy
        default:
            break
        }
    }
}