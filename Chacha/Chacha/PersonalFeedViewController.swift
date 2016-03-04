//
//  PersonalFeedViewController.swift
//  Chacha
//
//  Created by Daniel Jones on 3/3/16.
//  Copyright © 2016 Chong500Productions. All rights reserved.
//

import UIKit

class PersonalFeedViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    var withPicture: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //for making cells grow and shrink with cell size content
        self.tableView.estimatedRowHeight = 80
        self.tableView.rowHeight = UITableViewAutomaticDimension
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if withPicture {
            let cell = self.tableView.dequeueReusableCellWithIdentifier("QuestionCellWithPicture")! as! QuestionWithPictureTableViewCell
            return cell
        } else {
            let cell = self.tableView.dequeueReusableCellWithIdentifier("QuestionCellNoPicture")! as! QuestionNoPictureTableViewCell
            return cell
        }
        
       
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
    }

}
