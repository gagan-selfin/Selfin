//
//  DiscoverActions.swift
//  Selfin
//
//  Created by Marlon Monroy on 11/17/18.
//  Copyright © 2018 Selfin. All rights reserved.
//

import Foundation

enum DiscoverControllerAction {
	case showPostDetail(id:Int)
	case showSearch
}

protocol DiscoverViewControllerDelegate {
	func discoverControllerActions(action:DiscoverControllerAction)
}

protocol DiscoverViewCollectionDelegate : class {
    func didFetchMoreData(page : Int)
}


