//
//  OnboardingPageViewController.swift
//  Selfin
//
//  Created by Marlon Monroy on 8/17/18.
//  Copyright © 2018 Selfin. All rights reserved.
//

import UIKit

class OnboardingPageViewController: UIViewController {
    @IBOutlet var image: UIImageView!
    @IBOutlet var messageTitle: UILabel!
    @IBOutlet var message: UILabel!
    var item: OnboardingItem?
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

    private func setup() {
        if let item = item {
            image.image = UIImage(named: item.imageName)
            messageTitle.text = item.title
            message.text = item.message
        }
    }
}
