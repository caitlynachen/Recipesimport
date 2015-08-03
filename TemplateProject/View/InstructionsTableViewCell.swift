//
//  InstructionsTableViewCell.swift
//  TemplateProject
//
//  Created by Caitlyn Chen on 7/6/15.
//  Copyright (c) 2015 Make School. All rights reserved.
//

import UIKit
import Bond

class InstructionsTableViewCell: UITableViewCell, UITextViewDelegate {
    




    @IBOutlet weak var textView: UITextView!{
        didSet{
            textView.delegate = self
        }

    }
    
    let instruction: Dynamic<String> = Dynamic("")

    func textViewDidEndEditing(textView: UITextView){
        // println("hello")
        //println(textfield.text)
        instruction.value = textView.text
        //println(instruction.value)
    }
    
    
    
    //sourcetreeeee
    
    func configure(#text: String?, placeholder: String) {
        textView.text = text
        
        textViewDidEndEditing(textView)
        
        textView.accessibilityValue = text
    }
    
    
//    func textFieldShouldReturn(textField: UITextField) -> Bool {
//        textField.resignFirstResponder()
//        return true
//    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
