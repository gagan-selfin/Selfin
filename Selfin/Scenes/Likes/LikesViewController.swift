//
//  LikesViewController.swift
//  Selfin
//
//  Created by cis on 21/09/2018.
//  Copyright © 2018 Selfin. All rights reserved.
//

import UIKit

class LikesViewController: UIViewController {
    @IBOutlet var tableViewLikes: LikesListTableView!
    @IBOutlet weak var lblLikes: UINavigationItem!
    @IBOutlet var headerView: UIView!
    @IBOutlet var labelTotalLikeCount: UILabel!
    @IBOutlet var labelTotalSuperLikeCount: UILabel!
    
    weak var delegateCoordinate: LikesCoordinatorDelegate?
    weak var delegate: LikesViewControllerDelegate?
    let viewModel = LikesViewModel()
    var postId = Int()

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        backButton()
    }

    // MARK:- Custom Methods
    
    func setup() {
        tableViewLikes.delegateAction = self
        viewModel.controller = self
        if #available(iOS 11.0, *)
        {navigationController?.navigationBar.prefersLargeTitles = true}
        else {/* Fallback on earlier versions*/}

        tableViewLikes.tableHeaderView = headerView
        viewModel.fetchPostLikes(id: postId, page: 1)
    }
    
    func getLikeList (list: PostLikedUsersResponse) {
        self.lblLikes.title = "\(list.user.count) Likes"
        self.labelTotalLikeCount.text = "\(list.likeCount)"
        self.labelTotalSuperLikeCount.text = "\(list.superLikeCount)"
        
        tableViewLikes.display(likes: list.user)
    }
}

extension LikesViewController:LikeViewDelegate, LikeTableDelegate, LikesDelegate {
    func showProfile(username: String)
    {delegateCoordinate?.showProfile(username: username)}
   
    func setData(page: Int){}
    
    func didReceived(data: PostLikedUsersResponse) {getLikeList(list: data)}
    
    func didReceived(error msg: String) {}
}
