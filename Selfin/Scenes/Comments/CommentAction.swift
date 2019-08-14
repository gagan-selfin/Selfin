//
//  CommentAction.swift
//  Selfin
//
//  Created by cis on 29/11/18.
//  Copyright © 2018 Selfin. All rights reserved.
//

import Foundation

protocol CommentViewDelegate : class {
    func didReceived(commentList:PostCommentsResponse)
    func didReceived(comment:PostCommentResponse)
    func didReceived(erorr msg:String)
    func didReceived(like:ReusableResponse)
}

extension CommentViewDelegate {
    func didReceived(commentList:PostCommentsResponse){}
    func didReceived(comment:PostCommentResponse){}
    func didReceived(erorr msg:String){}
    func didReceived(like:PostLikeResponse){}
}

protocol CommentTableDelegate: class {func setData (page:Int)}

enum likeAction : String {
    case like
    case superlike = "super_like"
    case dislike
}

enum likeActionResponse : String {
    case liked = "Liked."
    case superliked = "SuperLiked."
    case disliked = "Disliked."
}


protocol CommentsDelegate: class {
    func showProfile(username:String)
}

protocol CommentsCoordinatorDelegate: class {
    func showProfile(username:String)
}
