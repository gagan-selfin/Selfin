//
//  DiscoverViewController.swift
//  Selfin
//
//  Created by Marlon Monroy on 6/30/18.
//  Copyright © 2018 Selfin. All rights reserved.
//

import UIKit

class DiscoverViewController: UIViewController {
	let viewModel = DiscoverViewModel()
	var delegate: DiscoverViewControllerDelegate?
	@IBOutlet var collectionView: DiscoverCollectionView!
	
	lazy var refreshControl: UIRefreshControl = {
		let refreshControl = UIRefreshControl()
		refreshControl.tintColor = .white
		refreshControl.addTarget(self, action:
			#selector(handleRefresh(_:)),
										 for: .valueChanged)
		return refreshControl
	}()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		setup()}
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        if #available(iOS 11.0, *) {
            navigationController?.navigationBar.prefersLargeTitles = true
        } else {// Fallback on earlier versions
        }
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        view.layoutIfNeeded()
        switch UIDevice.current.orientation  {
        case .portraitUpsideDown, .portrait:
            self.navigationController?.isNavigationBarHidden = false
        case .landscapeRight, .landscapeLeft:
            self.navigationController?.isNavigationBarHidden = true
        default: break
        }
        collectionView.updateLayout(for: UIDevice.current.orientation)
    }
	
	// MARK: -
	// MARK: - Custom Methods
	func setup() {
        viewModel.delegate = self
        tabBarItem.selectedImage = #imageLiteral(resourceName: "discoverSelected").withRenderingMode(.alwaysOriginal)
        collectionView.didSelect = didSelect
        collectionView.controller = self
		viewModel.fetchDiscover(page: 1)
		collectionView.addSubview(refreshControl)
	}
	
	@objc func handleRefresh(_ refreshControl: UIRefreshControl) {
        collectionView.prepareForRefresh()
        viewModel.fetchDiscover(page: 1)
		refreshControl.endRefreshing()
	}
	
	func didSelect(id: Int) {
		if isPortraitMode(){
            delegate?.discoverControllerActions(action: .showPostDetail(id:id))
        }
	}
	
	@IBAction func btnSearchPressed(_: Any) {
		delegate?.discoverControllerActions(action: .showSearch)
	}
}

extension DiscoverViewController:DiscoverDelegate, DiscoverViewCollectionDelegate {
	func didReceived(items: [DiscoverResponse.Post]) {
        collectionView.displayItems(items)
	}
    
	func didReceived(error: String) {showAlert(str: error)}
    
    func didFetchMoreData(page : Int) {
       viewModel.fetchDiscover(page: page)
    }
}
