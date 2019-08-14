//
//  ChatListCollectionViewCell.swift
//  Selfin
//
//  Created by cis on 20/11/2018.
//  Copyright © 2018 Selfin. All rights reserved.
//

import UIKit
import Nuke

class ChatListCollectionViewCell: UICollectionViewCell {
    @IBOutlet var imageViewUser: UIImageView!
    @IBOutlet var labelUsername: UILabel!
    @IBOutlet var labelMessage: UILabel!
    @IBOutlet var labelTime: UILabel!
    var didSelect: ((_ user: String) -> Void)?
    var username : String?
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configure<T>(with content: T, isSearch : Bool ) {
        stopLoading()
        if isSearch {
            let user : FollowingFollowersResponse.User = content as! FollowingFollowersResponse.User
            username = user.username
            labelUsername.text = user.username
            labelMessage.text = user.firstName + "" + user.lastName
            if let postUrl = URL(string: user.userImage) {Nuke.loadImage(with: postUrl, into: imageViewUser)}else {imageViewUser.image = UIImage.init(named: "")}
            if user.following {
                imageViewUser.layer.cornerRadius = imageViewUser.frame.height/2
            }else {imageViewUser.layer.cornerRadius = 5}
            labelTime.text = ""
        }else {
            let chat = content as! HSChatUsers
            username = chat.name
            labelUsername.text = chat.name
            labelMessage.text = chat.lastMessage
            if chat.time != 0 {
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
                dateFormatter.timeZone = NSTimeZone(abbreviation: "UTC")! as TimeZone
                let date = dateFormatter.date(from: dateFormatter.string(from: Date(timeIntervalSince1970: TimeInterval(chat.time))))
                labelTime.text = timeAgoSince(date ?? Date())
            }
            
            if let postUrl = URL(string: "\(chat.image)") {
                Nuke.loadImage(with: postUrl, into: imageViewUser)
            }else {imageViewUser.image =  UIImage.init(named: "Placeholder_image")}
        }
    }
    
    @IBAction func actionViewProfile(_ sender: Any) {didSelect?(username ?? "")}
    
    func loading() {[imageViewUser,labelUsername,labelMessage,labelTime].forEach { $0?.showAnimatedSkeleton()}}
    
    func stopLoading() {[imageViewUser,labelUsername,labelMessage,labelTime].forEach { $0?.hideSkeleton()}}
}
