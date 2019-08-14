//
//  User.swift
//  Selfin
//
//  Created by Marlon Monroy on 11/16/18.
//  Copyright © 2018 Selfin. All rights reserved.
//

import Foundation
import RealmSwift

final class User : Object, Codable {
	@objc dynamic var id = 0
	@objc dynamic var firstName = ""
	@objc dynamic var lastName = ""
	@objc dynamic var profileImage = ""
	@objc dynamic var userName = ""
	@objc dynamic var email = ""
	@objc dynamic var bio = ""
    @objc dynamic var isPrivate = Bool()
    @objc dynamic var isPromotional = Bool()
    @objc dynamic var isPush = Bool()
    @objc dynamic var fullname = ""
    @objc dynamic var mobileNumber = ""
    
    var userImage:String {
        return environment.host + profileImage
    }
}

final class AuthToken: Object, Codable {
    @objc dynamic var token = ""
}

final class NotificationsCount: Object, Codable {
    @objc dynamic var count = 0
}

