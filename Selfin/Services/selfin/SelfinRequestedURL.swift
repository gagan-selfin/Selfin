//
//  SelfinRequestedURL.swift
//  Selfin
//
//  Created by cis on 07/12/2018.
//  Copyright © 2018 Selfin. All rights reserved.
//

import Foundation

struct SelfinRequestedURL {
    static let base = "v1/selfin/"
    
    static func referralCode() -> String {
        return "user/referral_code/"
    }
    
    static func FrequentlyAskedQuestions() -> String {
        return "\(base)FAQs/"
    }
    
    static func TermOfUses() -> String {
        return "\(base)terms-of-use/"
    }
    
    static func ContactUs() -> String {
        return "\(base)contact-us/"
    }
    
    static func PrivacyPolicy() -> String {
        return "\(base)privacy-policy/"
    }
    
    static func chatNotification() -> String {
        return "v1/chat/send-notification/"
    }
    
    static func AcceptTermOfUse() -> String {
        return "\(base)terms-and-policy/"
    }
    
    static func listOfSubSelfinAccounts() -> String {
        return "v1/sub-accounts/"
    }
    
    static func followAll() -> String {
        return "v1/sub-accounts/follow-all/"
    }
}

