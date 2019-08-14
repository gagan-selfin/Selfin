//
//  mainCoordinator.swift
//  Selfin
//
//  Created by Marlon Monroy on 6/30/18.
//  Copyright © 2018 Selfin. All rights reserved.
//

import UIKit
enum NavigationItem {
    case toFeeds
    case toSearch
    case toCamera
    case toPostDetails(id: Int)
    case toUserProfile(post: HomeFeed.Post)
    case chat
}

protocol Navigator: class {
    func to(module: NavigationItem)
	 func hidesCamera(hides:Bool)
}

class MainCoordinator: Coordinator<AppDeepLink>, UITabBarControllerDelegate {
    var tabs: [UIViewController: Coordinator<AppDeepLink>] = [:]
    var mainTabController = MainViewController()
    weak var navigator: Navigator?

    lazy var feeds: FeedsCoodinator = {
        let router = Router()
        let coordinator = FeedsCoodinator(router: router)
        return coordinator
    }()

    lazy var discover: DiscoverCoordinator = {
        let router = Router()
        let coordinator = DiscoverCoordinator(router: router)
        coordinator.navigator = self
        return coordinator
    }()

    lazy var camera: CameraCoordinator = {
        let router = Router()
        let coordinator = CameraCoordinator(router: router)
        return coordinator
    }()

    lazy var notifications: NotificationsCooridinator = {
        let router = Router()
        let coordinator = NotificationsCooridinator(router: router)
        coordinator.navigator = self
        return coordinator
    }()

    lazy var profile: ProfileCoordinator = {
        let router = Router()
        let coordinator = ProfileCoordinator(router: router)
        coordinator.navigator = self
        coordinator.start(with: .userProfile, username: "", nav : nil)
        return coordinator
    }()

    var staticPage: StaticPageCoordinator = {
        let router = Router()
        let coordinator = StaticPageCoordinator(router: router)
        return coordinator
    }()
    
    func otherProfile(username:String) {
        let router = Router()
        let profile = ProfileCoordinator(router: router)
        navigator?.hidesCamera(hides: true)
        profile.start(with: .profile, username: username, nav: navigator)
        add(profile)
    }
    
    func post(id:Int) {
        let router = Router()
        let post = PostDetailsCoordinator(router: router)
        post.start(with: id)
        navigator?.hidesCamera(hides: true)
        add(post)
        self.router.push(post, animated: true, completion: {[weak self] in
            self?.navigator?.hidesCamera(hides:false)
        })
    }

    override init(router: Router) {
        super.init(router: router)
        feeds.navigator = self
        router.setRootModule(mainTabController, hideBar: true)
        mainTabController.delegate = self
    }
    
    func start(with link: AppDeepLink, deeplink:deepLinkValues?) {
        setTabs([feeds, discover, camera, notifications, profile], deeplink: deeplink ?? deepLinkValues.post(id: 0) , link: link)
    }

    func setTabs(_ coordinators: [Coordinator<AppDeepLink>], animated: Bool = false, deeplink:deepLinkValues, link :AppDeepLink) {
        tabs = [:]
        let vcs = coordinators.map { coordinator -> UIViewController in
            if coordinator == feeds {
                (coordinator as! FeedsCoodinator).start(type: link, deeplink: deeplink)
            }
            let viewController = coordinator.toPresentable()
            tabs[viewController] = coordinator
            return viewController
        }
        mainTabController.setViewControllers(vcs, animated: animated)
    }

    func tabBarController(_: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        guard let coordinator = tabs[viewController] else { return true }
        if coordinator is CameraCoordinator {
            camereSelected()
            return false
        } else if coordinator is ProfileCoordinator {
            coordinator.start()
        }
        return true
    }
}

extension MainCoordinator:CameraCoordinatorDelegate, Navigator {
    func hidesCamera(hides: Bool) {
        mainTabController.hideCamera(hides: hides)
    }
    
    func to(module: NavigationItem) {
        switch module {
        default:
            break
        }
    }

    func camereSelected() {
        let nav = selfinNavigationController()
        let cameraRouter = Router(navigationController: nav)
        let coordinator = CameraCoordinator(router: cameraRouter)
        coordinator.start(screenType: .camera)
        router.present(coordinator, animated: true)
        add(camera)
    }
}
