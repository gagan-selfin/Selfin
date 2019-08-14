//
//  SubAccountCollectionViewCell.swift
//  Selfin
//
//  Created by cis on 21/02/2019.
//  Copyright © 2019 Selfin. All rights reserved.
//

import UIKit
import Nuke

class SubAccountCollectionViewCell: UICollectionViewCell {
    @IBOutlet var imageViewAccount: UIImageView!
    @IBOutlet var labelName: UILabel!
    @IBOutlet var labelBio: UILabel!
    @IBOutlet var buttonFollow: UIButton!
    let color = UIColor(red: 249.0 / 255.0, green: 64.0 / 255.0, blue: 148.0 / 255.0, alpha: 1.0)
    var onFollow:((_ username : String) -> ())?
    var username : String?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        buttonFollow.layer.cornerRadius = 20
        buttonFollow.clipsToBounds = true
        imageViewAccount.layer.cornerRadius = 8
        imageViewAccount.clipsToBounds = true
    }
    
    func configure(data : SubSelfinAccounts.AccountList) {
        stopLoading()
        buttonFollow.hideSkeleton()
        username = data.username
        print(data.profileImage)
        if let postUrl = URL(string: data.profileImage) {
            Nuke.loadImage(with: postUrl, into: imageViewAccount)
        }else {
            imageViewAccount.image = UIImage.init(named: "Placeholder_image")
        }
        labelName.text = data.username
        labelBio.text = data.name
        handleButtonUI(isFollowing: data.following)
    }
    
    @IBAction func actionFollowAccount(_ sender: UIButton) {onFollow?(username ?? "");buttonFollow.showAnimatedSkeleton()}
    
    func loading() {
        [imageViewAccount, labelName, labelBio, buttonFollow]
            .forEach { $0?.showAnimatedSkeleton() }}
    
    func stopLoading() {
        [imageViewAccount, labelName, labelBio, buttonFollow]
            .forEach { $0?.hideSkeleton() }}
    
    func handleButtonUI(isFollowing : Bool) {
        if isFollowing {
            buttonFollow.isUserInteractionEnabled = false
            buttonFollow.layer.borderColor = color.cgColor
            buttonFollow.layer.borderWidth = 1
            buttonFollow.backgroundColor = color
            buttonFollow.setTitleColor(.white, for: .normal)
            buttonFollow.setTitle("FOLLOWING", for: .normal)
            buttonFollow.setImage(nil, for: .normal)
            buttonFollow.imageEdgeInsets.right = 0
            imageViewAccount.layer.cornerRadius = imageViewAccount.bounds.height/2
            imageViewAccount.clipsToBounds = true
        }else{
            buttonFollow.isUserInteractionEnabled = true
            buttonFollow.layer.borderColor = color.cgColor
            buttonFollow.layer.borderWidth = 1
            buttonFollow.backgroundColor = .white
            buttonFollow.setTitleColor(color, for: .normal)
            buttonFollow.setTitle("FOLLOW", for: .normal)
            buttonFollow.setImage(#imageLiteral(resourceName: "follow"), for: .normal)
            buttonFollow.imageEdgeInsets.right = 10
            imageViewAccount.layer.cornerRadius = 8
            imageViewAccount.clipsToBounds = true
        }
    }
}



