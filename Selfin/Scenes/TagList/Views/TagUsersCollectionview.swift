//
//  TagUsersCollectionview.swift
//  Selfin
//
//  Created by cis on 05/10/2018.
//  Copyright © 2018 Selfin. All rights reserved.
//

import Nuke
import UIKit

class TagUsersCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet var imgProfilePic: UIImageView!
    @IBOutlet var buttonCancel: UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()
        imgProfilePic.layer.cornerRadius = imgProfilePic.frame.size.height / 2
        imgProfilePic.clipsToBounds = true
    }

    func configure(with user: FollowingFollowersResponse.User) {
            let imageURLProfile = environment.imageHost + user.profileImage
            if let urlProfile = URL(string: imageURLProfile) {
                Nuke.loadImage(with: urlProfile, into: imgProfilePic)
            }
    }
}

class TagUsersCollectionview: UICollectionView, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    var taggedUser = [FollowingFollowersResponse.User]()

    override func awakeFromNib() {
        super.awakeFromNib()
        delegate = self
        dataSource = self
        self.register(UINib.init(nibName: "TagUsersCollectionview", bundle: nil), forCellWithReuseIdentifier: "TagUsers")
    }

    func collectionView(_: UICollectionView, numberOfItemsInSection _: Int) -> Int {
        return taggedUser.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TagUsers", for: indexPath) as! TagUsersCollectionViewCell
        cell.configure(with: taggedUser[indexPath.item])
        return cell
    }

    func collectionView(_: UICollectionView, didSelectItemAt _: IndexPath) {}

    @available(iOS 6.0, *)
    public func collectionView(_: UICollectionView, layout _: UICollectionViewLayout, sizeForItemAt _: IndexPath) -> CGSize {
        return CGSize(width: 45, height: 45)
    }

    @available(iOS 6.0, *)
    public func collectionView(_: UICollectionView, layout _: UICollectionViewLayout, insetForSectionAt _: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 5, left: 20, bottom: 5, right: 20)
    }

    func display(user: [FollowingFollowersResponse.User]) {
        taggedUser = user
        reloadData()
    }

    var didSelect: ((_ userID: FollowingFollowersResponse.User) -> Void)?
}
