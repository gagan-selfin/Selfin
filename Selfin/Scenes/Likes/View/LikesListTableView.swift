//
//  LikesListTableView.swift
//  Selfin
//
//  Created by cis on 29/11/18.
//  Copyright © 2018 Selfin. All rights reserved.
//

import UIKit

class LikesListTableView: UITableView, UITableViewDelegate, UITableViewDataSource
{
    var controller:LikeTableDelegate?
    var likeList :[PostLikedUsersResponse.Liked] = []
    var page = 1
    var hasMore = true
    weak var delegateAction:LikesDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
        delegate = self
        dataSource = self
        tableFooterView = UIView()
    }
    
    //MARK:-
    //MARK:- TableView Datasource
    
    func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int
    {return likeList.count}
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {return cell(for: indexPath)}
    
    //MARK:-
    //MARK:- TableView Delegate

    func tableView(_: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath)
    {handlePagination(controller: controller, indexPath: indexPath)}
    
    //MARK:-
    //MARK:- Custom Methods
    func cell (for index:IndexPath) -> UITableViewCell {
        let cell = dequeueReusableCell(withIdentifier: "LikesTableViewCell", for: index) as! LikesTableViewCell
        
        cell.btnUserImage.tag = index.row
        cell.btnUserImage.addTarget(self, action: #selector(btnUserImagePressed(sender:)), for: .touchUpInside)

        cell.configure(with: likeList[index.row])
        return cell
    }
    
    func display(likes: [PostLikedUsersResponse.Liked]) {
        hasMore = likes.count > 0
        if page == 1 {likeList.removeAll()}
        likeList.append(contentsOf: likes)
        reloadData()
    }
    
    func handlePagination(controller : LikeTableDelegate?, indexPath : IndexPath){
        if indexPath.row == likeList.count - 1 && hasMore {
            page += 1
            controller?.setData(page: page)}
    }
    
    @objc func btnUserImagePressed(sender: UIButton){
        delegateAction?.showProfile(username: likeList[sender.tag].user.username)
    }
}
