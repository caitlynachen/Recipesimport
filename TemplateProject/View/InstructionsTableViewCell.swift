//
//  InstructionsTableViewCell.swift
//  TemplateProject
//
//  Created by Caitlyn Chen on 7/6/15.
//  Copyright (c) 2015 Make School. All rights reserved.
//

import UIKit
import Bond

class InstructionsTableViewCell: UITableViewCell, UITextFieldDelegate {

    @IBOutlet weak var textField: UITextField!{
        didSet{
            textField.delegate = self
        }
    }
    
    let instruction: Dynamic<String> = Dynamic("")

    func textFieldDidEndEditing(textfield: UITextField){
        // println("hello")
        //println(textfield.text)
        instruction.value = textfield.text
        //println(instruction.value)
    }
    
    func configure(#text: String?, placeholder: String) {
        textField.text = text
        textField.placeholder = placeholder
        
        textFieldDidEndEditing(textField)

        
        textField.accessibilityValue = text
        textField.accessibilityLabel = placeholder
    }
    
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
