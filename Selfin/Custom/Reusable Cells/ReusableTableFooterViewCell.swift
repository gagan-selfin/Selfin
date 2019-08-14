//
//  ReusableTableFooterViewCell.swift
//  Selfin
//
//  Created by cis on 18/12/18.
//  Copyright © 2018 Selfin. All rights reserved.
//

import UIKit

class ReusableTableFooterViewCell: UITableViewCell {
    @IBOutlet weak var lblMsg: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
