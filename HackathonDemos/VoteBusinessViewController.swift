//
//  VoteBusinessViewController.swift
//  HackathonDemos
//
//  Created by Dhruv Shah on 7/31/15.
//  Copyright (c) 2015 DhruvShah. All rights reserved.
//

import UIKit
import Parse

class VoteBusinessViewController: UIViewController {

    @IBOutlet weak var bIDField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func upvote(sender: AnyObject) {
        let business = PFObject(withoutDataWithClassName:"Businesses", objectId: bIDField.text)
        business.incrementKey("likeCount")
        business.saveInBackgroundWithBlock {
            (success: Bool, error: NSError?) -> Void in
            if (success) {
                // The score key has been incremented
                println("Upvote successful")
                

            } else {
                // There was a problem, check error.description
                println("Error downvoting" + error!.description)
            }
        }

    }
    @IBAction func downvote(sender: AnyObject) {
        let business = PFObject(withoutDataWithClassName:"Businesses", objectId: bIDField.text)
        business.incrementKey("likeCount", byAmount: -1)
        business.saveInBackgroundWithBlock {
            (success: Bool, error: NSError?) -> Void in
            if (success) {
                // The score key has been incremented
                println("Downvote successful")
            } else {
                // There was a problem, check error.description
                println("Error downvoting" + error!.description)

            }
        }
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
