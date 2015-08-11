//
//  CouponViewController.swift
//  Example
//
//  Created by Srividhya Gopalan on 8/2/15.
//  Copyright (c) 2015 Alexander Schuch. All rights reserved.
//

import UIKit
//import Parse
import QRCode

class CouponViewController: UIViewController {
    
    //Im assuming the business we are currently on is a PFObject called Business

    @IBOutlet weak var businessCouponDescription: UITextView!
    @IBOutlet weak var businessNameLabel: UILabel!
    
    @IBOutlet weak var couponCode: UIImageView!
    var qrCodes: [UIImage]! = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.businessNameLabel.text = Business["name"]
        
        self.businessCouponDescription.text = Business["couponDescription"]
        
        for var t = 0; t < 20; t++ {
            couponCode.image = {
                var codeURL: String = "http://"
                codeURL = codeURL + Business["name"] + String(t)
                codeURL = codeURL + ".com"
                var qrCode = QRCode(codeURL)!
                qrCode.size = self.couponCode.bounds.size
                qrCode.errorCorrection = .High
                self.qrCodes.append(qrCode.image)
                return qrCode.image
            }()
            
        }

        
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
