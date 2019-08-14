//
//  BlockedUsersCoordinator.swift
//  Selfin
//
//  Created by cis on 04/02/2019.
//  Copyright © 2019 Selfin. All rights reserved.
//

import Foundation
class BlockedUsersCoordinator: Coordinator<AppDeepLink> {
    let controller: BlockedUsersViewController = BlockedUsersViewController.from(from: .blockList, with: .blockList)
    
    override init(router: Router) {
        super.init(router: router)
        router.push(controller, animated: true, completion: nil)
    }
}
