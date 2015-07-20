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


class PostViewController: UIViewController {

    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    
    @IBOutlet weak var DescriptionLabel: UILabel!
    @IBOutlet weak var imageViewDisplay: UIImageView!
    @IBOutlet weak var countryLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var likeButton: UIButton!
    
    @IBAction func likeButtonTapped(sender: AnyObject) {
        
    }
    var RecipeTitle: String?
    var Description: String?
    var country: String?
    var ingredients: [String]?
    var instructions: [String]?
    
//    var post: Post? {
//        didSet {
//            if let post = post {
//                usernameLabel.text = post.user?.username
//                // 1
//                dateLabel.text = post.createdAt?.shortTimeAgoSinceDate(NSDate()) ?? ""
//            }
//        }
//    }
    
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
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleLabel.text = RecipeTitle
        countryLabel.text = country
        DescriptionLabel.text = Description
        
        
        
            

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
            
        }
    }

}
