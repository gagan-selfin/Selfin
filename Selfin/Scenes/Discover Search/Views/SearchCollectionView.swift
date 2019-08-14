//
//  SearchCollectionView.swift
//  Selfin
//
//  Created by cis on 13/11/2018.
//  Copyright © 2018 Selfin. All rights reserved.
//

import UIKit

class emptycell : UICollectionViewCell {}
class SearchCollectionView: UICollectionView,UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
   
    weak var headerView: SearchHeaderCollectionReusableView?
    var currentStyle:SearchRequestURL.searchStyle = .most
    weak var controller:SearchCollectionDelegate?
    let viewModel = SearchCollectionViewModel()   
    var didSelectHashtag: ((_ hashtag: String) -> Void)?
    var didSelectLocation: ((_ location: String) -> Void)?
    
    private let str = ""
    fileprivate let strfp = ""

    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
    }

    fileprivate func setup() {
        dataSource = self
        delegate = self
        if currentStyle == .hashtag || currentStyle == .location {
            contentInset = UIEdgeInsets.init(top: 0, left: 16, bottom: 0, right: 16)
        }
    }

    private func layout(for style: SearchRequestURL.searchStyle) {
        viewModel.clearSearchCache(style : style)
        viewModel.setBaseLayout(style: style, controller: controller)
        currentStyle = style
        reloadSections(IndexSet.init(integer: 1))
    }
    
    @available(iOS 6.0, *)
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }

    @available(iOS 6.0, *)
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {return 0}else {
        switch currentStyle {
        case .most:
            return viewModel.searchMost.count > 0 ? viewModel.searchMost.count : 10
        case .user:
            return viewModel.searchPeople.count > 0 ? viewModel.searchPeople.count : 10
        case .hashtag:
            return viewModel.searchTag.count > 0 ? viewModel.searchTag.count : 10
        case .location:
            return viewModel.searchLocation.count > 0 ? viewModel.searchLocation.count : 10
        }}
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.section != 0{ switch currentStyle {
        case .hashtag:
            didSelectHashtag!(viewModel.searchTag[indexPath.item].tag)
        case .most, .user:
            break
        case .location:
            didSelectLocation!(viewModel.searchLocation[indexPath.item].locationName)
            }}
    }
    
    @available(iOS 6.0, *)
    public func collectionView(_: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return cell(for: indexPath)
    }

    @available(iOS 8.0, *)
    public func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.section != 0 {
        //Pagination
        viewModel.handlePagination(currentStyle: currentStyle, controller: controller, indexPath: indexPath)
        
        //To handle UI for tag and location
        if currentStyle == .hashtag || currentStyle == .location {
            if indexPath.row == 0 {
                cell.round(corners: [.topLeft, .topRight], withRadius: 10)
            } else {
                cell.round(corners: [.bottomLeft, .bottomRight], withRadius: 0)
            }}
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "SearchHeader", for: indexPath) as! SearchHeaderCollectionReusableView
            self.headerView = headerView
            
            headerView.onStyleSelected = {[weak self] in
                switch $0 {
                case .location:
                    self?.layout(for: .location)
                case .most:
                    self?.layout(for: .most)
                case .people:
                    self?.layout(for: .user)
                case .tag:
                    self?.layout(for: .hashtag)
                }
                return
            }
            
            headerView.performSearchOverSelectedStyle = {[weak self](style,string) in
                self?.viewModel.searchStr = string
                var type : SearchRequestURL.searchStyle = .most
                switch style {
                case .location:
                    type = .location
                case .most:
                    type = .most
                case .people:
                    type = .user
                case .tag:
                    type = .hashtag
                }
                self?.viewModel.performSearchOverDifferentTabs(delegate : self?.controller, type: type, searchStr : string)
                return
            }
            return headerView
    }
    
    @available(iOS 6.0, *)
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.section == 0 {return CGSize.zero}else {
            if currentStyle == .most || currentStyle == .user {
                return CGSize.init(width: UIScreen.main.bounds.width, height: 104)
            }
            return CGSize.init(width: UIScreen.main.bounds.width - 32, height: 54)
        }
    }
    
    @available(iOS 6.0, *)
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        if section == 0 {
            return CGSize.init(width: UIScreen.main.bounds.width, height: 140)
        }else {return CGSize.zero}
    }
    
    func cell(for index:IndexPath) -> UICollectionViewCell {
        if index.section != 0 {
            switch currentStyle {
            case .most :
                let cell = dequeueReusable(index) as ReusableSearchCollectionViewCell
                cell.delegate = self as SearchCollectionViewCellDelegate
                if viewModel.searchMost.count == 0 { cell.loading()} else {
                    cell.configure(with: viewModel.searchMost[index.row])
                }
                return cell
            case .user :
                let cell = dequeueReusable(index) as ReusableSearchCollectionViewCell
                cell.delegate = self as SearchCollectionViewCellDelegate
                if viewModel.searchPeople.count == 0 { cell.loading()} else {
                    cell.configure(with: viewModel.searchPeople[index.row])
                }
                return cell
            case .hashtag :
                let cell = dequeueReusableCell(withReuseIdentifier: "Tags", for: index) as! TagsCollectionViewCell
                if viewModel.searchTag.count == 0 { cell.loading()} else {
                    cell.configure(with: viewModel.searchTag[index.row], type: .tag)
                }
                return cell
            case .location:
                let cell = dequeueReusableCell(withReuseIdentifier: "Tags", for: index) as! TagsCollectionViewCell
                if viewModel.searchLocation.count == 0 { cell.loading()} else {
                    cell.configure(with: viewModel.searchLocation[index.row], type: .location)
                }
                return cell
            }
        }else {
            let cell = dequeueReusableCell(withReuseIdentifier: "emptycell", for: index) as! emptycell
            return cell
        }
    }
}

