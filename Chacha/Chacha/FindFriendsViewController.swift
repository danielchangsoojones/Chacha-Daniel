//
//  FindFriendsViewController.swift
//  Chacha
//
//  Created by Daniel Jones on 3/28/16.
//  Copyright © 2016 Chong500Productions. All rights reserved.
//

import UIKit

class FindFriendsViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var theTextField: UITextField!
    
    
    var friends = [User]()
    
    @IBAction func submit(sender: AnyObject) {
        let query = User.query()
        query?.whereKey("objectId", notEqualTo: (User.currentUser()?.objectId)!)
        query?.whereKey("fullName", containsString: theTextField.text)
        query?.findObjectsInBackgroundWithBlock({ (objects, error) -> Void in
            if let friends = objects as? [User] {
                self.friends = friends
                self.tableView.reloadData()
            }
        })
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.registerNib(UINib(nibName: "UserCell", bundle: nil), forCellReuseIdentifier: "userCell")
        
        tableView.estimatedRowHeight = 54
        tableView.rowHeight = UITableViewAutomaticDimension
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    

}

extension FindFriendsViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return friends.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let currentRow = indexPath.row
        let currentFriend = friends[currentRow]
        
        let cell = self.tableView.dequeueReusableCellWithIdentifier("userCell")! as! UserTableViewCell
        cell.fullName.text = currentFriend.fullName
        cell.username.text = currentFriend.username
        if let userImage = currentFriend.avatarImage {
            cell.profileImage.file = userImage
            cell.profileImage.loadInBackground()
        }
        
        return cell
    }
}
