//
//  CommentsViewModel.swift
//  Selfin
//
//  Created by cis on 18/09/2018.
//  Copyright © 2018 Selfin. All rights reserved.
//

import Foundation

final class CommentsViewModel {
    let postComment = PostTask()
    weak var controller:CommentViewDelegate?

    func fetchPostComments(id: Int, pageNumber: Int) {
        postComment.comments(id: id, page: pageNumber)
        .done {self.controller?.didReceived(commentList: $0)}
        .catch {self.controller?.didReceived(erorr: String(describing: $0))}
    }

    func postComment(postId: Int, comment: String) {
        postComment.comment(id: postId, params: PostTaskParams.Comment(content : comment))
        .done {self.controller?.didReceived(comment: $0)}
        .catch {self.controller?.didReceived(erorr: String(describing: $0))}
    }
    
    func performLikeOverComment(postId:Int,commentId:Int, action: String) {
        postComment.likeComment(id:postId, commentId:commentId, params:PostTaskParams.Like(action:action))
        .done {self.controller?.didReceived(like: $0)}
        .catch {self.controller?.didReceived(erorr: String(describing: $0))}
    }
}
