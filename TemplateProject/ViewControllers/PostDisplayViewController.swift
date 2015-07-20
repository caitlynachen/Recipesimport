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
    
    @IBAction func cameraButtonTapped(sender: AnyObject) {
        //println("hi")        
        photoTakingHelper =
            PhotoTakingHelper(viewController: self) { (image: UIImage?) in
                // 1
                self.post.image.value = image!
                self.imageView?.image = image!
                
        }
      
    }
    
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
            
            cell.configure(text: "", placeholder: "")
            return cell
        } else {
            let cell = tableView.dequeueReusableCellWithIdentifier("InstructionsInputCell") as! InstructionsTableViewCell
            
            cell.instruction.map { $0 } ->> instructionBond
            
            
            //instructionsArray?.append(cell.textField.text)
            cell.configure(text: "", placeholder: "")
            return cell
        }
      
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ingredientBond = Bond<String>(){ ingredient in
            self.ingredientsArray.append(ingredient)
            
        }
        
        instructionBond = Bond<String>(){ instruction in
            self.instructionsArray.append(instruction)
            //println(self.instructionsArray?.count)
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
        post.ImageFile = post.imageFileGet
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
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if (segue.identifier == "unwind") {
            
            createPost()
            // pass data to next view
        }
    }


}