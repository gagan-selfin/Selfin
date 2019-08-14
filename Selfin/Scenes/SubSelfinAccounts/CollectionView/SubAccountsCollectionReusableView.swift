//
//  SubAccountsCollectionReusableView.swift
//  Selfin
//
//  Created by cis on 21/02/2019.
//  Copyright © 2019 Selfin. All rights reserved.
//

import UIKit

class SubAccountsCollectionReusableView: UICollectionReusableView {
    @IBOutlet var buttonFollow: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        buttonFollow.layer.borderColor = UIColor(red: 249.0 / 255.0, green: 64.0 / 255.0, blue: 148.0 / 255.0, alpha: 1.0).cgColor
        buttonFollow.layer.borderWidth =  1.0
    }

    var onStyleSelected:(()-> ())?
    
    @IBAction func actionFollowAllSubSelfinAccounts(_ sender: Any) {
        onStyleSelected?()
    }
}
