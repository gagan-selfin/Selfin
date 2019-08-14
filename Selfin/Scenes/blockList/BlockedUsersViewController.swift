//
//  BlockedUsersViewController.swift
//  Selfin
//
//  Created by cis on 04/02/2019.
//  Copyright © 2019 Selfin. All rights reserved.
//

import UIKit

class BlockedUsersViewController: UIViewController {
    @IBOutlet var collectionview: BlockedUsersCollectionView!
    let viewModel = BlockedUsersViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if #available(iOS 11.0, *){navigationController?.navigationBar.prefersLargeTitles = true}
        else {/* Fallback on earlier versions*/}
    }
    
    fileprivate func setup() {
        collectionview.controller = self
        viewModel.fetchBlockedUsersList(page:1)
        viewModel.controller = self
        backButton()
    }
}

extension BlockedUsersViewController : BlockedUsersViewModelDelegate, BlockedUsersCollectionViewDelegate {
    func didUnblockUser(username: String, index: Int) {
        showAlert(str: "Are you sure want to Un-block this user?") {
            self.viewModel.blockUnblock(username: username, index : index)
        }
    }
    
    func didReceived(unblock: ReusableResponse, index : Int) {
        collectionview.displayUnblockResult(index: index)
    }

    func didReceived(data:[BlockList.User]) {
        collectionview.display(users: data)}
    
    func didReceived(error msg:String) {showAlert(str: msg)}
    
    func fetchMore(page : Int){
        viewModel.fetchBlockedUsersList(page : page)
    }
}
