//
//  UsersPostViewController.swift
//  Selfin
//
//  Created by cis on 21/12/2018.
//  Copyright © 2018 Selfin. All rights reserved.
//

import UIKit

enum postType : String {
    case location
    case hashtags
    case post  = "Post"
}

protocol UsersPostViewControllerDelegate : class {
    func didMoveToDetail(id:Int)
}

class UsersPostViewController: UIViewController {
    @IBOutlet var collectionView: UsersPostCollectionView!
    let viewModel = UsersPostViewModel()
    var type : postType = .post
    var typeText = String()

    weak var delegate:UsersPostViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        if #available(iOS 11.0, *) {
            navigationController?.navigationBar.prefersLargeTitles = true
        } else { // Fallback on earlier versions
        }

        switch type {
        case .hashtags:  navigationItem.title = typeText
        case .location:
            if #available(iOS 11, *){
                self.navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.font: UIFont(name: "HelveticaNeue-Bold", size: 24)!]
            }
            navigationItem.title = typeText
        case .post: navigationItem.title = type.rawValue
        }
    }
    
    fileprivate func setup() {
        backButton()
        collectionView.didSelect = didSelectPost
        collectionView.controller = self
        viewModel.delegate = self

        switch type {
        case .hashtags: viewModel.fetchHashtags(string: typeText, page: 1)
        case .location: viewModel.fetchLocations(string: typeText, page: 1)
        case .post: viewModel.fetchPost(string: typeText, page: 1)
        }
    }
    
    func didSelectPost(id : Int){delegate?.didMoveToDetail(id: id)}
}

extension UsersPostViewController : UsersPostViewModelDelegate, UsersPostCollectionViewDelegate {
    func fetchFeeds(page: Int) {
        switch type {
        case .hashtags:
            viewModel.fetchHashtags(string: typeText, page: page)
        case .location:
            viewModel.fetchLocations(string: typeText, page: page)
        case .post:
            viewModel.fetchPost(string: typeText, page: page)
        }
    }
    
    func didReceived(items: [SelfFeed.Post])
    {collectionView.display(feeds: items)}
    
    func didReceived(error: String) {print(error)}
}

