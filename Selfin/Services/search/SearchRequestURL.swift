//
//  SearchRequestURL.swift
//  Selfin
//
//  Created by cis on 06/12/2018.
//  Copyright © 2018 Selfin. All rights reserved.
//

import Foundation

struct SearchRequestURL {
    enum searchStyle : String {
        case most; case user; case hashtag; case location}
    
    static let base = "v1/"
    
    static func search(search:searchStyle, value:String, page:Int) -> String {
        return "\(base)search/?\(search)=\(value)&page=\(page)"
    }
    
}
