//
//  HomeFeedViewController.swift
//  Selfin
//
//  Created by Marlon Monroy on 11/6/18.
//  Copyright © 2018 Selfin. All rights reserved.
//

import UIKit
import RealmSwift

class HomeFeedViewController: UIViewController {
    @IBOutlet var collection: HomeFeedCollectionView!
    @IBOutlet var navHieght: NSLayoutConstraint!
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action:
            #selector(handleRefresh(_:)),
                                 for: .valueChanged)
        return refreshControl
    }()
    var index :Int?
    weak var delegate: HomeFeedViewControllerDelegate?
    var viewModel = HomeFeedViewModel()
    var feed:HomeFeed.Post?
    let controller: SubAccountsViewController = SubAccountsViewController.from(from: .subAccount, with: .subAccount)

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        NotificationCenter.default.addObserver(self, selector: #selector(UserBlocked(notification:)), name: NSNotification.Name(rawValue: "UserBlocked"), object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        manageOrientation()
        notificationBaged()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
    }
    
    @objc func UserBlocked(notification : Notification) {
        collection.prepareForRefresh()
        viewModel.fetchFeeds(page: 1)
    }
    
    func manageOrientation() {
        handleRotation(orientation: UIDevice.current.orientation)
        view.layoutIfNeeded()
        switch UIDevice.current.orientation  {
        case .portraitUpsideDown, .portrait:
            self.navigationController?.isNavigationBarHidden = false
            
                    if #available(iOS 11.0, *) {
                        navigationController?.navigationItem.largeTitleDisplayMode = .always
                        navigationController?.navigationBar.prefersLargeTitles = true
                    } else {// Fallback on earlier versions
                    }
            navigationController?.navigationBar.isTranslucent = false
            navigationController?.hidesBarsOnSwipe = true
        case .landscapeRight, .landscapeLeft:
            self.navigationController?.isNavigationBarHidden = true
            navigationController?.navigationBar.isTranslucent = true
            navigationController?.hidesBarsOnSwipe = false
        default: break
        }
        collection.reloadData()
//        collection.updateLayout(for: UIDevice.current.orientation)
    }
    
    func notificationBaged(){
        let count = UserStore.chatNotificationCount()
        let notificationButton = SelfinBadgeButton()
        notificationButton.frame = CGRect(x: 0, y: 0, width: 44, height: 44)
        notificationButton.addTarget(self, action: #selector(movetochat), for: .touchUpInside)
        notificationButton.setImage(UIImage(named: "feeds_message_nav_icon")?.withRenderingMode(.alwaysOriginal), for: .normal)
        if  count > 0 {
            notificationButton.badgeEdgeInsets = UIEdgeInsets(top: 38, left: 0, bottom: 0, right: 8)
            notificationButton.badge = "\(count)"
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: notificationButton)
        }else {
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: notificationButton)}
    }
    
    func postActionHandler(_ alert: UIAlertAction) {
        guard let title = alert.title else { return }
        switch title {
        case PosthandlerCases.report.rawValue:
            reportOptions()
        case PosthandlerCases.sendMessage.rawValue:
            delegate?.feedControllerActions(action: .showChatRoom(user: viewModel.createChatUser(user: (self.feed?.user)!)))
        case PosthandlerCases.copyLink.rawValue:
            viewModel.copyLink(postID: (self.feed?.id)!)
        case PosthandlerCases.delete.rawValue:
            viewModel.deleteUPost(id: self.feed?.id ?? 0)
        case PosthandlerCases.notificationOn.rawValue, PosthandlerCases.notificationOff.rawValue:
           viewModel.turnOnOffNotification(id: (self.feed?.id)!)
        case PosthandlerCases.edit.rawValue:
            showAlert(str: "Coming soon.")
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
            viewModel.report(postID: (self.feed?.id)!, type: ReportType.inappropraite)
        case ReportType.spam.rawValue:
            viewModel.report(postID: (self.feed?.id)!, type: ReportType.spam)
        default:
            break
        }
    }
   
    func showReport() {
        let alert = UIAlertController(title: "Post Reported", message: "Thank you for helping us improve selfin. We will investigate this post and take appropriate action with in 24 hours", preferredStyle: .alert)
        self.present(alert, animated: true, completion: nil)
        Timer.scheduledTimer(withTimeInterval: 3, repeats: false) {[weak self] _ in
            self?.collection.hideReportedPost(index: self?.index ?? 0);
            self?.dismiss(animated: true, completion: nil)
        }
    }

    func showPostSheet() {
        var notoficationState = PosthandlerCases.notificationOff.rawValue
        if feed!.is_notifying {
            notoficationState = PosthandlerCases.notificationOff.rawValue
        }else { notoficationState = PosthandlerCases.notificationOn.rawValue}
        if self.feed?.user.user_id == UserStore.user?.id {
            let actionSheet = UIAlertController.PostAction(titles: PosthandlerCases.copyLink.rawValue, notoficationState,PosthandlerCases.delete.rawValue, PosthandlerCases.edit.rawValue, handler: postActionHandler)
            self.present(actionSheet, animated: true, completion: nil)
        }else {
            let actionSheet = UIAlertController.PostAction(titles: PosthandlerCases.report.rawValue,notoficationState, PosthandlerCases.sendMessage.rawValue, PosthandlerCases.copyLink.rawValue, handler: postActionHandler)
            self.present(actionSheet, animated: true, completion: nil)
        }
    }
    
    func update(object : User) -> User {
        let user = User()
        user.isPrivate = true
        return user
    }

    func setup() {
        controller.delegate = self
        collection.addSubview(refreshControl)
        collection.delegateAction = self
        viewModel.controller = self
        viewModel.fetchFeeds(page: 1)
        tabBarItem.selectedImage = #imageLiteral(resourceName: "feedSelected").withRenderingMode(.alwaysOriginal)
    }
    
    @objc func movetochat() {
       UserStore.deleteNotification()
       delegate?.feedControllerActions(action: .showChat)
    }
    
    @objc func handleRefresh(_ refreshControl: UIRefreshControl) {
        collection.prepareForRefresh()
        viewModel.fetchFeeds(page: 1)
    }

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
         manageOrientation()
    }
}

