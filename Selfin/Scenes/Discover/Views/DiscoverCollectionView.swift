//
//  DiscoverCollectionView.swift
//  Selfin
//
//  Created by Marlon Monroy on 7/1/18.
//  Copyright © 2018 Selfin. All rights reserved.
//

import Nuke
import UIKit
import SkeletonView

class DiscoverCollectionViewCell: UICollectionViewCell {
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
	
    func configure(with post: DiscoverResponse.Post, animating _: Bool) {
        image.showAnimatedSkeleton()
        let imageURL = environment.imageHost + post.post_images
        print(imageURL)
        if let url = URL(string: imageURL) {
            Nuke.loadImage(with: url, options: ImageLoadingOptions(
                placeholder: nil,
                transition: .fadeIn(duration: 0.33)
            ), into: image, progress: nil) { _, _ in
                self.image.hideSkeleton()
            }
        }
    }
    
   override func prepareForReuse() {
      super.prepareForReuse()
      image.image = nil
   }
    
    func skeleton() {
        image.showAnimatedSkeleton()
    }
}

class DiscoverCollectionView: UICollectionView, UICollectionViewDelegate, UICollectionViewDataSource {
    var items: [DiscoverResponse.Post] = []
    let layout = MosaicLayoutFlow()
    var didSelect: ((_ id: Int) -> Void)?
    var hasMore = true
    var page = 1
    weak var controller : DiscoverViewCollectionDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
        collectionViewLayout = layout
        layout.scrollDirection = .vertical
        //layout.contentBounds = self.bounds
        delegate = self
        dataSource = self
    }

    // MARK: -
    // MARK: - CollectionView Datasource
    func collectionView(_: UICollectionView, numberOfItemsInSection _: Int) -> Int {
        return items.count > 0 ? items.count : 5
    }
    
    @available(iOS 8.0, *)
    public func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if items.count - 3 == indexPath.row && hasMore {
            page += 1
            controller?.didFetchMoreData(page: page)
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "discover_cell", for: indexPath) as? DiscoverCollectionViewCell else { fatalError() }
            if items.count == 0 {cell.skeleton()}
            else {cell.configure(with: items[indexPath.row], animating: false)}
            return cell
    }
	
    // MARK: - CollectionView Delegate
    func collectionView(_: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if items.count > 0 {
        let id = items[indexPath.item].id
        didSelect!(id)}
    }

    // MARK: -
    // MARK: - Custom Methods
    func displayItems(_ items: [DiscoverResponse.Post]) {
        hasMore = items.count > 0
        if page == 1 {self.items.removeAll()}
        self.items.append(contentsOf: items)
        reloadData()
    }
    
    func prepareForRefresh(){
        self.items.removeAll()
        page = 1
    }
}

extension DiscoverCollectionView {
    func updateLayout(for orientation: UIDeviceOrientation) {
        if orientation.isLandscape {
            layout.scrollDirection = .horizontal
            layout.invalidateLayout()
            layout.collectionView?.bounces = false
            layout.collectionView?.alwaysBounceHorizontal = false
            return
        }
        layout.scrollDirection = .vertical
        layout.invalidateLayout()
        layout.collectionView?.bounces = true
        layout.collectionView?.alwaysBounceVertical = true
    }
}
