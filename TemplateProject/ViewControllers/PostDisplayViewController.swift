//
//  PostDisplayViewController.swift
//  TemplateProject
//
//  Created by Caitlyn Chen on 7/6/15.
//  Copyright (c) 2015 Make School. All rights reserved.
//

import UIKit
import Parse
import MapKit
import Bond

class PostDisplayViewController: UIViewController, UINavigationControllerDelegate,UIImagePickerControllerDelegate, UITableViewDelegate, UITableViewDataSource, UITextViewDelegate, NSURLConnectionDataDelegate{
    
    @IBOutlet weak var autocompleteTextfield: AutoCompleteTextField!
    
    private var responseData:NSMutableData?

    private var connection:NSURLConnection?
    
    private let googleMapsKey = "AIzaSyD8-OfZ21X2QLS1xLzu1CLCfPVmGtch7lo"
    private let baseURLString = "https://maps.googleapis.com/maps/api/place/autocomplete/json"
    
    var photoTakingHelper: PhotoTakingHelper?
    
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
//            var data = annotation?.image.getData()
//            image = UIImage(data: data!)
//            imageView?.image = image
            autocompleteTextfield.text = annotation?.country
            
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
                if self.annotation == nil {
                self.post["imageFile"] = imageFile
                self.post.save()
                
                } else {
                    let imageData = UIImageJPEGRepresentation(self.imageView?.image, 0.8)
                    let imageFile = PFFile(data: imageData)
                    
                    self.annotation?.post.imageFile = imageFile
                    self.annotation?.post.imageFile?.save()
                    
                }
                
                
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
     
        configureTextField()
        handleTextFieldInterfaces()
        
        //picker = UIPickerView()
        
    
        
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
            var data = annotation?.image.getData()
            image = UIImage(data: data!)
            imageView?.image = image
            postButton.setTitle("DONE", forState: .Normal)
            
        }
        
        
        
        
        
        // Do any additional setup after loading the view.
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
                    let coordinate = placemark!.location.coordinate
                    
                    self!.autocompleteTextfield.text = text
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
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    var currentAnnotation: PinAnnotation?
    
    
    
    //var instructionsViewController = InstructionsViewController()
    
    func updatePost() {
        
//        appendIngredientsAndInstructions()
        //change parse info
        annotation?.post.RecipeTitle = titleTextField.text
        annotation?.post.caption = descriptionText.text
        annotation?.post.country = autocompleteTextfield.text
        annotation?.post.Ingredients = ingredientsArray
        annotation?.post.Instructions = instructionsArray
        
        
        
        annotation?.post.save()
        annotation?.post.saveInBackgroundWithBlock(nil)
        
        
    }
    
    func createPost(){
        
        post.caption = descriptionText.text
        post.RecipeTitle = titleTextField.text
        post.country = autocompleteTextfield.text
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
        
        
        var coor: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: lat!, longitude: long!)
        
        let test = post.Ingredients!
        
        var annotationToAdd = PinAnnotation(title: post.RecipeTitle!, coordinate: coordinateh, Description: post.caption!, country: post.country!, instructions: post.Instructions!, ingredients: post.Ingredients!, image: post.imageFile!, user: post.user!, date: post.date!, post: post)
        
        currentAnnotation = annotationToAdd
        //mapView.mapView.addAnnotation(annotation)
        
        mapViewController.viewWillAppear(true)
        
        
        
    }
    
}
