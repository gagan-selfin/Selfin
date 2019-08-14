//
//  CustomColorGradientView.swift
//  Selfin
//
//  Created by cis on 04/10/18.
//  Copyright © 2018 Selfin. All rights reserved.
//

import UIKit

class CustomColorGradientView: UIView {
    override func layoutSubviews() {
        super.layoutSubviews()
        let rectShape = CAShapeLayer()
        rectShape.bounds = frame
        rectShape.position = center
        rectShape.path = UIBezierPath(roundedRect: bounds, byRoundingCorners: [.bottomLeft, .bottomRight, .topLeft], cornerRadii: CGSize(width: 8, height: 8)).cgPath
        let gradientLayer: CAGradientLayer = CAGradientLayer()
        gradientLayer.frame.size = frame.size
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 1.0)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 1.0)
        let color2 = UIColor(red: 221 / 255.0, green: 25 / 255.0, blue: 182 / 255.0, alpha: 1.0).cgColor
        let color1 = UIColor(red: 248 / 255.0, green: 62 / 255.0, blue: 150 / 255.0, alpha: 1.0).cgColor
        gradientLayer.colors = [color1, color2]
        layer.addSublayer(gradientLayer)
        layer.mask = rectShape
    }
}
