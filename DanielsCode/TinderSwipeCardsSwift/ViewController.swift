

import UIKit

class ViewController: UIViewController, CZPickerViewDelegate, CZPickerViewDataSource {
    
    var miles = 1
    var radiusBool = false
    var locationsBool = false
    
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
        var draggableBackground: DraggableViewBackground = DraggableViewBackground(frame: self.view.frame)
        
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
        let picker = CZPickerView(headerTitle: "Restaurant Filters", cancelButtonTitle: "Cancel", confirmButtonTitle: "Confirm")
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
        if(radiusBool)
        {
            if(row == 0)
            {
                println(1)
            }
            else
            {
                println(row * 5)
                //DHRUV SOMEWHERE HERE
            }
        }

    }
    
    func czpickerView(pickerView: CZPickerView!, didConfirmWithItemsAtRows rows: [AnyObject]!) {
         if(locationsBool)
         {
            for type in rows
            {
                println(business_array[type as! Int])
                //DHRUV SOMEWHERE HERE

            }
            
         }
    }
    
}

