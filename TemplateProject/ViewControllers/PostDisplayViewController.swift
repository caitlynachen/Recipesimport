//
//  PostDisplayViewController.swift
//  TemplateProject
//
//  Created by Caitlyn Chen on 7/6/15.
//  Copyright (c) 2015 Make School. All rights reserved.
//

import UIKit
import Parse
import Bond

class PostDisplayViewController: UIViewController, UINavigationControllerDelegate,UIImagePickerControllerDelegate, UITableViewDelegate, UITableViewDataSource, UITextViewDelegate {
    
    @IBAction func backButton(sender: AnyObject) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let mapViewController = storyboard.instantiateViewControllerWithIdentifier("MapViewController") as! MapViewController
        self.dismissViewControllerAnimated(false, completion: nil)
        self.presentViewController(mapViewController, animated: true, completion: nil)
    }
    @IBOutlet weak var ingredientsTableView: UITableView!
    @IBOutlet weak var postButton: UIButton!

    var placeholderLabel: UILabel!
    @IBOutlet weak var descriptionText: UITextView!
   
    @IBOutlet weak var countryTextField: UITextField!
    var toLoc: PFGeoPoint?
    var photoTakingHelper: PhotoTakingHelper?
    
    @IBOutlet weak var titleTextField: UITextField!
    

    @IBOutlet weak var imageView: UIImageView?
    
    @IBOutlet weak var instructionTableView: UITableView!
    
    let post = Post()
    
    var postToEdit: PFObject?
    var titlerecipe: String?
    var countryrecipe: String?
    var ingredientsrecipe: [String]?
    var instructionsrecipe: [String]?
    var image: UIImage?
    var Description: String?
    
    @IBOutlet weak var cameraButton: UIButton!
    
    override func viewWillAppear(animated: Bool) {
        if ingredientsrecipe != nil && instructionsrecipe != nil && titlerecipe != nil && Description != nil && image != nil && countryrecipe != nil {
        titleTextField.text = titlerecipe
        descriptionText.text = Description
        imageView?.image = image
        countryTextField.text = countryrecipe
        ingredientsArray = ingredientsrecipe!
        instructionsArray = instructionsrecipe!
        placeholderLabel.hidden = count(descriptionText.text) != 0

            
        }
    }
    override func shouldPerformSegueWithIdentifier(identifier: String?, sender: AnyObject?) -> Bool {
        if let ident = identifier {
            if ident == "fromPostDiplayToMap" {
                
                return true
                
            }
        }
        
        return false
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "fromPostDiplayToMap") {
            createPost()
            var svc = segue.destinationViewController as! MapViewController;
            
            svc.annotationCurrent = currentAnnotation
        }
    }
    @IBAction func cameraButtonTapped(sender: AnyObject) {
        //println("hi")        
        photoTakingHelper =
            PhotoTakingHelper(viewController: self) { (image: UIImage?) in
                // 1
                self.post.image.value = image!
                self.imageView?.image = image!
                //self.imageView?.clipsToBounds = true
                let imageData = UIImageJPEGRepresentation(image, 0.8)
                let imageFile = PFFile(data: imageData)
                //imageFile.save()
                
                //let post = PFObject(className: "Post")
                self.post["imageFile"] = imageFile
                self.post.save()
                
               
              

        }
      
    }
    
    //var ingredientsDict: [String:String] = [:]
    var ingredientsArray: [String] = []
    var ingredientBond:Bond<String>!
    var instructionsArray: [String] = []
    var instructionBond:Bond<String>!
    
    var numOfRows: Int = 13
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == ingredientsTableView {
            return numOfRows // Create 1 row as an example
        } else {
            return numOfRows
        }
    }
    
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if tableView == ingredientsTableView {
           
            let cell = tableView.dequeueReusableCellWithIdentifier("IngredientsInputCell") as! IngredientsTableViewCell
                
            if indexPath.row == 0 {
                cell.configure(text: "", placeholder: "Ex. 1 cup of flour")
                
            } else{
                cell.configure(text: "", placeholder: "")

            }
            
            cell.ingredient.map { $0 } ->> ingredientBond
            
            return cell
        } else {
            let cell = tableView.dequeueReusableCellWithIdentifier("InstructionsInputCell") as! InstructionsTableViewCell
            
            cell.instruction.map { $0 } ->> instructionBond
            
            
            //instructionsArray?.append(cell.textField.text)
            if indexPath.row == 0 {
                cell.configure(text: "", placeholder: "Ex. 1 cup of flour")
                
            } else{
                cell.configure(text: "", placeholder: "")
                
            }
            return cell
        }
      
    }
    
    func textViewDidChange(textView: UITextView) {
        placeholderLabel.hidden = count(textView.text) != 0
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        descriptionText.delegate = self
        placeholderLabel = UILabel()
        placeholderLabel.text = "Write a caption..."
        placeholderLabel.sizeToFit()
        descriptionText.addSubview(placeholderLabel)

        placeholderLabel.frame.origin = CGPointMake(5, descriptionText.font.pointSize / 2)
        placeholderLabel.textColor = UIColor(white: 0, alpha: 0.3)
        placeholderLabel.hidden = count(descriptionText.text) != 0
        

        if postToEdit != nil{
            postButton.setTitle("DONE", forState: .Normal)
            
        }
        
        
        ingredientBond = Bond<String>(){ ingredient in

            var contained = contains(self.ingredientsArray, ingredient)
            if contained == false && ingredient != "" {
                self.ingredientsArray.append(ingredient)
            }
        }
        
        instructionBond = Bond<String>(){ instruction in
            var contained = contains(self.instructionsArray, instruction)
            if contained == false && instruction != "" {
                self.instructionsArray.append(instruction)
            }
        }

            
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    var currentAnnotation: PinAnnotation?


    func createPost(){

        //var instructionsViewController = InstructionsViewController()
    
        post.Description = descriptionText.text
        post.RecipeTitle = titleTextField.text
        post.country = countryTextField.text
        post.location = toLoc
        post.Ingredients = self.ingredientsArray
        post.Instructions = self.instructionsArray
        post.date = post.createdAt!
        
        
        post.save()
        post.uploadPost()
        
        
        
        
        
        let lat = post.location?.latitude
        let long = post.location?.longitude
        var coordinateh = CLLocationCoordinate2D(latitude: lat!, longitude: long!)
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let mapViewController = storyboard.instantiateViewControllerWithIdentifier("MapViewController") as! MapViewController
        //RELOAD MAPVIEW
        //mapViewController.reloadInputViews()
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
        var postcurrent = post
        
        var long1: CLLocationDegrees = location.longitude
        var lat1: CLLocationDegrees = location.latitude
        var coordinate: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: lat1, longitude: long1)
        
        var annotation = PinAnnotation(title: title, coordinate: coordinate, Description: description, country: country, instructions: instructions, ingredients: ingredients, image: image, user: user, date: date, post: postcurrent)
       
        currentAnnotation = annotation
    //mapView.mapView.addAnnotation(annotation)
        
        mapViewController.viewWillAppear(true)
        
        //map.locationManager(CLLocationManager, didUpdateLocations: )
        
//        if (self.titleTextField == nil){
//            println("add title")
//        }
//        if(self.imageView?.image == nil){
//            println("add image")
//        }
//        if (ingredientsViewController.ingredientsArray?.count == 0){
//            println("add ingredients")
//        }
//        if (instructionsViewController.instructionsArray?.count == 0){
//            println("add instructions")
//        } else {
//            post.uploadPost()
//        }
    }
    
   

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
//    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
//        if (segue.identifier == "unwind") {
//            
//            createPost()
//            // pass data to next view
//        }
//    }


}