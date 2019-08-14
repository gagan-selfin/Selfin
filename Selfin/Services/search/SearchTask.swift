//
//  SearchTask.swift
//  Selfin
//
//  Created by cis on 06/12/2018.
//  Copyright © 2018 Selfin. All rights reserved.
//

import Foundation
import PromiseKit

enum SearchRequest: RequestRepresentable {
    case searchResult(type: SearchRequestURL.searchStyle, searchString : String, page : Int)
}

extension SearchRequest {
    var method: HTTPMethod { return .get }
    
    var endpoint: String {
        switch self {
        case let .searchResult(type, searchString, page):
            return SearchRequestURL.search(search: type, value: searchString, page:page)
        }
    }
    
    var parameters: Parameters { return .none }
}

final class SearchTask {
    
    let dispatcher = SessionDispatcher()
    
    func SearchDiscoverTask(searchType : SearchRequestURL.searchStyle , searchStr : String, page: Int) -> Promise<FollowingFollowersResponse> {
        return dispatcher.execute(requst: SearchRequest.searchResult(type: searchType, searchString: searchStr, page: page), modeling: FollowingFollowersResponse.self)
    }
    
    func SearchDiscoverTags(searchStr : String, page: Int) -> Promise<SearchTags> {
        return dispatcher.execute(requst: SearchRequest.searchResult(type: .hashtag, searchString: searchStr, page: page), modeling: SearchTags.self)
    }
    
    func SearchDiscoverLocation(searchStr : String,page: Int) -> Promise<SearchLocation> {
        return dispatcher.execute(requst: SearchRequest.searchResult(type: .location, searchString: searchStr, page: page), modeling: SearchLocation.self)
    }
}
