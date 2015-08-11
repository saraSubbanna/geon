//
//  BusinessSignUpViewController.swift
//  HackathonDemos
//
//  Created by Dhruv Shah on 8/2/15.
//  Copyright (c) 2015 DhruvShah. All rights reserved.
//

import UIKit
import Photos
import MapKit
import CoreLocation
import Parse

private var kAssociationKeyNextField: UInt8 = 0
extension UITextField {
    @IBOutlet var nextField: UITextField? {
        get {
            return objc_getAssociatedObject(self, &kAssociationKeyNextField) as? UITextField
        }
        set(newField) {
            objc_setAssociatedObject(self, &kAssociationKeyNextField, newField, UInt(OBJC_ASSOCIATION_RETAIN))
        }
    }
}

class BusinessSignUpViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate, UITextViewDelegate {

    @IBOutlet weak var businessName: UITextField!
    @IBOutlet weak var businessLocation: UITextField!
    @IBOutlet weak var ownerName: UITextField!
    @IBOutlet weak var ownerEmail: UITextField!
    @IBOutlet weak var businessPassword: UITextField!
    @IBOutlet weak var businessUsername: UITextField!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var summary: UITextView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var actualView: UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
        
        var toolbar = UIToolbar(frame: CGRectMake(0, 0, 320, 50))
        toolbar.barStyle = UIBarStyle.BlackTranslucent;
        toolbar.items = NSArray(objects: UIBarButtonItem(title: "Cancel", style: UIBarButtonItemStyle.Bordered, target: self, action: "cancelNumberPad"), UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: nil, action: nil), UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.Done, target: self, action: "doneNumberPad")) as [AnyObject];

        toolbar.sizeToFit();
        summary.inputAccessoryView = toolbar;


    }
    
    func doneNumberPad() {
        summary.resignFirstResponder()
    }
    func cancelNumberPad() {
        summary.text = "";
        summary.resignFirstResponder()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func imagePlusPressed(sender: UIButton) {
        presentImagePickerSheet()
    }
    func presentImagePickerSheet() {
        let presentImagePickerController: UIImagePickerControllerSourceType -> () = { source in
            let controller = UIImagePickerController()
            controller.delegate = self
            var sourceType = source
            if (!UIImagePickerController.isSourceTypeAvailable(sourceType)) {
                sourceType = .PhotoLibrary
                println("Fallback to camera roll as a source since the simulator doesn't support taking pictures")
            }
            controller.sourceType = sourceType
            
            self.presentViewController(controller, animated: true, completion: nil)
        }
        
        let controller = ImagePickerSheetController()
        controller.maximumSelection = 1;
        controller.addAction(ImageAction(title: NSLocalizedString("Take Photo Or Video", comment: "Action Title"), secondaryTitle: NSLocalizedString("Upload This Photo", comment: "Action Title"), handler: { _ in
            presentImagePickerController(.Camera)
            }, secondaryHandler: { _, numberOfPhotos in
                let manager = PHImageManager.defaultManager();
                let width = CGFloat(controller.selectedImageAssets.first!.pixelWidth);
                let height = CGFloat(controller.selectedImageAssets.first!.pixelHeight);
                
                manager.requestImageForAsset(controller.selectedImageAssets.first, targetSize: CGSizeMake(width, height), contentMode: PHImageContentMode.AspectFit, options: nil) { (result, _) in
                    var imgName: String = controller.selectedImageAssets.first!.localIdentifier;
                    self.imageView.image = result;
                    self.imageView.contentMode = UIViewContentMode.ScaleAspectFit;
                    // self.uploadImage(result);
                }
        }))
        controller.addAction(ImageAction(title: NSLocalizedString("Photo Library", comment: "Action Title"), handler: { _ in
            presentImagePickerController(.PhotoLibrary)
        }));
        controller.addAction(ImageAction(title: NSLocalizedString("Cancel", comment: "Action Title"), style: .Cancel, handler: { _ in
            println("Cancelled")
        }))
        presentViewController(controller, animated: true, completion: nil);
    }

    
    // MARK: UIImagePickerControllerDelegate
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage!, editingInfo: [NSObject : AnyObject]!) {
        println("img selected");
        println(editingInfo);
        self.imageView.image = image;
        self.imageView.contentMode = UIViewContentMode.ScaleAspectFit;

        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }

    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        for view in actualView.subviews {
            if(view.isKindOfClass(UITextField) &&  view.isFirstResponder()) {
                view.resignFirstResponder()
            }
            else if(view.isKindOfClass(UITextView) &&  view.isFirstResponder()) {
                view.resignFirstResponder()
            }
        }
    }

    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if(textField != businessPassword) {
            textField.nextField?.becomeFirstResponder()
        }
        else {
            summary.becomeFirstResponder()
        }
        return true
    }
    
    @IBAction func signUpBusiness(sender: AnyObject) {
        var business = PFObject(className:"Businesses")
        var user = PFUser();
        user.username = businessUsername.text
        user.password = businessPassword.text
        SwiftOverlays.showBlockingWaitOverlayWithText("Registering business...")
        user.signUpInBackgroundWithBlock {
            (succeeded: Bool, error: NSError?) -> Void in
            if let error = error {
                // if user is already registered.....
                println("ERROR")
                SwiftOverlays.removeAllBlockingOverlays()
            }
            else {
                // Hooray! Let them use the app now.
                business["userAssociated"] = user;
                
                business["businessName"] = self.businessName.text
                self.geoCodeIt(self.businessLocation.text, completion: { (coor: CLLocationCoordinate2D) -> Void in
                    business["location"] = PFGeoPoint(latitude: coor.latitude, longitude: coor.longitude)
                })
                business["businessPhoto"] = PFFile(data: UIImagePNGRepresentation(self.imageView.image))
                business["likeCount"] = 0
                business["checkinCount"] = 0
                business["likeVisitRatio"] = 0
                business["summary"] = self.summary.text;
                business["ownerName"] = self.ownerName.text;
                business["ownerEmail"] = self.ownerEmail.text;

                
                business.saveInBackgroundWithBlock {
                    (success: Bool, error: NSError?) -> Void in
                    if (success) {
                        // The object has been saved.
                        println("Business registered");
                        // All registration complete (Pattys code here)
                        SwiftOverlays.removeAllBlockingOverlays()
                        var homeVC: HomeViewController = self.storyboard?.instantiateViewControllerWithIdentifier("home") as! HomeViewController
                        self.presentViewController(homeVC, animated: true, completion: nil)
                        
                    } else {
                        // There was a problem, check error.description
                        SwiftOverlays.removeAllBlockingOverlays()
                        var e: ErrorManager = ErrorManager();
                        e.popupVibrateAndShakeForError(error!, currView: self.view);
                    }
                }

            }
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
