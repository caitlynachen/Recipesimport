//
//  ViewController.swift
//  SafeApp2
//
//  Created by Caitlyn Chen on 6/30/15.
//  Copyright (c) 2015 Caitlyn Chen. All rights reserved.
//

//this project's map and login with parse works


import MapKit
import UIKit
import CoreLocation
import Parse
import ParseUI
import Bond
import FBSDKCoreKit


class MapViewController: UIViewController, CLLocationManagerDelegate, UISearchBarDelegate, MKMapViewDelegate, UITextFieldDelegate {
    
    @IBOutlet weak var logoutButton: UIBarButtonItem!
    @IBOutlet weak var cancel: UIButton!
    var annotationCurrent: PinAnnotation?
    
    var searchController:UISearchController!
    var annotation:MKAnnotation!
    var localSearchRequest:MKLocalSearchRequest!
    var localSearch:MKLocalSearch!
    var localSearchResponse:MKLocalSearchResponse!
    var error:NSError!
    var pointAnnotation:MKPointAnnotation!
    var pinAnnotationView:MKPinAnnotationView!
    
    @IBOutlet weak var toolbar: UIToolbar!
    var ann: PinAnnotation?
    
    @IBOutlet weak var cancelSearchBar: UIButton!
    var points: [PFGeoPoint] = []
    
    var locationManager = CLLocationManager()
    let loginViewController = PFLogInViewController()
    var parseLoginHelper: ParseLoginHelper!
    
    var mapAnnoations: [PinAnnotation] = []
    
    var flagBond: Bond<[PFUser]?>!
    
    @IBOutlet weak var autocompleteTextfield: AutoCompleteTextField!
    
    private var responseData:NSMutableData?
    private var selectedPointAnnotation:MKPointAnnotation?
    private var connection:NSURLConnection?
    
    private let googleMapsKey = "AIzaSyD8-OfZ21X2QLS1xLzu1CLCfPVmGtch7lo"
    private let baseURLString = "https://maps.googleapis.com/maps/api/place/autocomplete/json"
    
    
    @IBAction func unwindToVC(segue:UIStoryboardSegue) {
        if(segue.identifier == "fromPostToMap"){
            if PFUser.currentUser() != nil{
                toolbar.hidden = false
            } else{
                toolbar.hidden = true
            }

            
        }
        
    }
    
    
    
    
    @IBAction func logoutTapped(sender: AnyObject) {
        let actionSheetController: UIAlertController = UIAlertController(title: "Logout", message: "Are you sure you want to logout?", preferredStyle: .Alert)
        
        //Create and add the Cancel action
        let cancelAction: UIAlertAction = UIAlertAction(title: "No", style: .Cancel) { action -> Void in
            //Do some stuff
            
        }
        actionSheetController.addAction(cancelAction)
        //Create and an option action
        let nextAction: UIAlertAction = UIAlertAction(title: "Yes", style: .Default) { action -> Void in
            //Do some other stuff
            PFUser.logOut()
            let logoutNotification: UIAlertController = UIAlertController(title: "Logout", message: "Successfully Logged Out!", preferredStyle: .Alert)
            
            
            self.presentViewController(logoutNotification, animated: true, completion: nil)
            logoutNotification.dismissViewControllerAnimated(true, completion: nil)
            self.toolbar.hidden = true
            
        }
        actionSheetController.addAction(nextAction)
        //Add a text field
        
        
        //Present the AlertController
        self.presentViewController(actionSheetController, animated: true, completion: nil)
        
    }
    override func shouldPerformSegueWithIdentifier(identifier: String?, sender: AnyObject?) -> Bool {
        if let ident = identifier {
            if ident == "segueToPostDisplay" {
                if let user = PFUser.currentUser(){
                    println("Should show post display View Controller")
                    return true
                    //show post display view controller
                    //                    var postDisplayViewController = self.storyboard?.instantiateViewControllerWithIdentifier("postDisplayViewController") as! PostDisplayViewController
                    //                    self.presentViewController(postDisplayViewController, animated: true, completion: nil)
                    
                    
                } else {
                    
                    
                    loginViewController.fields = .UsernameAndPassword | .LogInButton | .SignUpButton | .PasswordForgotten | .Facebook
                    
                    loginViewController.logInView?.backgroundColor = UIColor.whiteColor()
                    let logo = UIImage(named: "logo")
                    let logoView = UIImageView(image: logo)
                    loginViewController.logInView?.logo = logoView
                    
                    
                    
                    
                    parseLoginHelper = ParseLoginHelper {[unowned self] user, error in
                        // Initialize the ParseLoginHelper with a callback
                        println("before the error")
                        if let error = error {
                            // 1
                            ErrorHandling.defaultErrorHandler(error)
                        } else  if let user = user {
                            // if login was successful, display the TabBarController
                            // 2
                            println("show post  view controller")
                            
                            self.loginViewController.dismissViewControllerAnimated(true, completion: nil)
                            //****
                            
                            
                        }
                    }
                    
                    loginViewController.delegate = parseLoginHelper
                    loginViewController.signUpController?.delegate = parseLoginHelper

                    
                    
                    
                    self.presentViewController(loginViewController, animated: true, completion: nil)
                    return false
                    
                }
            }
        }
        
        return false
    }
    

    
    override func viewDidLayoutSubviews() {
        
        super.viewDidLayoutSubviews()
        

        self.loginViewController.logInView?.logo?.frame = CGRect(x: 80.0, y: 70.0, width: 187.0, height: 119.1)
        
    }
  
