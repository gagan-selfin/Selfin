//
//  LoginContainerView.swift
//  Selfin
//
//  Created by Marlon Monroy on 8/18/18.
//  Copyright © 2018 Selfin. All rights reserved.
//

import UIKit
class LoginContainerView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }

    private func setup() {
        layer.cornerRadius = 8
    }
}
