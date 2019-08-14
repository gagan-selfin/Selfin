//
//  LikeTableViewCell.swift
//  Selfin
//
//  Created by cis on 27/11/18.
//  Copyright © 2018 Selfin. All rights reserved.
//

import UIKit
import Nuke

class LikeTableViewCell: UITableViewCell {

    @IBOutlet weak var btnLikeUser: UIButton!
    @IBOutlet var imageViewLikeUser: UIImageView!
    @IBOutlet var imageViewLikePost: UIImageView!
    @IBOutlet var labelComment: UILabel!
    @IBOutlet var textViewDescription: AttrTextView!
    @IBOutlet var labelLikeTime: UILabel!
    weak var delegate:navigationFromCells?
    var notification: UserNotification.NotificationType?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func configureLikeCell (notification: UserNotification.NotificationType, username:String) {
        self.notification = notification
        if notification.time != "" {
            labelLikeTime.text = notification.timeAgo
        } else {labelLikeTime.text = ""}
        
        self.textViewDescription.setText(text: notification.description, type: .username , andCallBack: callBack(string:type:))

        let imageURL = notification.user.profile_Image
        if notification.user.profileImage == "" {
            imageViewLikeUser.image = #imageLiteral(resourceName: "Placeholder_image")
            imageViewLikeUser.backgroundColor = UIColor.clear
        } else {
            let url = URL(string: imageURL)
            Nuke.loadImage(with: url!, into: imageViewLikeUser)
            imageViewLikeUser.backgroundColor = UIColor.init(red: 242.0/255.0, green: 241/255.0, blue: 239/255.0, alpha: 1.0)
        }
        
        if notification.user.following {
            imageViewLikeUser.layer.cornerRadius = imageViewLikeUser.frame.height / 2
            imageViewLikeUser.clipsToBounds = true
        } else {
            if notification.user.userName == username {
                imageViewLikeUser.layer.cornerRadius = imageViewLikeUser.frame.height / 2
                imageViewLikeUser.clipsToBounds = true
            } else {
                imageViewLikeUser.layer.cornerRadius = 5
                imageViewLikeUser.clipsToBounds = true
            }
        }
        
        let postImageURL = notification.post_Image
        if let url = URL(string: postImageURL) {
            Nuke.loadImage(with: url, into: imageViewLikePost)
        }
        
        if notification.notificationContent != "" {
            labelComment.text = notification.notificationContent
        }
    }
    
    @IBAction func actionViewPost(_ sender: Any) {
         delegate?.didMove(to: .post(id: notification?.postId ?? 0))
    }
    
    func callBack(string : String , type : wordType){
        switch type {
        case .username:
           delegate?.didMove(to: .profile(username: string))
        default: break
        }
    }
}

extension LikeTableViewCell : UITextViewDelegate {
    @available(iOS 10.0, *)
    public func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        print(URL)
        return false
    }
}

extension NSAttributedString {
    func rangeOf(string: String) -> Range<String.Index>? {
        return self.string.range(of: string)
    }
}
