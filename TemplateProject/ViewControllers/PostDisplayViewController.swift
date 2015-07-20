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

class PostDisplayViewController: UIViewController, UINavigationControllerDelegate,UIImagePickerControllerDelegate, UITableViewDelegate, UITableViewDataSource {
    
    @IBAction func backButton(sender: AnyObject) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let mapViewController = storyboard.instantiateViewControllerWithIdentifier("MapViewController") as! MapViewController
        self.dismissViewControllerAnimated(false, completion: nil)
        self.presentViewController(mapViewController, animated: true, completion: nil)
    }
    @IBOutlet weak var ingredientsTableView: UITableView!
    @IBOutlet weak var postButton: UIButton!

    @IBOutlet weak var descriptionText: UITextView!
    @IBOutlet weak var countryTextField: UITextField!
    var toLoc: PFGeoPoint?
    var photoTakingHelper: PhotoTakingHelper?
    
    @IBOutlet weak var titleTextField: UITextField!
    

    @IBOutlet weak var imageView: UIImageView?
    
    @IBOutlet weak var instructionTableView: UITableView!
    
    let post = Post()

    
    @IBOutlet weak var cameraButton: UIButton!
    
    @IBAction func postButtonTapped(sender: AnyObject) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let mapViewController = storyboard.instantiateViewControllerWithIdentifier("MapViewController") as! MapViewController
        //RELOAD MAPVIEW
        //mapViewController.reloadInputViews()
        self.dismissViewControllerAnimated(false, completion: nil)
        self.presentViewController(mapViewController, animated: true, completion: nil)
        
        createPost()
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
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == ingredientsTableView {
            return 200 // Create 1 row as an example
        } else {
            return 200
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if tableView == ingredientsTableView {
            let cell = tableView.dequeueReusableCellWithIdentifier("IngredientsInputCell") as! IngredientsTableViewCell
            
            
            cell.ingredient.map { $0 } ->> ingredientBond
            
            cell.configure(text: "", placeholder: "Ex. 1 cup of flour")
            return cell
        } else {
            let cell = tableView.dequeueReusableCellWithIdentifier("InstructionsInputCell") as! InstructionsTableViewCell
            
            cell.instruction.map { $0 } ->> instructionBond
            
            
            //instructionsArray?.append(cell.textField.text)
            cell.configure(text: "", placeholder: "Ex. Preheat oven to 350 degrees.")
            return cell
        }
      
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
    
    

    func createPost(){

        //var instructionsViewController = InstructionsViewController()
        
        post.Description = descriptionText.text
        
        post.RecipeTitle = titleTextField.text
        post.country = countryTextField.text
        post.location = toLoc
        post.Ingredients = self.ingredientsArray
        post.Instructions = self.instructionsArray
        
        post.uploadPost()
        
        
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