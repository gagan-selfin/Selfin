//
//  SearchViewController.swift
//  Selfin
//
//  Created by cis on 13/11/2018.
//  Copyright © 2018 Selfin. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController {
    @IBOutlet var collectionView: SearchCollectionView!
    var viewModel = SearchViewModel()
    var delegate: DiscoverSearchCoordinatorDelegate?
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
		backButton()
    }
    
    func setup() {
        viewModel.delegate = self
        collectionView.controller = self
        collectionView.didSelectHashtag = didSelectHashtag
        collectionView.didSelectLocation = didSelectLocation
        viewModel.performSearch(type : .most, strSearch: "", page: 1)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        if #available(iOS 11.0, *) {
            navigationController?.navigationBar.prefersLargeTitles = false
        } else {// Fallback on earlier versions
        }
    }

    func didSelectLocation(search: String) {
        delegate?.showLocationPosts(search: search)
    }

    func didSelectHashtag(search: String) {
        delegate?.showHashtagPosts(search: search)
    }
}

extension SearchViewController: SearchControllerDelegate, SearchCollectionDelegate {
    
    func didViewUserProfile(username: String) {
        delegate?.moveToUserProfileFromDiscoverSearch(username: username)
    }
    
    func fetchData(type: SearchRequestURL.searchStyle, strSearch : String, page: Int) {
        switch type {
        case .hashtag:
            viewModel.performSearchTags(strSearch: strSearch, page: page)
        case .location:
            viewModel.performSearchLocation(strSearch: strSearch, page: page)
        default:
            viewModel.performSearch(type: type, strSearch: strSearch, page: page)
        }
    }
    
    func didReceived(type:SearchRequestURL.searchStyle, result:FollowingFollowersResponse) {
        collectionView.display(type: type, search: result)
    }

    func didReceivedTags(result:SearchTags) {
         collectionView.display(search: result)
    }
    
    func didReceivedLocation(result:SearchLocation) {
         collectionView.display(search:result)
    }
    
    func didReceived(error msg: String) {
        print(msg)
    }
}
