//
//  ProfileViewController.swift
//  Selfin
//
//  Created by Marlon Monroy on 11/13/18.
//  Copyright © 2018 Selfin. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {
    @IBOutlet var collectionView: UserProfileCollectionView!
    @IBOutlet var viewOverlay: UIView!
    weak var delegate:UserProfileDelegate?
    var viewModel = ProfileViewModel()
    var viewModelHome = HomeFeedViewModel()
    var username : String!
    var feed:HomeFeed.Post?
    var user : OthersProfile.User!
    weak var controller:showUserChatRoom?
    var indexpath = IndexPath()
    
    override func viewDidLoad() {
       super.viewDidLoad()
        setup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        navigationController?.isNavigationBarHidden = false
        if #available(iOS 11.0, *) {
            navigationController?.navigationBar.prefersLargeTitles = false
        } else {// Fallback on earlier versions
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navigationController?.hidesBarsOnSwipe = false
    }
    
    fileprivate func setup() {
        viewOverlay.isHidden = false
        collectionView.controller = self
        viewModel.controller = self
        viewModelHome.controller = self
        viewModel.username = username
        viewModel.OtherUserProfile(username: username ?? "")
        backButton()
        
        let navigationBar = navigationController!.navigationBar
        navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationBar.shadowImage = UIImage()
    }
    
    @IBAction func actionMore(_ sender: Any) {
        var actionSheet = UIAlertController()
        var blockStatus = String()
        
        if user != nil { if user.isBlocked {blockStatus = actionsOnUsers.unblock.rawValue}else {blockStatus = actionsOnUsers.block.rawValue}}
        
        actionSheet = UIAlertController.PostAction(titles: blockStatus, actionsOnUsers.copyLink.rawValue,actionsOnUsers.sendMessage.rawValue,actionsOnUsers.report.rawValue, handler: userActionHandler)
        
        self.present(actionSheet, animated: true, completion: nil)
    }
    
    func userActionHandler(_ alert: UIAlertAction) {
        guard let title = alert.title else { return }
        switch title {
        case actionsOnUsers.unblock.rawValue,actionsOnUsers.block.rawValue:
            showAlert(str: "Are you sure want to block this user?") {
                self.viewModel.blockUnblock()
            }
        case actionsOnUsers.sendMessage.rawValue:
             controller?.didMoveToChatScreen(user: viewModel.createChatUser(user: user))
        case actionsOnUsers.share.rawValue:
            break //showAlert(str: "Inprogress, Need Clarification")
        case actionsOnUsers.copyLink.rawValue:
             viewModel.userProfileLink(username: username)
        case actionsOnUsers.report.rawValue:
            print("report user")
        default:
            break
        }
    }
    
    func showPostSheet(feed : HomeFeed.Post, index : IndexPath) {
        var notoficationState = PosthandlerCases.notificationOff.rawValue
        if feed.is_notifying {
            notoficationState = PosthandlerCases.notificationOff.rawValue
        }else { notoficationState = PosthandlerCases.notificationOn.rawValue}
        
        indexpath = index
        let actionSheet = UIAlertController.PostAction(titles: PosthandlerCases.report.rawValue,notoficationState, PosthandlerCases.copyLink.rawValue, handler: postActionHandler)
        self.present(actionSheet, animated: true, completion: nil)
    }
    
    func postActionHandler(_ alert: UIAlertAction) {
        guard let title = alert.title else { return }
        switch title {
        case PosthandlerCases.report.rawValue:
            reportOptions()
        case PosthandlerCases.copyLink.rawValue:
            viewModelHome.copyLink(postID: (self.feed?.id)!)
        case PosthandlerCases.notificationOn.rawValue , PosthandlerCases.notificationOff.rawValue:
            viewModel.turnOnOffNotification(id: self.feed?.id ?? 0)
        default:
            break
        }
    }
    
    func reportOptions() {
        let actionSheet = UIAlertController.PostAction(titles: ReportType.inappropraite.rawValue,ReportType.spam.rawValue, handler: reportActionHandler)
        self.present(actionSheet, animated: true, completion: nil)
    }
    
    func reportActionHandler(_ alert: UIAlertAction) {
        guard let title = alert.title else { return }
        switch title {
        case ReportType.inappropraite.rawValue:
            viewModelHome.report(postID: (self.feed?.id)!, type: ReportType.inappropraite)
        case ReportType.spam.rawValue:
            viewModelHome.report(postID: (self.feed?.id)!, type: ReportType.spam)
        default:
            break
        }
    }
}

