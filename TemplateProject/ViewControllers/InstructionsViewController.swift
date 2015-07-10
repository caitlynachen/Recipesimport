//
//  instructionsViewController.swift
//  TemplateProject
//
//  Created by Caitlyn Chen on 7/6/15.
//  Copyright (c) 2015 Make School. All rights reserved.
//

import UIKit
import Bond


class InstructionsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var instructionsTableView: UITableView!
    //var instructionsCell = InstructionsTableViewCell()
    var instructionsArray: [String]?
    var instructionBond:Bond<String>!

    
    internal func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 200 // Create 1 row as an example
    }
    
    internal func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("InstructionsInputCell") as! InstructionsTableViewCell
        
        cell.instruction.map { $0 } ->> instructionBond


        //instructionsArray?.append(cell.textField.text)
        cell.configure(text: "", placeholder: "")
        return cell
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        instructionBond = Bond<String>(){ instruction in
            self.instructionsArray?.append(instruction)
            //println(self.instructionsArray?.count)
        }
        
        

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
