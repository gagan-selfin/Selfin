//
//  PostDetailsViewController.swift
//  Selfin
//
//  Created by cis on 18/09/2018.
//  Copyright © 2018 Selfin. All rights reserved.
//

import Nuke
import UIKit
import SkeletonView

class PostDetailsViewController: UIViewController {
    
    @IBOutlet weak var imageLoc: UIImageView!
    @IBOutlet var imageviewPostImage: UIImageView!
    @IBOutlet var imageViewPosterProfileImage: UIImageView!
    @IBOutlet var imageViewUserProfileImage: UIImageView!
    @IBOutlet var labelUserName: UILabel!
    @IBOutlet var labelUserLocation: UILabel!
    @IBOutlet var labelPostTextContent: UILabel!
    @IBOutlet var labelPostLikeCount: UILabel!
    @IBOutlet var labelPostCommentCount: UILabel!
    @IBOutlet weak var imageView_P_Comment: UIImageView!
    @IBOutlet weak var buttonLike: UIButton!
    
    @IBOutlet weak var viewLandscape: UIView!
    @IBOutlet var labelPostTime: UILabel!
    @IBOutlet var buttonFollow: UIButton!
    @IBOutlet var btn_L_Like: UIButton!
    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet var buttonShare: UIButton!
    @IBOutlet var postContent: AttrTextView!
    @IBOutlet weak var imgView_L_Comment: UIImageView!
    
    weak var delegate: PostDetailsViewControllerDelegate?
    var viewModel = PostDetailsViewModel()
    let user = UserStore.user
    var postId = Int ()
    var feed:PostDetailResponse?
    var action:String?
    var strNotification =  ""

    override func viewDidLoad() {
        super.viewDidLoad()
        
        imgView_L_Comment.layer.cornerRadius = imgView_L_Comment.frame.height / 2
        imageView_P_Comment.layer.cornerRadius = imageView_P_Comment.frame.height / 2

        imageViewPosterProfileImage.layer.cornerRadius = self.imageViewPosterProfileImage.frame.height / 2
        imageViewPosterProfileImage.clipsToBounds = true
        
        viewLandscape.isHidden = isDevicePortraitMode()

        NotificationCenter.default.addObserver(self, selector: #selector(rotated), name: UIDevice.orientationDidChangeNotification, object: nil)
        
		backButton(tint: .black)
		viewModel.controller = self
        loading()
        addGestures()
        // ScrollView Adjustment
        if #available(iOS 11.0, *) {
            scrollView.contentInsetAdjustmentBehavior = UIScrollView.ContentInsetAdjustmentBehavior.never
        }
        viewModel.fetchPostDetails(id: postId)
    }
    
    @objc func rotated() {
        
        if isDevicePortraitMode() {
            buttonLike = btn_L_Like
            viewLandscape.isHidden = true
            print("Portrait")
        }
        else {
            btn_L_Like = buttonLike
            viewLandscape.isHidden = false
            print("Landscape")
        }
    }
    
	func loading() {
        
		[imageViewUserProfileImage, imageviewPostImage, imageViewPosterProfileImage, labelUserName, labelUserLocation, labelPostLikeCount, labelPostCommentCount, labelPostTime, imageLoc, buttonLike, imageviewPostImage]
			.forEach { $0?.showAnimatedGradientSkeleton() }
	}
	
	func stopLoading() {
		[imageViewUserProfileImage, imageviewPostImage, imageViewPosterProfileImage, labelUserName, labelUserLocation, labelPostLikeCount, labelPostCommentCount, labelPostTime, imageLoc, buttonLike, imageviewPostImage]
			.forEach { $0?.hideSkeleton() }
	}

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.isNavigationBarHidden = false
        self.navigationController?.hidesBarsOnSwipe = false
    }
    
