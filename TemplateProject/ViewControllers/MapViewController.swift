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


class MapViewController: UIViewController, CLLocationManagerDelegate, UISearchBarDelegate, MKMapViewDelegate {
    
    var searchController:UISearchController!
    var annotation:MKAnnotation!
    var localSearchRequest:MKLocalSearchRequest!
    var localSearch:MKLocalSearch!
    var localSearchResponse:MKLocalSearchResponse!
    var error:NSError!
    var pointAnnotation:MKPointAnnotation!
    var pinAnnotationView:MKPinAnnotationView!
    
    var points: [PFGeoPoint] = []
    
    var locationManager = CLLocationManager()
    let loginViewController = PFLogInViewController()
    var parseLoginHelper: ParseLoginHelper!
    
    var mapAnnoations: [PinAnnotation] = []
    
    @IBOutlet weak var logoView: UIView!
    
    @IBAction func unwindToVC(segue:UIStoryboardSegue) {
        if(segue.identifier == "fromPostToMap"){
            
        }
        
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
                    loginViewController.logInView?.logo = self.logoView
                    
                    
                    parseLoginHelper = ParseLoginHelper {[unowned self] user, error in
                        // Initialize the ParseLoginHelper with a callback
                        println("before the error")
                        if let error = error {
                            // 1
                            ErrorHandling.defaultErrorHandler(error)
                        } else  if let user = user {
                            // if login was successful, display the TabBarController
                            // 2
                            println("show post display view controller")
                            
                            let storyboard = UIStoryboard(name: "Main", bundle: nil)
                            let postDisplayViewController = storyboard.instantiateViewControllerWithIdentifier("postDisplayViewController") as! PostDisplayViewController
                            self.dismissViewControllerAnimated(false, completion: nil)
                            self.presentViewController(postDisplayViewController, animated: true, completion: nil)
                            
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
    
    @IBOutlet var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        println("in MapViewController")
        
        // Do any additional setup after loading the view, typically from a nib.
        locationManager.delegate = self
        mapView.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        
    }
    
    @IBAction func showSearchBar(sender: AnyObject) {
        searchController = UISearchController(searchResultsController: nil)
        searchController.hidesNavigationBarDuringPresentation = false
        self.searchController.searchBar.delegate = self
        presentViewController(searchController, animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func locationManager(manager: CLLocationManager!, didFailWithError error: NSError!) {
        println("error")
    }
    
    //var point = PinAnnotation(title: "newPoint", coordinate: currentLocation!)
    var lat: CLLocationDegrees?
    var long: CLLocationDegrees?
    var currentLocation: CLLocationCoordinate2D?
    
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        
        var userLocation : CLLocation = locations[0] as! CLLocation
        
        self.lat = userLocation.coordinate.latitude
        self.long = userLocation.coordinate.longitude
        
        //self.mapView.addAnnotation(point)
        
        let location = CLLocationCoordinate2D(latitude: userLocation.coordinate.latitude, longitude: userLocation.coordinate.longitude)
        
        currentLocation = location
        
        let span = MKCoordinateSpanMake(0.05, 0.05)
        
        let region = MKCoordinateRegion(center: location, span: span)
        
        mapView.setRegion(region, animated: true)
        
        let postsQuery = PFQuery(className: "Post")
        
        var loc = PFGeoPoint(latitude: lat!, longitude: long!)
        
        postsQuery.whereKey("location", nearGeoPoint: loc, withinMiles: 100.0)
        //finds all posts near current locations
        
        var posts = postsQuery.findObjects()
        
        //        println(posts![0])
        //
        
        if let pts = posts {
            for post in pts {
                var location = post.objectForKey("location")! as! PFGeoPoint
                var image = post.objectForKey("imageFile")! as! PFFile
                var title = post.objectForKey("RecipeTitle") as! String
                var description = post.objectForKey("description") as! String
                var country = post.objectForKey("country") as! String
                var instructions = post.objectForKey("Instructions") as! [String]
                var ingredients = post.objectForKey("Ingredients") as! [String]
                var user = post.objectForKey("user") as! PFUser
                //println(post.objectForKey("createdAt"))
                var date = post.objectForKey("date") as! NSDate
                
                //println(post.objectForKey("date"))
                
               
                var long1: CLLocationDegrees = location.longitude
                var lat1: CLLocationDegrees = location.latitude
                var coordinate: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: lat1, longitude: long1)
                var annotation = PinAnnotation(title: title, coordinate: coordinate, Description: description, country: country, instructions: instructions, ingredients: ingredients, image: image, user: user, date: date)
                
                mapAnnoations.append(annotation)
                self.mapView.addAnnotation(annotation)
                
            }
            
        }
        
        locationManager.stopUpdatingLocation()
        
        
    }
    
    
    
    
    func mapView(mapView: MKMapView!, viewForAnnotation annotation: MKAnnotation!) -> MKAnnotationView! {
        var view: MKPinAnnotationView?
        //let annotation1 = self.mapAnnoations[0]
        if annotation is MKUserLocation{
            return nil
        }
        for annotation1 in mapAnnoations{
            let identifier = "pin"
            
            if let dequeuedView = mapView.dequeueReusableAnnotationViewWithIdentifier(identifier) as? MKPinAnnotationView{
                dequeuedView.annotation = annotation1
                view = dequeuedView
            } else {
                view = MKPinAnnotationView(annotation: annotation1, reuseIdentifier:identifier)
                view!.canShowCallout = true
                view!.calloutOffset = CGPoint(x: -5, y: 5)
                view!.pinColor = MKPinAnnotationColor.Purple
                
                
                let button = UIButton.buttonWithType(UIButtonType.Custom) as! UIButton
                button.frame.size.width = 44
                button.frame.size.height = 44
                var data = annotation1.image.getData()
                var imagebutton: UIImage = UIImage(data: data!)!
                
                button.setImage(imagebutton, forState: UIControlState.Normal)
                
                //button.backgroundColor = UIColor.redColor()
                //button.setImage(UIImage(named: "trash"), forState: .Normal)
                
                view!.leftCalloutAccessoryView = button
            }
            
        }
        return view
    }
    
    func mapView(mapView: MKMapView!, annotationView view: MKAnnotationView!, calloutAccessoryControlTapped control: UIControl!) {
        if let annotation = view.annotation as? PinAnnotation {
            
            performSegueWithIdentifier("toPostView", sender: annotation)
        }
    }
    
    
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar){
        //1
        searchBar.resignFirstResponder()
        dismissViewControllerAnimated(true, completion: nil)
        if self.mapView.annotations.count != 0{
            annotation = self.mapView.annotations[0] as! MKAnnotation
            self.mapView.removeAnnotation(annotation)
        }
        //2
        localSearchRequest = MKLocalSearchRequest()
        localSearchRequest.naturalLanguageQuery = searchBar.text
        localSearch = MKLocalSearch(request: localSearchRequest)
        localSearch.startWithCompletionHandler { (localSearchResponse, error) -> Void in
            
            if localSearchResponse == nil{
                var alert = UIAlertView(title: nil, message: "Place not found", delegate: self, cancelButtonTitle: "Try again")
                alert.show()
                return
            }
            //3
            self.pointAnnotation = MKPointAnnotation()
            self.pointAnnotation.title = searchBar.text
            self.pointAnnotation.coordinate = CLLocationCoordinate2D(latitude: localSearchResponse.boundingRegion.center.latitude, longitude:     localSearchResponse.boundingRegion.center.longitude)
            
            
            self.pinAnnotationView = MKPinAnnotationView(annotation: self.pointAnnotation, reuseIdentifier: nil)
            self.mapView.centerCoordinate = self.pointAnnotation.coordinate
            self.mapView.addAnnotation(self.pinAnnotationView.annotation)
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "segueToPostDisplay") {
            var svc = segue.destinationViewController as! PostDisplayViewController;
            
            svc.toLoc = PFGeoPoint(latitude: lat!, longitude: long!)
        }
        
        if (segue.identifier == "toPostView"){
            var annotation = sender as! PinAnnotation
            
            var svc = segue.destinationViewController as! PostViewController;
            svc.RecipeTitle = annotation.title
            svc.Description = annotation.Description
            svc.country = annotation.country
            svc.ingredients = annotation.ingredients
            svc.instructions = annotation.instructions
            
            svc.imageFile = annotation.image
            
            svc.user = annotation.user
            svc.date = annotation.date
        }
    }
    
    
    
}