//
//  LikesTableViewCell.swift
//  Selfin
//
//  Created by cis on 21/09/2018.
//  Copyright © 2018 Selfin. All rights reserved.
//

import Nuke
import UIKit

class LikesTableViewCell: UITableViewCell {
    
    @IBOutlet weak var btnUserImage: UIButton!
    @IBOutlet var imageViewUserProfileImage: UIImageView!
    @IBOutlet var labelUsername: UILabel!
    @IBOutlet var labelFullName: UILabel!
    @IBOutlet var imageViewLikeStatus: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()

        layer.cornerRadius = 10.0
        layer.shadowColor = UIColor.gray.cgColor
        layer.shadowOpacity = 0.2
        layer.shadowOffset = CGSize.zero
        layer.shadowRadius = 3
        clipsToBounds = false
    }

    func configure(with likes: PostLikedUsersResponse.Liked) {
        labelUsername.text = "\(likes.user.username)"
        labelFullName.text = likes.user.firstName + " " + likes.user.lastName

        imageViewLikeStatus.image = #imageLiteral(resourceName: "unselectedLike")

        if likes.isLiked
        {imageViewLikeStatus.image = #imageLiteral(resourceName: "likeHeart")}

        if likes.isSuperLiked
        {imageViewLikeStatus.image = #imageLiteral(resourceName: "superLike")}

        if likes.user.profileImage == ""
        {imageViewUserProfileImage.image = #imageLiteral(resourceName: "Placeholder_image")}
        
        else{
            if let url = URL(string: likes.user.userImage) {
                Nuke.loadImage(with: url, into: imageViewUserProfileImage)
            }
        }
    }
}
