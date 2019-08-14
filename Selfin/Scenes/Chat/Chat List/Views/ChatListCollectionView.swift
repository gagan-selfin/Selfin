//
//  ChatList.swift
//  Selfin
//
//  Created by cis on 20/11/2018.
//  Copyright © 2018 Selfin. All rights reserved.
//

import UIKit

class ChatListCollectionView: UICollectionView, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    weak var controller:SearchCollectionDelegate?
    var searchUser :[FollowingFollowersResponse.User] = []
    var recentChat: [HSChatUsers] = []
    var page = 1
    var hasMore = true
    var searchStr : String?
    var isSearch = false
    weak var controllerChatList :chatListTableViewDelegate?
   
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
        return isSearch ? searchUser.count > 0 ? searchUser.count: 0 : recentChat.count > 0 ? recentChat.count: 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {return cell(for: indexPath)}
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
            if isSearch {if searchUser.count > 0 {controllerChatList?.didSelectfromSearch(user: searchUser[indexPath.item])}
            }else {if recentChat.count > 0 { controllerChatList?.didSelect(user: recentChat[indexPath.item])}}
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.row == searchUser.count - 1 && hasMore {
            page += 1
            controller?.fetchData(type: SearchRequestURL.searchStyle.user, strSearch: searchStr ?? "", page: page)
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
                if string != "" {
                    self?.page = 1
                    self?.isSearch = true
                    self?.controller?.fetchData(type: SearchRequestURL.searchStyle.user, strSearch: self?.searchStr ?? "" , page: self?.page ?? 1)
                    return
                }
                self?.isSearch = false
                self?.searchUser.removeAll()
                self?.reloadData()
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
        if isSearch && searchUser.count ==  0 {
        return CGSize(width: collectionView.frame.width, height: 25)}
        else {return CGSize(width: collectionView.frame.width, height: 0)}
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 68)
    }
    
    func cell(for index:IndexPath) -> UICollectionViewCell {
        let cell = dequeueReusableCell(withReuseIdentifier: "ChatListCollectionViewCell", for: index) as! ChatListCollectionViewCell
        cell.didSelect = didSelectProfile
           if isSearch {if searchUser.count == 0 { cell.loading()} else {cell.configure(with: searchUser[index.item], isSearch: isSearch)}
           }else {if recentChat.count == 0 { cell.loading()} else {cell.configure(with: recentChat[index.item], isSearch: isSearch)}
        }
        return cell
    }
    

    func didSelectProfile(name : String) {controllerChatList?.didMoveToProfile(username: name)}
}

extension ChatListCollectionView {
    func display(search : FollowingFollowersResponse){
        hasMore = search.data.count > 0
        if page == 1 { searchUser.removeAll() }
        searchUser.append(contentsOf: search.data)
        reloadData()}
    
    func clearOldData() {
        recentChat.removeAll()
        reloadData()
    }
    
    func display(user: HSChatUsers) {
        recentChat.append(user)
        reloadData()
    }
}

