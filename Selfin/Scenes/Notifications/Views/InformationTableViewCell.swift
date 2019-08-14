//
//  InformationTableViewCell.swift
//  Selfin
//
//  Created by cis on 27/11/18.
//  Copyright © 2018 Selfin. All rights reserved.
//

import UIKit
import Nuke

class InformationTableViewCell: UITableViewCell {

    @IBOutlet weak var btnInfo: UIButton!
    @IBOutlet var imageviewInformation: UIImageView!
    @IBOutlet var labelInformation: UILabel!
    @IBOutlet var content: AttrTextView!
    weak var delegate:navigationFromCells?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func configureInformationCell(notification:UserNotification.NotificationType, username:String)
    {
        let imageURL = notification.user.profile_Image
        if notification.user.profileImage == "" {
            imageviewInformation.image = #imageLiteral(resourceName: "Placeholder_image")
            imageviewInformation.backgroundColor = UIColor.clear
        } else {
            let url = URL(string: imageURL)
            Nuke.loadImage(with: url!, into: imageviewInformation)
            imageviewInformation.backgroundColor = UIColor.init(red: 242.0/255.0, green: 241/255.0, blue: 239/255.0, alpha: 1.0)
        }
        if notification.user.following {
            imageviewInformation.layer.cornerRadius = imageviewInformation.frame.height / 2
            imageviewInformation.clipsToBounds = true
        } else {
            if notification.user.userName == username {
                imageviewInformation.layer.cornerRadius = imageviewInformation.frame.height / 2
                imageviewInformation.clipsToBounds = true
            } else {
                imageviewInformation.layer.cornerRadius = 5
                imageviewInformation.clipsToBounds = true
            }
        }
        
        content.setText(text: notification.description, type: .username, andCallBack: callBack(string:type:))
    }
    
    func callBack(string : String , type : wordType){
        switch type {
        case .username:
           delegate?.didMove(to: .profile(username: string))
        default: break
        }
    }
}
