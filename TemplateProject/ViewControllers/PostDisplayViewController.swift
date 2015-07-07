//
//  PostDisplayViewController.swift
//  TemplateProject
//
//  Created by Caitlyn Chen on 7/6/15.
//  Copyright (c) 2015 Make School. All rights reserved.
//

import UIKit
import Parse

class PostDisplayViewController: UIViewController, UINavigationControllerDelegate,UIImagePickerControllerDelegate {

    @IBOutlet weak var titleTextField: UITextField!
    
    @IBOutlet weak var imageView: UIImageView!
    var imagePicker = UIImagePickerController()
    @IBOutlet weak var ingredientsButton: UIButton!

   
    @IBAction func ingredientsButtonTapped(sender: AnyObject) {
    }
    @IBOutlet weak var instructionsButton: UIButton!
    @IBAction func instructionsButtonTapped(sender: AnyObject) {
    }
    
    
    @IBOutlet weak var cameraButton: UIButton!
    
    @IBAction func cameraButtonTapped(sender: AnyObject) {
        //println("hi")
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .PhotoLibrary
        
        presentViewController(imagePicker, animated: true, completion: nil)
      
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        imagePicker.delegate = self


        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            imageView.contentMode = .ScaleAspectFit
            imageView.image = pickedImage
        }
        
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
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


