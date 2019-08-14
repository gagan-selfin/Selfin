//
//  TutorialViewController.swift
//  Selfin
//
//  Created by cis on 19/09/18.
//  Copyright © 2018 Selfin. All rights reserved.
//

import UIKit

protocol TutorialViewControllerDelegate {
    func skipTutorial()
}

class TutorialViewController: UIViewController, UIScrollViewDelegate {
    @IBOutlet var pageControl: UIPageControl!
    @IBOutlet var scrllView: UIScrollView!

    var delegate: TutorialViewControllerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()

        AppUtility.lockOrientation(.portrait, andRotateTo: .portrait)
        // It means user has seen the tutorial, no need to show him again
        if UserDefaults.standard.object(forKey: Constants.isFirstVisit.rawValue) as? String == "No" {
            delegate?.skipTutorial()
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        AppUtility.lockOrientation(.all)
    }

    // MARK: -

    // MARK: - ScrollView Delegate

    func scrollViewDidEndDecelerating(_: UIScrollView) {
        if scrllView.contentOffset.x == 0 {
            pageControl.currentPage = 0
        } else if scrllView.contentOffset.x == view.frame.size.width {
            pageControl.currentPage = 1
        } else if scrllView.contentOffset.x == view.frame.size.width * 2 {
            pageControl.currentPage = 2
        }
    }

    // MARK: -

    // MARK: - Button Actions

    @IBAction func btnSkipPressed(_: Any) {
        delegate?.skipTutorial()
    }

    @IBAction func btnNextPressed(_: Any) {
        if scrllView.contentOffset.x == 0 {
            scrllView.setContentOffset(CGPoint(x: view.frame.size.width, y: scrllView.contentOffset.y), animated: true)
            pageControl.currentPage = 1
        } else if scrllView.contentOffset.x == view.frame.size.width {
            scrllView.setContentOffset(CGPoint(x: view.frame.size.width * 2, y: scrllView.contentOffset.y), animated: true)
            pageControl.currentPage = 2
        } else {
            delegate?.skipTutorial()
        }
    }
}
