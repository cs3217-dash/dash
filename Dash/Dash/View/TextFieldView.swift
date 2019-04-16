//
//  TextFieldView.swift
//  Dash
//
//  Created by Jolyn Tan on 16/4/19.
//  Copyright © 2019 nus.cs3217. All rights reserved.
//

import UIKit

class TextFieldView: UITextField {
    override init (frame: CGRect) {
        super.init(frame: frame)
    }

    convenience init(size: CGSize, origin: CGPoint) {
        self.init(frame: CGRect(origin: origin, size: size))

        // text properties
        self.textColor = .white
        self.attributedPlaceholder = NSAttributedString(
            string: "enter your name here",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.init(white: 1, alpha: 0.8)])
        self.layer.borderColor = UIColor.white.cgColor
        self.layer.borderWidth = 1
        self.backgroundColor = self.backgroundColor

        // left and right padding
        let padding = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: size.height))
        self.leftView = padding
        self.leftViewMode = .always
        self.rightView = padding
        self.rightViewMode = .always
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("This class does not support NSCoding")
    }
}
