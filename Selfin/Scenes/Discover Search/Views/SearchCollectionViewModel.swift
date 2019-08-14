//
//  SearchCollectionViewModel.swift
//  Selfin
//
//  Created by cis on 16/11/2018.
//  Copyright © 2018 Selfin. All rights reserved.
//

import Foundation

final class SearchCollectionViewModel {
    
    weak var controller: FollowUnfollowUserDelegate?
    let userTask = UserTask(username: "")
    var searchMost :[FollowingFollowersResponse.User] = []
    var searchPeople :[FollowingFollowersResponse.User] = []
    var searchTag :[SearchTags.Tags] = []
    var searchLocation :[SearchLocation.Location] = []
    var page = 1
    var pagePeople = 1
    var pageTag = 1
    var pageLocation = 1
    var hasMore = true
    var searchStr = ""
    var isSearchPerformed = false //To clear search cache
    var searchedType : SearchRequestURL.searchStyle? //To clear search cache
    
    func performFollowUnFollowUserAPI(username: String) {
        userTask.followUnfollow(with: UserTaskParams.FollowUnfollowRequest(username:username))
        .done {
            self.controller?.didReceived(data: $0)
            }
        .catch {
            print($0.localizedDescription)
            self.controller?.didReceived(error: String(describing: $0.localizedDescription))
        }
    }
    
    func setBaseLayout(style :SearchRequestURL.searchStyle, controller : SearchCollectionDelegate? ) {
        switch style {
        case .most:
            if searchMost.count == 0 {searchStr = "" ;controller?.fetchData(type: .most, strSearch: searchStr, page: 1)}
        case .user:
            if searchPeople.count == 0 {searchStr = "";controller?.fetchData(type: .user, strSearch: searchStr, page: 1)}
        case .hashtag:
            if searchTag.count == 0 {
               searchStr = "";controller?.fetchData(type: .hashtag, strSearch: searchStr, page: 1)}
        case .location:
            if searchLocation.count == 0 {searchStr = "";controller?.fetchData(type: .location, strSearch: searchStr, page: 1)}
        }
    }
    
    func handlePagination(currentStyle : SearchRequestURL.searchStyle, controller : SearchCollectionDelegate?, indexPath : IndexPath)  {
        switch currentStyle {
        case .most:
            if indexPath.row == searchMost.count - 1 && hasMore {
                page += 1
                controller?.fetchData(type: .most, strSearch: searchStr, page: page)}
        case .user:
            if indexPath.row == searchPeople.count - 1 && hasMore {
                pagePeople += 1
                controller?.fetchData(type: .user, strSearch: searchStr, page: pagePeople)}
        case .hashtag:
            if indexPath.row == searchTag.count - 1 && hasMore {
                pageTag += 1
                controller?.fetchData(type: .hashtag, strSearch: searchStr, page: pageTag)}
        case .location:
            if indexPath.row == searchLocation.count - 1 && hasMore {
                pageLocation += 1
                controller?.fetchData(type: .location, strSearch: searchStr, page: pageLocation)}
        }
    }
    
    func performSearchOverDifferentTabs(delegate : SearchCollectionDelegate? ,type: SearchRequestURL.searchStyle, searchStr : String){
        if  searchStr == "" {isSearchPerformed = false}else {isSearchPerformed = true}
        switch type {
        case .most:
            page = 1
            searchedType = .most
            delegate?.fetchData(type: .most, strSearch: searchStr , page: page)
        case .user:
            pagePeople = 1
            searchedType = .user
            delegate?.fetchData(type: .user, strSearch: searchStr, page: pagePeople)
        case .hashtag:
            pageTag = 1
            searchedType = .hashtag
            delegate?.fetchData(type: .hashtag, strSearch: searchStr, page: pageTag)
        case .location:
            pageLocation = 1
            searchedType = .location
            delegate?.fetchData(type: .location, strSearch: searchStr, page: pageLocation)
        }
    }
    
    func clearSearchCache(style : SearchRequestURL.searchStyle) {
        if isSearchPerformed {
            if style != searchedType {
                switch searchedType {
                case .most?:
                    page = 1
                    searchMost.removeAll()
                case .user?:
                    pagePeople = 1
                    searchPeople.removeAll()
                case .hashtag?:
                    pageTag = 1
                    searchTag.removeAll()
                case .location?:
                    pageLocation = 1
                    searchLocation.removeAll()
                default:
                    break
                }}}
    }
}
