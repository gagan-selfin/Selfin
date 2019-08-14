//
//  ReusableSearchCollectionViewCell.swift
//  Selfin
//
//  Created by cis on 13/11/2018.
//  Copyright © 2018 Selfin. All rights reserved.
//

import UIKit
import Nuke
protocol SearchCollectionViewCellDelegate : class {
    func didMovetoProfile(username:String)
    func didUpdateFollowStatus(id : Int)
}
class ReusableSearchCollectionViewCell: UICollectionViewCell, Reusable {
    
    @IBOutlet var imageViewUserImage: UIImageView!
    @IBOutlet var labelUserName: UILabel!
    @IBOutlet var labelFullName: UILabel!
    @IBOutlet var buttonFollowing: UIButton!
    fileprivate var user : FollowingFollowersResponse.User!
    var viewModel = SearchCollectionViewModel()
    weak var delegate :SearchCollectionViewCellDelegate?
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }
    
    fileprivate func setup() {
        viewModel.controller = self
    }

    
    func configure<T>(with content: T) {
        self.user = content as? FollowingFollowersResponse.User
        print(self.user.userImage)
        if user.profileImage !=  ""{
            if let postUrl = URL(string: self.user.userImage) {
                Nuke.loadImage(with: postUrl, into: imageViewUserImage)
            }
        }else {
            imageViewUserImage.image = UIImage.init(named: "Placeholder_image")
        }
        
        //user should not follow himself
        if user.id == UserStore.user?.id {buttonFollowing.isHidden = true}
        else { buttonFollowing.isHidden = false}
        
        DispatchQueue.main.async {
            self.imageViewUserImage.layer.masksToBounds = true
            if self.user.following {
                self.imageViewUserImage.layer.cornerRadius = self.imageViewUserImage.frame.height/2
                self.buttonFollowing.isSelected = true
            }else {
                self.imageViewUserImage.layer.cornerRadius = 8
                self.buttonFollowing.isSelected = false
            }
        }
        
        labelFullName.text = user.firstName + "" + user.lastName
        labelUserName.text = user.username
        stopLoading()
    }
    
    func loading() {[imageViewUserImage,labelUserName,labelFullName,buttonFollowing].forEach { $0?.showAnimatedSkeleton()}
    }
    
    func stopLoading() {[imageViewUserImage,labelUserName,labelFullName,buttonFollowing].forEach { $0?.hideSkeleton()}
    }
    
    //MARK: UIAction
    @IBAction func actionFollowUser(_ sender: UIButton) {
        buttonFollowing.showAnimatedSkeleton()
        viewModel.performFollowUnFollowUserAPI(username: user.username)
    }
    
    @IBAction func actionCheckUserProfile(_ sender: Any) {
        if user != nil {delegate?.didMovetoProfile(username: user.username)}
    }
}

extension ReusableSearchCollectionViewCell: FollowUnfollowUserDelegate {
    func didReceived(data: followUnfollowUser){
        buttonFollowing.hideSkeleton()
        if data.status {
            delegate?.didUpdateFollowStatus(id: user.id)
            if data.isFollowing{buttonFollowing.isSelected = true;return}
            buttonFollowing.isSelected = false}
    }
    
    func didReceived(error msg: String) {//TODO
    }
}


