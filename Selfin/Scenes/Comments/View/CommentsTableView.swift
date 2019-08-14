//
//  CommentsTableView.swift
//  Selfin
//
//  Created by cis on 29/11/18.
//  Copyright © 2018 Selfin. All rights reserved.
//

import UIKit

class CommentsTableView: UITableView, UITableViewDelegate, UITableViewDataSource
{
    var postId = Int()
    var controller:CommentTableDelegate?
    var commentList :[PostCommentsResponse.Comment] = []
    var page = 1
    var hasMore = true
    var viewModel = CommentsViewModel ()
    weak var delegateAction :CommentsDelegate?


    override func awakeFromNib() {
        super.awakeFromNib()
        delegate = self
        dataSource = self
        tableFooterView = UIView()
        viewModel.controller = self
        estimatedRowHeight = 100
        rowHeight = UITableView.automaticDimension
    }
    
    //MARK:-
    //MARK:- Tableview Datasource
    
    func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int
    {return commentList.count}
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {return cell(for: indexPath)}
    
    //MARK:-
    //MARK:- Tableview Delegate
    
    func tableView(_: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        handlePagination(controller: controller, indexPath: indexPath)
        
        if indexPath.row == 0 {
            if indexPath.row == commentList.count - 1 {
                cell.round(corners: [.topLeft, .topRight, .bottomLeft, .bottomRight], withRadius: 10)
            }else {
                cell.round(corners: [.topLeft, .topRight], withRadius: 10)
            }}
        else if indexPath.row == commentList.count - 1 {cell.round(corners: [.bottomLeft, .bottomRight], withRadius: 10)}
        else {cell.round(corners: [.bottomLeft, .bottomRight], withRadius: 0)}
    }
    
    //MARK:-
    //MARK:- Custom Methods

    func onActionCellSelected(id _: Int) {}
    
    func cell (for index:IndexPath) -> UITableViewCell {
        let cell = dequeueReusableCell(withIdentifier: "CommentsTableViewCell", for: index) as! CommentsTableViewCell
        
        cell.configure(with: commentList[index.row])
        cell.actionLikePressed = onActionCellSelected
        
        cell.btnUserImage.tag = index.row
        
        cell.btnUserImage.addTarget(self, action: #selector(btnUserImagePressed(sender:)), for: .touchUpInside)
        
        let singleTapGesture = UITapGestureRecognizer(target: self, action: #selector(performLikeDislikeOperation(gestureRecongnizer:)))
        singleTapGesture.numberOfTapsRequired = 1
        cell.addGestureRecognizer(singleTapGesture)
        
        let longGesture = UILongPressGestureRecognizer(target: self, action: #selector(performSuperlikeDislikeOperation(gestureRecongnizer:)))
        cell.addGestureRecognizer(longGesture)

        singleTapGesture.delaysTouchesBegan = true
        
        return cell
    }
    
    @objc func btnUserImagePressed(sender: UIButton){
        delegateAction?.showProfile(username: commentList[sender.tag].user.username)
    }

    func display(comments: [PostCommentsResponse.Comment]) {
        hasMore = comments.count > 0
        if page == 1 {commentList.removeAll()}
        commentList.append(contentsOf: comments)
        reloadData()
    }
    
    func displayAdded(comment : PostCommentResponse) {
        commentList.append(comment.comment)
        reloadData()
        scrollToRow(at: IndexPath(row: commentList.count - 1, section: 0), at: .bottom, animated: true)
    }
    
    @objc func performLikeDislikeOperation(gestureRecongnizer: UITapGestureRecognizer) {
        let tappedPoint = gestureRecongnizer.location(in: self)
        let tappedIndexpath = indexPathForRow(at: tappedPoint)
        if let indexpath = tappedIndexpath {
        let action : String!
        let cell = cellForRow(at: indexpath) as! CommentsTableViewCell
        
        if cell.imageViewLike.image == #imageLiteral(resourceName: "likelite") {action = likeAction.dislike.rawValue}
        else if cell.imageViewLike.image == #imageLiteral(resourceName: "likeSelected") {action = likeAction.dislike.rawValue}
        else {action = likeAction.like.rawValue}
        
        viewModel.performLikeOverComment(postId: postId, commentId: commentList[(tappedIndexpath?.row)!].id, action: action)
        isSuccess = {data in
            if data.status {
                if data.message == likeActionResponse.liked.rawValue{
                    cell.imageViewLike.image = #imageLiteral(resourceName: "likelite")
                    self.commentList[(tappedIndexpath?.row)!].isLiked = true
                    self.commentList[(tappedIndexpath?.row)!].isSuperLiked = false
                }
                else{
                    cell.imageViewLike.image = #imageLiteral(resourceName: "likeCount")
                    self.commentList[(tappedIndexpath?.row)!].isLiked = false
                    self.commentList[(tappedIndexpath?.row)!].isSuperLiked = false
                }
            }
        }}
    }
    
    var isSuccess: ((ReusableResponse) -> Void)?
    func getLikeData(likeData:ReusableResponse){isSuccess!(likeData)}
    
    func handlePagination(controller : CommentTableDelegate?, indexPath : IndexPath)
    {
        if indexPath.row == commentList.count - 1 && hasMore {
            page += 1
            controller?.setData(page: page)}
    }

    @objc func performSuperlikeDislikeOperation(gestureRecongnizer: UILongPressGestureRecognizer) {
        
        if gestureRecongnizer.state == UIGestureRecognizer.State.ended {
            let tappedPoint = gestureRecongnizer.location(in: self)
            let tappedIndexpath = indexPathForRow(at: tappedPoint)
            let cell = cellForRow(at: tappedIndexpath!) as! CommentsTableViewCell
            let action : String!
            if cell.imageViewLike.image == #imageLiteral(resourceName: "likeSelected") {action = likeAction.dislike.rawValue}
            else {action = likeAction.superlike.rawValue}
            
            viewModel.performLikeOverComment(postId: postId, commentId: commentList[(tappedIndexpath?.row)!].id, action: action)
            isSuccess = {data in
                if data.status {
                    if data.message == likeActionResponse.superliked.rawValue{
                        cell.imageViewLike.image = #imageLiteral(resourceName: "likeSelected")
                        self.commentList[(tappedIndexpath?.row)!].isSuperLiked = true
                        self.commentList[(tappedIndexpath?.row)!].isLiked = false
                    }
                    else{
                        cell.imageViewLike.image = #imageLiteral(resourceName: "likeCount")
                        self.commentList[(tappedIndexpath?.row)!].isLiked = false
                        self.commentList[(tappedIndexpath?.row)!].isSuperLiked = false
                    }
                }
            }
        }
    }
}

extension CommentsTableView:CommentViewDelegate {
    
    func didReceived(like:ReusableResponse) {
        getLikeData(likeData: like)}
    
    func didReceived(erorr msg: String) {}
}
