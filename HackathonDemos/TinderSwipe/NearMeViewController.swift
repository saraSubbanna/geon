

import UIKit
import Parse

class ViewController: UIViewController, CZPickerViewDelegate, CZPickerViewDataSource {
    
    var miles = 1
    var radiusBool = false
    var locationsBool = false
    var currObjects: [PFObject]!;
    var numMiles: Double = 1.0;
    var rowsSelected: [AnyObject]!;
    
    var allLocationKeys: [String] = ["restaurant", "fastFood", "pet", "art", "sports", "media", "clothing", "other"];
    
    var validLocationKeys: [String] = ["restaurant", "fastFood", "pet", "art", "sports", "media", "clothing", "other"];
    /*
    restaurant
    fastFood
    pet
    art
    sports
    media
    clothing
    other
    
    */
    
    var business_array = ["Restaurant", "Fast Food", "Pet Shop", "Art Shop", "Sports Shop", "Media Shop", "Clothing Shop", "Other"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        var draggableBackground: DraggableViewBackground! = DraggableViewBackground(frame: self.view.frame)
        self.view.addSubview(draggableBackground)
    }
    
    func pressed_radius(sender: AnyObject) {
        if(locationsBool){
            radiusBool = true
            locationsBool = false
        }
        else{
            radiusBool = true
        }
        let picker = CZPickerView(headerTitle: "Location Filters", cancelButtonTitle: "Cancel", confirmButtonTitle: "Confirm")
        picker.delegate = self
        picker.dataSource = self
        picker.needFooterView = true
        picker.show()
    }
    
    func pressed_locations(sender: AnyObject) {
        if(radiusBool){
            locationsBool = true
            radiusBool = false
        }
        else{
            locationsBool = true
        }
        let picker = CZPickerView(headerTitle: "Business Type Filters", cancelButtonTitle: "Cancel", confirmButtonTitle: "Confirm")
        picker.delegate = self
        picker.dataSource = self
        picker.needFooterView = true
        picker.allowMultipleSelection = true
        picker.show()
    }
    
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func numberOfRowsInPickerView(pickerView: CZPickerView!) -> Int {
        if(locationsBool){
            return 8
        }
        else
        {
            return 7
        }
    }
    
    func czpickerView(pickerView: CZPickerView!, titleForRow row: Int) -> String! {
        if(row == 0){
            if(radiusBool)
            {
                return "Miles - \(1)"
            }
        }
        else if (row != 0)
        {
            if(radiusBool)
            {
                return "Miles - \(row * 5)";
            }
        }
        if(locationsBool && radiusBool == false){
            return business_array[row]
        }
        return ""
    }

    func czpickerView(pickerView: CZPickerView!, didConfirmWithItemAtRow row: Int){
        if(radiusBool) {

            if(row == 0)
            {
                self.numMiles = 1.0
            }
            else
            {
                self.numMiles = Double(row * 5)
                
            }
            PFGeoPoint.geoPointForCurrentLocationInBackground {
                (geoPoint: PFGeoPoint?, error: NSError?) -> Void in
                if (error == nil && geoPoint != nil) {
                    // do something with the new geoPoint
                    // Create a query for places
                    var query = PFQuery(className:"Businesses")
                    // Interested in locations near user.
                    query.whereKey("location", nearGeoPoint:geoPoint!, withinMiles: self.numMiles)
                    query.whereKey("type", containedIn: self.validLocationKeys)

                    // Final list of objects
                    var places: NSArray = NSArray().arrayByAddingObjectsFromArray(query.findObjects()!) as NSArray;
                    if(places.count > 0) {
                        self.currObjects = places as! [PFObject]
                        self.view.subviews.last?.removeFromSuperview();
                        var draggableBackground: DraggableViewBackground! = DraggableViewBackground(frame: self.view.frame)
                        var arr: [String]!;
                        for(var i = 0; i < self.currObjects.count; i++) {
                            arr[i] = (self.currObjects[i])["businessName"] as! String
                        }
                        // draggableBackground.storeNamesStorage = arr;
                        self.view.addSubview(draggableBackground)
                        
                    }
                }
            }

        }

    }
    
    func czpickerView(pickerView: CZPickerView!, didConfirmWithItemsAtRows rows: [AnyObject]!) {
         if(locationsBool)
         {
            validLocationKeys = [];

            for type in rows
            {
                println(business_array[type as! Int])
                //DHRUV SOMEWHERE HERE
                self.validLocationKeys.append(allLocationKeys[type as! Int])

            }
            PFGeoPoint.geoPointForCurrentLocationInBackground {
                (geoPoint: PFGeoPoint?, error: NSError?) -> Void in
                if (error == nil && geoPoint != nil) {
                    // do something with the new geoPoint
                    // Create a query for places
                    var query = PFQuery(className:"Businesses")
                    // Interested in locations near user.
                    query.whereKey("location", nearGeoPoint:geoPoint!, withinMiles: self.numMiles)
                    query.whereKey("type", containedIn: self.validLocationKeys)
                    
                    // Final list of objects
                    var places: NSArray = NSArray().arrayByAddingObjectsFromArray(query.findObjects()!) as NSArray;
                    if(places.count > 0) {
                        self.currObjects = places as! [PFObject]
                        self.view.subviews.last?.removeFromSuperview();
                        var draggableBackground: DraggableViewBackground! = DraggableViewBackground(frame: self.view.frame)
                        var arr: [String]!;
                        for(var i = 0; i < self.currObjects.count; i++) {
                            arr[i] = (self.currObjects[i])["businessName"] as! String
                        }
                        // draggableBackground.storeNamesStorage = arr;
                        self.view.addSubview(draggableBackground)
                        
                    }
                }
            }
            
         }
    }
    
}

