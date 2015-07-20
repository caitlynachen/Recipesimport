//
////
////  ViewController.swift
////  TemplateProject
////
////  Created by Sara Subbanna on 7/9/15.
////  Copyright (c) 2015 Make School. All rights reserved.
////
//
//import UIKit
//import Parse
//import MapKit
//import CoreLocation // take out if necessary
//
//class MainViewController: UIViewController , CLLocationManagerDelegate {
//    
//    @IBOutlet weak var mapView: MKMapView!
//    @IBOutlet weak var titleLabel: UILabel!
//    @IBOutlet weak var scrollView: UIScrollView!
//    @IBOutlet weak var startTime: UILabel!
//    @IBOutlet weak var locationLabel: UILabel!
//    @IBOutlet weak var eventImage: UIImageView!
//    @IBOutlet weak var descriptionLabel: UILabel!
//    @IBOutlet weak var nextButton: UIButton!
//    var locationManager = CLLocationManager()
//    let regionRadius: CLLocationDistance = 100000
//    var dateFormatter = NSDateFormatter()
//    var dontShowUsers = ["What", "No"]
//    var nearbyEvents: [PFObject]!
//    var count = 0
//    let locationRequest = MKLocalSearchRequest()
//    var places: [Place] = []
//    
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        scrollView.contentSize.height = 1000
//        let query = PFQuery(className: "Post")
//        //        query.whereKey("eventTitle", notContainedIn:dontShowUsers)
//        // 6
//        query.orderByDescending("createdAt")
//        
//        query.findObjectsInBackgroundWithBlock {(result: [AnyObject]?, error: NSError?) -> Void in
//            // 8
//            self.nearbyEvents = result as? [PFObject] ?? []
//            //println("in loop")
//            println(self.nearbyEvents.count)
//            println("count of nearbyEvents")
//            self.displayScreen()
//        }
//        
//        if CLLocationManager.locationServicesEnabled() {
//            self.locationManager.startUpdatingLocation()
//        }
//        
//        if CLLocationManager.authorizationStatus() == .NotDetermined {
//            self.locationManager.requestWhenInUseAuthorization()
//        }
//        
//        locationManager.delegate = self
//        locationManager.desiredAccuracy = kCLLocationAccuracyBest
//        
//        
//    }
//    
//    override func didReceiveMemoryWarning() {
//        super.didReceiveMemoryWarning()
//        // Dispose of any resources that can be recreated.
//    }
//    
//    
//    @IBAction func nextButtonTapped(sender: AnyObject) {
//        if count < nearbyEvents.count - 1
//        {
//            count++
//        }
//        else
//        {
//            count = 0
//        }
//        self.displayScreen()
//    }
//    
//    
//    
//    func locationManager(manager: CLLocationManager!, didFailWithError error: NSError!) {
//        println("error")
//    }
//    
//    
//    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
//        //self.mapView.setUserTrackingMode(MKUserTrackingMode.Follow, animated: true)
//        //Do What ever you want with it
//    }
//    
//    
//    
//    
//    
//    
//    func displayScreen(){
//        
//        //self.mapView.showsUserLocation = true
//        if self.places != []
//        {
//            self.mapView.removeAnnotation(places[0])
//        }
//        self.places = []
//        
//        let currentObject = self.nearbyEvents[count]
//        
//        descriptionLabel.text = currentObject["eventDescription"] as? String
//        
//        titleLabel.text = currentObject["eventTitle"] as? String
//        
//        startTime.text = getTimeRange(currentObject)
//        
//        locationRequest.naturalLanguageQuery = currentObject["locationName"] as? String
//        locationRequest.region = mapView.region
//        
//        let search = MKLocalSearch(request: locationRequest)
//        
//        search.startWithCompletionHandler({(response: MKLocalSearchResponse!,
//            error: NSError!) in
//            
//            if error != nil {
//                println("Error occured in search: \(error.localizedDescription)")
//            } else if response.mapItems.count == 0 {
//                println("No matches found")
//            } else {
//                println("Matches found")
//                
//                for item in response.mapItems as! [MKMapItem] {
//                    println("Name = \(item.name)")
//                    println("Phone = \(item.phoneNumber)")
//                    
//                }
//            }
//            
//            if (response.mapItems.count > 0)
//            {
//                var firstItem = response.mapItems[0] as! MKMapItem
//                
//                var x = firstItem.placemark.location.coordinate.latitude
//                self.mapView.delegate = self
//                //let newPin = Place(title: currentObject["eventTitle"] as! String,
//                //coordinate: CLLocationCoordinate2D(latitude: firstItem.placemark.location.coordinate.latitude, longitude: firstItem.placemark.location.coordinate.longitude))
//                self.places.append(Place(title: currentObject["eventTitle"] as! String, coordinate: CLLocationCoordinate2D(latitude: firstItem.placemark.location.coordinate.latitude, longitude: firstItem.placemark.location.coordinate.longitude)))
//                self.mapView.addAnnotation(self.places[0])
//                
//            }
//            
//        })
//        
//        
//        let qualityOfServiceClass = QOS_CLASS_BACKGROUND
//        let backgroundQueue = dispatch_get_global_queue(qualityOfServiceClass, 0)
//        dispatch_async(backgroundQueue, {
//            //println("This is run on the background queue")
//            let data = currentObject["imageFile"]!.getData()
//            self.eventImage.image
//                = UIImage(data: data!, scale:1.0)
//            dispatch_async(dispatch_get_main_queue(), { () -> Void in
//                //println("This is run on the main queue, after the previous code in outer block")
//                self.eventImage.image
//                    = UIImage(data: data!, scale:1.0)
//            })
//        })
//        
//    }
//    
//    
//    
//    
//    
//    
//    
//    
//    
//    
//    func getTimeRange(currentObject: PFObject) -> String {
//        var toReturn: String!
//        
//        dateFormatter.dateFormat = "MM" //format style. Browse online to get a format that fits your needs.
//        let startDate = currentObject["startTime"] as? NSDate//get the time, in this case the time an object was created.
//        var monthStartDateString = dateFormatter.stringFromDate(startDate!)
//        switch monthStartDateString{
//        case "01":
//            toReturn = "January"
//        case "02":
//            toReturn = "February"
//        case "03":
//            toReturn = "March"
//        case "04":
//            toReturn = "April"
//        case "05":
//            toReturn = "May"
//        case "06":
//            toReturn = "June"
//        case "07":
//            toReturn = "July"
//        case "08":
//            toReturn = "August"
//        case "09":
//            toReturn = "September"
//        case "10":
//            toReturn = "October"
//        case "11":
//            toReturn = "November"
//        case "12":
//            toReturn = "December"
//        default:
//            toReturn = "Unable to get month"
//        }
//        dateFormatter.dateFormat = " dd, hh:mm"
//        var startDateString = dateFormatter.stringFromDate(startDate!)
//        toReturn = toReturn + startDateString + "        -      "
//        
//        dateFormatter.dateFormat = "hh:mm"
//        let endDate = currentObject["endTime"] as? NSDate
//        var endDateString = dateFormatter.stringFromDate(endDate!)
//        //println("")
//        toReturn = toReturn + endDateString
//        return toReturn
//    }
//    
//    /*
//    // MARK: - Navigation
//    
//    // In a storyboard-based application, you will often want to do a little preparation before navigation
//    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
//    // Get the new view controller using segue.destinationViewController.
//    // Pass the selected object to the new view controller.
//    }
//    */
//    
//}
//
//extension MainViewController: MKMapViewDelegate {
//    
//    // 1
//    func mapView(mapView: MKMapView!, viewForAnnotation annotation: MKAnnotation!) -> MKAnnotationView! {
//        //        let test = annotation as! Place
//        //        let test2 = test.title
//        let annotation1 = self.places[0]
//        //        }as? Place {
//        let identifier = "pin"
//        var view: MKPinAnnotationView
//        if let dequeuedView = mapView.dequeueReusableAnnotationViewWithIdentifier(identifier)
//            as? MKPinAnnotationView { // 2
//                dequeuedView.annotation = annotation1
//                view = dequeuedView
//        } else {
//            // 3
//            view = MKPinAnnotationView(annotation: annotation1, reuseIdentifier: identifier)
//            view.canShowCallout = true
//            view.calloutOffset = CGPoint(x: -5, y: 5)
//            view.rightCalloutAccessoryView = UIButton.buttonWithType(.DetailDisclosure) as! UIView
//            view.pinColor = MKPinAnnotationColor.Red
//        }
//        return view
//        //}
//        //return nil
//    }
//}
