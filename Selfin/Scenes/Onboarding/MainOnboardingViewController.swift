//
//  MainOnboardingViewController.swift
//  Selfin
//
//  Created by Marlon Monroy on 8/17/18.
//  Copyright © 2018 Selfin. All rights reserved.
//

import UIKit

class MainOnboardingViewController: UIViewController {
    @IBOutlet var pageControl: UIPageControl!
    @IBOutlet var nextButton: UIButton!
    @IBOutlet var skipButton: UIButton!

    var embededContainer: OnboardingViewController?
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()

        AppUtility.lockOrientation(.portrait, andRotateTo: .portrait)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        // We Didn't forget to reset when view is being removed (Smart we are ;))
        AppUtility.lockOrientation(.all)
    }

    override func addChild(_ childController: UIViewController) {
        super.addChild(childController)
        if let child = childController as? OnboardingViewController {
            embededContainer = child
        }
    }

    private func setup() {
        pageControl.currentPage = 0
        nextButton.addTarget(self, action: #selector(nextButtonPressed(sender:)), for: .touchUpInside)
        skipButton.addTarget(self, action: #selector(nextButtonPressed(sender:)), for: .touchUpInside)
        embededContainer?.onIndexChanged = { [weak self] index in
            self?.pageControl.currentPage = index
        }
    }

    @objc func nextButtonPressed(sender _: UIButton) {
        embededContainer?.next()
    }
}
