//
//  UserPostsViewController.swift
//  Selfin
//
//  Created by cis on 11/10/18.
//  Copyright © 2018 Selfin. All rights reserved.
//

import UIKit

protocol UserPostsViewControllerDelegate {
    func backToPreviousScreen()
    func moveToPostDetailsFromUserPostScreen(id: Int)
}

class UserPostsViewController: UIViewController {
    @IBOutlet var collectionView: DiscoverCollectionView!
    // let feedViewModel = FeedsViewModel()
    var username = String()

    var delegate: UserPostsViewControllerDelegate?

    var page_number = Int()
    var feed: [Feed] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        page_number = 1

        AppUtility.lockOrientation(.portrait, andRotateTo: .portrait)
        collectionView.didSelect = didSelect
        collectionView.callAPIForGettingNextDiscoverSet = callAPIForGettingNextDiscoverSet

        setup(isShowLoader: true)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        // We Didn't forget to reset when view is being removed (Smart we are ;))
        AppUtility.lockOrientation(.all)
    }

    func callAPIForGettingNextDiscoverSet(page: Int) {
        print(page)
        page_number = page
        setup(isShowLoader: false)
    }

    func didSelect(id: Int) {
        delegate?.moveToPostDetailsFromUserPostScreen(id: id)
    }

    func setup(isShowLoader: Bool) {
        // API to get self feeds
        if isShowLoader {
            showLoader()
        }
//
//        feedViewModel.fetchMyFeedsForProfile(username: username, page_number: page_number)
//        feedViewModel.isSuccess = { success, feeds in
//            if isShowLoader {
//                self.hideLoader()
//            }
//            if success {
//                let feedsList: FeedData = feeds!
//                if self.feed.count == 0 {
//                    self.feed = feedsList.feedList
//                } else {
//                    self.feed.append(contentsOf: feedsList.feedList)
//                    // self.feed.append(feedsList.feedList)
//                }
//
//                if feedsList.feedList.count == 0 {
//                    self.collectionView.displayTest(feeds: feedsList.feedList, page_number: self.page_number, isMoreData: false)
//
//                } else {
//                    self.collectionView.displayTest(feeds: feedsList.feedList, page_number: self.page_number, isMoreData: true)
//                }
//            }
//        }
    }

    @IBAction func btnBackPressed(_: Any) {
        delegate?.backToPreviousScreen()
    }
}
