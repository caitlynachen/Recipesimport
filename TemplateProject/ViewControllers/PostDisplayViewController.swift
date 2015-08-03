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
import FBSDKCoreKit


class PostDisplayViewController: UIViewController, UINavigationControllerDelegate,UIImagePickerControllerDelegate, UITextViewDelegate, NSURLConnectionDataDelegate{
    
    @IBOutlet weak var ingTextView: UITextView!
    @IBOutlet weak var instructionsTextView: UITextView!
    @IBOutlet weak var emptyLabel: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var autocompleteTextfield: AutoCompleteTextField!
    
    @IBOutlet weak var cookTime: UITextField!
    private var responseData:NSMutableData?
    
    @IBOutlet weak var numOfServings: UITextField!
    @IBOutlet weak var prepTime: UITextField!
    private var connection:NSURLConnection?
    
    private let googleMapsKey = "AIzaSyD8-OfZ21X2QLS1xLzu1CLCfPVmGtch7lo"
    private let baseURLString = "https://maps.googleapis.com/maps/api/place/autocomplete/json"
    
    var photoTakingHelper: PhotoTakingHelper?
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var imageView: UIImageView?
//    @IBOutlet weak var instructionTableView: UITableView!
    @IBOutlet weak var descriptionText: UITextView!
//    @IBOutlet weak var ingredientsTableView: UITableView!
    @IBOutlet weak var postButton: UIBarButtonItem!
    
