//
//  DIscoverViewModel.swift
//  Selfin
//
//  Created by Marlon Monroy on 7/2/18.
//  Copyright © 2018 Selfin. All rights reserved.
//

import Foundation

protocol DiscoverDelegate: class {
    func didReceived(items:[DiscoverResponse.Post])
    func didReceived(error:String)

}
class DiscoverViewModel {
    let task = DiscoverTask()
    weak var delegate:DiscoverDelegate?
    
    func fetchDiscover(page: Int) {
        task.discover(page: page)
            .done {self.delegate?.didReceived(items: $0.post)}
            .catch {self.delegate?.didReceived(error: String(describing: $0.localizedDescription))}
    }
}
