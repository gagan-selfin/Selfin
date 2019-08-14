//
//  SubSelfinAccountsAction.swift
//  Selfin
//
//  Created by cis on 25/02/2019.
//  Copyright © 2019 Selfin. All rights reserved.
//

import Foundation

enum SubAccountsAPIResponse {
    case followAll(data:ReusableResponse)
    case follow(data:followUnfollowUser, username:String)
    case accounts(data:SubSelfinAccounts)
    case error(message:String)
}

protocol SubAccountsResponseDelegate : class {
    func didReceive(response data:SubAccountsAPIResponse)
}

protocol didFollowAccounts : class {
    func didFollowAllSubAccounts()
    func didFollowSubAccount(username : String)
}

protocol SubAccountsCoordinatorDelegate: class {
    func didMoveToProfleDetails(username : String)
}




