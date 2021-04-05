//
//  TextInputTableViewCell.swift
//  iRecipe
//
//  Created by Guang Zheng Ang on 05/04/2021.
//

import UIKit

class TextInputTableViewCell: UITableViewCell {
    @IBOutlet weak var tableViewTextInput: UITextField!
    
    public func configure(text: String!, placeholder: String) {
        tableViewTextInput.text = text
        tableViewTextInput.placeholder = placeholder
        
        tableViewTextInput.accessibilityValue = text
        tableViewTextInput.accessibilityLabel = placeholder
    }
    
    public func getTextInput() -> UITextField {
        return tableViewTextInput
    }
}

class TextInputTableViewCell2: UITableViewCell {
    @IBOutlet weak var tableViewTextInput: UITextField!
    
    public func configure(text: String!, placeholder: String) {
        tableViewTextInput.text = text
        tableViewTextInput.placeholder = placeholder
        
        tableViewTextInput.accessibilityValue = text
        tableViewTextInput.accessibilityLabel = placeholder
    }
    public func getTextInput() -> UITextField {
        return tableViewTextInput
    }
}

