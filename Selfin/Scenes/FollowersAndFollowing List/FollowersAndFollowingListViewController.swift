//
//  FollowersAndFollowingListViewController.swift
//  Selfin
//
//  Created by cis on 28/09/18.
//  Copyright © 2018 Selfin. All rights reserved.
//

import UIKit

protocol FollowingListViewControllerDelegate:class {
    func didMoveToProfile(username:String)
}

class FollowersAndFollowingListViewController: UIViewController {
    
    let viewModel = FollowersAndFollowingListViewModel()
    @IBOutlet var collectionView: FollowersFollowingCollectionView!
    var listType:UserRequestURL.List  = .following
    var username = String()
    weak var controller:FollowingListViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
         setup()
         backButton()
    }

    func setup() {
        viewModel.delegate = self
        collectionView.controller = self
        if listType == .following {self.navigationItem.title = "Following"
        }else {self.navigationItem.title = "Followers"}
        viewModel.username = username
        listType == .following ?  viewModel.performSearch(type: .following, strSearch: "", page: 1) : viewModel.performSearch(type: .follower, strSearch: "", page: 1)
        
        extendedLayoutIncludesOpaqueBars = true

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if #available(iOS 11.0, *) {
            navigationController?.navigationBar.prefersLargeTitles = true
        } else {// Fallback on earlier versions
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        navigationController?.hidesBarsOnSwipe = false
    }
}

extension FollowersAndFollowingListViewController : SearchFollowersDelegate, FollowersFetchCollectionDelegate {

    func didMoveToProfile(username: String){
        controller?.didMoveToProfile(username: username)
    }
    
    func fetchFollowerAndFollowingList(type: UserRequestURL.List, searchUser: String, page: Int) {
        viewModel.performSearch(type: type, strSearch: searchUser, page: page)
    }

    func didReceived(type :UserRequestURL.List, result:FollowingFollowersResponse) {
        collectionView.display(type: type, search: result)
    }
    
    func didReceived(error msg : String) {
        //TODO : handle error
    }
}
