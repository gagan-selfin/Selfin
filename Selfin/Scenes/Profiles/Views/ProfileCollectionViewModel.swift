//
//  ProfileCollectionViewModel.swift
//  Selfin
//
//  Created by cis on 29/11/2018.
//  Copyright © 2018 Selfin. All rights reserved.
//

import Foundation
import UIKit

protocol ProfileCollection: class {
    func didReceived(feed: PostLikeResponse)
    func didReceived(error msg: String)
}

final class ProfileCollectionViewModel {
    var posts: [HomeFeed.Post] = []
    var page = 1
    var mentionedPost : [TaggedLikedPostResponse.Post] = []
    var likedPost : [TaggedLikedPostResponse.Post] = []
    var pageMention = 1
    var pageLike = 1
    var hasMore = true
    var hasMoreMention = true
    var hasMoreLikes = true
    var isFetched = false
    
    let task = PostTask ()
    weak var collection:ProfileCollection?
    func like (postId:Int,action:likeAction) {
        task.like(id: postId, params: PostTaskParams.Like(action:action.rawValue))
            .done{self.collection?.didReceived(feed: $0)}
            .catch{self.collection?.didReceived(error: String(describing: $0))}
    }
    
    let userTask = UserTask(username: "")
    weak var followDelegate:followUnfollowDelegate?
    func performFollowUnFollowUserAPI(username: String) {
        userTask.followUnfollow(with: UserTaskParams.FollowUnfollowRequest(username:username))
            .done {
                self.followDelegate?.didReceived(data: $0)
            }
            .catch {
                self.followDelegate?.didReceived(error: String(describing: $0.localizedDescription))
        }
    }
    
    func refreshData(currentStyle :UserProfileCollectionStyle, collectionView : UICollectionView, controller : UserFeedCollectionDelegate?) {
        page = 1
        posts.removeAll()
        switch currentStyle {//****Get auto update with user profile details wherever refresh
            
        //case .grid, .list:
//            page = 1
//            posts.removeAll()
            //hasMore = true;  collectionView.reloadData() ;
            //controller?.userProfileCollectionActions(action: .fetchMore(page: page))
        case .mention:
            pageMention = 1
            mentionedPost.removeAll()
            hasMoreMention = true ;  collectionView.reloadData()
            controller?.fetchUsersData(.mention, page: pageMention)
        case .heart:
            pageLike = 1
            likedPost.removeAll()
            hasMoreLikes = true ;  collectionView.reloadData()
            controller?.fetchUsersData(.heart, page: pageLike)
        default:
            break
        }
    }
    
    func handlePagination(currentStyle :UserProfileCollectionStyle, indexPath : IndexPath, controller : UserFeedCollectionDelegate?) {
        switch currentStyle {
        case .grid,.list:
            if indexPath.row ==  posts.count - 2 && hasMore {
                page += 1; controller?.userProfileCollectionActions(action: .fetchMore(page: page))}
        case .mention:
            if indexPath.row == mentionedPost.count - 2 && hasMoreMention {
                pageMention += 1
                controller?.fetchUsersData(.mention, page: pageMention)}
        case .heart:
            if indexPath.row == likedPost.count - 2 && hasMoreLikes {
                pageLike += 1
                controller?.fetchUsersData(.heart, page: pageLike)}
        default:
            break
        }
    }
    
    func setBaseLayout(style :UserProfileCollectionStyle, controller : UserFeedCollectionDelegate?){
        switch style {
        case .mention:
            if mentionedPost.count == 0 {
                controller?.fetchUsersData(.mention, page: pageMention );  return }
        case .heart:
            if pageLike == 1 {
                controller?.fetchUsersData(.heart, page: pageLike ) ; return }
        default:
            break
        }
    }
    
    func didSelectPost(currentStyle:UserProfileCollectionStyle, indexPath : IndexPath,controller : UserFeedCollectionDelegate?){
        switch currentStyle {
        case .list,.grid:
            if posts.count > 0 {
                controller?.userProfileCollectionActions(action: .postSelected(post: posts[indexPath.item]))}
        case .heart:
             if likedPost.count > 0 {
                controller?.userProfileCollectionActions(action: .mentionLikesSelected(post: likedPost[indexPath.item]))}
        case .mention:
             if mentionedPost.count > 0 {
                controller?.userProfileCollectionActions(action: .mentionLikesSelected(post: mentionedPost[indexPath.item]))}
        default:
            break
        }
    }
    
    func countForUsersPost (collectionView : UICollectionView, headerView : ReusableProfileHeaderView?) -> Int {
        if  isFetched { //API get called but no data found, show message
            if posts.count == 0 {
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {collectionView.setEmptyMessage(initialMassege.noPost.rawValue, image: UIImage.init(named: "private_Grid")!, headerViewHeight: headerView?.bounds.height ?? 320)
                }
            }else {collectionView.restore()}//if data found, remove message
            return posts.count > 0 ? posts.count : 0
        }else {//remove message and load data
            collectionView.restore()
            return posts.count > 0 ? posts.count : 10
        }
    }
    
    func countForTaggedPosts(collectionView : UICollectionView, headerView : ReusableProfileHeaderView?) -> Int {
        if  isFetched {
            if mentionedPost.count == 0 {
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0){collectionView.setEmptyMessage(initialMassege.noTaggedPost.rawValue, image: UIImage.init(named: "private_Mention")!, headerViewHeight: headerView?.bounds.height ?? 320)}
            }else {collectionView.restore()}
            return mentionedPost.count > 0 ? mentionedPost.count : 0
        }else {
            collectionView.restore()
            return mentionedPost.count > 0 ? mentionedPost.count : 10
        }
    }
    
    func countForUsersLikedPosts(collectionView : UICollectionView, headerView : ReusableProfileHeaderView?) -> Int {
        if  isFetched {
            if likedPost.count == 0 {
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0){collectionView.setEmptyMessage(initialMassege.noLikedPost.rawValue, image: UIImage.init(named: "private_Heart")!, headerViewHeight: headerView?.bounds.height ?? 320)}
            }else {collectionView.restore()}
            return likedPost.count > 0 ? likedPost.count : 0
        }else {
            collectionView.restore()
            return likedPost.count > 0 ? likedPost.count : 10
        }
    }
    
    func actionOverUserProfileDetails(action : ProfileAction ,controller : UserFeedCollectionDelegate?, username : String)  {
        if action == .showFollowers { controller?.userProfileCollectionActions(action: .profileAction(action: .showFollowers, username: username))
        } else if action == .showFollowing { controller?.userProfileCollectionActions(action: .profileAction(action: .showFollowing, username: username))
        }else  if action == .showPost {
            controller?.userProfileCollectionActions(action: .profileAction(action: .showPost, username: username))
        }
    }

}
