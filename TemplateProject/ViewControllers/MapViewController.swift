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
    
    var locationManager = CLLocationManager()
    let loginViewController = PFLogInViewController()
    var parseLoginHelper: ParseLoginHelper!
    
    
    override func shouldPerformSegueWithIdentifier(identifier: String?, sender: AnyObject?) -> Bool {
        if let ident = identifier {
            if ident == "segueToPostDisplay" {
                if let user = PFUser.currentUser(){
                    println("should show post display View Controller")
                    
                    //show post display view controller
                    var postDisplayViewController = self.storyboard?.instantiateViewControllerWithIdentifier("postDisplayViewController") as! PostDisplayViewController
                    self.presentViewController(postDisplayViewController, animated: true, completion: nil)
                    
                } else {
                    
                    
                    loginViewController.fields = .UsernameAndPassword | .LogInButton | .SignUpButton | .PasswordForgotten | .Facebook
                    
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
                    
                    
                }
            }
        }
        
    }
    
            @IBOutlet var mapView: MKMapView!
            
            override func viewDidLoad() {
                super.viewDidLoad()
                
                // Do any additional setup after loading the view, typically from a nib.
                locationManager.delegate = self
                locationManager.desiredAccuracy = kCLLocationAccuracyBest
                locationManager.requestWhenInUseAuthorization()
                locationManager.startUpdatingLocation()
                
                //        let query = PFQuery(className: "Post")
                //        query.whereKey("recipeTitle", equalTo: user())
                //
                //
                //        query.findObjectsInBackgroundWithBlock {
                //            (results: [AnyObject]?, error: NSError?) -> Void in
                //            // 2
                //            if let results = results as? [PFObject] {
                //                for likes in results {
                //                    likes.deleteInBackgroundWithBlock(ErrorHandling.errorHandlingCallback)
                //                }
                //            }
                //        }
                
                
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
            
            func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
                var userLocation : CLLocation = locations[0] as! CLLocation
                
                var point = MKPointAnnotation()
                point.coordinate = CLLocationCoordinate2D(latitude: userLocation.coordinate.latitude, longitude: userLocation.coordinate.longitude)
                self.mapView.addAnnotation(point)
                
                var anView: MKAnnotationView = mapView(self.mapView, viewForAnnotation: point)
                
                locationManager.stopUpdatingLocation()
                
                let location = CLLocationCoordinate2D(latitude: userLocation.coordinate.latitude, longitude: userLocation.coordinate.longitude)
                
                let span = MKCoordinateSpanMake(0.05, 0.05)
                
                let region = MKCoordinateRegion(center: location, span: span)
                
                mapView.setRegion(region, animated: true)
            }
            
            
            func mapView(mapView: MKMapView!, viewForAnnotation annotation: MKAnnotation!) -> MKAnnotationView! {
                if !(annotation is MKPointAnnotation) {
                    return nil
                }
                
                let reuseId = "test"
                
                var anView = mapView.dequeueReusableAnnotationViewWithIdentifier(reuseId)
                if anView == nil {
                    anView = MKAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
                    //anView.image = image from Display View
                    anView.canShowCallout = true
                }
                else {
                    anView.annotation = annotation
                }
                
                return anView
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
            
            
}