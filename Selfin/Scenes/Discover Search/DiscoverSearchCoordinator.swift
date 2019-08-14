//
//  DiscoverSearchCoordinator.swift
//  Selfin
//
//  Created by cis on 25/09/18.
//  Copyright © 2018 Selfin. All rights reserved.
//

import Foundation
import UIKit


class DiscoverSearchCoordinator: Coordinator<AppDeepLink> {

   var searchViewController: SearchViewController = SearchViewController.from(from: .search, with: .search)
    weak var navigator:Navigator?
    
    override init(router: Router) {
        super.init(router: router)
        searchViewController.delegate = self
    }
    
	override func toPresentable() -> UIViewController {
		return searchViewController
	}
    
    func showProfile(username : String) {
        let profile = ProfileCoordinator(router: self.router as! Router)
        profile.start(with: .profile, username: username, nav : nil)
        add(profile)
    }
    
    func showUsersPosts(string : String, type : postType) {
        let post = UsersPostCoordinator(router: self.router as! Router)
        navigator?.hidesCamera(hides:true)
        post.start(string: string, type: type)
        self.router.push(post, animated: true) {[weak self] in
            self?.navigator?.hidesCamera(hides:false)
            self?.remove(child: post)
        }
        add(post)
    }
}

extension DiscoverSearchCoordinator : DiscoverSearchCoordinatorDelegate {
    func showHashtagPosts(search: String)
    {showUsersPosts(string: search, type: .hashtags)}
    
    func showLocationPosts(search: String)
    {showUsersPosts(string: search, type: .location)}
    
    func moveToUserProfileFromDiscoverSearch(username: String)
    {showProfile(username: username)}
}




