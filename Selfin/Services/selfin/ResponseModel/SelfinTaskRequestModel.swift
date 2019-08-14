//
//  SelfinTaskRequestModel.swift
//  Selfin
//
//  Created by cis on 07/12/2018.
//  Copyright © 2018 Selfin. All rights reserved.
//

import Foundation

struct ReferralCode: Codable {
    var referralCode: String
    var message: String
    var status: Bool
    
    enum CodingKeys: String, CodingKey {
        case referralCode = "referral_code"
        case message = "msg"
        case status
    }
}
