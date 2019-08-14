//
//  DiscoverRequestURL.swift
//  Selfin
//
//  Created by Marlon Monroy on 11/28/18.
//  Copyright © 2018 Selfin. All rights reserved.
//

import Foundation



struct DiscoverRequestURL {
	static func discover(page:Int) -> String {
		return "v1/discover-post/?page=\(page)"
	}
	static func search(type:String,value:String, page:Int) -> String {
		return "v1/search/?\(type)=\(value)&page=\(page)"
	}
}
