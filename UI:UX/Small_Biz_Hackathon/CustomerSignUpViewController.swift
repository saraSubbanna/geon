//
//  CustomerSignUpViewController.swift
//  Small_Biz_Hackathon
//
//  Created by Srividhya Gopalan on 8/1/15.
//  Copyright (c) 2015 Srividhya Gopalan. All rights reserved.
//

import UIKit

class CustomerSignUpViewController: UIViewController {
    @IBOutlet weak var usernameSignup: UITextField!

    @IBOutlet weak var passwordSignup: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        usernameSignup.attributedPlaceholder = NSAttributedString(string:"Username",
            attributes:[NSForegroundColorAttributeName: UIColor.lightTextColor()])
        passwordSignup.attributedPlaceholder = NSAttributedString(string:"Password",
            attributes:[NSForegroundColorAttributeName: UIColor.lightTextColor()])
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
