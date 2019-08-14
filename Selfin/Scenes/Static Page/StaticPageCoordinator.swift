//
//  StaticPageCoordinator.swift
//  Selfin
//
//  Created by cis on 20/09/18.
//  Copyright © 2018 Selfin. All rights reserved.
//

import UIKit

class StaticPageCoordinator: Coordinator<AppDeepLink> {
    var heading = String()

    lazy var controller: StaticPageViewController = {
        let controller: StaticPageViewController = StaticPageViewController.from(from: .static_page, with: .static_page)
        return controller
    }()

    override init(router: Router) {
        super.init(router: router)
        // router.push(controller, animated: true, completion: nil)
    }

    override func start() {
        controller.heading = heading
        router.push(controller, animated: true, completion: nil)
    }
}

