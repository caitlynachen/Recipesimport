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
    

    var photoTakingHelper: PhotoTakingHelper?
    @IBAction func postButtonTapped(sender: AnyObject) {
        createPost()
        
    }
    @IBOutlet weak var titleTextField: UITextField!
    

    @IBOutlet weak var imageView: UIImageView?
    
    @IBOutlet weak var ingredientsButton: UIButton!
    @IBAction func ingredientsButtonTapped(sender: AnyObject) {
    }
    @IBOutlet weak var instructionsButton: UIButton!
    @IBAction func instructionsButtonTapped(sender: AnyObject) {
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
        
        var ingredientsViewController = IngredientsViewController()
        var instructionsViewController = InstructionsViewController()
        
        post.imageFile = post.imageFile
        post.recipeTitle = titleTextField.text
        post.ingredients = ingredientsViewController.ingredientsArray
        post.instructions = instructionsViewController.instructionsArray
        
        
        if (self.titleTextField == nil){
            println("add title")
        }
        if(self.imageView?.image == nil){
            println("add image")
        }
        if (ingredientsViewController.ingredientsArray?.count == 0){
            println("add ingredients")
        }
        if (instructionsViewController.instructionsArray?.count == 0){
            println("add instructions")
        } else {
            post.uploadPost()
        }
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

