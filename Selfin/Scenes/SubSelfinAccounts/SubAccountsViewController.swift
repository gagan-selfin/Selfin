//
//  SubAccountsViewController.swift
//  Selfin
//
//  Created by cis on 21/02/2019.
//  Copyright © 2019 Selfin. All rights reserved.
//

import UIKit

class SubAccountsViewController: UIViewController {
    @IBOutlet var collectionview: SubAccountCollectionView!
    let viewModel = SubAccountsViewModel()
    weak var delegate : SubAccountsCoordinatorDelegate?
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action:
            #selector(handleRefresh(_:)),
                                 for: .valueChanged)
        return refreshControl
    }()
    var refreshSubAccount:(()->())?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    fileprivate func setup() {
        collectionview.addSubview(refreshControl)
        collectionview.didSelect = didSelect
        collectionview.controller = self
        viewModel.delegate = self
        tabBarItem.selectedImage = #imageLiteral(resourceName: "feedSelected").withRenderingMode(.alwaysOriginal)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.hidesBarsOnSwipe = true
        if #available(iOS 11.0, *) {
            navigationController?.navigationItem.largeTitleDisplayMode = .always
            navigationController?.navigationBar.prefersLargeTitles = true
        } else {// Fallback on earlier versions
        }
        viewModel.listOfSubSelfinAccounts()
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator){
        super.viewWillTransition(to: size, with: coordinator)
        manageOrientation()
    }
    
    func didSelect(user : String){
        delegate?.didMoveToProfleDetails(username: user)
    }
    
    func manageOrientation() {
        handleRotation(orientation: UIDevice.current.orientation)
        view.layoutIfNeeded()
        switch UIDevice.current.orientation  {
        case .portraitUpsideDown, .portrait:
            self.navigationController?.isNavigationBarHidden = false
            navigationController?.hidesBarsOnSwipe = true
        case .landscapeRight, .landscapeLeft:
            self.navigationController?.isNavigationBarHidden = true
            navigationController?.hidesBarsOnSwipe = false
        default: break
        }
    }
    
    @objc func handleRefresh(_ refreshControl: UIRefreshControl) {
        Timer.scheduledTimer(withTimeInterval: 1, repeats: false) {[weak self] _ in
            self?.refreshControl.endRefreshing()
            self?.refreshSubAccount?()
        }
    }
}

extension SubAccountsViewController : SubAccountsResponseDelegate, HorizontalDisplayable {
    func didReceive(response data: SubAccountsAPIResponse) {
        switch data {
        case .accounts(data: let data):
            collectionview.display(data: data)
        case .followAll(data: let data):
            hideLoader()
            showAlert(str: data.message) {
                self.showLoader()
            self.refreshSubAccount?()
            }
        case .follow(data: _, username: let username):
             collectionview.updateUI(username:username)
        case .error(message: let message):
            showAlert(str: message)
        }
    }
}

extension SubAccountsViewController : didFollowAccounts {
    func didFollowAllSubAccounts(){showLoader();viewModel.followAllSubAccounts()}
    func didFollowSubAccount(username : String){viewModel.followSubAccount(username: username)}
}
