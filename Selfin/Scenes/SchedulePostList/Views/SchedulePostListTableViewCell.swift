//
//  SchedulePostListTableViewCell.swift
//  Selfin
//
//  Created by cis on 04/10/18.
//  Copyright © 2018 Selfin. All rights reserved.
//

import Nuke
import UIKit

class SchedulePostListTableViewCell: UITableViewCell {
    @IBOutlet var btnTagCount: UIButton!
    @IBOutlet var constraintHeightImgViewTag: NSLayoutConstraint!
    @IBOutlet var lblTime: UILabel!
    @IBOutlet var viewContainer: UIView!
    @IBOutlet var lblLocationTag: UILabel!
    @IBOutlet var imgViewTag4: UIImageView!
    @IBOutlet var imgViewTag3: UIImageView!
    @IBOutlet var imgViewTag2: UIImageView!
    @IBOutlet var imgViewTag1: UIImageView!
    @IBOutlet var lblDetails: UILabel!
    @IBOutlet var imgViewAvatar: UIImageView!
    @IBOutlet var imgViewPost: UIImageView!
    @IBOutlet var lblLocation: UILabel!
    @IBOutlet var lblUsername: UILabel!
    @IBOutlet var btnDropDown: UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code

        viewContainer.layer.cornerRadius = 10.0
        viewContainer.layer.shadowColor = UIColor.gray.cgColor
        viewContainer.layer.shadowOpacity = 0.2
        viewContainer.layer.shadowOffset = CGSize.zero
        viewContainer.layer.shadowRadius = 3
        viewContainer.clipsToBounds = false

        imgViewAvatar.layer.cornerRadius = imgViewAvatar.frame.size.width / 2
        imgViewAvatar.clipsToBounds = true

        imgViewTag1.layer.cornerRadius = imgViewTag1.frame.size.width / 2
        imgViewTag1.clipsToBounds = true

        imgViewTag2.layer.cornerRadius = imgViewTag2.frame.size.width / 2
        imgViewTag2.clipsToBounds = true

        imgViewTag3.layer.cornerRadius = imgViewTag3.frame.size.width / 2
        imgViewTag3.clipsToBounds = true

        imgViewTag4.layer.cornerRadius = imgViewTag4.frame.size.width / 2
        imgViewTag4.clipsToBounds = true

