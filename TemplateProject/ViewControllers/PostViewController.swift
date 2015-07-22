//
//  PostViewController.swift
//  TemplateProject
//
//  Created by Caitlyn Chen on 7/6/15.
//  Copyright (c) 2015 Make School. All rights reserved.
//

import UIKit
import Bond
import Parse
//import DateTools



class PostViewController: UIViewController {
    
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    var post: PFObject?
    @IBOutlet weak var DescriptionLabel: UILabel!
    @IBOutlet weak var imageViewDisplay: UIImageView!
    @IBOutlet weak var countryLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var likeButton: UIButton!
    
    @IBOutlet weak var likeLabel: UILabel!
    var numOfLikes: Int = 0
    var numOfFlags: Int?
    
    @IBAction func likeButtonTapped(sender: AnyObject) {
        numOfLikes = numOfLikes + 1
        self.likeLabel.text = "\(numOfLikes)"
    }
    
    @IBAction func moreButtonTapped(sender: AnyObject) {
        if(PFUser.currentUser()?.username == usernameLabel.text){
            let actionSheetController: UIAlertController = UIAlertController()
            
            let cancelAction: UIAlertAction = UIAlertAction(title: "Cancel", style: .Cancel) { action -> Void in
            }
            actionSheetController.addAction(cancelAction)
            let takePictureAction: UIAlertAction = UIAlertAction(title: "Delete", style: .Default) { action -> Void in
                let deleteAlert: UIAlertController = UIAlertController(title: "Confirm Deletion", message: "Delete Photo?", preferredStyle: .Alert)
                
                let dontDeleteAction: UIAlertAction = UIAlertAction(title: "Don't Delete", style: .Cancel) { action -> Void in
                }
                deleteAlert.addAction(dontDeleteAction)
                let deleteAction: UIAlertAction = UIAlertAction(title: "Delete", style: .Default) { action -> Void in
                    
                    self.post?.delete()
                    
                    self.performSegueWithIdentifier("fromPostMap", sender: nil)
                    
                    
                    //delete row from parse?
                }
                deleteAlert.addAction(deleteAction)
                
                
                //Present the AlertController
                self.presentViewController(deleteAlert, animated: true, completion: nil)
            }
            actionSheetController.addAction(takePictureAction)
            let choosePictureAction: UIAlertAction = UIAlertAction(title: "Edit", style: .Default) { action -> Void in
                self.performSegueWithIdentifier("editPost", sender: nil)
                
            }
            actionSheetController.addAction(choosePictureAction)
            
            //We need to provide a popover sourceView when using it on iPad
            actionSheetController.popoverPresentationController?.sourceView = sender as! UIView;
            
            //Present the AlertController
            self.presentViewController(actionSheetController, animated: true, completion: nil)
            
        } else{
            let actionSheetController: UIAlertController = UIAlertController()
            
            //Create and add the Cancel action
            let cancelAction: UIAlertAction = UIAlertAction(title: "Cancel", style: .Cancel) { action -> Void in
                //Just dismiss the action sheet
            }
            actionSheetController.addAction(cancelAction)
            //Create and add first option action
            let takePictureAction: UIAlertAction = UIAlertAction(title: "Report Inappropriate", style: .Default) { action -> Void in
                let deleteAlert: UIAlertController = UIAlertController(title: "Flag", message: "", preferredStyle: .Alert)
                
                let dontDeleteAction: UIAlertAction = UIAlertAction(title: "Cancel", style: .Cancel) { action -> Void in
                }
                deleteAlert.addAction(dontDeleteAction)
                let deleteAction: UIAlertAction = UIAlertAction(title: "Flag", style: .Default) { action -> Void in
                    
                    self.numOfFlags = self.numOfFlags! + 1
                    
                    //flag row in parse
                }
                deleteAlert.addAction(deleteAction)
                
                
                //Present the AlertController
                self.presentViewController(deleteAlert, animated: true, completion: nil)
            }
            actionSheetController.addAction(takePictureAction)
            //Create and add a second option action
            
            
            //We need to provide a popover sourceView when using it on iPad
            actionSheetController.popoverPresentationController?.sourceView = sender as! UIView;
            
            //Present the AlertController
            self.presentViewController(actionSheetController, animated: true, completion: nil)
        }
    }
   
    var RecipeTitle: String?
    var Description: String?
    var country: String?
    var ingredients: [String]?
    var instructions: [String]?
    var imageFile: PFFile?
    var user: PFUser?
    var date: NSDate?
    var coor: CLLocationCoordinate2D?

    
    @IBAction func unwindToPostView(segue:UIStoryboardSegue) {
        if(segue.identifier == "unwindToPostView"){
            
            
        }
    }
    
    
    override func shouldPerformSegueWithIdentifier(identifier: String?, sender: AnyObject?) -> Bool {
        if let ident = identifier {
            if ident == "toRecipeView" {
                return true
            }
            
        }
        
        return false
        
    }
    
   
    var image: UIImage?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleLabel.text = RecipeTitle
        countryLabel.text = country
        DescriptionLabel.text = Description
        var userfetch = user?.fetchIfNeeded()
        usernameLabel.text = user?.username
        
        
        dateLabel.text = date!.shortTimeAgoSinceDate(NSDate())
        
        
        
        var data = imageFile?.getData()
        image = UIImage(data: data!)
        
        imageViewDisplay.image = image
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func backButtonTapped(sender: AnyObject) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let mapViewController = storyboard.instantiateViewControllerWithIdentifier("MapViewController") as! MapViewController
        self.dismissViewControllerAnimated(false, completion: nil)
        self.presentViewController(mapViewController, animated: true, completion: nil)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
        
    }
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }
    */
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "toRecipeView") {
            var dest = segue.destinationViewController as! RecipeViewController;
            dest.titlerecipe = titleLabel.text
            dest.countryrecipe = countryLabel.text
            dest.instructionsrecipe = instructions
            dest.ingredientsrecipe = ingredients
            dest.image = image
            
        } else if(segue.identifier == "editPost"){
            var dest = segue.destinationViewController as! PostDisplayViewController;
            
            dest.titlerecipe = titleLabel.text
            dest.countryrecipe = countryLabel.text
            dest.instructionsrecipe = instructions
            dest.ingredientsrecipe = ingredients
            dest.image = image
            dest.Description = DescriptionLabel.text
            dest.postToEdit = post
            

        } else if(segue.identifier == "fromPostMap"){
            var anno: PinAnnotation? = PinAnnotation(title: RecipeTitle!, coordinate: coor!, Description: Description!, country: country!, instructions:instructions!, ingredients: ingredients!, image: imageFile!, user: user!, date: date!, post: post!)
            var dest = segue.destinationViewController as! MapViewController;
            dest.ann = anno
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let mapViewController = storyboard.instantiateViewControllerWithIdentifier("MapViewController") as! MapViewController
    
            
            mapViewController.viewWillAppear(true)
            
    
        }
    }
    
}
