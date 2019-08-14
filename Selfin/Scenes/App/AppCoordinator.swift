//
//  AppCoordinator.swift
//  Selfin
//
//  Created by Marlon Monroy on 6/30/18.
//  Copyright © 2018 Selfin. All rights reserved.
//

import UIKit

//enum AppDeepLink<T> {
//    case root
//    case details(data:T)
//}

enum AppDeepLink {
    case root
    case details
}

class AppCoordinator {
    var windowCoordinator: UIWindow?

    lazy var main: MainCoordinator = {
        let nav = selfinNavigationController()
        let router = Router(navigationController: nav)
        let coordinator = MainCoordinator(router: router)
        return coordinator
    }()

    lazy var onboarding: OnboardingCoordinator = {
        let nav = selfinNavigationController()
        let router = Router(navigationController: nav)
        let coordinator = OnboardingCoordinator(router: router)
        return coordinator
    }()

    lazy var tutorial: TutorialCoordinator = {
        let nav = selfinNavigationController()
        nav.isNavigationBarHidden = true
        let router = Router(navigationController: nav)
        let coordinator = TutorialCoordinator(router: router)
        return coordinator
    }()
    
    init(window: UIWindow) {
        tutorial.delegate = self
        tutorial.start(with: .root, email: "")
        window.rootViewController = tutorial.toPresentable()
        windowCoordinator = window
    }

    init(homeWindow: UIWindow) {
        main.start(with: .root, deeplink: nil)
        homeWindow.rootViewController = main.toPresentable()
        windowCoordinator = homeWindow
    }
    
    func deepLinkNavigator(deeplink : deepLinkValues) {
        switch deeplink {
        case .forgetPassword(email : let email):
            tutorial.start(with: .details, email : email)
            windowCoordinator?.rootViewController = tutorial.toPresentable()
        default:
            main.start(with: .details, deeplink: deeplink)
            windowCoordinator?.rootViewController = main.toPresentable()
        }
    }
}

extension AppCoordinator: TutorialCoordinatorDelegate {
    func moveToMainVC() {
        main.start(with: .root, deeplink: nil)
        windowCoordinator?.rootViewController = main.toPresentable()
    }
}
