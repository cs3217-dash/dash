//
//  LoadingView.swift
//  Dash
//
//  Created by Jolyn Tan on 16/4/19.
//  Copyright © 2019 nus.cs3217. All rights reserved.
//

import UIKit

class LoadingView: UIView {

    required init(coder aDecoder: NSCoder) {
    fatalError("This class does not support NSCoding")
    }

    override init (frame: CGRect) {
        super.init(frame: frame)
    }

    convenience init(origin: CGPoint, mid: CGPoint, size: CGSize) {
        self.init(frame: CGRect(origin: origin, size: size))

        // window
        let loadingRect = CGRect(x: origin.x, y: origin.y,
                                 width: size.width, height: size.height)
        self.frame = loadingRect
        self.backgroundColor = UIColor.init(white: 0, alpha: 0.8)

        // label
        let loadingLabel = UILabel(frame: CGRect(x: 0, y: 0,
                                                 width: size.width, height: size.height))
        loadingLabel.font = UIFont(name: "HelveticaNeue-Light", size: 20)
        loadingLabel.center = CGPoint(x: mid.x,
                                      y: mid.y + 64)
        loadingLabel.textColor = .white
        loadingLabel.textAlignment = .center
        loadingLabel.text = "loading"
        self.addSubview(loadingLabel)

        // icon
        let loadingIconRect = CGRect(x: 0, y: 0, width: 5, height: 5)
        let loadingIcon = UIView(frame: loadingIconRect)
        loadingIcon.center = CGPoint(x: mid.x, y: mid.y - 28)
        loadingIcon.backgroundColor = .white
        loadingIcon.layer.cornerRadius = loadingIconRect.width / 2
        self.addSubview(loadingIcon)

        animate(loadingIcon)
    }

    private func animate(_ icon: UIView) {
        UIView.animate(withDuration: 1, delay: 0, options: [.repeat, .curveEaseInOut], animations: {
            icon.transform = CGAffineTransform(scaleX: 20, y: 20)
            icon.alpha = 0
        })
    }
}
