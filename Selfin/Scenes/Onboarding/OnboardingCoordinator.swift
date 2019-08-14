//
//  OnboardingCoordinator.swift
//  Selfin
//
//  Created by Marlon Monroy on 8/17/18.
//  Copyright © 2018 Selfin. All rights reserved.
//

import UIKit

class OnboardingCoordinator: Coordinator<AppDeepLink> {
    var onboardingViewController: MainOnboardingViewController = MainOnboardingViewController.from(from: .onboarding, with: .onboarding)

    override init(router: Router) {
        super.init(router: router)
    }

    override func toPresentable() -> UIViewController {
        return onboardingViewController
    }
}
