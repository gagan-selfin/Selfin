//
//  ReusableFeedCollectionViewCell.swift
//  Selfin
//
//  Created by Marlon Monroy on 11/7/18.
//  Copyright © 2018 Selfin. All rights reserved.
//

import Nuke
import SkeletonView
import UIKit
import OnlyPictures

class ReusableFeedCollectionViewCell: UICollectionViewCell, Reusable {
 weak var delegates: PostDetailsViewControllerDelegate?
    weak var delegate: UserProfileFeedItemDelegate?
    fileprivate var post: HomeFeed.Post!
   // var viewModel = PostDetailsViewModel()
    
    @IBOutlet weak var bottomHeightConst: NSLayoutConstraint!
    
    @IBOutlet weak var viewBottom: UIView!
    @IBOutlet weak var BtnComment: UIButton!
    @IBOutlet weak var onlyPictures:  OnlyHorizontalPictures!
   
    @IBOutlet weak var postComments: AttrTextView!
    @IBOutlet weak var leftConst: NSLayoutConstraint!
    @IBOutlet weak var rightConst: NSLayoutConstraint!
    @IBOutlet weak var imgViewLike: UIImageView!
    @IBOutlet weak var imageLocMarker: UIImageView!
    @IBOutlet var btnAvatarImage: UIButton!
    @IBOutlet weak var mainView: UIView!
    @IBOutlet var btnUsername: UIButton!
    @IBOutlet var image: UIImageView!
    @IBOutlet var profileImage: UIImageView!
    @IBOutlet var username: UILabel!
    @IBOutlet var time: UILabel!
    @IBOutlet var actionButton: UIButton!
    @IBOutlet var place: UILabel!
    @IBOutlet var location: UIButton!
    @IBOutlet weak var constantLeading_imgViewLike: NSLayoutConstraint!
    
    @IBOutlet weak var constantTrailing_imgViewProfile: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()

       // viewModel.fetchPostDetails(id: post.id)
        setup()}
  
    fileprivate func setup() {
        
        mainView.layer.cornerRadius = 10
        mainView.clipsToBounds = true
        image.contentMode = .scaleAspectFill
        profileImage.clipsToBounds = true
        profileImage.layer.cornerRadius = profileImage.bounds.width / 2
        isSkeletonable = true
        location.contentVerticalAlignment = .top
        
        //add gestures over like image
        let singleTapGesture = UITapGestureRecognizer(target: self, action: #selector(performActionLike(gestureRecongnizer:)))
        singleTapGesture.numberOfTapsRequired = 1
        imgViewLike.addGestureRecognizer(singleTapGesture)
        BtnComment.addTarget(self, action: #selector(showPostDetails), for: .touchUpInside)
        
//        let singleTapGestureOnFeed = UITapGestureRecognizer(target: self, action: #selector(showPostDetails))
//        singleTapGestureOnFeed.numberOfTapsRequired = 1
        
       // image.addGestureRecognizer(singleTapGestureOnFeed)

        let doubleTapGesture = UITapGestureRecognizer(target: self, action: #selector(performActionLike(gestureRecongnizer:)))
        doubleTapGesture.numberOfTapsRequired = 2
        singleTapGesture.delaysTouchesBegan = true
        image.addGestureRecognizer(doubleTapGesture)
        singleTapGesture.require(toFail: doubleTapGesture)
//        singleTapGestureOnFeed.require(toFail: doubleTapGesture)

        let longGesture = UILongPressGestureRecognizer(target: self, action: #selector(performActionSuperLike(gestureRecongnizer:)))
        image.addGestureRecognizer(longGesture)
        
        let longGestureOnFeed = UILongPressGestureRecognizer(target: self, action: #selector(performActionSuperLike(gestureRecongnizer:)))
        imgViewLike.addGestureRecognizer(longGestureOnFeed)
        singleTapGesture.delaysTouchesBegan = true
//        singleTapGestureOnFeed.delaysTouchesBegan = true
    }

    func configure<T>(with content: T) {
        stopAnimate()
        post = content as? HomeFeed.Post
        if post.is_liked {imgViewLike.image = #imageLiteral(resourceName: "feed_like")}
        else if post.is_super_liked {imgViewLike.image = #imageLiteral(resourceName: "feed_superlike")}
        else {imgViewLike.image = #imageLiteral(resourceName: "feed_dislike")}

        if let postUrl = URL(string: post.postImage) {
            Nuke.loadImage(with: postUrl, options: ImageLoadingOptions.shared, into: image, progress: nil) { _, _ in
                self.image.hideSkeleton()
            }
        }
        if post.location_details.location_name.count == 0 {
            location.isHidden = true
            imageLocMarker.isHidden = true
        }else{
            location.isHidden = false
            imageLocMarker.isHidden = false
        }
        
        location.setTitle(post.location_details.location_name, for: .normal)
        
        
        //place.text = post.location_details.location_name
        time.text = post.time
        guard let user  = post?.user else { return }
        setupPost(with: user)
    }
    func callBack(string : String , type : wordType){
        switch type {
        case .hashtag:
            delegates?.postDetailActions(action: .hashtags(string : string))
        case .mention:
            delegates?.postDetailActions(action: .mention(string : string))
        default: break
        }
    }
    fileprivate func setupPost(with user: HomeFeed.Post.User) {
        username.text = user.username
        postComments.setText(text: "#travel post.post.content", type: .hashtag, andCallBack: callBack(string:type:))
        
        if user.profile_image != "" {
        if let userImageUrl = URL(string: environment.imageHost + user.profile_image) {
            Nuke.loadImage(with: userImageUrl, into: profileImage)
        }}else {profileImage.image = UIImage.init(named: "Placeholder_image")}
    }

    func skeleton() {
        animate()
    }

    fileprivate func animate() {
        [profileImage, username, image, time, place, imageLocMarker].forEach { v in
            v?.showAnimatedSkeleton()
        }
        time.isHidden = true
    }

    fileprivate func stopAnimate() {
        [profileImage, username, time, place, imageLocMarker].forEach { v in
            v?.hideSkeleton()
        }
        time.isHidden = false
    }

    @IBAction func actionOnFeeds(_ sender: UIButton) {
        if post == nil {return}
        switch sender {
        case actionButton:
          delegate?.userFeedItemActions(action: .postActionButtonPressed(post: post, index: IndexPath.init(row: self.tag, section: 0)))
        case btnUsername :
            delegate?.userFeedItemActions(action: .userButtonPressed(post: post))
        case btnAvatarImage :
            delegate?.userFeedItemActions(action: .avatarButtonPressed(post: post))
        case location :
            delegate?.userFeedItemActions(action: .locationButtonPressed(location : post.location_details.location_name))
        default:
            break
        }
    }
    
    @objc func performActionLike(gestureRecongnizer: UITapGestureRecognizer){
        delegate?.userFeedItemActions(action: .likeButtonPressed(post: post, like: .like, gesture: gestureRecongnizer))
    }
    
    @objc func performActionSuperLike(gestureRecongnizer: UILongPressGestureRecognizer){
        if gestureRecongnizer.state == .ended{
            delegate?.userFeedItemActions(action: .likeButtonPressed(post: post, like: .superlike, gesture: gestureRecongnizer))
        }
    }
    
    @objc func showPostDetails()
    {
        delegate?.userFeedItemActions(action: .postSelected(post: post))
    }
}

