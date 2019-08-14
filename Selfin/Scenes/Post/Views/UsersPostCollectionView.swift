//
//  UsersPostCollectionView.swift
//  Selfin
//
//  Created by cis on 21/12/2018.
//  Copyright © 2018 Selfin. All rights reserved.
//

import UIKit
import Nuke
import SkeletonView

protocol UsersPostCollectionViewDelegate : class {
    func fetchFeeds(page:Int)
}

class UsersPostCell: UICollectionViewCell {
    let image = UIImageView()
    override func awakeFromNib() {
        super.awakeFromNib()
        image.layer.cornerRadius = 6
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        autoresizesSubviews = true
        image.frame = CGRect(x: 4, y: 8, width: bounds.width - 8, height: bounds.height - 8)
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        image.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addSubview(image)
    }
    
    func configure(with post: SelfFeed.Post, animating _: Bool) {
        image.showAnimatedSkeleton()
        if let url = URL(string: post.postImage) {
            Nuke.loadImage(with: url, options: ImageLoadingOptions(
                placeholder: nil,
                transition: .fadeIn(duration: 0.33)
            ), into: image, progress: nil) { _, _ in
                self.image.hideSkeleton()
            }
        }
    }
    
    func skeleton() {
        image.showAnimatedSkeleton()
    }
}

class UsersPostCollectionView: UICollectionView, UICollectionViewDelegate, UICollectionViewDataSource {
    let layout = MosaicLayoutFlow()
    var didSelect: ((_ id: Int) -> Void)?
    var posts = [SelfFeed.Post]()
    var page = 1
    var hasMore = true
    weak var controller:UsersPostCollectionViewDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        collectionViewLayout = layout
        layout.scrollDirection = .vertical
        delegate = self
        dataSource = self
    }

    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.item == posts.count - 2 && hasMore {
            page += 1
            controller?.fetchFeeds(page: page)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {return posts.count}
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "UsersPostCell", for: indexPath) as? UsersPostCell else { fatalError("err") }
        cell.configure(with: posts[indexPath.item], animating: true)
        return cell
    }
    
    func collectionView(_: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        didSelect!(posts[indexPath.item].id)
    }
    
    func display(feeds: [SelfFeed.Post]) {
        hasMore = feeds.count > 0
        if page == 1 { self.posts.removeAll() }
        self.posts.append(contentsOf: feeds)
        reloadData()
    }
}
