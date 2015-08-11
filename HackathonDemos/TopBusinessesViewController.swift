//
//  TopBusinessesViewController.swift
//  HackathonDemos
//
//  Created by Dhruv Shah on 8/1/15.
//  Copyright (c) 2015 DhruvShah. All rights reserved.
//

import UIKit
import Parse

class TopBusinessesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var busTableView: UITableView!
    var businesses: NSMutableArray! = [];
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        SwiftOverlays.showBlockingWaitOverlayWithText("Please wait...")

        var query = PFQuery(className:"Businesses")
        
        // Sorts the results in ascending order by the score field
        query.orderByDescending("likeVisitRatio")
        
        query.findObjectsInBackgroundWithBlock {
            (objects: [AnyObject]?, error: NSError?) -> Void in
            
            if error == nil {
                // The find succeeded.
                println("Successfully retrieved \(objects!.count) businesses.")
                // Do something with the found objects
                if let objects = objects as? [PFObject] {
                    self.businesses.addObjectsFromArray(objects);
                    self.busTableView.reloadData()
                    // Don't forget to unblock!
                    SwiftOverlays.removeAllBlockingOverlays()
                }
            } else {
                // Log details of the failure
                println("Error: \(error!) \(error!.userInfo!)")
            }
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        // Block user interaction
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.businesses.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "reuseID");
        cell.textLabel?.text = (businesses[indexPath.row].objectForKey("businessName") as! String);
        
        println(businesses[indexPath.row])
        var text: String = ("Likes: " + String(businesses[indexPath.row].objectForKey("likeCount") as! Int) + " Visits: " + String(businesses[indexPath.row].objectForKey("checkinCount") as! Int)) as String

        cell.detailTextLabel?.text = text;
        println(businesses[indexPath.row].objectForKey("businessPhoto"))
        if let shit = (businesses[indexPath.row].objectForKey("businessPhoto") as? PFFile) {
            var image:UIImage = UIImage(data: shit.getData()!)!
            cell.imageView?.image = image;
        }
        
        cell.backgroundColor = UIColor.darkGrayColor()
        return cell;
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