extension ProfileViewController : UserProfileController {
    func didReceived(profile: ReusableResponse) {
         if user.isBlocked {user.isBlocked = false}else {user.isBlocked = true}
         delegate?.profileActions(action: .blocked, user: "")
         NotificationCenter.default.post(name: NSNotification.Name(rawValue: "UserBlocked"), object: nil, userInfo: nil)
    }
    
    func didReceived(profile: OthersProfile) {
        user = profile.user
        collectionView.display(profile: profile)
    }

    func didReceived(posts: [HomeFeed.Post]) {
        if user.isPrivate && !user.isRequestedAccepted{}else {
            collectionView.display(posts: posts, with: collectionView.currentStyle, type : profileType.publicProfile)
        }
        viewOverlay.isHidden = true
    }
    
    func didReceived(data: [TaggedLikedPostResponse.Post], style: UserProfileCollectionStyle) {
        if user.isPrivate && !user.isRequestedAccepted{}else {
            collectionView.display(data: data, style: style, type :.publicProfile)
        }
    }
    
    func didReceived(error msg: String) {
        showAlert(str: msg)
        print(msg)
    }
    
    func didReceived(link : StaticPage) {
        UIPasteboard.general.string = link.HTMLPath
        showAlert(str: CopyLinkSuccess.copied.rawValue)
    }
    
    func didReceived(notificationstatus: ReusableResponse) {
        collectionView.updateNotificationSettings(feeds: feed!)
    }
}

extension ProfileViewController : UserFeedCollectionDelegate, HomeFeedController {
    
    func userProfileCollectionActions(action:UserProfileCollectionAction) {
        switch action {
        case .profileAction(let values):
            if values.action == .showFollowers {
                delegate?.profileActions(action: .showFollowers, user: values.username)
            }else if values.action == ProfileAction.showFollowing {
                delegate?.profileActions(action: .showFollowing, user: values.username)
            }else {delegate?.profileActions(action: .showPost, user: values.username)}
        case .fetchMore(let page):
            viewModel.fetchPosts(page: page)
        case .postSelected(let post):
            delegate?.profileFeedAction(action: .showUserPostDetail(id: post.id))
        case .mentionLikesSelected(let post):
            delegate?.profileFeedAction(action: .showUserPostDetail(id: post.id))
        case .postAction(let actionFeed) :
            performActionOverFeed(action: actionFeed)
        case .location(let location):
            delegate?.profileFeedAction(action: .showLocation(string : location))
        default:
            break
        }
    }
    
    func fetchUsersData(_ style : UserProfileCollectionStyle, page : Int) {
        if style == .mention {
            viewModel.fetchMentions(username: "", page: page)
            return}
        viewModel.fetchLikes(username: "", page: page)
    }
    
    func performActionOverFeed(action : UserProfilePostItemAction) {
        switch action {
        case .postActionButtonPressed(let post):
             self.feed = post.post
             showPostSheet(feed: post.post, index : post.index)
        default:
            break
        }
    }
    
    func didReceived(responseType: FeedAPIResponse) {
        switch responseType {
        case .report(data: let data):
            if data.status {showReport()}
        case .copyLink(data: let data):
            if data.status {UIPasteboard.general.string = data.HTMLPath;showAlert(str: CopyLinkSuccess.copied.rawValue)}
        case .error(error: let err):
            print(err)
        default:
            break
    }}
    
    func showReport() {
        let alert = UIAlertController(title: "Post Reported", message: "Thank you for helping us improve selfin. We will investigate this post and take appropriate action with in 24 hours", preferredStyle: .alert)
        self.present(alert, animated: true, completion: nil)
        Timer.scheduledTimer(withTimeInterval: 3, repeats: false) {[weak self] _ in
            self?.collectionView.deletePost(id: self?.feed?.id ?? 0, index: self?.indexpath ?? IndexPath.init(row: 0, section: 0) )
            self?.dismiss(animated: true, completion: nil)
        }
    }
}
