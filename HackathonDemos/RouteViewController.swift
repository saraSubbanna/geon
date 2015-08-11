//
//  RouteViewController.swift
//  HackathonDemos
//
//  Created by Dhruv Shah on 8/1/15.
//  Copyright (c) 2015 DhruvShah. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class RouteViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, MKMapViewDelegate {

    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var routeTableView: UITableView!
    var tableViewContent = NSMutableArray();
    var address: String! = "14091 Elvira Street, Saratoga, CA";

    var locationManager = CLLocationManager()
    func checkLocationAuthorizationStatus() -> Bool{
        if CLLocationManager.authorizationStatus() == .AuthorizedAlways {
            mapView.showsUserLocation = true
            return true;
        } else {
            locationManager.requestAlwaysAuthorization()
            return false;
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.mapView.delegate = self;
        if (checkLocationAuthorizationStatus() && count(address) > 0) {
            var request = MKDirectionsRequest();
            request.setSource(MKMapItem.mapItemForCurrentLocation());
            //var curLoc: CLLocation = CLLocation(latitude: 37.277725, longitude: -122.014106)
            geoCodeIt(address, completion: { (location: CLLocationCoordinate2D) -> Void in
                var placemark = MKPlacemark(coordinate: location, addressDictionary: nil)
                request.setDestination(MKMapItem(placemark: placemark))
                request.transportType = (MKDirectionsTransportType.Any); // This can be limited to automobile and walking directions.
                request.requestsAlternateRoutes = (true); // Gives you several route options.
                var directions: MKDirections = MKDirections(request: request);
                
                directions.calculateDirectionsWithCompletionHandler { (response: MKDirectionsResponse!, error: NSError!) -> Void in
                    
                    if (response != nil) {
                        var shortestDistance: CLLocationDistance = (response.routes[0] as! MKRoute).distance;
                        var shortestRoute: MKRoute = (response.routes[0] as! MKRoute);
                        for route in response.routes {
                            if (route.distance < shortestDistance) {
                                shortestDistance = route.distance;
                            }
                        }
                        self.mapView.showsUserLocation = true
                        self.mapView.addOverlay(shortestRoute.polyline, level: MKOverlayLevel.AboveRoads)
                        self.tableViewContent.addObjectsFromArray(shortestRoute.steps)
                        self.routeTableView.reloadData();
                        
                        println(shortestDistance * 0.000621371)
                        println(shortestRoute.expectedTravelTime)
                    }
                    else {
                        println(error);
                    }
                }
            })
        }
        else {
            // present registerBusinesses
            println("Not allowed! ERROR");
        }
        
    }
    
    
    
    func geoCodeIt(address : String,  completion:(CLLocationCoordinate2D)->Void) -> Void
    {
        var locationManager = LocationManager.sharedInstance
        var finalAddress = CLLocationCoordinate2D();

        locationManager.geocodeUsingGoogleAddressString(address: address) { (geocodeInfo,placemark,error) -> Void in
            
            if(error != nil){
                println(error)
            }
            else{
                //finalAddress.latitude = (geocodeInfo!["latitude"] as! NSString).doubleValue
                //finalAddress.longitude = (geocodeInfo!["longitude"] as! NSString).doubleValue
                finalAddress.latitude = geocodeInfo!["latitude"]!.doubleValue
                finalAddress.longitude = geocodeInfo!["longitude"]!.doubleValue
                //println(geocodeInfo!["longitude"]!.doubleValue)
                return completion(finalAddress)
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func segmentChanged(sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            showMap();
        }
        else {
            showTable();
        }
    }
    
    func mapView(mapView: MKMapView!, rendererForOverlay overlay: MKOverlay!) -> MKOverlayRenderer! {
        if(overlay.isKindOfClass(MKPolyline)) {
            var renderer: MKPolylineRenderer = MKPolylineRenderer(overlay: overlay)
            renderer.strokeColor = UIColor.blueColor()
            renderer.lineWidth = 5.0;
            return renderer;
        }
        return nil;
    }

    func showMap() {
        mapView.hidden = false; routeTableView.hidden = true;
    }
    func showTable() {
        mapView.hidden = true; routeTableView.hidden = false; self.routeTableView.reloadData();
    }
    
    // MARK: - Table view data source
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // Return the number of sections.
        return 1;
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Return the number of rows in the section.
        if (self.tableViewContent.count > 0) {
            return tableViewContent.count;
        }
        else {
            return 0;
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "reuseID")
        cell.textLabel?.text = (tableViewContent[indexPath.row] as! MKRouteStep).instructions as String;
        cell.textLabel?.numberOfLines = 0
        cell.textLabel?.lineBreakMode = NSLineBreakMode.ByWordWrapping
        var font: UIFont = UIFont.systemFontOfSize(UIFont.systemFontSize())
        cell.textLabel?.font = font;
        return cell
    }
    
    func heightForView(text:NSString, font:UIFont, width:CGFloat) -> CGFloat{
        var attributes = [NSFontAttributeName as NSObject : UIFont.systemFontOfSize(UIFont.systemFontSize()) as AnyObject] as [NSObject : AnyObject];
        var bounds: CGRect = text.boundingRectWithSize(CGSizeMake(width, CGFloat.max), options: NSStringDrawingOptions.UsesLineFragmentOrigin, attributes: attributes, context: nil)
        return bounds.size.height
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        var font: UIFont = UIFont.systemFontOfSize(UIFont.systemFontSize())
        var cell: UITableViewCell = (self.tableView(tableView, cellForRowAtIndexPath: indexPath)) as UITableViewCell;
        var textLabel: UILabel = cell.textLabel!;
        var height = heightForView(textLabel.text!, font: font, width: textLabel.frame.size.width);
        if(height > 28.0) {
            return height + 24.0;
        }
        else {
            return 44.0;
        }
    }
    override func prefersStatusBarHidden() -> Bool {
        return true
    }

}
