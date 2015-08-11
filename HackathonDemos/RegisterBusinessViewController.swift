//
//  RegisterBusinessViewController.swift
//  HackathonDemos
//
//  Created by Dhruv Shah on 7/31/15.
//  Copyright (c) 2015 DhruvShah. All rights reserved.
//

import UIKit
import Parse

class RegisterBusinessViewController: UIViewController {

    @IBOutlet weak var regBusField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    /*
PFQuery *query = [PFQuery queryWithClassName:@"GameScore"];
[query whereKey:@"playerName" equalTo:@"Dan Stemkoski"];
[query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
if (!error) {
// The find succeeded.
NSLog(@"Successfully retrieved %d scores.", objects.count);
// Do something with the found objects
for (PFObject *object in objects) {
NSLog(@"%@", object.objectId);
}
} else {
// Log details of the failure
NSLog(@"Error: %@ %@", error, [error userInfo]);
}
}];
*/
    @IBAction func registerPressed(sender: AnyObject) {
        println("Somwhow this fukin registerPressed function is called")
        var business = PFObject(className:"Businesses")
        business["userAssociated"] = PFUser.currentUser();
        business["businessName"] = regBusField.text
        business["likeCount"] = 0
        business["checkinCount"] = 0
        business["likeVisitRatio"] = 1

        business.saveInBackgroundWithBlock {
            (success: Bool, error: NSError?) -> Void in
            if (success) {
                // The object has been saved.
                println("Business registered");
                var regVC = self.storyboard!.instantiateViewControllerWithIdentifier("vote") as!  VoteBusinessViewController;
                self.presentViewController(regVC, animated: true, completion: nil)
            } else {
                // There was a problem, check error.description
                println(error?.description);
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
