//
//  IngredientsViewController.swift
//  TemplateProject
//
//  Created by Caitlyn Chen on 7/6/15.
//  Copyright (c) 2015 Make School. All rights reserved.
//

import UIKit
import Bond

class IngredientsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var ingredientsTableView: UITableView!
//    var ingredientscell = IngredientsTableViewCell()
    var ingredientsArray: [String]?
    var ingredientBond:Bond<String>!
    
     func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 200 // Create 1 row as an example
    }
    
     func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("IngredientsInputCell") as! IngredientsTableViewCell
       

        
        cell.ingredient.map { $0 } ->> ingredientBond

//        println(ingredientscell.textField?.text)
//        ingredientsArray?.append("test")
        
        cell.configure(text: "", placeholder: "")
        return cell
    }
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        ingredientBond = Bond<String>(){ ingredient in
            self.ingredientsArray?.append(ingredient)
            
        }
        //println(ingredientsArray)

        // Do any additional setup after loading the view.
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
