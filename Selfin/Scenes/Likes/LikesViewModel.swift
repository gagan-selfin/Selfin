//
//  LikesViewModel.swift
//  Selfin
//
//  Created by cis on 21/09/2018.
//  Copyright © 2018 Selfin. All rights reserved.
//

import Foundation

class LikesViewModel {
    let postTask = PostTask()
    weak var controller:LikeViewDelegate?
    
    func fetchPostLikes(id: Int, page: Int) {
        postTask.likedUsers(id: id, page: page)
            .done {self.controller?.didReceived(data: $0)}
            .catch {self.controller?.didReceived(error: String(describing: $0))}
    }
}
