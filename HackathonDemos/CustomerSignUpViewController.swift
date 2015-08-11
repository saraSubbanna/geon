//
//  CustomerSignUpViewController.swift
//  HackathonDemos
//
//  Created by Dhruv Shah on 8/2/15.
//  Copyright (c) 2015 DhruvShah. All rights reserved.
//

import UIKit
import Parse

class CustomerSignUpViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var password: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        username.attributedPlaceholder = NSAttributedString(string:"Username",
            attributes:[NSForegroundColorAttributeName: UIColor.lightTextColor()])
        password.attributedPlaceholder = NSAttributedString(string:"Password",
            attributes:[NSForegroundColorAttributeName: UIColor.lightTextColor()])
    }
    
    
    
    @IBAction func signUpPressed(sender: UIButton) {
        var user = PFUser()
        user.username = username.text
        user.password = password.text
        SwiftOverlays.showBlockingWaitOverlayWithText("Signing up...")
        user.signUpInBackgroundWithBlock {
            (succeeded: Bool, error: NSError?) -> Void in
            if let error = error {
                let errorString = error.userInfo?["error"] as? NSString
                // Show the errorString somewhere and let the user try again.
                println(errorString)
                ErrorManager().popupVibrateAndShakeForError(error, currView: self.view)
            } else {
                // Hooray! Let them use the app now.
                SwiftOverlays.removeAllBlockingOverlays()
                // Go to patricks code
                var homeVC: HomeViewController = self.storyboard?.instantiateViewControllerWithIdentifier("home") as! HomeViewController
                self.presentViewController(homeVC, animated: true, completion: nil)
                SwiftOverlays.removeAllBlockingOverlays()
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if(textField == username) {
            textField.resignFirstResponder();
            password.becomeFirstResponder()
        }
        else if(textField == password) {
            password.resignFirstResponder()
        }
        return true
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
