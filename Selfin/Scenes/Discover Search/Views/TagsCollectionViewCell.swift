//
//  TagsCollectionViewCell.swift
//  Selfin
//
//  Created by cis on 14/11/2018.
//  Copyright © 2018 Selfin. All rights reserved.
//

import UIKit
import Nuke

class TagsCollectionViewCell: UICollectionViewCell {
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var labelDetail: UILabel!
    @IBOutlet var labelPostCount: UILabel!
    @IBOutlet var bgView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configure<T>(with content: T, type : searchCollectionStyle) {
         stopLoading()
        if type == .tag {
            let tags = content as! SearchTags.Tags
            labelDetail.text = tags.tag
            labelPostCount.text = "\(tags.postCount) Posts"
            imageView.image = UIImage.init(named: "Hash")
        }else {
            let location = content as! SearchLocation.Location
            labelDetail.text = location.locationName
            labelPostCount.text = "\(location.postCount) Posts"
            imageView.image = UIImage.init(named: "Location")
        }
    }
    
    func loading() {[imageView,labelDetail,labelPostCount].forEach { $0?.showAnimatedSkeleton()}
    }
    
    func stopLoading() {[imageView,labelDetail,labelPostCount].forEach { $0?.hideSkeleton()}
    }
}
