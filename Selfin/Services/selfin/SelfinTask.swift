//
//  SelfinTask.swift
//  Selfin
//
//  Created by cis on 07/12/2018.
//  Copyright © 2018 Selfin. All rights reserved.
//

import Foundation
import PromiseKit

enum SelfinRequest: RequestRepresentable {
    case getReferralCode
    case referral(param:SelfinTaskParam.referralCode)
    case earnStars
    case chatNotification(param:SelfinTaskParam.cahtNotification)
    case subSelfinAccounts
    case followAllSelfinAccounts
}

extension SelfinRequest {
    var method:HTTPMethod {
        switch self {
        case .referral(_),.chatNotification(_): return .post
        default:
            return .get
        }
    }
    
    var endpoint: String {
        switch self {
        case .referral(_):
            return SelfinRequestedURL.referralCode()
        case .earnStars:
            return SelfinRequestedURL.referralCode()
        case .getReferralCode:
            return SelfinRequestedURL.referralCode()
        case .chatNotification(_):
            return SelfinRequestedURL.chatNotification()
        case .subSelfinAccounts:
            return SelfinRequestedURL.listOfSubSelfinAccounts()
        case .followAllSelfinAccounts:
            return SelfinRequestedURL.followAll()
        }
    }
    
    var parameters: Parameters {
        switch self {
        case let .referral(params):
            return .body(data: encodeBody(data: params))
        case let .chatNotification(params):
            return .body(data: encodeBody(data: params))
        default: return .none
        }
    }
}

final class SelfinTask{
    let dispatcher = SessionDispatcher()
    
    func referralCode(param:SelfinTaskParam.referralCode) -> Promise<ReferralCode> {
        return dispatcher.execute(requst: SelfinRequest.referral(param: param), modeling: ReferralCode.self)
    }
    
    func earnStarts() -> Promise<ReferralCode> {
        return dispatcher.execute(requst: SelfinRequest.earnStars, modeling: ReferralCode.self)
    }
    
    func getReferralCode() ->  Promise<ReferralCode> {
         return dispatcher.execute(requst: SelfinRequest.getReferralCode, modeling: ReferralCode.self)
    }
    
    func sendChatNotification(param : SelfinTaskParam.cahtNotification) -> Promise<ReusableResponse> {
        return dispatcher.execute(requst: SelfinRequest.chatNotification(param: param), modeling: ReusableResponse.self)
    }
    
    func fetchListOfSubSelfinAccounts() -> Promise<SubSelfinAccounts> {
        return dispatcher.execute(requst: SelfinRequest.subSelfinAccounts, modeling: SubSelfinAccounts.self)
    }
    
    func followAllSubSelfinAccount() -> Promise<ReusableResponse> {
        return dispatcher.execute(requst: SelfinRequest.followAllSelfinAccounts, modeling: ReusableResponse.self)
    }
}
