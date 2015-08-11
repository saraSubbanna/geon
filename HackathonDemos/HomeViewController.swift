//
//  HomeViewController.swift
//  HackathonDemos
//
//  Created by Dhruv Shah on 8/2/15.
//  Copyright (c) 2015 DhruvShah. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import Parse


class HomeViewController: UIViewController, CAPSPageMenuDelegate {

    var pageMenu : CAPSPageMenu?
    var tealColor: UIColor! = UIColor(red: 73/255, green: 167/255, blue: 167/255, alpha: 1.0);
    var mileRadius: Int! = 5;
    var places:NSMutableArray = NSMutableArray();

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        SwiftOverlays.showBlockingTextOverlay("Loading all businesses within \(mileRadius) miles...")
        PFGeoPoint.geoPointForCurrentLocationInBackground {
            (geoPoint: PFGeoPoint?, error: NSError?) -> Void in
            if (error == nil && geoPoint != nil) {
                // do something with the new geoPoint
                // Create a query for places
                var query = PFQuery(className:"Businesses")
                // Interested in locations near user.
                query.whereKey("location", nearGeoPoint:geoPoint!, withinMiles: Double(self.mileRadius))
                
                    // Final list of objects
                    self.places.addObjectsFromArray(query.findObjects()!);
                    println(self.places)
                    var curObjects: [PFObject] = ((self.places as NSArray) as! [PFObject])
                    println("ASDASDlksdjf;alksdjf;aslkdjf;lkajdsf;lkjasd;lkfja;sdlkfj;asldkfj")
                    println(curObjects)
                    SwiftOverlays.removeAllBlockingOverlays()
                    // Array to keep track of controllers in page menu
                    var controllerArray : [UIViewController] = []
                    
                    // Create variables for all view controllers you want to put in the
                    // page menu, initialize them, and add each to the controller array.
                    // (Can be any UIViewController subclass)
                    // Make sure the title property of all view controllers is set
                    // Example:
                    var controller : TopBusinessesViewController = self.storyboard?.instantiateViewControllerWithIdentifier("topBiz") as! TopBusinessesViewController
                    controller.title = "Top Businesses"
                    controllerArray.append(controller)
                    
                    
                    var controller2 : ViewController = self.storyboard?.instantiateViewControllerWithIdentifier("nearMe") as! ViewController
                    controller2.title = "Near Me"
                    println(curObjects)
                    controller2.currObjects = curObjects;
                    controllerArray.append(controller2)
                    
                    
                    // Customize page menu to your liking (optional) or use default settings by sending nil for 'options' in the init
                    // Example:
                    var parameters: [CAPSPageMenuOption] = [
                        .MenuItemSeparatorWidth(4.3),
                        .UseMenuLikeSegmentedControl(true),
                        .MenuItemSeparatorPercentageHeight(0.1)
                    ]
                    
                    // Initialize page menu with controller array, frame, and optional parameters
                    self.pageMenu = CAPSPageMenu(viewControllers: controllerArray, frame: CGRectMake(0.0, 0.0, self.view.frame.width, self.view.frame.height), pageMenuOptions: parameters)
                    
                    // Lastly add page menu as subview of base view controller view
                    // or use pageMenu controller in you view hierachy as desired
                    self.view.addSubview(self.pageMenu!.view)
                    self.pageMenu?.selectionIndicatorColor = self.tealColor
                    self.pageMenu!.delegate = self

                    
                
            }
        }

        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prefersStatusBarHidden() -> Bool {
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
