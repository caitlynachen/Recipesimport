//
//  IngredientsTableViewCell.swift
//  TemplateProject
//
//  Created by Caitlyn Chen on 7/6/15.
//  Copyright (c) 2015 Make School. All rights reserved.
//

import UIKit
import Bond

class IngredientsTableViewCell: UITableViewCell, UITextFieldDelegate {

    @IBOutlet weak var textField: UITextField!
    let ingredient: Dynamic<String?> = Dynamic(nil)
    
    optional func textFieldDidEndEditing(textField: UITextField){
        
    }
   
    
    internal func configure(#text: String?, placeholder: String) {
        textField.text = text
        textField.placeholder = placeholder
        
        textField.accessibilityValue = text
        textField.accessibilityLabel = placeholder
    }
    
    


    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    
}
