//
//  FeedsTask.swift
//  Selfin
//
//  Created by Marlon Monroy on 6/30/18.
//  Copyright © 2018 Selfin. All rights reserved.
//

import Foundation
import PromiseKit

enum FeedRequest: RequestRepresentable {
    var endpoint: String {
        switch self {
        case let .feeds(page):
			return FeedRequestURL.feeds(page: page)
     }
	}
	
    var method: HTTPMethod { return .get }
    case feeds(page: Int)
}

final class FeedsTask {
    let dispatcher = SessionDispatcher()
    func feed(page:Int) ->Promise<HomeFeed> {
        return dispatcher.execute(requst: FeedRequest.feeds(page: page), modeling: HomeFeed.self)
    }
}
