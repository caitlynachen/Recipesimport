//
//  RecipeViewController.swift
//  TemplateProject
//
//  Created by Caitlyn Chen on 7/14/15.
//  Copyright (c) 2015 Make School. All rights reserved.
//

import UIKit

class RecipeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var countryLabel: UILabel!
    
    @IBOutlet weak var instructionsTableView: UITableView!
    @IBOutlet weak var ingredientsTableView: UITableView!
    var titlerecipe: String?
    var countryrecipe: String?
    var ingredientsrecipe: [String]?
    var instructionsrecipe: [String]?
    var image: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleLabel.text = titlerecipe
        countryLabel.text = countryrecipe
        
        self.ingredientsTableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        self.instructionsTableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "instruccell")

        imageView.image = image
        
        // Do any additional setup after loading the view.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == ingredientsTableView {
            return self.ingredientsrecipe!.count;
        } else {
            return self.instructionsrecipe!.count;
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var myFont = UIFont(name: "Arial", size: 12.0)
        if tableView == ingredientsTableView{
            var cell: UITableViewCell = self.ingredientsTableView.dequeueReusableCellWithIdentifier("cell") as! UITableViewCell
            
            
            cell.textLabel?.font = myFont
            cell.textLabel?.text = self.ingredientsrecipe![indexPath.row]
            return cell
            
        } else {
            var cell: UITableViewCell = self.instructionsTableView.dequeueReusableCellWithIdentifier("instruccell") as! UITableViewCell
            
            cell.textLabel?.font = myFont
            cell.textLabel?.text = self.instructionsrecipe![indexPath.row]
            return cell
        }

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
    
    
    
}
