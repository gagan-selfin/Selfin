//
//  SettingsTableViewCell.swift
//  Selfin
//
//  Created by cis on 20/09/18.
//  Copyright © 2018 Selfin. All rights reserved.
//

import UIKit

class SettingsTableViewCell: UITableViewCell {
    @IBOutlet var lblPrivate: UILabel!
    @IBOutlet var lblPublic: UILabel!
    @IBOutlet var switchAccountType: UISwitch!
    @IBOutlet var imgPrivate: UIImageView!
    @IBOutlet var imgPublic: UIImageView!
    @IBOutlet var imgMore: UIImageView!
    @IBOutlet var constraintLeadingLblOption: NSLayoutConstraint!
    @IBOutlet var lblOption: UILabel!
    @IBOutlet var imgViewOption: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func configureCell(image: [Any], options: [Any], index: Int) {
        lblOption.text = options[index] as? String
        if index == 3 {
            switchAccountType.isHidden = false
            imgPublic.isHidden = false
            imgPrivate.isHidden = false
            lblPublic.isHidden = false
            lblPrivate.isHidden = false
        } else {
            switchAccountType.isHidden = true
            imgPublic.isHidden = true
            imgPrivate.isHidden = true
            lblPublic.isHidden = true
            lblPrivate.isHidden = true
        }

        if index == 0 || index == 5 || index == 6 {imgMore.isHidden = false}
        else {imgMore.isHidden = true}

        if index == options.count - 1 {
            imgViewOption.isHidden = true
            constraintLeadingLblOption.constant = -17
            lblOption.textColor = UIColor(red: 249.0 / 255.0, green: 64.0 / 255.0, blue: 148.0 / 255.0, alpha: 1.0)
            lblOption.font = UIFont.systemFont(ofSize: 15.0)
        } else {
            imgViewOption.image = image[index] as? UIImage

            imgViewOption.isHidden = false
            lblOption.textColor = .black
            constraintLeadingLblOption.constant = 17
            lblOption.font = UIFont.systemFont(ofSize: 14.0)
        }
    }
}
