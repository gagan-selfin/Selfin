//
//  ProfileTask.swift
//  Selfin
//
//  Created by Marlon Monroy on 11/28/18.
//  Copyright © 2018 Selfin. All rights reserved.
//

import Foundation
import PromiseKit

enum ProfileRequest:RequestRepresentable {
    case editProfile(param:ProfileTaskParam.editProfile)
    case changeProfilePicture(param:ProfileTaskParam.changeProfileImage,username:String)
    case copyLink(username : String)
    
    var method: HTTPMethod {
        switch self {
        case .copyLink:
            return .get
        default:
            return .put
        }
    }
    
    var endpoint: String {
        switch self {
        case .editProfile(_):
            return ProfileRequestURL.editProfile()
        case let .changeProfilePicture(_,username):
            return ProfileRequestURL.changePicture(username: username)
        case let .copyLink(username):
            return ProfileRequestURL.copyUserProfileLink(username: username)
        }
    }
    
    var parameters: Parameters {
        switch self {
        case let .editProfile(params):
            return .body(data: encodeBody(data: params))
        case let .changeProfilePicture(params):
            return .body(data: encodeBody(body: params))
        case .copyLink(_):
            return .none
        }
    }
}

final class ProfileTask {
	let dispatcher = SessionDispatcher()
    func editUsersProfile(param:ProfileTaskParam.editProfile) -> Promise<EditProfile> {
        return dispatcher.execute(requst: ProfileRequest.editProfile(param: param), modeling: EditProfile.self)
    }
    
    func userProfileLink(username : String) -> Promise<StaticPage> {
        return dispatcher.execute(requst: ProfileRequest.copyLink(username: username), modeling: StaticPage.self)
    }
    
    let disp = MultiPartDispatcher()
    func avatar(avatarImage: UIImage)
        -> Promise<EditProfile> {
            let promise = Promise<EditProfile>.pending()
            disp.execute(request: EditProfileRequest.avatar(), with: avatarImage)
            return promise.promise
    }
}
