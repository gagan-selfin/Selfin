//
//  DiscoverTask.swift
//  Selfin
//
//  Created by Marlon Monroy on 7/1/18.
//  Copyright © 2018 Selfin. All rights reserved.
//

import Foundation
import PromiseKit

enum DiscoverRequest: RequestRepresentable {
    var endpoint: String {
        switch self {
        case let .discover(page):
            return DiscoverRequestURL.discover(page: page)
		case let .search(type,value, page):
			return DiscoverRequestURL.search(type: type,value:value, page: page)
        }
    }
    case discover(page: Int)
	case search(type:String,value:String, page:Int)
	
}

final class DiscoverTask: NSObject {
    let dispatcher = SessionDispatcher()
	enum DiscoverSearchType:String {
		case hashtag
		case most
		case user
		case location
	}
    func discover(page: Int) -> Promise<DiscoverResponse> {
       return  dispatcher.execute(requst: DiscoverRequest.discover(page: page), modeling: DiscoverResponse.self)
		
    }
	
	/**
	 - Here when calling this func you can
	   specify what type you want to return by passing
		the the returning type and what search type as well
	 - parameters:
			- type:  The search type e.g  `hastag`
			- value: the search value e.g `marlon` default to `""`
			- page:  The current page
		   - returning: [SearchHashtagResponse | SearchUserResponse | SearchLocationResponse ]
	- returns:
		A promise of type [SearchHashtagResponse | SearchUserResponse | SearchLocationResponse ]
  */
	func search<T:Decodable>(type:DiscoverSearchType,value:String = "", page:Int, returning:T) -> Promise<T> {
		return dispatcher.execute(requst:DiscoverRequest.search(type: type.rawValue, value: value, page: page) , modeling:T.self)
		
	}
}
