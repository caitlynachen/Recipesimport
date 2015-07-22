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
    
    var annotation: PinAnnotation?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleLabel.text = annotation?.title
        countryLabel.text = annotation?.country
        
        ing = annotation?.ingredients
        ins = annotation?.instructions
        
        self.ingredientsTableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        self.instructionsTableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "instruccell")

        var data = annotation!.image.getData()
        var image = UIImage(data: data!)
        
        imageView.image = image
        
        // Do any additional setup after loading the view.
    }
    var ing: [String]?
    var ins: [String]?
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == ingredientsTableView {
            return ing!.count;
        } else {
            return ins!.count;
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var myFont = UIFont(name: "Arial", size: 12.0)
        if tableView == ingredientsTableView{
            var cell: UITableViewCell = self.ingredientsTableView.dequeueReusableCellWithIdentifier("cell") as! UITableViewCell
            
            
            cell.textLabel?.font = myFont
            cell.textLabel?.text = annotation?.ingredients[indexPath.row]
            return cell
            
        } else {
            var cell: UITableViewCell = self.instructionsTableView.dequeueReusableCellWithIdentifier("instruccell") as! UITableViewCell
            
            cell.textLabel?.font = myFont
            cell.textLabel?.text = annotation?.instructions[indexPath.row]
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