//
//    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
//        if UIDevice.current.orientation.isLandscape {
//            print("Landscape")
//            if UIDevice.current.orientation.isFlat {
//                print("Flat")
//            } else {
//                print("Portrait")
//            }
//        }
//    }

    // MARK: - Custom Methods
    func displayReportStatus (msg:String) {self.showAlert(str: msg)}
    
    func setupLike(data: PostLikeResponse) {
        
        let btn: UIButton! = isPortraitMode() ? buttonLike :  btn_L_Like
        
        if (data.status) {
            if action == likeAction.like.rawValue {
                //For single tap i.e. like
                if btn.imageView?.image == #imageLiteral(resourceName: "likelite") {
                    btn.setImage(#imageLiteral(resourceName: "likeCount"), for: .normal)
                } else {
                    btn.setImage(#imageLiteral(resourceName: "likelite"), for: .normal)
                }
            }
            else if action == likeAction.superlike.rawValue {
                //For double tap i.e. superlike
                if btn.imageView?.image == #imageLiteral(resourceName: "likeSelected") {
                    btn.setImage(#imageLiteral(resourceName: "likeCount"), for: .normal)
                } else {
                    btn.setImage(#imageLiteral(resourceName: "likeSelected"), for: .normal)
                }
            }
            else {//For dislike
                btn.setImage(#imageLiteral(resourceName: "likeCount"), for: .normal)
            }
                //To show no. of likes
                labelPostLikeCount.text = String.init(format: "%d", data.likeCount)
        }
    }
    
    func setUpFollowUnfollow (data:followUnfollowUser) {
        if (data.status) {
            if (data.isFollowing) {
                self.imageViewPosterProfileImage.layer.cornerRadius = self.imageViewPosterProfileImage.frame.height / 2
                self.buttonFollow.isSelected = true
                self.setFollowButtonUI(forState: true)
            } else {
                self.imageViewPosterProfileImage.layer.cornerRadius = self.imageViewPosterProfileImage.frame.height / 2
                self.buttonFollow.isSelected = false
                self.setFollowButtonUI(forState: false)
            }
    	}
	}
    
    func setup (post: PostDetailResponse) {
        feed = post//To get the value
        
        self.labelUserName.text = post.post.user.username
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(
            target: self, action: #selector(self.labelUserNametapped)
        )
        self.labelUserName.addGestureRecognizer(tap)
        
        self.labelUserLocation.text = post.post.locationDetail.name
        if self.labelUserLocation.text?.count == 0  {
            self.imageLoc.isHidden = true
        } else {
            self.imageLoc.isHidden = false
        }
        self.labelPostLikeCount.text = "\(post.post.likedCount + post.post.superLikeCount)"
        self.labelPostCommentCount.text = "\(post.post.comments_count)"

        self.postContent.setText(text: post.post.content, type: .hashtag, andCallBack: callBack(string:type:))
        
        if self.user!.id == feed?.post.user.id {buttonShare.isHidden = true}
//        else {buttonShare.isHidden = false}

        //Method to set like button
        setLikeButton(isLiked: post.post.isLiked, isSuperLiked: post.post.isSuperLiked)
        
        //Method to set time
        setTimeLabel(createdAt: post.post.createdAt)

        //Method to adjust image corner radius as per the API's reponse
        adjustUserProfileImageRadius(username: post.post.user.username, isFollowing: post.post.user.following!)
        
        //Method to setup images
        setUpImages(post: post)
    }
    
    func callBack(string : String , type : wordType){
        switch type {
        case .hashtag:
            delegate?.postDetailActions(action: .hashtags(string : string))
        case .mention:
            delegate?.postDetailActions(action: .mention(string : string))
        default: break
        }
    }
    
    func setTimeLabel (createdAt:String) {
        if createdAt != "" {
            labelPostTime.text = feed?.time
        } else {
            labelPostTime.text = ""
        }
    }
    
    func setLikeButton (isLiked:Bool,isSuperLiked:Bool) {
        if (isLiked) {
            self.buttonLike.setImage(#imageLiteral(resourceName: "likelite"), for: .normal)
        } else if (isSuperLiked) {
            self.buttonLike.setImage(#imageLiteral(resourceName: "likeSelected"), for: .normal)
        } else {
            self.labelPostTime.text = ""
        }
    }
    
    func adjustUserProfileImageRadius (username:String, isFollowing:Bool) {
        if user?.userName == username {
            self.imageViewPosterProfileImage.layer.cornerRadius = self.imageViewPosterProfileImage.frame.height / 2
            self.buttonFollow.isSelected = true
            self.setFollowButtonUI(forState: true)
            
            self.buttonFollow.isHidden = true
            self.buttonShare.isHidden = true
        } else {
            if isFollowing {
                self.imageViewPosterProfileImage.layer.cornerRadius = self.imageViewPosterProfileImage.frame.height / 2
                self.buttonFollow.isSelected = true
                self.setFollowButtonUI(forState: true)
            } else {
                self.imageViewPosterProfileImage.layer.cornerRadius = self.imageViewPosterProfileImage.frame.height / 2
                self.buttonFollow.isSelected = false
                self.setFollowButtonUI(forState: false)
            }
        }
    }
    
    func displayUserProfileImage () {
        if user?.profileImage == "" { // To show placeholder image
            imageViewUserProfileImage.image = #imageLiteral(resourceName: "Placeholder_image")
            
            imageviewPostImage.image = #imageLiteral(resourceName: "Placeholder_image")
        } else {
            
            guard let imgURLProfile = URL(string: (user?.userImage)!) else { return}
            Nuke.loadImage(with: imgURLProfile, into: imageViewUserProfileImage)
            Nuke.loadImage(with: imgURLProfile, into: imageviewPostImage)
           
        }
        stopLoading() //To hide skeleton view
    }
    
    func setUpImages (post:PostDetailResponse) {
        guard let postImage = URL(string: post.postImage + "?w=800&h=800&dpr=1"  ) else { return }
        Nuke.loadImage(with: postImage, into: self.imageviewPostImage)
        
        self.imageViewPosterProfileImage.layer.borderColor = UIColor.white.cgColor
        self.imageViewPosterProfileImage.layer.borderWidth = 2
        
        if (post.post.user.profileImage) == "" {
            self.imageViewPosterProfileImage.image = #imageLiteral(resourceName: "Placeholder_image")
        } else {
            guard let urlProfile = URL(string: post.userImage) else { return}
            Nuke.loadImage(with: urlProfile, into: self.imageViewPosterProfileImage)
        }
        //Displaying user profile image
        displayUserProfileImage ()
    }
    
    func addGestures () {

        let singleTapGesture = UITapGestureRecognizer(target: self, action: #selector(singleTapOnLike(sender:)))
        singleTapGesture.numberOfTapsRequired = 1
        buttonLike.addGestureRecognizer(singleTapGesture)
        
        let longGesture = UILongPressGestureRecognizer(target: self, action: #selector(longPressOnLike(sender:)))
        buttonLike.addGestureRecognizer(longGesture)
        
        singleTapGesture.delaysTouchesBegan = true
    }

     func setFollowButtonUI(forState selected: Bool) {
        let color = UIColor(red: 249.0 / 255.0, green: 64.0 / 255.0, blue: 148.0 / 255.0, alpha: 1.0)

        if selected {
            buttonFollow.layer.borderColor = color.cgColor
            buttonFollow.layer.borderWidth = 1
            buttonFollow.backgroundColor = color
            buttonFollow.setTitleColor(.white, for: .selected)
            buttonFollow.setTitle("FOLLOWING", for: .selected)
            buttonFollow.setImage(nil, for: .selected)
            buttonFollow.setImage(nil, for: .normal)
            buttonFollow.imageEdgeInsets.right = 0
        } else {
            buttonFollow.layer.borderColor = color.cgColor
            buttonFollow.layer.borderWidth = 2
            buttonFollow.backgroundColor = .white
            buttonFollow.setTitleColor(color, for: .normal)
            buttonFollow.setTitle("FOLLOW", for: .normal)
            buttonFollow.setImage(#imageLiteral(resourceName: "follow"), for: .normal)
            buttonFollow.imageEdgeInsets.right = 10
        }
    }
    
    func showPostSheet(user:PostDetailResponse.User) {
        if (feed?.post.isNoticationTurnOn)! {
            strNotification = PosthandlerCases.notificationOff.rawValue
        } else {strNotification = PosthandlerCases.notificationOn.rawValue}
        
        if self.user!.id == feed?.post.user.id {
            let actionSheet = UIAlertController.PostAction(titles: PosthandlerCases.copyLink.rawValue, strNotification, PosthandlerCases.edit.rawValue, handler: postActionHandler)
            self.present(actionSheet, animated: true, completion: nil)
        }else {
            let actionSheet = UIAlertController.PostAction(titles: PosthandlerCases.sendMessage.rawValue,strNotification,PosthandlerCases.copyLink.rawValue, handler: postActionHandler)
            self.present(actionSheet, animated: true, completion: nil)
        }
    }
    
    func showReport() {
        let alert = UIAlertController(title: "Post Reported", message: "Thank you for helping us improve selfin", preferredStyle: .alert)
        self.present(alert, animated: true, completion: nil)
        Timer.scheduledTimer(withTimeInterval: 3, repeats: false) {[weak self] _ in
            self?.dismiss(animated: true, completion: nil)
        }
    }
    
    func handleReportTask (data:ReusableResponse) {
        if data.status {
            if data.message == "Successfully reported." {showReport()}
            else {
                showAlert(str: data.message)
                if data.message == NotificationResponse.notificationOn.rawValue
                {strNotification = PosthandlerCases.notificationOff.rawValue}
                else
                {strNotification = PosthandlerCases.notificationOn.rawValue}
            }
        }
    }

    // MARK: - UI Actions
	func postActionHandler(_ alert:UIAlertAction) {
        guard let title = alert.title else { return}
        switch title {
        case PosthandlerCases.report.rawValue:
            viewModel.report(postID: postId)
        case  PosthandlerCases.sendMessage.rawValue:
        delegate?.postDetailActions(action: .action(feedId: nil, user:viewModel.createChatUser(user: (feed?.post.user)!)))
        case PosthandlerCases.notificationOn.rawValue,PosthandlerCases.notificationOff.rawValue:
            viewModel.turnNotifications(id : self.feed?.post.id ?? 0)
        case PosthandlerCases.copyLink.rawValue:
            viewModel.copyLink(postID: postId)
        case PosthandlerCases.delete.rawValue: print("Delete")
        case PosthandlerCases.edit.rawValue:showAlert(str: "Coming soon.")
        default:
            break
        }
	}
    
    @objc func labelUserNametapped(){
        if self.user!.id != feed?.post.user.id {
            delegate?.postDetailActions(action: .profile(username: labelUserName.text!))
        }
    }
    
    @IBAction func actionExploreLocation(_ sender: Any) {
        delegate?.postDetailActions(action: .location(location :labelUserLocation.text ?? ""))
    }
    
    @IBAction func actionMoveToLikeList(_: Any)
    {delegate?.postDetailActions(action: .like)}
    
    @IBAction func actionMoreTouched(_: Any)
    { if feed != nil {showPostSheet(user: (feed?.post.user)!)}}

    @IBAction func actionAddCommentTouched(_: Any)
    {delegate?.postDetailActions(action: .comment)}

    @objc func singleTapOnLike(sender _: UITapGestureRecognizer) {
        action = ""
        if buttonLike.imageView?.image == #imageLiteral(resourceName: "likelite") || buttonLike.imageView?.image == #imageLiteral(resourceName: "likeSelected")
        {action = likeAction.dislike.rawValue}
        else {action = likeAction.like.rawValue}

        viewModel.performLike(action: action!, postId: postId)
    }

    @objc func longPressOnLike(sender : UILongPressGestureRecognizer) {
        if sender.state == UIGestureRecognizer.State.ended {
            action = ""
            if buttonLike.imageView?.image == #imageLiteral(resourceName: "likeSelected")
            {action = likeAction.dislike.rawValue}
            else if buttonLike.imageView?.image == #imageLiteral(resourceName: "likelite")
            {action = likeAction.superlike.rawValue}
            else
            {action = likeAction.superlike.rawValue}
            viewModel.performLike(action: action!, postId: postId)
        }
    }

    @IBAction func actionShareTouched(_: Any)
    {delegate?.postDetailActions(action: .action(feedId: nil, user:viewModel.createChatUser(user: (feed?.post.user)!)))}

    @IBAction func actionFollowingTouched(_: Any)
    {viewModel.callFollowUnfollowUserAPI(username: ((feed?.post.user.username)!))}

    @IBAction func actionViewUserProfileDetailsTouched(_: Any) {
        if self.user!.id != feed?.post.user.id {
            delegate?.postDetailActions(action: .profile(username: labelUserName.text!))
        }
    }
}

extension PostDetailsViewController: PostDetailController {
	
    func viewModalActions(action: PostViewModalAction) {
		switch action {
        case .notification(data: _):
            if self.feed?.post.isNoticationTurnOn ?? true {self.feed?.post.isNoticationTurnOn = false}else {self.feed?.post.isNoticationTurnOn = true}
        case .copyLink(data: let data):
            UIPasteboard.general.string = data.HTMLPath
            showAlert(str: CopyLinkSuccess.copied.rawValue)
        case .report(data: let data):
            handleReportTask(data: data)
		case let .like(like):
			setupLike(data: like)
		case let .post(post):
			setup(post: post)
		case let .followUnFollow(follows):
			setUpFollowUnfollow(data: follows)
		default:
			break
		}
	}
}
