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

class PostDisplayViewController: UIViewController, UINavigationControllerDelegate,UIImagePickerControllerDelegate {
    

    @IBOutlet weak var ingredientsButton: UIButton!
    @IBOutlet weak var instructionsButton: UIButton!
    @IBOutlet weak var countryTextField: UITextField!
    var photoTakingHelper: PhotoTakingHelper?
    @IBAction func postButtonTapped(sender: AnyObject) {
        createPost()
       
        
    }
    @IBOutlet weak var titleTextField: UITextField!
    

    @IBOutlet weak var imageView: UIImageView?
    
    @IBAction func ingredientsButtonTapped(sender: AnyObject) {
        var ingredientsViewController = self.storyboard?.instantiateViewControllerWithIdentifier("ingredientsViewController") as! IngredientsViewController
        self.presentViewController(ingredientsViewController, animated: true, completion: nil)

    }
    @IBAction func instructionsButtonTapped(sender: AnyObject) {
        var instructionsViewController = self.storyboard?.instantiateViewControllerWithIdentifier("instructionsViewController") as! InstructionsViewController
        self.presentViewController(instructionsViewController, animated: true, completion: nil)
    }
    
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
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func createPost(){
        
        var map = MapViewController()
        
        var ingredientsViewController = IngredientsViewController()
        var instructionsViewController = InstructionsViewController()
        
        post.ImageFile = post.imageFileGet
        post.RecipeTitle = titleTextField.text
        post.country = countryTextField.text
        post.Ingredients = ingredientsViewController.ingredientsArray
        post.Instructions = instructionsViewController.instructionsArray
        
        
        
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
    
   

       /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

