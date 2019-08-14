//
//  UserTask.swift
//  Selfin
//
//  Created by Marlon Monroy on 6/30/18.
//  Copyright © 2018 Selfin. All rights reserved.
//

import Foundation
import PromiseKit

enum UserRequest: RequestRepresentable {
	case profile()
    case otherProfile(username: String)
    case posts(username: String, page:Int)
    case taggedPosts(username: String, page:Int)
    case likedPosts(username: String, page:Int)
	case accept(params: UserTaskParams.AcceptDenyFollowRequest)
	case deny(params: UserTaskParams.AcceptDenyFollowRequest)
	case followingFollowers(username: String, listType: UserRequestURL.List, search:String,page:Int)
    case followUnfollowUser(param : UserTaskParams.FollowUnfollowRequest)
    case scheduledPosts(page:Int)
    case editScheduledPost(UserTaskParams.EditScheduledPost, id:Int)
    case shareNow(UserTaskParams.EditScheduleTime, id:Int)
    case deleteScheduledPost(id:Int)
    case retriveScheduledPost(id:Int)
    case accountSettings(username: String)
    case updateAccountSettings(param:UserTaskParams.accountSettings,username: String)
    case notificationSettings(username: String)
    case updateNotificationSettings(param:UserTaskParams.notificationSettings,username: String)
    case blockUnblock(param:UserTaskParams.FollowUnfollowRequest)
    case turnOnOffNotification(param:UserTaskParams.FollowUnfollowRequest)
    case blockedUserList(page:Int)
}

extension UserRequest {
	var parameters: Parameters {
		switch self {
		case let .accept(params), let .deny(params):
			return .body(data: encodeBody(data: params))
        case let .followUnfollowUser(params):
            return .body(data: encodeBody(data: params))
        case let .editScheduledPost(param,_):
            return .body(data: encodeBody(data: param))
        case let .blockUnblock(param):
            return .body(data: encodeBody(data: param))
        case let .turnOnOffNotification(param):
            return .body(data: encodeBody(data: param))
        case let .updateNotificationSettings(param, _):
            return .body(data: encodeBody(data: param))
        case let .updateAccountSettings(param, _):
            return .body(data: encodeBody(data: param))
        case let .shareNow(param,_):
                return .body(data: encodeBody(data: param))
		default: return .none
		}
	}
    
	var endpoint: String {
		switch self {
        case .profile:
			return UserRequestURL.profile()
            
		case let .posts(username,page):
            return UserRequestURL.posts(username: username, page: page)
			
		case let .taggedPosts(username,page):
            return UserRequestURL.taggedPosts(username: username, page:page)
			
		case let .likedPosts(username,page):
            return UserRequestURL.likedPost(username: username, page: page)
			
        case .accept(_):
			return UserRequestURL.accept()
			
        case .deny(_):
            return UserRequestURL.deny()
            
        case let .followingFollowers(username, listType, search, page):
            return UserRequestURL.followingFollowers(username: username, list: listType, search: search, page: page)
            
        case .followUnfollowUser(_):
            return UserRequestURL.FollowUnfollow()
        
        case .otherProfile(let username):
            return UserRequestURL.othersProfile(username: username)
            
        case let .scheduledPosts(page: page):
            return UserRequestURL.scheduledPost(page: page)
            
        case let .deleteScheduledPost(id):
             return UserRequestURL.deleteSchedulePost(id: id)
            
        case let .retriveScheduledPost(id):
             return UserRequestURL.retriveSchedulePost(id: id)
            
        case let .editScheduledPost(_, id):
             return UserRequestURL.editSchedulePost(id: id)
            
        case let .updateNotificationSettings(_, username):
            return UserRequestURL.notificationSettings(username: username)
            
        case let .notificationSettings(username):
            return UserRequestURL.notificationSettings(username: username)
            
        case let .updateAccountSettings(_,username):
            return UserRequestURL.accoutSettings(username: username)
            
        case let .accountSettings(username):
            return UserRequestURL.accoutSettings(username: username)
            
        case .blockUnblock(_):
             return UserRequestURL.blockUnblock()
            
        case .turnOnOffNotification(_):
            return UserRequestURL.turnOnOffNotifications()
        case let .shareNow(_, id):
            return UserRequestURL.shareNow(id: id)
        case .blockedUserList(let page):
            return UserRequestURL.blockedUserList(page : page)
        }
	}
    
    var method: HTTPMethod {
        switch self {
        case .turnOnOffNotification(param: _), .blockUnblock:
            return .post
        case .editScheduledPost,.updateAccountSettings, .updateNotificationSettings, .shareNow:
            return .put
        case .deleteScheduledPost:
            return .delete
     case .accountSettings, .notificationSettings, .profile(), .scheduledPosts, .posts, .likedPosts, .taggedPosts, .followingFollowers, .otherProfile, .blockedUserList:
            return .get
        default:
            return .post
        }
    }
}

final class UserTask {
	let dispatcher: SessionDispatcher
	let username: String
	
	enum RespodingFollowRequest {
		case deny
		case accept
	}
	
