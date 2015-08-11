//
//  MainViewController.swift
//
//
//  Created by Srividhya Gopalan on 8/1/15.
//
//

import UIKit

class ScrollViewController: UIViewController {

    @IBOutlet weak var businessName: UITextField!
    @IBOutlet weak var businessLocation: UITextField!
    @IBOutlet weak var ownerName: UITextField!
    @IBOutlet weak var ownerEmail: UITextField!
    @IBOutlet weak var businessPassword: UITextField!
    @IBOutlet weak var businessUsername: UITextField!
    @IBOutlet weak var scrollView: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        super.viewDidLoad()
        businessLocation.attributedPlaceholder = NSAttributedString(string:"Business Location",
            attributes:[NSForegroundColorAttributeName: UIColor.lightTextColor()])
        super.viewDidLoad()
        businessName.attributedPlaceholder = NSAttributedString(string:"Business Name",
            attributes:[NSForegroundColorAttributeName: UIColor.lightTextColor()])
        businessPassword.attributedPlaceholder = NSAttributedString(string:"Business Account Password",
            attributes:[NSForegroundColorAttributeName: UIColor.lightTextColor()])
        businessUsername.attributedPlaceholder = NSAttributedString(string:"Business Account Username",
            attributes:[NSForegroundColorAttributeName: UIColor.lightTextColor()])
        ownerEmail.attributedPlaceholder = NSAttributedString(string:"owneremail@domain.com",
            attributes:[NSForegroundColorAttributeName: UIColor.lightTextColor()])
        ownerName.attributedPlaceholder = NSAttributedString(string:"Owner Name",
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
