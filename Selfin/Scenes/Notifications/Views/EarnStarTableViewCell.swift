//
//  EarnStarTableViewCell.swift
//  Selfin
//
//  Created by cis on 27/11/18.
//  Copyright © 2018 Selfin. All rights reserved.
//

import UIKit
import Nuke

class EarnStarTableViewCell: UITableViewCell {

    @IBOutlet weak var btnStars: UIButton!
    @IBOutlet var imageViewStars: UIImageView!
    @IBOutlet var labelStarCount: UILabel!
    @IBOutlet var labelStarTime: UILabel!
    @IBOutlet var content: AttrTextView!
    weak var delegate:navigationFromCells?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
//        let tap : UITapGestureRecognizer = UITapGestureRecognizer.init(target: self, action: #selector(moveToUserProfile(gesture:)))
//        tap.numberOfTapsRequired = 1
//        imageViewStars.addGestureRecognizer(tap)
    }

    func configureEarnStarCell (notification:UserNotification.NotificationType, username:String) {
        let imageURL = notification.user.profile_Image
        
        if notification.user.profileImage == "" {
            imageViewStars.image = #imageLiteral(resourceName: "Placeholder_image")
            imageViewStars.backgroundColor = UIColor.clear
        } else {
            let url = URL(string: imageURL)
            Nuke.loadImage(with: url!, into: imageViewStars)
            imageViewStars.backgroundColor = UIColor.init(red: 242.0/255.0, green: 241/255.0, blue: 239/255.0, alpha: 1.0)
        }
        
        if notification.user.following {
            imageViewStars.layer.cornerRadius = imageViewStars.frame.height / 2
            imageViewStars.clipsToBounds = true
        } else {
            if notification.user.userName == username {
                imageViewStars.layer.cornerRadius = imageViewStars.frame.height / 2
                imageViewStars.clipsToBounds = true
            } else {
                imageViewStars.layer.cornerRadius = 5
                imageViewStars.clipsToBounds = true
            }
        }
        
        if notification.time != "" {
            labelStarTime.text = notification.timeAgo
        } else { labelStarTime.text = "" }
        
        content.setText(text: notification.notificationContent, type: .username, andCallBack: callBack(string:type:))
    }
    
    @objc func moveToUserProfile(gesture: UITapGestureRecognizer) {
        delegate?.didMove(to: .profile(username: ""))
    }
    
    func callBack(string : String , type : wordType){
        switch type {
        case .username:
            print(string)
             delegate?.didMove(to: .profile(username: string))
        default: break
        }
    }
}
