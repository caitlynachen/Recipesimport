import MapKit
import Foundation
import UIKit
import Parse

class PinAnnotation : NSObject, MKAnnotation {
    
    let title: String
    let coordinate: CLLocationCoordinate2D
    let Description: String
    let country:String
    let instructions: [String]
    let ingredients: [String]
    let image: PFFile
    let user: PFUser
    let date: NSDate
    let post: PFObject
    
    
    init (title: String, coordinate: CLLocationCoordinate2D, Description: String, country: String, instructions: [String], ingredients: [String], image:PFFile, user: PFUser, date: NSDate, post: PFObject) {
        self.title = title
        self.coordinate = coordinate
        self.Description = Description
        self.country = country
        self.ingredients = ingredients
        self.instructions = instructions
        self.image = image
        self.user = user
        self.date = date
        self.post = post
        
        
    }
    
//    private var coord: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 0, longitude: 0)
//    
//    var coordinate: CLLocationCoordinate2D {
//        get {
//            return coord
//        }
//    }
//    
//    var title: String = ""
//    var subtitle: String = ""
//    
//    func setCoordinate(newCoordinate: CLLocationCoordinate2D) {
//        self.coord = newCoordinate
//    }
}