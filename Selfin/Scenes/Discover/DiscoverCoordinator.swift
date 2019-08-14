//
//  DiscoverCoordinator.swift
//  Selfin
//
//  Created by Marlon Monroy on 6/30/18.
//  Copyright © 2018 Selfin. All rights reserved.
//

import UIKit


class DiscoverCoordinator: Coordinator<AppDeepLink> {
	lazy var discoverViewController: DiscoverViewController = {
		let controller: DiscoverViewController = DiscoverViewController.from(from: .discover, with: .discover)
		controller.delegate = self
		return controller
	}()
	
	override init(router: Router) {
		super.init(router: router)
		router.setRootModule(discoverViewController, hideBar: false)
	}
	weak var navigator:Navigator?
}

extension DiscoverCoordinator: DiscoverViewControllerDelegate {
	func discoverControllerActions(action: DiscoverControllerAction) {
		switch action {
		case .showSearch:
			showSearch()
		case let .showPostDetail(id):
			showPost(id: id)
			
		}
	}
	func showPost(id:Int) {
		//let router = Router()
		let post = PostDetailsCoordinator(router: self.router as! Router)
		post.start(with: id)
		navigator?.hidesCamera(hides: true)
		add(post)
		self.router.push(post, animated: true, completion: {[weak self] in
			self?.navigator?.hidesCamera(hides:false)
		})
	}
	func showSearch() {
		let search = DiscoverSearchCoordinator(router: self.router as! Router)
		add(search)
		navigator?.hidesCamera(hides: true)
		self.router.push(search, animated: true, completion: {[weak self] in
			self?.remove(child: search)
			self?.navigator?.hidesCamera(hides: false)
		})
	}
}
