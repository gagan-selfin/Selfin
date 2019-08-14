//
//  ReusableProfileHeaderView.swift
//  Selfin
//
//  Created by Marlon Monroy on 11/12/18.
//  Copyright © 2018 Selfin. All rights reserved.
//

import Nuke
import UIKit

enum UserProfileCollectionStyle {
    case grid
    case tags
    case list
    case heart
    case mention
}

class ReusableProfileHeaderView: UICollectionReusableView {
    let selectedColor = UIColor(displayP3Red: 249 / 255, green: 64 / 255, blue: 148 / 255, alpha: 1)
    @IBOutlet var profileImage: UIImageView!
    @IBOutlet var name: UILabel!
    @IBOutlet var username: UILabel!
    @IBOutlet var bio: UILabel!
    @IBOutlet var starts: UIButton!
    
    @IBOutlet var following: UILabel!
    @IBOutlet var followers: UILabel!
    @IBOutlet var postCount: UILabel!

    @IBOutlet var grid: UIButton!
    @IBOutlet var list: UIButton!
    @IBOutlet var mentions: UIButton!
    @IBOutlet var hearts: UIButton!

    @IBOutlet var followersImg1: UIImageView!
    @IBOutlet var followersImg2: UIImageView!

    @IBOutlet var followingImg1: UIImageView!
    @IBOutlet var followingImg2: UIImageView!
    
    @IBOutlet var followUnfollow: UIButton!
    @IBOutlet var showFollower: UIButton!
    @IBOutlet var showFollowing: UIButton!
    @IBOutlet var showPost: UIButton!
    @IBOutlet var followBottonWidth: NSLayoutConstraint!
    @IBOutlet var buttonFollowTrailingConstraints: NSLayoutConstraint!
    @IBOutlet var editImage: UIButton!
    let viewModel = ProfileCollectionViewModel()
    
    func loading() {
        [profileImage, name, bio, username, starts,
         following, followers, postCount, followersImg1,
         followersImg2, followingImg1, followingImg2]
            .forEach { $0?.showAnimatedSkeleton() }
    }

    func stopLoading() {
        [profileImage, name, bio, username, starts,
         following, followers, postCount, followersImg1,
         followersImg2, followingImg1, followingImg2]
            .forEach { $0?.hideSkeleton() }
    }

