//
//  CommentsTableViewCell.swift
//  Selfin
//
//  Created by cis on 20/09/2018.
//  Copyright © 2018 Selfin. All rights reserved.
//

import Nuke
import UIKit

class CommentsTableViewCell: UITableViewCell {
    @IBOutlet weak var btnUserImage: UIButton!
    @IBOutlet var imageViewUserImage: UIImageView!
    @IBOutlet var labelComments: UILabel!
    @IBOutlet var labelTime: UILabel!
    @IBOutlet var imageViewLike: UIImageView!

    var actionLikePressed: ((_ commentId: Int) -> Void)?
    var likeActionCount: Int?
    var likeCount = 0

    override func awakeFromNib() {
        super.awakeFromNib()
        imageViewUserImage.layer.borderColor = UIColor.lightGray.cgColor
        imageViewUserImage.layer.borderWidth = 1
    }
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        layoutIfNeeded()
    }

    func configure(with comment: PostCommentsResponse.Comment) {
        labelComments.attributedText = attributedString(name: comment.user.username, comment: comment.content)
        print(comment)
        DispatchQueue.main.async {
            self.imageViewUserImage.layer.masksToBounds = true
            if comment.user.following ?? false {
                self.imageViewUserImage.layer.cornerRadius = self.imageViewUserImage.frame.height/2
            }else {
                self.imageViewUserImage.layer.cornerRadius = 8
            }
        }
        
        labelTime.text = comment.time

        if comment.isLiked {imageViewLike.image = #imageLiteral(resourceName: "likelite")}
        else if comment.isSuperLiked {imageViewLike.image = #imageLiteral(resourceName: "likeSelected")}
        else {imageViewLike.image = #imageLiteral(resourceName: "likeCount")}

        if comment.user.profileImage == "" {
            imageViewUserImage.image = #imageLiteral(resourceName: "Placeholder_image")
        } else {
            if let url = URL(string: comment.user.image) {
                Nuke.loadImage(with: url, into: imageViewUserImage)
            }
        }
    }

    func attributedString(name: String, comment: String) -> NSMutableAttributedString {
        let username = NSMutableAttributedString(string: name)
        username.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor(red: 24 / 255, green: 19 / 255, blue: 67 / 255, alpha: 1), range: NSRange(location: 0, length: name.count))

        let attrStr = NSMutableAttributedString(string: comment)
        let searchPattern = "@\\w+"
        var ranges: [NSRange] = [NSRange]()

        let regex = try! NSRegularExpression(pattern: searchPattern, options: [])
        ranges = regex.matches(in: attrStr.string, options: [], range: NSMakeRange(0, attrStr.string.count)).map { $0.range }

        for range in ranges {
            attrStr.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor(red: 24 / 255, green: 19 / 255, blue: 67 / 255, alpha: 1), range: NSRange(location: range.location, length: range.length))
        }

        let combination = NSMutableAttributedString()
        combination.append(username)
        combination.append(NSAttributedString(string: " "))
        combination.append(attrStr)
        return combination
    }
    @objc func actionLikePressed(sender _: UIButton) {}
}
