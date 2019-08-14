//
//  EarnStarsViewModel.swift
//  Selfin
//
//  Created by cis on 14/09/2018.
//  Copyright © 2018 Selfin. All rights reserved.
//

import Foundation

protocol EarnStarDelegate {
    func didReceived(data:ReferralCode)
    func didReceived(error:String)
}

final class EarnStarsViewModel {
    
    let task = SelfinTask ()
    var delegate:EarnStarDelegate?

    func referralCodeProcess() {
        task.getReferralCode()
            .done{self.delegate?.didReceived(data: $0)}
            .catch{self.delegate?.didReceived(error: String(describing: $0))}
    }
}
