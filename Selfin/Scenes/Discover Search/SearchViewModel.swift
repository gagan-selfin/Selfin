//
//  SearchViewModel.swift
//  Selfin
//
//  Created by cis on 15/11/2018.
//  Copyright © 2018 Selfin. All rights reserved.
//

import Foundation


final class SearchViewModel {
    private let task = SearchTask()
    weak var delegate:SearchControllerDelegate?
    
    func performSearch(type : SearchRequestURL.searchStyle, strSearch:String, page : Int)  {
        task.SearchDiscoverTask(searchType: type, searchStr: strSearch, page : page)
            .done  { self.delegate?.didReceived(type: type, result: $0) }
            .catch { self.delegate?.didReceived(error: String(describing: $0)) }
    }
    
    func performSearchTags(strSearch:String, page : Int)  {
        task.SearchDiscoverTags(searchStr: strSearch, page: page)
            .done {self.delegate?.didReceivedTags(result: $0)
        }
            .catch {self.delegate?.didReceived(error: String(describing: $0))
        }
    }
    
    func performSearchLocation(strSearch:String, page : Int)  {
        task.SearchDiscoverLocation(searchStr: strSearch
            , page: page)
            .done {self.delegate?.didReceivedLocation(result: $0)
            }
            .catch {self.delegate?.didReceived(error: String(describing: $0))
        }
    }
}
