//
//  CustomRoundCornerView.swift
//  Selfin
//
//  Created by cis on 03/10/18.
//  Copyright © 2018 Selfin. All rights reserved.
//

import UIKit

class CustomRoundCornerView: UIView {
    /*
     // Only override draw() if you perform custom drawing.
     // An empty implementation adversely affects performance during animation.
     override func draw(_ rect: CGRect) {
     // Drawing code
     }
     */
    override func layoutSubviews() {
        super.layoutSubviews()
        let rectShape = CAShapeLayer()
        rectShape.bounds = frame
        rectShape.position = center
        if tag == 88 {
            rectShape.path = UIBezierPath(roundedRect: bounds, byRoundingCorners: [.bottomLeft, .bottomRight, .topRight], cornerRadii: CGSize(width: 20, height: 20)).cgPath
        } else if tag == 99 {
            rectShape.path = UIBezierPath(roundedRect: bounds, byRoundingCorners: [.bottomLeft, .bottomRight, .topLeft], cornerRadii: CGSize(width: 20, height: 20)).cgPath
        } else if tag == 109 {
            rectShape.path = UIBezierPath(roundedRect: bounds, byRoundingCorners: [.topLeft,.topRight], cornerRadii: CGSize(width: 10, height: 10)).cgPath
        }else if tag == 119 {
            rectShape.path = UIBezierPath(roundedRect: bounds, byRoundingCorners: [.topLeft,.topRight], cornerRadii: CGSize(width: 10, height: 10)).cgPath
        }else if tag == 0 {
            rectShape.path = UIBezierPath(roundedRect: bounds, byRoundingCorners: [.topLeft,.topRight,.bottomLeft,.bottomRight], cornerRadii: CGSize(width: 0, height: 0)).cgPath        }

        layer.mask = rectShape
    }

    // Here I'm masking the textView's layer with rectShape layer
}
