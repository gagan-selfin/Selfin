//
//  CustomShadowView.swift
//  Selfin
//
//  Created by cis on 03/10/18.
//  Copyright © 2018 Selfin. All rights reserved.
//

import UIKit

class CustomShadowView: UIView {
    /*
     // Only override draw() if you perform custom drawing.
     // An empty implementation adversely affects performance during animation.
     override func draw(_ rect: CGRect) {
     // Drawing code
     }
     */
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.masksToBounds = false
        layer.shadowRadius = 1.0
        layer.shadowOpacity = 0.3
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize.zero
    }
}
