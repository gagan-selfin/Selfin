//
//  TagListViewModel.swift
//  Selfin
//
//  Created by cis on 04/10/2018.
//  Copyright © 2018 Selfin. All rights reserved.
//

import Foundation



final class TagListViewModel {
    private let task = SearchTask()
    weak var controller : tagViewModelDelegate?

    func searchApplicationsUsersToTag(searchString: String, pageNumber : Int) {
        task.SearchDiscoverTask(searchType: .most, searchStr: searchString, page: pageNumber)
            .done { user in
                self.controller?.didReceived(data: user.data)
            }
            .catch { self.controller?.didReceived(error: String(describing: $0.localizedDescription)) }
    }
}
