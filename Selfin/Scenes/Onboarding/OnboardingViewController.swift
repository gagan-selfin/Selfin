//
//  OnboardingViewController.swift
//  Selfin
//
//  Created by Marlon Monroy on 8/17/18.
//  Copyright © 2018 Selfin. All rights reserved.
//

import UIKit

class OnboardingViewController: UIPageViewController {
    var onIndexChanged: ((Int) -> Void)?
    var onFinalScreen: (() -> Void)?
    let viewModel = OnboardingViewModel()
    private var currentIndex = 0
    lazy var pages: [OnboardingPageViewController] = {
        let content = viewModel.onboardinItems.map { (item) -> OnboardingPageViewController in
            let controller: OnboardingPageViewController = OnboardingPageViewController.from(from: .onboarding, with: .onboardingPage)
            controller.item = item
            return controller
        }
        return content
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        AppUtility.lockOrientation(.portrait, andRotateTo: .portrait)
        setControllers()
        delegate = self
        dataSource = self
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        // We Didn't forget to reset when view is being removed (Smart we are ;))
        AppUtility.lockOrientation(.all)
    }

    func setControllers() {
        let first = pages[0]
        setViewControllers([first], direction: .forward, animated: true, completion: nil)
    }

    func next() {
        guard currentIndex + 1 <= pages.count - 1 else { return }
        setViewControllers([pages[currentIndex + 1]], direction: .forward, animated: true, completion: nil)
        currentIndex += 1
        onIndexChanged?(currentIndex)
    }
}

extension OnboardingViewController: UIPageViewControllerDelegate, UIPageViewControllerDataSource {
    func pageViewController(_: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let index = pages.index(of: viewController as! OnboardingPageViewController) else { return nil }
        onIndexChanged?(index)
        currentIndex = index
        let preview = index - 1
        if preview < 0 { return nil }

        return pages[preview]
    }

    func pageViewController(_: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let index = pages.index(of: viewController as! OnboardingPageViewController) else { return nil }
        onIndexChanged?(index)
        currentIndex = index
        let next = index + 1
        if next > pages.count - 1 { return nil }

        return pages[next]
    }
}
