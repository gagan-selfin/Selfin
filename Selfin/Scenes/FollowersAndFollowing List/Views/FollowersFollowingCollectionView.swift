//
//  FollowersFollowingCollectionView.swift
//  Selfin
//
//  Created by cis on 20/11/2018.
//  Copyright © 2018 Selfin. All rights reserved.
//

import UIKit

protocol FollowersFetchCollectionDelegate : class {
    func fetchFollowerAndFollowingList(type : UserRequestURL.List, searchUser : String , page: Int)
    func didMoveToProfile(username: String)
}

class FollowersFollowingCollectionView: UICollectionView, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    weak var controller:FollowersFetchCollectionDelegate?
    var currentUserType : UserRequestURL.List = .follower
    var searchResult :[FollowingFollowersResponse.User] = []
    var page = 1
    var hasMore = true
    var searchStr : String?
    var isSearch = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }
    
    fileprivate func setup() {
        dataSource = self
        delegate = self
        register(UINib(nibName: "ReusableFooterCollectionReusableView", bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: "FooterView")
        register(UINib(nibName: "SearchUserCollectionReusableView", bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "Search")
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return isSearch ? searchResult.count > 0 ? searchResult.count : 0 : searchResult.count > 0 ? searchResult.count : 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {return cell(for: indexPath)}
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        print(indexPath.row)
        print(searchResult.count)
        print(hasMore)
        if indexPath.row == searchResult.count - 1 && hasMore {
            page += 1
            if currentUserType == .follower {
                controller?.fetchFollowerAndFollowingList(type: .follower, searchUser: searchStr ?? "", page: page)
                return
            }
        controller?.fetchFollowerAndFollowingList(type: .following, searchUser: searchStr ?? "", page: page)
        }
    }
    
    @available(iOS 6.0, *)
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {return CGSize.init(width: UIScreen.main.bounds.width, height: 104)}
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "Search", for: indexPath) as! SearchUserCollectionReusableView
            headerView.performSearch = {[weak self](string) in
                self?.searchStr = string
                if self?.searchStr == "" {self?.isSearch = false}else {self?.isSearch = true}
                self?.page = 1
                if self?.currentUserType == .follower {self?.controller?.fetchFollowerAndFollowingList(type: .follower, searchUser: string, page: self?.page ?? 1)
                }else {
                    self?.controller?.fetchFollowerAndFollowingList(type: .following, searchUser: string, page: self?.page ?? 1)
                }
            }
            return headerView
        case UICollectionView.elementKindSectionFooter:
            let footerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "FooterView", for: indexPath) as! ReusableFooterCollectionReusableView
            return footerView
        default:
            return UICollectionReusableView()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        if isSearch && searchResult.count ==  0 {
            return CGSize(width: collectionView.frame.width, height: 25)}
        else {return CGSize(width: collectionView.frame.width, height: 0)}
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 68)
    }
    
    func cell(for index:IndexPath) -> UICollectionViewCell {
        let cell = dequeueReusable(index) as ReusableSearchCollectionViewCell
        cell.delegate = self
        if searchResult.count == 0 { cell.loading()} else {
            cell.configure(with: searchResult[index.row])
        }
        return cell
    }
}

extension FollowersFollowingCollectionView {
    func display(type:UserRequestURL.List , search:FollowingFollowersResponse) {
        if isSearch && page == 1{ page = 1;self.searchResult.removeAll()}
        currentUserType = type
        self.hasMore = search.data.count > 0
        if  page == 1{ searchResult.removeAll() }
        searchResult.append(contentsOf: search.data)
        reloadData()
    }
}

extension FollowersFollowingCollectionView: SearchCollectionViewCellDelegate {
    func didMovetoProfile(username: String) {
        controller?.didMoveToProfile(username: username)
    }
    
    func didUpdateFollowStatus(id : Int) {
        let indx : Int = searchResult.firstIndex { $0.id == id} ?? 0
        if searchResult[indx].following {searchResult[indx].following = false}else {searchResult[indx].following = true}
    }
}
