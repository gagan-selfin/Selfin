//
//  HeaderViewCell.swift
//  Selfin
//
//  Created by cis on 27/11/18.
//  Copyright © 2018 Selfin. All rights reserved.
//

import UIKit

class HeaderViewCell: UITableViewCell {
    @IBOutlet weak var selfNotification: UIButton!
    @IBOutlet weak var socialNotification: UIButton!
    var table = NotificationsTableView()
    var onSelection:((_ type:Type_Notification) ->())?
    let selectedColor = UIColor(displayP3Red: 249/255, green: 64/255, blue: 148/255, alpha: 1)

    func setType(type:Type_Notification)
    {
        [selfNotification,socialNotification].forEach {
            $0?.setTitleColor(UIColor(displayP3Red: 24/255, green: 19/255, blue: 67/255, alpha: 1), for: .normal)
            $0?.backgroundColor = .clear
        }

        switch type {
        case .type_self:
            selfNotification.setTitleColor(.white, for: .normal)
            selfNotification.backgroundColor = selectedColor
        case .type_social:
            socialNotification.setTitleColor(.white, for: .normal)
            socialNotification.backgroundColor = selectedColor
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    @IBAction func buttonAction(_ sender: UIButton) {
        [selfNotification,socialNotification].forEach {
            $0?.setTitleColor(UIColor(displayP3Red: 24/255, green: 19/255, blue: 67/255, alpha: 1), for: .normal)
            $0?.backgroundColor = .clear}
        switch sender {
        case selfNotification:
            onSelection?(.type_self)
            selfNotification.setTitleColor(.white, for: .normal)
            selfNotification.backgroundColor = selectedColor
        case socialNotification:
            onSelection?(.type_social)
            socialNotification.setTitleColor(.white, for: .normal)
            socialNotification.backgroundColor = selectedColor

        default:
            break
        }
    }
}
