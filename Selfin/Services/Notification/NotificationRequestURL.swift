//
//  NotificationRequestURL.swift
//  Selfin
//
//  Created by cis on 05/12/2018.
//  Copyright © 2018 Selfin. All rights reserved.
//

import Foundation

struct NotificationRequestURL {
    static let base = "v1/user/"
    
    static func notification(page:Int) -> String {
        return "\(base)notifications/?page=\(page)"
    }
    
    static func publicNotification(page:Int) -> String {
        return "\(base)notifications/?public&page=\(page)"
    }
}

