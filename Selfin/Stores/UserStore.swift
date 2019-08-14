//
//  MainStore.swift
//  Selfin
//
//  Created by Marlon Monroy on 11/15/18.
//  Copyright © 2018 Selfin. All rights reserved.
//

import Foundation
import RealmSwift

struct UserStore {
    
    static func token() ->String {
        let realm = try! Realm()
        let authToken = realm.objects(AuthToken.self).first
        if authToken != nil {
            return authToken!.token
        }
        return ""
    }

    static func save(token:AuthToken) {
        let realm = try! Realm()
        let authToken = realm.objects(AuthToken.self)
        if authToken.count > 0 {
            try! realm.write {
                realm.delete(authToken)
            }
        }
        try! realm.write {
            realm.add(token)
        }
    }
	
	static func save(user:User) {
		let realm = try! Realm()
		let userList = realm.objects(User.self)
		if userList.count > 0{
			try! realm.write {
				realm.delete(userList)
			}
		}
		try! realm.write {
			realm.add(user)
		}
	}
    
    static var user:User? {
        let realm = try! Realm()
        let userList = realm.objects(User.self)
        if userList.count > 0{
            return userList.first
        }
        return nil
    }
    
    static func delete() {
        let realm = try! Realm()
        let userList = realm.objects(User.self)
        let authToken = realm.objects(AuthToken.self)
        if userList.count > 0 {
            try! realm.write {
                realm.delete(userList)
                realm.delete(authToken)
            }}
    }
    
    static func save(notificationCout : NotificationsCount) {
        let realm = try! Realm()
        let chatNotification = realm.objects(NotificationsCount.self)
        if chatNotification.count > 0 {
            try! realm.write {
                realm.delete(chatNotification)
            }
        }
        try! realm.write {
            realm.add(notificationCout)
        }
    }
    
    static func chatNotificationCount() -> Int {
        let realm = try! Realm()
        let notification = realm.objects(NotificationsCount.self).first
        if notification != nil {
            return notification!.count
        }
        return 0
    }
    
    static func deleteNotification() {
        let realm = try! Realm()
        let chatNotification = realm.objects(NotificationsCount.self)
        if chatNotification.count > 0 {
            try! realm.write {
                realm.delete(chatNotification)
            }}
    }
}