    var selctedStyle: UserProfileCollectionStyle = .list
    var onStyleSelected: ((_ style: UserProfileCollectionStyle) -> Void)?
    var didSelectProfileOptions: ((_ style: ProfileAction, _ username: String) -> Void)?
    var didSelectEditImage: (() -> Void)?
    var userName : String!
   
    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }

    private func setup() {
        profileImage.layer.cornerRadius = profileImage.bounds.width / 2
        profileImage.clipsToBounds = true
        profileImage.center = CGPoint.init(x: 500, y: 500)
        starts.layer.cornerRadius = starts.bounds.height / 2
        [followersImg1, followersImg2, followingImg1, followingImg2].forEach {
            $0?.layer.cornerRadius = followersImg1.bounds.height/2
            $0?.layer.borderWidth = 2
            $0?.layer.borderColor = UIColor.white.cgColor
            if $0 == followersImg1 || $0 == followersImg2 {
                $0?.layer.cornerRadius = 8
            }
        }
        loading()
        viewModel.followDelegate = self
        NotificationCenter.default.addObserver(self, selector: #selector(updateUserInformation(notification:)), name: NSNotification.Name(rawValue: "updateUserInfo"), object: nil)
    }
    
    @objc func updateUserInformation(notification : Notification) {
        if notification.object != nil {
            let object : [String:String] = notification.object as! [String : String]
            username.text = object["username"]
            let firstName : String = object["firstName"] ?? ""
            let lastName : String = object["lastName"] ?? ""
            name.text = firstName + "" + lastName
            bio.text = object["status"]
            Nuke.loadImage(with: URL.init(string: object["avatar"] ?? "")!, into: profileImage)
         }
    }

    func display(profile: Profile) {
        DispatchQueue.main.async {
            self.profileImage.layer.cornerRadius = self.profileImage.bounds.width / 2
            self.profileImage.clipsToBounds = true}
        editImage.isEnabled = true
        userName = profile.user.userName
        bio.text = profile.user.bio
        name.text = "\(profile.user.firstName) \(profile.user.lastName)"
        username.text = profile.user.userName
        postCount.text = "\(profile.posts)"
        starts.setTitle("\(profile.user.stars)", for: .normal)
        
        if profile.followersCount > 999
        {followers.text = String.init(format: "%dk", profile.followersCount/1000)}
        else if profile.followersCount > 99999
        {followers.text = String.init(format: "%dm", profile.followersCount/100000)}
        else {followers.text = "\(profile.followersCount)"}
        
        if profile.followingCount > 999
        {following.text = String.init(format: "%dk", profile.followingCount/1000)}
        else if profile.followingCount > 99999
        {following.text = String.init(format: "%dm", profile.followingCount/100000)}
        else {following.text = "\(profile.followingCount)"}

        setupImages(profile: profile.user.profileImage, followers: profile.followersImage, following: profile.followingsImage)
        
        followUnfollow.isHidden = true
        stopLoading()
    }
    
    func display(profile: OthersProfile) {
        DispatchQueue.main.async {
            if profile.user.isRequestedAccepted {self.profileImage.layer.cornerRadius = self.profileImage.bounds.width / 2
            }else {self.profileImage.layer.cornerRadius = 10.0}
            self.profileImage.clipsToBounds = true
        }
        
        editImage.isEnabled = false
        userName = profile.user.userName
        bio.text = profile.user.bio
        name.text = "\(profile.user.firstName) \(profile.user.lastName)"
        username.text = profile.user.userName
        postCount.text = "\(profile.posts)"
        starts.setTitle("\(profile.user.stars)", for: .normal)
        
        if profile.followersCount > 999
        {followers.text = String.init(format: "%dk", profile.followersCount/1000)}
        else if profile.followersCount > 99999
        {followers.text = String.init(format: "%dm", profile.followersCount/100000)}
        else {followers.text = "\(profile.followersCount)"}
        
        if profile.followingCount > 999
        {following.text = String.init(format: "%dk", profile.followingCount/1000)}
        else if profile.followingCount > 99999
        {following.text = String.init(format: "%dm", profile.followingCount/100000)}
        else {following.text = "\(profile.followingCount)"}
        
        setupImages(profile: profile.user.profileImage, followers: profile.followersImage, following: profile.followingsImage)
        
        //To Manage follow/Unfollow button only for other's profile
        if profile.user.id == UserStore.user?.id {followUnfollow.isHidden = true}else {handleFollowUnfollowRequestAppearence(profile:profile)}
        stopLoading()
    }
    
    @IBAction func actionShowFollowerFollowingList(_ sender: UIButton) {
        switch sender {
        case showFollower:
            didSelectProfileOptions?(.showFollowers, userName)
        case showFollowing:
            didSelectProfileOptions?(.showFollowing, userName)
        case showPost:
            didSelectProfileOptions?(.showPost, userName)
        case followUnfollow:
            didFollowUnfollow()
        case editImage:
            didSelectEditImage?()
        default:
            break
        }
    }
    
    @IBAction func collectionStyleButtonPressed(_ sender: UIButton) {
        [grid, list, hearts, mentions].forEach { $0?.tintColor = .lightGray }
        switch sender {
        case grid:
            grid.tintColor = selectedColor
            onStyleSelected?(.grid)
        case list:
            list.tintColor = selectedColor
            onStyleSelected?(.list)
        case hearts:
            hearts.tintColor = selectedColor
            onStyleSelected?(.heart)
        case mentions:
            mentions.tintColor = selectedColor
            onStyleSelected?(.mention)
        default:
            break
        }
    }
    
    private func setupImages(profile: String, followers: [String], following: [String]) {
        if profile != "" {
            guard let profURL = URL(string:environment.imageHost + profile) else { return }
            Nuke.loadImage(with: profURL, into: profileImage)}
        else {profileImage.image = UIImage.init(named: "Placeholder_image")}
     
        if followers.count > 0 {
            guard let follower1URL = URL(string:environment.imageHost + followers[0]) else { return }
            Nuke.loadImage(with: follower1URL, into: followersImg1)

            if followers.count > 1 {
                guard let follower2URL = URL(string:environment.imageHost + followers[1]) else { return }
                Nuke.loadImage(with: follower2URL, into: followersImg2)
            }
        }

        if following.count > 0 {
            guard let following1URL = URL(string:environment.imageHost + following[0]) else { return }
            Nuke.loadImage(with: following1URL, into: followingImg1)

            if following.count > 1 {
                guard let following2URL = URL(string:environment.imageHost + following[1]) else { return }
                Nuke.loadImage(with: following2URL, into: followingImg2)
            }
        }
    }
    
    private func handleFollowUnfollowRequestAppearence(profile: OthersProfile) {
        if profile.user.following {
            if profile.user.isRequestedAccepted {followingUser()}else {pending()}
        }else{follow()}
        self.layoutIfNeeded()
    }
    
    func setUpFollowButton(image : UIImage?, color : UIColor?, width : CGFloat, radius : CGFloat, title : String, isEnabled : Bool ) {
        followUnfollow.setImage(image, for: .normal)
        followUnfollow.layer.borderColor = color?.cgColor
        followUnfollow.layer.borderWidth = width
        followUnfollow.layer.cornerRadius = radius
        followUnfollow.setTitle(title, for: .normal)
        followUnfollow.isEnabled = isEnabled
    }
    
    func didFollowUnfollow() {
        viewModel.performFollowUnFollowUserAPI(username: userName)
    }
    
    func followingUser()  {
        buttonFollowTrailingConstraints.constant = 50
        followBottonWidth.constant = 35
        setUpFollowButton(image: UIImage(named:"following"), color: nil, width: 0, radius: 0, title: "", isEnabled: true)
    }
    
    func follow()  {
        buttonFollowTrailingConstraints.constant = 50
        followBottonWidth.constant = 35
        setUpFollowButton(image: UIImage(named: "follow_user"), color: nil, width: 0, radius: 0, title: "", isEnabled: true)
    }
    
    func pending()  {
        buttonFollowTrailingConstraints.constant = 16
        followBottonWidth.constant = 80
        setUpFollowButton(image: nil, color: UIColor.lightGray, width: 1, radius: 16.0, title: "Pending", isEnabled: false)
    }
}

extension ReusableProfileHeaderView : followUnfollowDelegate {
    func didReceived(data: followUnfollowUser){
        if !data.isFollowing {follow()}else if data.isFollowing && !data.isRequestApproved {pending()}else {followingUser()}
    }
    
    func didReceived(error msg: String){}
}
