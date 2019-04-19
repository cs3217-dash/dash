//
//  TextFieldView.swift
//  Dash
//
//  Created by Jolyn Tan on 16/4/19.
//  Copyright © 2019 nus.cs3217. All rights reserved.
//

import UIKit

class TextFieldView: UITextField {

    convenience init(size: CGSize, origin: CGPoint, placeholder: String) {
        self.init(frame: CGRect(origin: origin, size: size))

        // text properties
        self.textColor = .white
        self.attributedPlaceholder = NSAttributedString(
            string: placeholder,
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.init(white: 1, alpha: 0.8)])
        self.layer.borderColor = UIColor.white.cgColor
        self.layer.borderWidth = 1
        self.backgroundColor = .clear

        // left and right padding
        let padding = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: size.height))
        self.leftView = padding
        self.leftViewMode = .always
        self.rightView = padding
        self.rightViewMode = .always

        self.delegate = self
    }
}

extension TextFieldView: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return false
    }
}