    @IBOutlet var mapView: MKMapView!
    
    func textFieldDidBeginEditing(textField: UITextField) {
        cancel.hidden = false
    }
    
    
    //    var flagged: [AnyObject]?
    //    var flaggedPosts: [Post]?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        if PFUser.currentUser() != nil{
            toolbar.hidden = false
        } else{
            toolbar.hidden = true
        }
        
        cancel.hidden = true
        
        autocompleteTextfield.delegate = self
        
        
        configureTextField()
        handleTextFieldInterfaces()
        println("in MapViewController")
        
        // Do any additional setup after loading the view, typically from a nib.
        locationManager.delegate = self
        mapView.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        
    }
    
    @IBAction func cancelTapped(sender: AnyObject) {
        
        autocompleteTextfield = nil
    }
    @IBOutlet weak var navbar: UINavigationBar!
    @IBAction func showSearchBar(sender: AnyObject) {
        let countlol = mapAnnoations.count
        println(countlol)
        navbar.hidden = true
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func locationManager(manager: CLLocationManager!, didFailWithError error: NSError!) {
        println("error")
    }
    
    func toolBar() {
        if PFUser.currentUser() != nil{
            toolbar.hidden = false
        } else{
            toolbar.hidden = true
        }

    }
    
    //var point = PinAnnotation(title: "newPoint", coordinate: currentLocation!)
    var lat: CLLocationDegrees?
    var long: CLLocationDegrees?
    var currentLocation: CLLocationCoordinate2D?
    var regionCenter: CLLocationCoordinate2D?
    
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        
        var userLocation : CLLocation = locations[0] as! CLLocation
        
        self.lat = userLocation.coordinate.latitude
        self.long = userLocation.coordinate.longitude
        
        //self.mapView.addAnnotation(point)
        
        let location = CLLocationCoordinate2D(latitude: userLocation.coordinate.latitude, longitude: userLocation.coordinate.longitude)
        
        
        let span = MKCoordinateSpanMake(0.05, 0.05)
        
        let region = MKCoordinateRegion(center: location, span: span)
        
        regionCenter = region.center
        
        mapView.setRegion(region, animated: true)
        
        var loc = PFGeoPoint(latitude: lat!, longitude: long!)
        
        
        
        let postsQuery = PFQuery(className: "Post")
        
        postsQuery.whereKey("location", nearGeoPoint: loc, withinMiles: 5.0)
        //finds all posts near current locations
        
        var posts = postsQuery.findObjects()
        
        //        println(posts![0])
        //
        
        if let pts = posts {
            for post in pts {
                
                println(pts.count)
                println("posts from parse")
                
                var postcurrent = post as! Post
                
                postcurrent.fetchFlags()
                
                
                flagBond = Bond<[PFUser]?>() { [unowned self] flagList in
                    
                    if let flagList = flagList {
                        if flagList.count > 0 {
                            postcurrent.delete()
                        }
                        
                    }
                    
                }
                
                postcurrent.flags ->> flagBond
                
                if postcurrent.imageFile != nil && postcurrent.RecipeTitle != nil && postcurrent.location != nil && postcurrent.caption != nil && postcurrent.country != nil && postcurrent.Instructions != nil && postcurrent.user != nil && postcurrent.date != nil && postcurrent.prep != nil && postcurrent.cook != nil && postcurrent.servings != nil {
                    println(" make stuff")
                    let lati = postcurrent.location!.latitude
                    let longi = postcurrent.location!.longitude
                    let coor = CLLocationCoordinate2D(latitude: lati, longitude: longi)
                    
                    var annotationcurrent = PinAnnotation?()
                    
                    
                    annotationcurrent = PinAnnotation(title: postcurrent.RecipeTitle!, coordinate: coor, Description: postcurrent.caption!, country: postcurrent.country!, instructions: postcurrent.Instructions!, ingredients: postcurrent.Ingredients!, image: postcurrent.imageFile!, user: postcurrent.user!, date: postcurrent.date!, prep: postcurrent.prep!, cook: postcurrent.cook!, servings: postcurrent.servings!, post: postcurrent)
                    
                    
                    self.mapAnnoations.append(annotationcurrent!)
                    println("append")
                    //for anno in mapAnnoations {
                    self.mapView.addAnnotation(annotationcurrent)
                }
            }
        }
        
        //        for anno in mapAnnoations {
        //            mapView.addAnnotation(anno)
        //        }
        
        locationManager.stopUpdatingLocation()
        
        
    }
    
   
    
    func mapView(mapView: MKMapView!, viewForAnnotation annotation: MKAnnotation!) -> MKAnnotationView! {
        var view: MKAnnotationView?
        //let annotation1 = self.mapAnnoations[0]
        if annotation is MKUserLocation{
            return nil
        } else if !(annotation is PinAnnotation) {
            return nil
        }
        
        var anView: MKAnnotationView?
        
        if fromTxtField == false{
            
            // for annotation in mapAnnoations{
            
            println("mapAnnotationS: \(mapAnnoations.count)")
            println("make anno")
            let identifier = "postsFromParseAnnotations"
            
            anView = mapView.dequeueReusableAnnotationViewWithIdentifier(identifier)
            if anView == nil {
                anView = MKAnnotationView(annotation: annotation, reuseIdentifier: identifier)
                anView!.canShowCallout = true
//                anView!.calloutOffset = CGPoint(x: -10, y: 5)
            }
                
            else {
                
                anView!.annotation = annotation
                
            }
            
            let pinanno = annotation as! PinAnnotation
            if (pinanno.image.getData() != nil){
                let data = pinanno.image.getData()
                let size = CGSize(width: 30.0, height: 30.0)
                
                let imagee = UIImage(data: data!)
                let scaledImage = imageResize(imagee!, sizeChange: size)
                anView!.image = scaledImage
                
                let button = UIButton.buttonWithType(UIButtonType.Custom) as! UIButton
                let float = CGFloat(count(pinanno.title))
                let newFloat = float * 12
                button.frame.size.width = newFloat
                button.frame.size.height = 44
                button.backgroundColor = UIColor.blackColor()
                //                var imagebutton: UIImage = UIImage(data: data!)!
                
                button.setTitle(pinanno.title, forState: .Normal)
                
                //button.backgroundColor = UIColor.redColor()
                //button.setImage(UIImage(named: "trash"), forState: .Normal)
                anView!.leftCalloutAccessoryView = button
                
                
            }
            
            // }
            
        } else{
            let reuseId = "hi"
            
            var anView = mapView.dequeueReusableAnnotationViewWithIdentifier(reuseId) as? MKPinAnnotationView
            if anView == nil {
                anView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
                anView!.canShowCallout = true
                anView!.animatesDrop = true
                anView!.pinColor = .Purple
            }
            else {
                anView!.annotation = annotation
            }
            
            fromTxtField = false
        }
        return anView
    }
    
    
    
    func imageResize (imageObj:UIImage, sizeChange:CGSize)-> UIImage{
        
        let hasAlpha = false
        let scale: CGFloat = 0.0 // Automatically use scale factor of main screen
        
        UIGraphicsBeginImageContextWithOptions(sizeChange, !hasAlpha, scale)
        imageObj.drawInRect(CGRect(origin: CGPointZero, size: sizeChange))
        
        let scaledImage = UIGraphicsGetImageFromCurrentImageContext()
        return scaledImage
    }
    
    func mapView(mapView: MKMapView!, annotationView view: MKAnnotationView!, calloutAccessoryControlTapped control: UIControl!) {
        if let annotation = view.annotation as? PinAnnotation {
            
            performSegueWithIdentifier("toPostView", sender: annotation)
        }
    }
    
    var coordinateAfterPosted: CLLocationCoordinate2D?
    
    override func viewWillAppear(animated: Bool) {
        if annotationCurrent != nil{
            coordinateAfterPosted = annotationCurrent?.coordinate
            self.mapView.setCenterCoordinate(coordinateAfterPosted!, animated: true)
            
            mapView.addAnnotation(annotationCurrent)
            
            if PFUser.currentUser() != nil{
                toolbar.hidden = false
            } else{
                toolbar.hidden = true
            }
        } else if ann != nil {
            mapView.removeAnnotation(ann)
            if PFUser.currentUser() != nil{
                toolbar.hidden = false
            } else{
                toolbar.hidden = true
            }
        }
        
        toolBar()
    }
    
    
    private func configureTextField(){
        autocompleteTextfield.autoCompleteTextColor = UIColor(red: 128.0/255.0, green: 128.0/255.0, blue: 128.0/255.0, alpha: 1.0)
        autocompleteTextfield.autoCompleteTextFont = UIFont(name: "HelveticaNeue-Light", size: 12.0)
        autocompleteTextfield.autoCompleteCellHeight = 35.0
        autocompleteTextfield.maximumAutoCompleteCount = 20
        autocompleteTextfield.hidesWhenSelected = true
        autocompleteTextfield.hidesWhenEmpty = true
        autocompleteTextfield.enableAttributedText = true
        var attributes = [String:AnyObject]()
        attributes[NSForegroundColorAttributeName] = UIColor.blackColor()
        attributes[NSFontAttributeName] = UIFont(name: "HelveticaNeue-Bold", size: 12.0)
        autocompleteTextfield.autoCompleteAttributes = attributes
    }
    
    private func handleTextFieldInterfaces(){
        autocompleteTextfield.onTextChange = {[weak self] text in
            if !text.isEmpty{
                if self!.connection != nil{
                    self!.connection!.cancel()
                    self!.connection = nil
                }
                let urlString = "\(self!.baseURLString)?key=\(self!.googleMapsKey)&input=\(text)"
                let url = NSURL(string: urlString.stringByAddingPercentEscapesUsingEncoding(NSASCIIStringEncoding)!)
                if url != nil{
                    let urlRequest = NSURLRequest(URL: url!)
                    self!.connection = NSURLConnection(request: urlRequest, delegate: self)
                }
            }
        }
        
        autocompleteTextfield.onSelect = {[weak self] text, indexpath in
            Location.geocodeAddressString(text, completion: { (placemark, error) -> Void in
                if placemark != nil{
                    self!.autocompleteTextfield.text = text
                    self!.autocompleteTextfield.resignFirstResponder()
                    let coordinate = placemark!.location.coordinate
                    self!.addAnnotation(coordinate, address: text)
                    self?.mapView.setCenterCoordinate(coordinate, animated: true)
                }
            })
        }
    }
    
    
    //MARK: NSURLConnectionDelegate
    func connection(connection: NSURLConnection, didReceiveResponse response: NSURLResponse) {
        responseData = NSMutableData()
    }
    
    func connection(connection: NSURLConnection, didReceiveData data: NSData) {
        responseData?.appendData(data)
    }
    
    func connectionDidFinishLoading(connection: NSURLConnection) {
        if responseData != nil{
            var error:NSError?
            if let result = NSJSONSerialization.JSONObjectWithData(responseData!, options: nil, error: &error) as? NSDictionary{
                let status = result["status"] as? String
                if status == "OK"{
                    if let predictions = result["predictions"] as? NSArray{
                        var locations = [String]()
                        for dict in predictions as! [NSDictionary]{
                            locations.append(dict["description"] as! String)
                        }
                        self.autocompleteTextfield.autoCompleteStrings = locations
                    }
                }
                else{
                    self.autocompleteTextfield.autoCompleteStrings = nil
                }
            }
        }
    }
    
    func connection(connection: NSURLConnection, didFailWithError error: NSError) {
        println("Error: \(error.localizedDescription)")
    }
    
    var fromTxtField: Bool = false
    //MARK: Map Utilities
    private func addAnnotation(coordinate:CLLocationCoordinate2D, address:String?){
        if selectedPointAnnotation != nil{
            mapView.removeAnnotation(selectedPointAnnotation)
        }
        fromTxtField = true
        selectedPointAnnotation = MKPointAnnotation()
        selectedPointAnnotation?.coordinate = coordinate
        selectedPointAnnotation?.title = address
        mapView.addAnnotation(selectedPointAnnotation)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "segueToPostDisplay") {
            var svc = segue.destinationViewController as! PostDisplayViewController;
            
            svc.toLoc = PFGeoPoint(latitude: lat!, longitude: long!)
        }
        
        if (segue.identifier == "toPostView"){
            var annotation = sender as! PinAnnotation
            
            var svc = segue.destinationViewController as! PostViewController;
            svc.anno = annotation
            svc.post = annotation.post
            svc.login = loginViewController
        }
    }
    
    
    @IBAction func cancelSerachBar(sender: AnyObject) {
        autocompleteTextfield.text = nil
        navbar.hidden = false
        
    }
    
    
}