    var placeholderLabel: UILabel!
    var placeholderInstructionsLabel: UILabel!
    var placeholderIngredientsLabel: UILabel!


    
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
        mapViewController.viewDidAppear(true)
    }
    
    
    override func viewWillAppear(animated: Bool) {
        if (annotation?.ingredients != nil && annotation?.instructions != nil && annotation?.title != nil && annotation?.Description != nil && annotation?.image != nil && annotation?.country != nil && annotation?.servings != nil && annotation?.prep != nil && annotation?.cook != nil) {
            titleTextField.text = annotation?.title
            descriptionText.text = annotation?.Description
            cookTime.text = annotation?.cook
            prepTime.text = annotation?.prep
            numOfServings.text = annotation?.servings
            
            autocompleteTextfield.text = annotation?.country
            
            let ingredientsArrayFromMap = annotation?.ingredients
            let stringedi = "\n".join(ingredientsArrayFromMap!)
            ingTextView.text = stringedi
            
            
            let instructionsArrayFromMap = annotation?.instructions
            let strinstuc = "\n".join(instructionsArrayFromMap!)
            instructionsTextView.text = strinstuc

            
            placeholderLabel.hidden = count(descriptionText.text) != 0
            placeholderIngredientsLabel.hidden = count(ingTextView.text) != 0

            placeholderInstructionsLabel.hidden = count(instructionsTextView.text) != 0

            
            
        }
    }
    
    
    override func shouldPerformSegueWithIdentifier(identifier: String?, sender: AnyObject?) -> Bool {
        if let ident = identifier {
            if ident == "fromPostDiplayToMap" {
                if titleTextField.text == "" {
                    emptyLabel.text = "Please enter a title."
                    emptyLabel.hidden = false
                    
                } else if autocompleteTextfield.text == "" {
                    emptyLabel.text = "Please enter location tag."
                    emptyLabel.hidden = false
                    
                } else if imageView?.image == nil {
                    emptyLabel.text = "Please add an image."
                    emptyLabel.hidden = false
                    
                } else if prepTime.text == ""{
                    emptyLabel.text = "Please enter a prep time."
                    emptyLabel.hidden = false
                    
                } else if cookTime.text == "" {
                    emptyLabel.text = "Please enter a cook time."
                    emptyLabel.hidden = false
                    
                } else if numOfServings.text == "" {
                    emptyLabel.text = "Please enter the number of servings."
                    emptyLabel.hidden = false
                    
                } else if ingTextView.text == nil {
                    emptyLabel.text = "Please enter at least one ingredient."
                    emptyLabel.hidden = false
                    
                } else if instructionsTextView.text == nil {
                    emptyLabel.text = "Please enter at least one instruction."
                    emptyLabel.hidden = false
                    
                } else {
                    
                    return true
                }
            }
        }
        
        return false
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "fromPostDiplayToMap") {
            var svc = segue.destinationViewController as! MapViewController;

            if annotation?.post == nil{
                createPost()
                
                
            } else {
                updatePost()
                svc.updatedPost = true
            }
            
            
            svc.annotationCurrent = currentAnnotation
            svc.addPostedAnnotation()
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
                
                self.cameraButton.hidden = true
        }
        
    }
    
    var ingredientsArray: [String] = []
    var instructionsArray: [String] = []
    func textViewDidChange(textView: UITextView) {
        if textView == descriptionText{
            placeholderLabel.hidden = count(textView.text) != 0

        } else if textView == ingTextView{
            placeholderIngredientsLabel.hidden = count(textView.text) != 0

        } else if textView == instructionsTextView {
            placeholderInstructionsLabel.hidden = count(textView.text) != 0
        }
    }
    
    func appendIngredientsAndInstructions(){
        
        var ingredi = split(ingTextView.text) {$0 == "\n"}
        self.ingredientsArray = ingredi

        
        var instruc = split(instructionsTextView.text) {$0 == "\n"}
       
        self.instructionsArray = instruc
        
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        emptyLabel.hidden = true
        configureTextField()
        handleTextFieldInterfaces()
        
        //picker = UIPickerView()
        
        
        let screenSize: CGRect = UIScreen.mainScreen().bounds
        
        let screenWidth = screenSize.width
        let screenHeight = screenSize.height
        
        scrollView.contentSize.width = screenWidth
        
        descriptionText.delegate = self
        placeholderLabel = UILabel()
        placeholderLabel.text = "Write a caption..."
        placeholderLabel.sizeToFit()
        descriptionText.addSubview(placeholderLabel)
        
        placeholderLabel.frame.origin = CGPointMake(5, descriptionText.font.pointSize / 2)
        placeholderLabel.textColor = UIColor(white: 0, alpha: 0.3)
        placeholderLabel.hidden = count(descriptionText.text) != 0
        
        ingTextView.delegate = self
        placeholderIngredientsLabel = UILabel()
        placeholderIngredientsLabel.text = "Put each new ingredient on a separate line."
        placeholderIngredientsLabel.sizeToFit()
        ingTextView.addSubview(placeholderIngredientsLabel)
        
        placeholderIngredientsLabel.frame.origin = CGPointMake(5, ingTextView.font.pointSize / 2)
        placeholderIngredientsLabel.textColor = UIColor(white: 0, alpha: 0.3)
        placeholderIngredientsLabel.hidden = count(ingTextView.text) != 0
        
        
        instructionsTextView.delegate = self
        placeholderInstructionsLabel = UILabel()
        placeholderInstructionsLabel.text = "Put each new instruction on a separate line."
        placeholderInstructionsLabel.sizeToFit()
        instructionsTextView.addSubview(placeholderInstructionsLabel)
        
        placeholderInstructionsLabel.frame.origin = CGPointMake(5, descriptionText.font.pointSize / 2)
        placeholderInstructionsLabel.textColor = UIColor(white: 0, alpha: 0.3)
        placeholderInstructionsLabel.hidden = count(instructionsTextView.text) != 0
        
        
        appendIngredientsAndInstructions()
        
        if annotation?.post != nil{
            var data = annotation?.image.getData()
            image = UIImage(data: data!)
            imageView?.image = image
            
            
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
    
    var coordinateh: CLLocationCoordinate2D?
    
    var pfgeopoint: PFGeoPoint?
    
    
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
                    
                    self!.coordinateh = coordinate
                    self!.pfgeopoint = PFGeoPoint(latitude: coordinate.latitude, longitude: coordinate.longitude)
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
        
        appendIngredientsAndInstructions()
        //change parse info
        annotation?.post.prep = prepTime.text
        annotation?.post.cook = cookTime.text
        annotation?.post.servings = numOfServings.text
        annotation?.post.RecipeTitle = titleTextField.text
        annotation?.post.caption = descriptionText.text
        annotation?.post.country = autocompleteTextfield.text
        annotation?.post.Ingredients = ingredientsArray
        annotation?.post.Instructions = instructionsArray
        
        
        
        annotation?.post.save()
        annotation?.post.saveInBackgroundWithBlock(nil)
        
        
        
        
    }
    
    func createPost(){
        
        appendIngredientsAndInstructions()

        
        post.prep = prepTime.text
        post.cook = cookTime.text
        post.servings = numOfServings.text
        post.caption = descriptionText.text
        post.RecipeTitle = titleTextField.text
        post.country = autocompleteTextfield.text
        post.location = pfgeopoint
        post.Ingredients = self.ingredientsArray
        post.Instructions = self.instructionsArray
        post.date = NSDate()
        
        post.save()
        post.uploadPost()
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let mapViewController = storyboard.instantiateViewControllerWithIdentifier("MapViewController") as! MapViewController
        
        
        let test = post.Ingredients!
        
        var annotationToAdd = PinAnnotation(title: post.RecipeTitle!, coordinate: coordinateh!, Description: post.caption!, country: post.country!, instructions: post.Instructions!, ingredients: post.Ingredients!, image: post.imageFile!, user: post.user!, date: post.date!, prep: post.prep!, cook: post.cook!, servings: post.servings!, post: post)
        
        currentAnnotation = annotationToAdd
//        mapViewController.mapView.addAnnotation(annotationToAdd)
        
        
    }
    
}
