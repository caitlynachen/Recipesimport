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
import ParseUI
//import DateTools



class PostViewController: UIViewController {
    
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    var anno: PinAnnotation?

    @IBOutlet weak var DescriptionLabel: UILabel!
    @IBOutlet weak var imageViewDisplay: UIImageView!
    @IBOutlet weak var countryLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var likeButton: UIButton!
    
    @IBOutlet weak var likeLabel: UILabel!
    var numOfFlags: Int?
    var login: PFLogInViewController?
    
    @IBAction func likeButtonTapped(sender: AnyObject) {
//        if PFUser.currentUser() == nil {
//            let storyboard: UIStoryboard = UIStoryboard(name: "myTabBarName", bundle: nil)
//            let vc: UIViewController = storyboard.instantiateViewControllerWithIdentifier("myVCID") as UIViewController
//            self.presentViewController(vc, animated: true, completion: nil)
//        }
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
                    
                    self.anno?.post.delete()
                    
                    self.performSegueWithIdentifier("fromPostMap", sender: nil)
        
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
        
        titleLabel.text = anno?.title
        countryLabel.text = anno?.country
        DescriptionLabel.text = anno?.Description
        var userfetch = anno?.user.fetchIfNeeded()
        usernameLabel.text = anno?.user.username
        
        dateLabel.text = anno?.date.shortTimeAgoSinceDate(NSDate())

        
        var data = anno?.image.getData()
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
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "toRecipeView") {
            var dest = segue.destinationViewController as! RecipeViewController;
            
            dest.annotation = anno
            
        } else if(segue.identifier == "editPost"){
            var dest = segue.destinationViewController as! PostDisplayViewController;
            
            dest.annotation = anno
            

        } else if(segue.identifier == "fromPostMap"){
        
            var dest = segue.destinationViewController as! MapViewController;
            dest.ann = anno
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let mapViewController = storyboard.instantiateViewControllerWithIdentifier("MapViewController") as! MapViewController
    
            
            mapViewController.viewWillAppear(true)
            
    
        }
    }
    
}
