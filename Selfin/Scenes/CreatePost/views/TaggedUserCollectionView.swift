//
//  TaggedUserCollectionView.swift
//  Selfin
//
//  Created by cis on 17/12/2018.
//  Copyright © 2018 Selfin. All rights reserved.
//

import UIKit



import Nuke
import UIKit

class TaggedUsersCollectionViewCell: UICollectionViewCell {
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var buttonCancel: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        if imageView != nil {
            imageView.layer.cornerRadius = imageView.frame.size.height / 2
            imageView.clipsToBounds = true
        }
    }
    
    func configure(with user: FollowingFollowersResponse.User) {
        if user.profileImage == "" {
            imageView.image = #imageLiteral(resourceName: "Placeholder_image")
        } else {
            let imageURLProfile = environment.imageHost + user.profileImage
            if let urlProfile = URL(string: imageURLProfile) {
                Nuke.loadImage(with: urlProfile, into: imageView)
            }
        }
    }
}

class TaggedUserCollectionView: UICollectionView, UICollectionViewDelegate, UICollectionViewDataSource {
    var taggedUser = [FollowingFollowersResponse.User]()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        delegate = self
        dataSource = self
    }
    
    func collectionView(_: UICollectionView, numberOfItemsInSection _: Int) -> Int {
        return taggedUser.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var identifier = "TaggedUsers"
        if indexPath.item == taggedUser.count {
            identifier = "AddMoreTaggedUsers"
        }
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as! TaggedUsersCollectionViewCell
        
        if indexPath.row < taggedUser.count {
            cell.configure(with: taggedUser[indexPath.item])
        }
        return cell
    }
    
    func collectionView(_: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.item == taggedUser.count {
            didSelect!(taggedUser)
            return
        }
        taggedUser.remove(at: indexPath.item)
        reloadData()
    }
    
    @available(iOS 6.0, *)
    public func collectionView(_: UICollectionView, layout _: UICollectionViewLayout, sizeForItemAt _: IndexPath) -> CGSize {
        return CGSize(width: 40, height: 40)
    }
    
    @available(iOS 6.0, *)
    public func collectionView(_: UICollectionView, layout _: UICollectionViewLayout, insetForSectionAt _: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 8, left: 20, bottom: 7, right: 20)
    }
    
    func showTaggedUser(user: [FollowingFollowersResponse.User]) {
        print(user.count)
        taggedUser = user
        reloadData()
    }
    
    var didSelect: ((_ users: [FollowingFollowersResponse.User]) -> Void)?
}
