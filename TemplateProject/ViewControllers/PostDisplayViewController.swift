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
    
    
    
    var photoTakingHelper: PhotoTakingHelper?
    
    @IBOutlet weak var countryTextField: UITextField!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var imageView: UIImageView?
    @IBOutlet weak var instructionTableView: UITableView!
    @IBOutlet weak var descriptionText: UITextView!
    @IBOutlet weak var ingredientsTableView: UITableView!
    @IBOutlet weak var postButton: UIButton!
    
    var placeholderLabel: UILabel!
    
    
    let post = Post()
    
    var toLoc: PFGeoPoint?
    var image: UIImage?
    var annotation: PinAnnotation?
    @IBOutlet weak var cameraButton: UIButton!
    
    var ing: [String]?
    var ins: [String]?
    
    
    @IBAction func backButton(sender: AnyObject) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let mapViewController = storyboard.instantiateViewControllerWithIdentifier("MapViewController") as! MapViewController
        self.dismissViewControllerAnimated(false, completion: nil)
        self.presentViewController(mapViewController, animated: true, completion: nil)
    }
    
    override func viewWillAppear(animated: Bool) {
        if annotation?.ingredients != nil && annotation?.instructions != nil && annotation?.title != nil && annotation?.Description != nil && annotation?.image != nil && annotation?.country != nil {
            titleTextField.text = annotation?.title
            descriptionText.text = annotation?.Description
            var data = annotation?.image.getData()
            image = UIImage(data: data!)
            imageView?.image = image
            countryTextField.text = annotation?.country
            
            ing = annotation?.ingredients
            ins = annotation?.instructions
            
            ingredientsArray = ing!
            instructionsArray = ins!
            
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
            if annotation?.post == nil{
                createPost()

            } else {
                updatePost()
            }
            
            
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
            
            if (indexPath.row < ingredientsArray.count){
                cell.textField.text = ingredientsArray[indexPath.row]
            }
            else{
                if indexPath.row == 0 {
                    cell.configure(text: "", placeholder: "Ex. 1 cup of flour")
                    
                } else{
                    cell.configure(text: "", placeholder: "")
                    
                }
            }
            
            cell.ingredient.map { $0 } ->> ingredientBond
            
            return cell
        } else {
            let cell = tableView.dequeueReusableCellWithIdentifier("InstructionsInputCell") as! InstructionsTableViewCell
            
            
            if (indexPath.row < instructionsArray.count){
                cell.textField.text = instructionsArray[indexPath.row]
            }
                
            else{
                if indexPath.row == 0 {
                    cell.configure(text: "", placeholder: "Ex. 1 cup of flour")
                    
                } else{
                    cell.configure(text: "", placeholder: "")
                    
                }
            }
            appendIngredientsAndInstructions()
            
            cell.instruction.map { $0 } ->> instructionBond

            return cell
        }
        
    }
    
    func textViewDidChange(textView: UITextView) {
        placeholderLabel.hidden = count(textView.text) != 0
    }
    
    func appendIngredientsAndInstructions(){
        ingredientBond = Bond<String>(){ ingredient in
            
            var contained = contains(self.ingredientsArray, ingredient)
            if contained == false && ingredient != "" {

                    self.ingredientsArray.append(ingredient)
                    println(contained)
            }
            
        }
        
        instructionBond = Bond<String>(){ instruction in
            var contained = contains(self.instructionsArray, instruction)
            if contained == false && instruction != "" {
                self.instructionsArray.append(instruction)
            }
        }
        
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
        
        appendIngredientsAndInstructions()
        
        if annotation?.post != nil{
            postButton.setTitle("DONE", forState: .Normal)
            
        }
        
        
       
        
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    var currentAnnotation: PinAnnotation?
    
    
    
        //var instructionsViewController = InstructionsViewController()
        
    func updatePost() {
            
            appendIngredientsAndInstructions()
            //change parse info
            annotation?.post.setObject(titleTextField.text, forKey: "RecipeTitle")
            annotation?.post.setObject(descriptionText.text, forKey: "description")
            annotation?.post.setObject(countryTextField.text, forKey: "country")
            annotation?.post.setObject(ingredientsArray, forKey: "Ingredients")
            annotation?.post.setObject(self.instructionsArray, forKey: "Instructions")
            
            let imageData = UIImageJPEGRepresentation(imageView?.image, 0.8)
            let imageFile = PFFile(data: imageData)
            
            annotation?.post.setObject(imageFile, forKey: "imageFile")
        
        
        
            
            
    }
        
    func createPost(){

            post.Description = descriptionText.text
            post.RecipeTitle = titleTextField.text
            post.country = countryTextField.text
            post.location = toLoc
            post.Ingredients = self.ingredientsArray
            post.Instructions = self.instructionsArray
            post.date = NSDate()
            
            
            post.save()
            post.uploadPost()
            
            
            
            let lat = post.location?.latitude
            let long = post.location?.longitude
            var coordinateh = CLLocationCoordinate2D(latitude: lat!, longitude: long!)
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let mapViewController = storyboard.instantiateViewControllerWithIdentifier("MapViewController") as! MapViewController
            
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
            
            var annotationToAdd = PinAnnotation(title: title, coordinate: coordinate, Description: description, country: country, instructions: instructions, ingredients: ingredients, image: image, user: user, date: date, post: postcurrent)
            
            currentAnnotation = annotationToAdd
            //mapView.mapView.addAnnotation(annotation)
            
            mapViewController.viewWillAppear(true)
        
        
        
    }
    
}