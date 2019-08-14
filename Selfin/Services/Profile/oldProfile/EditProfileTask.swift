//
//  EditProfileTask.swift
//  Selfin
//
//  Created by cis on 24/09/18.
//  Copyright © 2018 Selfin. All rights reserved.
//

import Foundation
import PromiseKit

enum EditProfileRequest: RequestRepresentable {
    var endpoint: String {
        switch self {
        case .editprofile:
            return APIs.userProfileApi.rawValue
        case .avatar():

            return APIs.changeAvatarApi.rawValue.replacingOccurrences(of: "USERNAME", with: UserStore.user?.userName ?? "")
        }
    }

    var method: HTTPMethod {
        switch self {
        case .editprofile:

            return .put
        case .avatar:

            return .post
        }
    }

    var parameters: Parameters {
        switch self {
        case let .editprofile(info):

            do {
                let data = try JSONSerialization.data(withJSONObject: info
                                                      , options: .prettyPrinted)

                return .body(data: data)

            } catch {}
        case .avatar():
            break
        }

        return .none
    }

    var headers: [String: String]? { return ["Content-Type": "application/json"] }
    case editprofile(info: [String: Any])
    case avatar()
}

final class EditProfileTask: NSObject {
    let disp = MultiPartDispatcher()

    let dispatcher = SessionDispatcher()

    func avatar(avatarImage: UIImage)
        -> Promise<EditProfile> {
        let promise = Promise<EditProfile>.pending()

        disp.execute(request: EditProfileRequest.avatar(), with: avatarImage)
        return promise.promise
    }

    func editprofile(info: [String: Any])
        -> Promise<EditProfile> {
        let promise = Promise<EditProfile>.pending()
        dispatcher.execute(requst: EditProfileRequest.editprofile(info: info), modeling: EditProfile.self)
            .done { user in
                promise.resolver.fulfill(user)
            }
            .catch { err in
                promise.resolver.reject(err)
            }

        return promise.promise
    }
}
