//
//  UserProfileViewController.swift
//  Selfin
//
//  Created by Marlon Monroy on 11/7/18.
//  Copyright © 2018 Selfin. All rights reserved.
//

import UIKit

class UserProfileViewController: UIViewController {
    weak var delegate:UserProfileDelegate?
	lazy var refreshControl: UIRefreshControl = {
		let refreshControl = UIRefreshControl()
		refreshControl.addTarget(self, action:
			#selector(handleRefresh(_:)),
										 for: .valueChanged)
		return refreshControl
	}()
    var viewModel : ProfileViewModel?
    var userPost : HomeFeed.Post!
    var indexpath = IndexPath()
    @IBOutlet var collection: UserProfileCollectionView!
    @IBOutlet var viewOverlay: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        if #available(iOS 11.0, *) {
            navigationController?.navigationBar.prefersLargeTitles = false
        } else {// Fallback on earlier versions
        }
    }
    
    func setup() {
        viewOverlay.isHidden = false
        collection.addSubview(refreshControl)
        collection.controller = self
        viewModel = ProfileViewModel()
        viewModel?.controller = self
        viewModel?.username = UserStore.user?.userName ?? ""
        viewModel?.fetchUser()
        tabBarItem.selectedImage = #imageLiteral(resourceName: "ProfileSelected").withRenderingMode(.alwaysOriginal)
        
        let navigationBar = navigationController!.navigationBar
        navigationBar.setBackgroundImage(UIImage(),
                                         for: .default)
        navigationBar.shadowImage = UIImage()
    }
    
	@objc func handleRefresh(_ refreshControl: UIRefreshControl) {
        //To update profile after user edit his profile
        viewModel?.profile?.user.userName = UserStore.user?.userName ?? ""
        viewModel?.profile?.user.firstName = UserStore.user?.firstName ?? ""
        viewModel?.profile?.user.lastName = UserStore.user?.lastName ?? ""
        viewModel?.profile?.user.bio = UserStore.user?.bio ?? ""
        viewModel?.username = UserStore.user?.userName ?? ""
        
        viewModel?.fetchUser()//Update user details on every refresh
		collection.prepareForRefresh()
		refreshControl.endRefreshing()
	}
    
    @IBAction func schedulePostButtonPressed(_ sender: Any) {
        delegate?.profileActions(action: .showShedulePostList, user: "")
    }
    
	@IBAction func settingButtonPressed(_ sender: UIBarButtonItem) {
        delegate?.profileActions(action: .showSettings, user: "")
	}
}

extension UserProfileViewController: UserProfileController {
    
    func didReceived(profile: Profile) {
        collection.display(profile: profile)
    }
    
    func didReceiveSuccess(id: Int, index: IndexPath) {
        collection.deletePost(id: id, index: index)
    }
    
    func didReceived(data: [TaggedLikedPostResponse.Post], style : UserProfileCollectionStyle) {
        collection.display(data: data, style: style, type :.userProfile)
    }

    func didReceived(error err: String) {
        showAlert(str: err)
    }

    func didReceived(posts: [HomeFeed.Post]) {
        collection.display(posts: posts, with: collection.currentStyle, type : profileType.userProfile
        ); viewOverlay.isHidden = true
    }
    
    func didReceived(notificationstatus: ReusableResponse) {
        collection.updateNotificationSettings(feeds: userPost)
    }
}

extension UserProfileViewController  : UserFeedCollectionDelegate {
    func userProfileCollectionActions(action:UserProfileCollectionAction) {
        switch action {
        case .profileAction(let values):
            if values.action == .showFollowers {
                delegate?.profileActions(action: .showFollowers, user: values.username)
            }else if values.action == ProfileAction.showFollowing {
                delegate?.profileActions(action: .showFollowing, user: values.username)
            }else {delegate?.profileActions(action: .showPost, user: values.username)}
        case .fetchMore(let page):
            viewModel?.fetchPosts(page: page)
        case .postSelected(let post):
        delegate?.profileFeedAction(action: .showUserPostDetail(id: post.id))
        case .mentionLikesSelected(let post):
        delegate?.profileFeedAction(action: .showUserPostDetail(id: post.id))
        case .postAction(let actionFeed) :
            performActionOverFeed(action: actionFeed)
        case .editImage() :
            delegate?.profileActions(action: .editProfile, user: "")
        case .location(let location):
            delegate?.profileFeedAction(action: .showLocation(string : location))
        default:
            break
        }
    }
    
    func fetchUsersData(_ style : UserProfileCollectionStyle, page : Int) {
        if style == .mention {
            viewModel?.fetchMentions(username: "", page: page)
            return}
        viewModel?.fetchLikes(username: "", page: page)
    }
    
    func performActionOverFeed(action : UserProfilePostItemAction) {
        switch action {
        case .postActionButtonPressed(let post):
            showPostSheet(post: post.post, index: post.index)
        default:
            break
        }
    }
    
    func showPostSheet(post:HomeFeed.Post, index : IndexPath) {
        userPost = post
        
        var notoficationState = PosthandlerCases.notificationOff.rawValue
        if userPost.is_notifying {
            notoficationState = PosthandlerCases.notificationOff.rawValue
        }else { notoficationState = PosthandlerCases.notificationOn.rawValue}
        
        indexpath = index
        let actionSheet = UIAlertController.PostAction(titles: PosthandlerCases.copyLink.rawValue, notoficationState, PosthandlerCases.delete.rawValue, PosthandlerCases.edit.rawValue, handler: postActionHandler )
        self.present(actionSheet, animated: true)
    }

    func postActionHandler(_ alert:UIAlertAction) {
        guard let title = alert.title else { return}
        switch title {
        case PosthandlerCases.copyLink.rawValue:
            viewModel?.copyLink(postID: userPost.id)
        case PosthandlerCases.delete.rawValue:
            viewModel?.deleteUPost(id: userPost.id, index: indexpath)
        case PosthandlerCases.notificationOn.rawValue, PosthandlerCases.notificationOff.rawValue:
            viewModel?.turnOnOffNotification(id: userPost.id)
        case PosthandlerCases.edit.rawValue:
            showAlert(str: "Coming soon.")
        default:
            break
        }
    }
}