extension HomeFeedViewController: HomeFeedController, HorizontalDisplayable, UserFeedCollectionDelegate, SubAccountsCoordinatorDelegate {
    
    func didMoveToProfleDetails(username: String) {
        delegate?.feedControllerActions(action: .showProfile(username: username))
    }
    
    func userProfileCollectionActions(action: UserProfileCollectionAction) {
        switch action {
        case .postAction(action: let actionFeed):
            if isPortraitMode(){performActionOverFeed(action: actionFeed)}
        case .fetchMore(page: let page):
            viewModel.fetchFeeds(page: page)
        case .postSelected(post: let post):
            if isPortraitMode()
            {delegate?.feedControllerActions(action: .showPostDetail(id: post.id, isAnimate: true))}
        default:
            break
        }
    }
    
    func performActionOverFeed(action : UserProfilePostItemAction) {
        switch action {
        case .avatarButtonPressed(let post), .userButtonPressed(let post):
            if post.user.username == UserStore.user?.userName {
                self.tabBarController?.selectedIndex = 4
            }else {delegate?.feedControllerActions(action: .showProfile(username: post.user.username))}
        case .likeButtonPressed( _):
           break
        case .postActionButtonPressed(let post):
            index = collection.feeds.firstIndex { $0.id == post.post.id}
            self.feed = post.post
            showPostSheet()
        case .postSelected( _):
            break
        case .locationButtonPressed(let location):
            delegate?.feedControllerActions(action: .showLocation(location: location))
        }
    }
    
    func didReceived(responseType: FeedAPIResponse) {
        switch responseType {
        case .feed(feed: let feed, let page):
            hideLoader()
            refreshControl.endRefreshing();
            print(feed.count)
            print(viewModel.feeds.count)
            if feed.count == 0  && page == 1{
                if !controller.view.isDescendant(of: self.view) {
                    controller.refreshSubAccount = checkforData
                    addChild(controller)
                    view.addSubview(controller.view)
                    controller.didMove(toParent: self)
                }
            }else {
                controller.willMove(toParent: nil)
                controller.view.removeFromSuperview()
                controller.removeFromParent()
            }
            
            collection.display(feeds: feed)
        case .report(data: let data):
            if data.status {showReport()}
        case .copyLink(data: let data):
            if data.status {
                UIPasteboard.general.string = data.HTMLPath;showAlert(str: CopyLinkSuccess.copied.rawValue)}
        case .error(error: let err):
            print(err)
        case .delete(_):
           collection.hideReportedPost(index: index ?? 0)
        case .notification(data: _):
            collection.updateNotificationSettings(feeds: self.feed!)
        }
    }
    
    func checkforData() {viewModel.fetchFeeds(page: 1)}
}