	init(username: String, dispatcher: SessionDispatcher = SessionDispatcher()) {
		self.username = username
		self.dispatcher = dispatcher
	}
	
	func profile() -> Promise<ProfileResponse> {
		return dispatcher.execute(requst: UserRequest.profile(), modeling: ProfileResponse.self)
	}
    
    func otherProfile(username:String)  -> Promise<OthersProfileResponse> {
        return dispatcher.execute(requst: UserRequest.otherProfile(username: username), modeling: OthersProfileResponse.self)
    }
	
    func posts(page:Int, userName : String) -> Promise<SelfFeed> {
        return dispatcher.execute(requst: UserRequest.posts(username: userName, page: page), modeling: SelfFeed.self)
	}
	
    func taggedPosts(page:Int) -> Promise<TaggedLikedPostResponse> {
        return dispatcher.execute(requst: UserRequest.taggedPosts(username: username, page: page), modeling: TaggedLikedPostResponse.self)
	}
	
	func likedPosts(page:Int) -> Promise<TaggedLikedPostResponse> {
        return dispatcher.execute(requst: UserRequest.likedPosts(username: username, page: page), modeling: TaggedLikedPostResponse.self)
	}
	
    func followersFollowing(listType: UserRequestURL.List, search:String, page:Int) -> Promise<FollowingFollowersResponse> {
        return dispatcher.execute(requst: UserRequest.followingFollowers(username: username, listType: listType, search: search, page: page), modeling: FollowingFollowersResponse.self)
	}
	
	func declineFollowRequest(with params: UserTaskParams.AcceptDenyFollowRequest) -> Promise<ReusableResponse> {
			return dispatcher.execute(requst: UserRequest.deny(params: params), modeling: ReusableResponse.self)
    }
    
    func acceptFollowRequest(with params: UserTaskParams.AcceptDenyFollowRequest) -> Promise<AcceptResquestResponse> {
           return dispatcher.execute(requst: UserRequest.accept(params: params), modeling: AcceptResquestResponse.self)
    }
    
    func followUnfollow(with param:UserTaskParams.FollowUnfollowRequest) -> Promise<followUnfollowUser> {
        return dispatcher.execute(requst: UserRequest.followUnfollowUser(param: param), modeling: followUnfollowUser.self)
    }
    
    func scheduledPost(page:Int) -> Promise<scheduledPostResponse>  {
        return dispatcher.execute(requst: UserRequest.scheduledPosts(page: page), modeling: scheduledPostResponse.self)
    }
    
    func shareNow(with param:UserTaskParams.EditScheduleTime, id:Int) -> Promise<ReusableResponse> {
        return dispatcher.execute(requst: UserRequest.shareNow(param, id: id), modeling: ReusableResponse.self)
    }
    
    
    func editScheduledPost(param:UserTaskParams.EditScheduledPost,id:Int) -> Promise<ReusableResponse> {
        return dispatcher.execute(requst: UserRequest.editScheduledPost(param, id: id), modeling:ReusableResponse.self )
    }
    
    func deleteScheduledPost(id:Int) -> Promise<ReusableResponse> {
        return dispatcher.execute(requst: UserRequest.deleteScheduledPost(id: id), modeling: ReusableResponse.self)
    }
    
    //**Seems not of use till date...
//    func retriveScheduledPost(id:Int) -> Promise<> {
//        return dispatcher.execute(requst: UserRequest.retriveScheduledPost(id: id), modeling: )
//    }
    
    func getAccoutSettings() -> Promise<accountSettings>  {
        return dispatcher.execute(requst: UserRequest.accountSettings(username: username), modeling: accountSettings.self)
    }
    
    func updateAccountSettings(param: UserTaskParams.accountSettings) -> Promise<accountSettings> {
        return dispatcher.execute(requst: UserRequest.updateAccountSettings(param:param , username: UserStore.user?.userName ?? ""), modeling: accountSettings.self)
    }
    
    func getNotificationSettings() -> Promise<NotificationSettings> {
        return dispatcher.execute(requst: UserRequest.notificationSettings(username: username), modeling: NotificationSettings.self)
    }
    
    func updateNotificationSettings(param:UserTaskParams.notificationSettings) -> Promise<NotificationSettings> {
        return dispatcher.execute(requst: UserRequest.updateNotificationSettings(param: param, username: UserStore.user?.userName ?? ""), modeling: NotificationSettings.self)
    }
    
    func blockUnblockUser(param:UserTaskParams.FollowUnfollowRequest) -> Promise<ReusableResponse> {
        return dispatcher.execute(requst: UserRequest.blockUnblock(param: param), modeling: ReusableResponse.self)
    }
    
    func TurnOnOffNotifications(param:UserTaskParams.FollowUnfollowRequest) -> Promise<ReusableResponse> {
        return dispatcher.execute(requst: UserRequest.turnOnOffNotification(param: param), modeling: ReusableResponse.self)
    }
    
    func showBlockUsers(page : Int) -> Promise<BlockList> {
        return dispatcher.execute(requst: UserRequest.blockedUserList(page: page), modeling: BlockList.self)
    }
}
