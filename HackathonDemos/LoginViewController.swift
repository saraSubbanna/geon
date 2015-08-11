//
//  ViewController.swift
//  HackathonDemos
//  Created by Dhruv Shah on 7/31/15.
//  Copyright (c) 2015 DhruvShah. All rights reserved.
//

import UIKit
import Parse
import MapKit
import CoreLocation
import AudioToolbox

class LoginViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var password: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        super.viewDidLoad()
        UITextField.appearance().textColor = UIColor.whiteColor();
        
        username.attributedPlaceholder = NSAttributedString(string:"Username",
            attributes:[NSForegroundColorAttributeName: UIColor.lightTextColor()])
        password.attributedPlaceholder = NSAttributedString(string:"Password",
            attributes:[NSForegroundColorAttributeName: UIColor.lightTextColor()])
        
        username.textColor = UIColor.whiteColor()
        password.textColor = UIColor.whiteColor()
    }
    
    var locationManager = CLLocationManager()
    func checkLocationAuthorizationStatus() -> Bool{
        if CLLocationManager.authorizationStatus() == .AuthorizedAlways {
            return true;
        } else {
            locationManager.requestAlwaysAuthorization()
            return false;
        }
    }
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated);
        checkLocationAuthorizationStatus();
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
    - (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    for (UIView * txt in self.view.subviews){
    if ([txt isKindOfClass:[UITextField class]] && [txt isFirstResponder]) {
    [txt resignFirstResponder];
    }
    }
    }
    */
    
    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        for view in self.view.subviews {
            if(view.isKindOfClass(UITextField) &&  view.isFirstResponder()) {
                view.resignFirstResponder()
            }
        }
    }
    @IBAction func loginPressed(sender: AnyObject) {
        // Block user interaction
        SwiftOverlays.showBlockingWaitOverlayWithText("Logging in...")
        PFUser.logInWithUsernameInBackground(username.text, password:password.text) {
            (user: PFUser?, error: NSError?) -> Void in
            if user != nil {
                // Do stuff after successful login.
                SwiftOverlays.removeAllBlockingOverlays()
                var homeVC: HomeViewController = self.storyboard?.instantiateViewControllerWithIdentifier("home") as! HomeViewController
                self.presentViewController(homeVC, animated: true, completion: nil)
                
            } else {
                SwiftOverlays.removeAllBlockingOverlays()
                ErrorManager().popupVibrateAndShakeForError(error!, currView: self.view);
            }
        }
    }
}

