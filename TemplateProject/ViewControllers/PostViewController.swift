////
////  PostViewController.swift
////  TemplateProject
////
////  Created by Caitlyn Chen on 7/6/15.
////  Copyright (c) 2015 Make School. All rights reserved.
////
//
//import UIKit
//import Bond
//
//class PostViewController: UIViewController {
//
//    @IBOutlet weak var usernameLabel: UILabel!
//    @IBOutlet weak var dateLabel: UILabel!
//    
//    @IBOutlet weak var likeButton: UIButton!
//    var likeBond: Bond<[PFUser]?>!
//
//    
//    @IBAction func likeButtonTapped(sender: AnyObject) {
//        post?.toggleLikePost(PFUser.currentUser()!)
//
//    }
//    
//    var post: Post? {
//        didSet {
//            if let post = post {
//                usernameLabel.text = post.user?.username
//                dateLabel.text = post.createdAt?.shortTimeAgoSinceDate(NSDate()) ?? ""
//            }
//        }
//    }
//    
//    var post:Post? {
//        didSet {
//            // free memory of image stored with post that is no longer displayed
//            // 1
//            if let oldValue = oldValue where oldValue != post {
//                // 2
//                likeBond.unbindAll()
//                postImageView.designatedBond.unbindAll()
//                // 3
//                if (oldValue.image.bonds.count == 0) {
//                    oldValue.image.value = nil
//                }
//            }
//            
//            if let post = post {
//                // bind the image of the post to the 'postImage' view
//                post.image ->> postImageView
//                
//                // bind the likeBond that we defined earlier, to update like label and button when likes change
//                post.likes ->> likeBond
//            }
//        }
//    }
//    
//    required init(coder aDecoder: NSCoder) {
//        super.init(coder: aDecoder)
//        
//        // 1
//        likeBond = Bond<[PFUser]?>() { [unowned self] likeList in
//            // 2
//            if let likeList = likeList {
//                // 3
//                self.likesLabel.text = self.stringFromUserList(likeList)
//                // 4
//                self.likeButton.selected = contains(likeList, PFUser.currentUser()!)
//                // 5
//                self.likesIconImageView.hidden = (likeList.count == 0)
//            } else {
//                // 6
//                // if there is no list of users that like this post, reset everything
//                self.likesLabel.text = ""
//                self.likeButton.selected = false
//                self.likesIconImageView.hidden = true
//            }
//        }
//    }
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        // Do any additional setup after loading the view.
//    }
//
//    override func didReceiveMemoryWarning() {
//        super.didReceiveMemoryWarning()
//        // Dispose of any resources that can be recreated.
//    }
//    
//
//    /*
//    // MARK: - Navigation
//
//    // In a storyboard-based application, you will often want to do a little preparation before navigation
//    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
//        // Get the new view controller using segue.destinationViewController.
//        // Pass the selected object to the new view controller.
//    }
//    */
//
//}
