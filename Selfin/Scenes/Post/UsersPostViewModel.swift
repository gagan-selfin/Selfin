//
//  UsersPostViewModel.swift
//  Selfin
//
//  Created by cis on 21/12/2018.
//  Copyright © 2018 Selfin. All rights reserved.
//

import Foundation
protocol UsersPostViewModelDelegate: class {
    func didReceived(items:[SelfFeed.Post])
    func didReceived(error:String)
}
class UsersPostViewModel {
    weak var delegate:UsersPostViewModelDelegate?
    var username = String()
    lazy var task = {
        return UserTask(username: self.username)
    }()
    let taskPost = PostTask ()
  
    func fetchLocations(string : String, page:Int) {
        taskPost.location(location: string, page: page)
            .done{self.delegate?.didReceived(items: $0.post)}
            .catch {
                self.delegate?.didReceived(error: String(describing: $0.localizedDescription)) }
    }

    func fetchHashtags(string : String, page:Int) {
        taskPost.hashtag(hashtag: string, page: page)
            .done{self.delegate?.didReceived(items: $0.post)}
            .catch {
                self.delegate?.didReceived(error: String(describing: $0.localizedDescription)) }
    }
    
    func fetchPost(string : String, page: Int) {
        task.posts(page: page, userName: string)
            .done{self.delegate?.didReceived(items: $0.post)}
            .catch {
                self.delegate?.didReceived(error: String(describing: $0.localizedDescription)) }
    }
}
