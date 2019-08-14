//
//  FeedRequestURL.swift
//  Selfin
//
//  Created by Marlon Monroy on 11/25/18.
//  Copyright © 2018 Selfin. All rights reserved.
//

import Foundation

struct FeedRequestURL {
	static func feeds(page:Int) -> String {
		return "v1/public-posts/?page=\(page)"
	}
}