        imgViewPost.layer.cornerRadius = 10.0
        imgViewPost.clipsToBounds = true
    }

    func configure(with feed: scheduledPostResponse.Post) {
       
        if feed.user.image == "" { // To show placeholder image
            imgViewAvatar.image = #imageLiteral(resourceName: "Placeholder_image")
        } else {
            let imageURLProfile = feed.user.image
            if let urlProfile = URL(string: imageURLProfile) {
                Nuke.loadImage(with: urlProfile, into: imgViewAvatar)
            }
        }

        let imageURL = feed.Image
        if let url = URL(string: imageURL) {
            Nuke.loadImage(with: url, into: imgViewPost)
        }

        lblUsername.text = feed.user.username
        lblLocation.text = feed.locationDetails.locationName
        lblDetails.text = feed.content
        lblLocationTag.text = feed.locationDetails.locationName

        lblTime.text = "Scheduled for " + feed.time
        
        setTaggedUser(feed : feed)
    }
    
    func setTaggedUser(feed: scheduledPostResponse.Post)  {
        let arr = feed.taggedUser
        if arr.count == 0 {
            constraintHeightImgViewTag.constant = 0.0
            imgViewTag2.isHidden = true
            imgViewTag3.isHidden = true
            imgViewTag4.isHidden = true
            
            btnTagCount.isHidden = true
        } else if arr.count == 1 {
            constraintHeightImgViewTag.constant = 25.0
            imgViewTag2.isHidden = true
            imgViewTag3.isHidden = true
            imgViewTag4.isHidden = true
            
            let str = arr[0].userImage
            
            if str == "" {
                imgViewTag1.image = #imageLiteral(resourceName: "Placeholder_image")
            } else {
                
                if let urlProfile = URL(string: str) {
                    Nuke.loadImage(with: urlProfile, into: imgViewTag1)
                }
            }
            btnTagCount.isHidden = true
            
        } else if arr.count == 2 {
            constraintHeightImgViewTag.constant = 25.0
            imgViewTag2.isHidden = false
            imgViewTag3.isHidden = true
            imgViewTag4.isHidden = true
            
            let str = arr[0].userImage
            let str1 = arr[1].userImage
            
            if str == "" {
                imgViewTag1.image = #imageLiteral(resourceName: "Placeholder_image")
            } else {
                
                if let urlProfile = URL(string: str) {
                    Nuke.loadImage(with: urlProfile, into: imgViewTag1)
                }
            }
            
            if str1 == "" {
                imgViewTag2.image = #imageLiteral(resourceName: "Placeholder_image")
            } else {
                if let urlProfile1 = URL(string: str1) {
                    Nuke.loadImage(with: urlProfile1, into: imgViewTag2)
                }
            }
            btnTagCount.isHidden = true
            
        } else if arr.count == 3 {
            constraintHeightImgViewTag.constant = 25.0
            imgViewTag2.isHidden = false
            imgViewTag3.isHidden = false
            imgViewTag4.isHidden = true
            
            let str3 = arr[2].userImage
            let str2 = arr[1].userImage
            let str1 = arr[0].userImage
            
            if str1 == "" {
                imgViewTag1.image = #imageLiteral(resourceName: "Placeholder_image")
            } else {
                if let urlProfile1 = URL(string: str1) {
                    Nuke.loadImage(with: urlProfile1, into: imgViewTag1)
                }
            }
            
            if str2 == "" {
                imgViewTag2.image = #imageLiteral(resourceName: "Placeholder_image")
            } else {
                if let urlProfile2 = URL(string: str2) {
                    Nuke.loadImage(with: urlProfile2, into: imgViewTag2)
                }
            }
            
            if str3 == "" {
                imgViewTag3.image = #imageLiteral(resourceName: "Placeholder_image")
            } else {
                if let urlProfile3 = URL(string: str3) {
                    Nuke.loadImage(with: urlProfile3, into: imgViewTag3)
                }
            }
            btnTagCount.isHidden = true
            
        } else if arr.count == 4 {
            constraintHeightImgViewTag.constant = 25.0
            imgViewTag2.isHidden = false
            imgViewTag3.isHidden = false
            imgViewTag4.isHidden = false
            
            let str1 = arr[0].userImage
            let str2 = arr[1].userImage
            let str3 = arr[2].userImage
            let str4 = arr[3].userImage
            
            if str1 == "" {
                imgViewTag1.image = #imageLiteral(resourceName: "Placeholder_image")
            } else {
                if let urlProfile1 = URL(string: str1) {
                    Nuke.loadImage(with: urlProfile1, into: imgViewTag1)
                }
            }
            
            if str2 == "" {
                imgViewTag2.image = #imageLiteral(resourceName: "Placeholder_image")
            } else {
                if let urlProfile2 = URL(string: str2) {
                    Nuke.loadImage(with: urlProfile2, into: imgViewTag2)
                }
            }
            
            if str3 == "" {
                imgViewTag3.image = #imageLiteral(resourceName: "Placeholder_image")
            } else {
                if let urlProfile3 = URL(string: str3) {
                    Nuke.loadImage(with: urlProfile3, into: imgViewTag3)
                }
            }
            
            if str4 == "" {
                imgViewTag4.image = #imageLiteral(resourceName: "Placeholder_image")
            } else {
                if let urlProfile4 = URL(string: str4) {
                    Nuke.loadImage(with: urlProfile4, into: imgViewTag4)
                }
            }
            
            btnTagCount.isHidden = true
            
        } else if arr.count > 3 {
            constraintHeightImgViewTag.constant = 25.0
            imgViewTag2.isHidden = false
            imgViewTag3.isHidden = false
            imgViewTag4.isHidden = false
            
            let str1 = arr[0].userImage
            let str2 = arr[1].userImage
            let str3 = arr[2].userImage
            let str4 = arr[3].userImage
            
            if str1 == "" {
                imgViewTag1.image = #imageLiteral(resourceName: "Placeholder_image")
            } else {
                if let urlProfile1 = URL(string: str1) {
                    Nuke.loadImage(with: urlProfile1, into: imgViewTag1)
                }
            }
            
            if str2 == "" {
                imgViewTag2.image = #imageLiteral(resourceName: "Placeholder_image")
            } else {
                if let urlProfile2 = URL(string: str2) {
                    Nuke.loadImage(with: urlProfile2, into: imgViewTag2)
                }
            }
            
            if str3 == "" {
                imgViewTag3.image = #imageLiteral(resourceName: "Placeholder_image")
            } else {
                if let urlProfile3 = URL(string: str3) {
                    Nuke.loadImage(with: urlProfile3, into: imgViewTag3)
                }
            }
            
            if str4 == "" {
                imgViewTag4.image = #imageLiteral(resourceName: "Placeholder_image")
            } else {
                if let urlProfile4 = URL(string: str4) {
                    Nuke.loadImage(with: urlProfile4, into: imgViewTag4)
                }
            }
            
            if arr.count > 4 {
                if arr.count - 4 > 0 {
                    btnTagCount.isHidden = false
                    btnTagCount.setTitle(String(format: "+%d", arr.count - 2), for: .normal)
                } else {
                    btnTagCount.isHidden = true
                }
            } else {
                btnTagCount.isHidden = true
            }
        }
    }
}
