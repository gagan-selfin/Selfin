//
//  ChatListViewController.swift
//  Selfin
//
//  Created by cis on 24/09/18.
//  Copyright © 2018 Selfin. All rights reserved.
//

import UIKit

class ChatListViewController: UIViewController {
    @IBOutlet var collectionView: ChatListCollectionView!
    let viewModel = ChatListViewModel()
    weak var delegate: MoveToChatDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        backButton()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        navigationController?.hidesBarsOnSwipe = false
        if #available(iOS 11.0, *) {
        navigationController?.navigationBar.prefersLargeTitles = true
        } else {// Fallback on earlier versions
        }
    }
    
    fileprivate func setup() {
        viewModel.delegate = self
        collectionView.controller = self
        collectionView.keyboardDismissMode = .onDrag
        collectionView.controllerChatList = self
        fetchRecentchat()
    }

    func fetchRecentchat() {
         self.collectionView.clearOldData()
         self.viewModel.function_LoadData()
    }
}

extension ChatListViewController : SearchCollectionDelegate, ChatListDelegate, chatListTableViewDelegate {
   
    func didSelectfromSearch(user: FollowingFollowersResponse.User) {delegate?.didMoveUsersChat(user: viewModel.createChatUser(user: user as FollowingFollowersResponse.User))}
    
    func didSelect(user: HSChatUsers){delegate?.didMoveUsersChat(user: user)}
    
    func didMoveToProfile(username : String){delegate?.didMoveToUserProfile(username: username)}
    
    func didViewUserProfile(username: String) {}
    
    func fetchData(type: SearchRequestURL.searchStyle, strSearch: String, page: Int) {
        viewModel.performSearchUser(strSearch: strSearch, page: page)
    }
    
    func didReceivedResult(result: FollowingFollowersResponse) {
        collectionView.display(search: result)
    }
    
    func didReceivedChatUser(result: HSChatUsers) {
        print(result)
        collectionView.display(user: result)
    }
    
    func didReceived(error msg: String) {//TODO
    }
}
