//
//  Settings.swift
//  Selfin
//
//  Created by Marlon Monroy on 1/23/19.
//  Copyright © 2019 Selfin. All rights reserved.
//
import Nuke
import Foundation

class Settings {
	static func setImageCachingSize() {
		ImageCache.shared.costLimit = 1024 * 1024 * 1024 // 1 GB
		ImageCache.shared.countLimit = 400
		ImageCache.shared.ttl = 60 * 10
	}
}
