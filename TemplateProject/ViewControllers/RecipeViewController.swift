//
//  RecipeViewController.swift
//  TemplateProject
//
//  Created by Caitlyn Chen on 7/14/15.
//  Copyright (c) 2015 Make School. All rights reserved.
//

import UIKit

class RecipeViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var countryLabel: UILabel!
    
    //var titleh: String?
    var country: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //titleLabel.text = titleh
        //countryLabel.text = country

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
