//
//  DiscoverReusableCollectionViewCell.swift
//  Selfin
//
//  Created by Marlon Monroy on 11/7/18.
//  Copyright © 2018 Selfin. All rights reserved.
//

import Nuke
import SkeletonView
import UIKit

class DiscoverReusableCollectionViewCell: UICollectionViewCell, Reusable {
    
    let image = UIImageView()
    override func awakeFromNib() {
        super.awakeFromNib()
        image.layer.cornerRadius = 6
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        autoresizesSubviews = true
        image.frame = CGRect(x: 0, y: 0, width: bounds.width, height: bounds.height)
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        image.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addSubview(image)
    }

    var post: HomeFeed.Post?

    func configure<T>(with content: T) {
        let feed = content as! HomeFeed.Post
        image.showAnimatedSkeleton()
        let imageURL = feed.postImage
        if let url = URL(string: imageURL + "?w=420&h=400&dpr=1") {
            Nuke.loadImage(with: url, options: ImageLoadingOptions(
                placeholder: nil,
                transition: .fadeIn(duration: 0.33)
            ), into: image, progress: nil) { _, _ in
                self.image.hideSkeleton()
            }
        }
    }

    func configure(with post : TaggedLikedPostResponse.Post){
        skeleton()
        let imageURL = post.postImage
        if let url = URL(string: imageURL + "?w=420&h=400&dpr=1") {
            Nuke.loadImage(with: url, options: ImageLoadingOptions(
                placeholder: nil,
                transition: .fadeIn(duration: 0.33)
            ), into: image, progress: nil) { _, _ in
                self.image.hideSkeleton()
            }
        }
    }

    func skeleton() {image.showAnimatedSkeleton()}
}
