//
//  PostActionTask.swift
//  Selfin
//
//  Created by Marlon Monroy on 11/22/18.
//  Copyright © 2018 Selfin. All rights reserved.
//

import Foundation
import PromiseKit

enum PostRequest: RequestRepresentable {
	case details(id:Int)
	case like(id:Int, params:PostTaskParams.Like)
    case report(id:Int, type:String)
	case copyLink(id:Int)
	case comment(id:Int, params:PostTaskParams.Comment)
	case comments(id:Int, page:Int)
	case likedUsers(id:Int, page:Int)
	case taggedUsers(id:Int, page:Int)
	case delete(id:Int)
	case create(params:PostTaskParams.Create)
    case likedComment(id:Int, commentId:Int, params:PostTaskParams.Like)
    case hashtag(hashtag:String, page:Int)
    case location(location:String, page:Int)
    case notificationOnOff(id:Int)
}

extension PostRequest {
    var method: HTTPMethod {
        switch self {
        case .details, .comments, .likedUsers, .taggedUsers, .copyLink, .hashtag, .location, .report, .notificationOnOff: return .get
        case .delete: return .delete
        default:
            return .post
        }
    }
    
    var parameters: Parameters {
        switch self {
        case let .like(_, params):
            return .body(data: encodeBody(data: params))
        case let .comment(_, params):
            return .body(data: encodeBody(data: params))
        case let .create(params):
            return .body(data: encodeBody(data: params))
        case let .likedComment(_, _, params):
            return .body(data: encodeBody(data: params))
        default: return .none
        }
    }
    
    var endpoint: String{
        switch self {
        case let .details(id):
            return PostRequestURL.details(id: id)
        case let .like(id, _):
            return PostRequestURL.like(id: id)
        case let .report(id,type):
            return PostRequestURL.report(id: id, type: type)
        case let .copyLink(id):
            return PostRequestURL.copyLink(id: id)
        case let .comment(id, _ ):
            return PostRequestURL.comment(id: id)
        case let .comments(id, page):
            return PostRequestURL.comments(id: id, page: page)
        case let .likedComment(id, commentId, _):
            return PostRequestURL.likedComment(id: id, commentId: commentId)
        case let .likedUsers(id, page):
            return PostRequestURL.likedUsers(id: id, page: page)
        case let .taggedUsers(id, page):
            return PostRequestURL.taggedUsers(id: id, page: page)
        case let .delete(id):
            return PostRequestURL.details(id: id)
        case  .create:
            return PostRequestURL.base
        case let .hashtag(hashtag, page):
            return PostRequestURL.hashtag(hashtag: hashtag, page: page)
        case let .location(location,page):
            return PostRequestURL.location(location: location, page: page)
        case let .notificationOnOff(id):
            return PostRequestURL.handlePostNotification(id: id)
        }
    }
}

final class PostTask {
	let dispatcher = SessionDispatcher()
	let multipPart = MultiPartDispatcher()

    func location(location:String, page: Int) -> Promise<SelfFeed> {
        return dispatcher.execute(requst: PostRequest.location(location: location, page: page), modeling: SelfFeed.self)
    }

    func hashtag(hashtag:String, page: Int) -> Promise<SelfFeed> {
        return dispatcher.execute(requst: PostRequest.hashtag(hashtag: hashtag, page: page), modeling: SelfFeed.self)
    }

	func details(id:Int, forUser:Bool = false) -> Promise<PostDetailResponse> {
		return dispatcher.execute(requst: PostRequest.details(id: id), modeling: PostDetailResponse.self)
	}
	
	func likedUsers(id:Int, page:Int) ->Promise<PostLikedUsersResponse> {
		return  dispatcher.execute(requst: PostRequest.likedUsers(id: id, page: page), modeling: PostLikedUsersResponse.self)
	}
	
	func taggedUsers(id:Int, page:Int) {}
	
    func report(id:Int, type :String) ->Promise<ReusableResponse>{
        return dispatcher.execute(requst: PostRequest.report(id: id, type: type), modeling: ReusableResponse.self)
	}
	
	func copyLink(id:Int) ->Promise<StaticPage> {
		return dispatcher.execute(requst: PostRequest.copyLink(id:id), modeling: StaticPage.self)
	}
	
	func comments(id:Int, page:Int) ->Promise<PostCommentsResponse> {
		return dispatcher.execute(requst: PostRequest.comments(id:id, page:page), modeling: PostCommentsResponse.self)
		
	}
	
	func like(id:Int, params:PostTaskParams.Like) -> Promise<PostLikeResponse> {
		return dispatcher.execute(requst: PostRequest.like(id: id, params: params), modeling: PostLikeResponse.self)
	}
	
	func comment(id:Int, params:PostTaskParams.Comment) ->Promise<PostCommentResponse>{
		return dispatcher.execute(requst: PostRequest.comment(id: id, params: params), modeling: PostCommentResponse.self)
	}
    
    func likeComment(id:Int, commentId:Int, params:PostTaskParams.Like) -> Promise<ReusableResponse> {
        return dispatcher.execute(requst: PostRequest.likedComment(id: id, commentId: commentId, params: params), modeling: ReusableResponse.self)
    }
	
	func delete(id:Int) ->Promise<ReusableResponse> {
		return dispatcher.execute(requst: PostRequest.delete(id: id), modeling: ReusableResponse.self)
	}
	
	/// Make sure to become the delete of this class
	/// in order to receive a response from this call
	func createPost(image:UIImage, params:PostTaskParams.Create) {
        multipPart.delegate = self
		multipPart.execute(request: PostRequest.create(params:params), with: image, expectsData: true)
	}
    
    func handleNotoficationForPost(id : Int) -> Promise<ReusableResponse>{
        return dispatcher.execute(requst: PostRequest.notificationOnOff(id: id), modeling: ReusableResponse.self)
    }
}

extension PostTask : MultiPartDispatcherDelegate {
    func onMultipartActions(action: MultiPartDispatcherAction) {
        switch action {
        case .success(response: let success):
            print("success: ",success)
        case .progress(progress: let progress):
            print("progress: ",progress)
        case .failed(err: let err):
            print("error: ",err)
        }
    }
}
