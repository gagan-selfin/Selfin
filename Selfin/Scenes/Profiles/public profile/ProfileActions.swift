//
//  ProfileActions.swift
//  Selfin
//
//  Created by Marlon Monroy on 11/20/18.
//  Copyright © 2018 Selfin. All rights reserved.
//

import Foundation

protocol showUserChatRoom : class {
    func didMoveToChatScreen(user: HSChatUsers)
}

enum actionsOnUsers : String {
    case unblock = "Un-block"
    case block = "Block"
    case sendMessage = "Send Message"
    case share = "Share"
    case copyLink = "Copy Link"
    case report = "Report"
}

