//
//  AppViewModel.swift
//  Selfin
//
//  Created by cis on 07/01/19.
//  Copyright © 2019 Selfin. All rights reserved.
//

import Foundation

enum deepLinkValues {
    case forgetPassword(email:String)
    case post(id: Int)
    case profile(username: String)
}

enum UniversalLinkType : String {
    case forgetPassword = "forgot-password/"
    case post = "post/"
    case profile = "profile/"
}

final class DeepLinkManager {
    static let shared = DeepLinkManager()
    var deeplink : deepLinkValues = .forgetPassword(email: "")
    var isSuccess: ((Bool, deepLinkValues?) -> Void)?
    private init(){}
    
    func deepLinkMethod(userActivity: NSUserActivity)  {
        let strUrl = userActivity.webpageURL!.absoluteString
        if let range = strUrl.range(of: UniversalLinkType.post.rawValue) {
            let postId = strUrl[range.upperBound...].trimmingCharacters(in: .whitespaces)
            deeplink = deepLinkValues.post(id: Int(postId) ?? 0)
        }else if let range = strUrl.range(of: UniversalLinkType.forgetPassword.rawValue) {
            let token = strUrl[range.upperBound...].trimmingCharacters(in: .whitespaces)
            checkTokenValidity(token: token)
        }else if let range = strUrl.range(of: UniversalLinkType.profile.rawValue) {
            let username = strUrl[range.upperBound...].trimmingCharacters(in: .whitespaces)
            deeplink = deepLinkValues.profile(username: username)
        }
    }
    
    private let auth = AuthTask()
    func checkTokenValidity(token:String)  {
        auth.tokenValidity(params: AuthTaskParams.Validity(hash_token: token))
            .done {
                self.isSuccess!(true, deepLinkValues.forgetPassword(email: $0.email))
        }
            .catch { (err) in
               self.isSuccess!(true, nil)
        }
    }
}