extension SearchCollectionView  {
    
    func display(type : SearchRequestURL.searchStyle, search : FollowingFollowersResponse) {
        print(str)
        print(strfp)
        
        viewModel.hasMore = search.data.count > 0
        switch type {
        case .most:
            if  viewModel.page == 1 { viewModel.searchMost.removeAll() }
            viewModel.searchMost.append(contentsOf: search.data)
            if currentStyle == type {layout(for: .most)}
        case .user:
            if  viewModel.pagePeople == 1 { viewModel.searchPeople.removeAll() }
            viewModel.searchPeople.append(contentsOf: search.data)
            if currentStyle == type {layout(for: .user)}
        default:
            break
        }
    }
    
    func display(search : SearchTags){
        viewModel.hasMore = search.data.count > 0
        if viewModel.pageTag == 1 {
            viewModel.searchTag.removeAll()}
            viewModel.searchTag.append(contentsOf: search.data)
        if currentStyle == .hashtag {layout(for: .hashtag)}
    }
    
    func display(search : SearchLocation){
        viewModel.hasMore = search.data.count > 0
        if viewModel.pageLocation == 1 {
            viewModel.searchLocation.removeAll()
        }
        viewModel.searchLocation.append(contentsOf: search.data)
        if currentStyle == .location{layout(for: .location)}
    }
}

extension SearchCollectionView: SearchCollectionViewCellDelegate {
    func didMovetoProfile(username: String) {
        controller?.didViewUserProfile(username: username)
    }
    
    func didUpdateFollowStatus(id : Int) {
        switch currentStyle {
        case .most:
            let indx : Int = viewModel.searchMost.firstIndex { $0.id == id} ?? 0
            if viewModel.searchMost[indx].following {viewModel.searchMost[indx].following = false}else {viewModel.searchMost[indx].following = true}
        case .user:
            let indx : Int = viewModel.searchPeople.firstIndex { $0.id == id} ?? 0
            if viewModel.searchPeople[indx].following {viewModel.searchPeople[indx].following = false}else {viewModel.searchPeople[indx].following = true}
        default : break
        }
    }
}


