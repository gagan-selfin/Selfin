//
//  SubAccountCollectionView.swift
//  Selfin
//
//  Created by cis on 21/02/2019.
//  Copyright © 2019 Selfin. All rights reserved.
//

import UIKit

class SubAccountCollectionView: UICollectionView {
    var arrayAccountList = [SubSelfinAccounts.AccountList]()
    weak var controller : didFollowAccounts?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setup()}
    
    fileprivate func setup() {
        delegate = self
        dataSource = self
        register(UINib(nibName: "SubAccountsCollectionReusableView", bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "SubAccountsReusableView")
    }
    
    func cell(indexpath : IndexPath) -> UICollectionViewCell {
        let cell = dequeueReusableCell(withReuseIdentifier: "SubAccount", for: indexpath) as! SubAccountCollectionViewCell
        if arrayAccountList.count == 0 {cell.loading()}else { cell.configure(data: arrayAccountList[indexpath.item]); cell.onFollow = onFollow}
        return cell
    }
    
    func display(data : SubSelfinAccounts){
        arrayAccountList = data.accounts
        reloadData()
    }
    
    func updateUI(username:String){
        guard let i = arrayAccountList.index(where:{$0.username == username})else { return }
        arrayAccountList[i].following = true
        reloadItems(at: [IndexPath(row: i, section: 0)])
    }
    
    func onFollow(username : String){controller?.didFollowSubAccount(username : username)}
    var didSelect:((_ user : String)-> ())?
}

extension SubAccountCollectionView : UICollectionViewDataSource,UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int { return arrayAccountList.count > 0 ? arrayAccountList.count : 10 }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return cell(indexpath: indexPath)
    }
    
    @available(iOS 6.0, *)
    public func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
         let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "SubAccountsReusableView", for: indexPath) as! SubAccountsCollectionReusableView
        headerView.onStyleSelected = { [weak self] in
           self?.controller?.didFollowAllSubAccounts()
        }
        return headerView
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        didSelect?(arrayAccountList[indexPath.item].username)
    }
}

extension SubAccountCollectionView : UICollectionViewDelegateFlowLayout {
    @available(iOS 6.0, *)
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch UIApplication.shared.statusBarOrientation {
        case .portrait,.portraitUpsideDown:
            return CGSize.init(width: UIScreen.main.bounds.width, height: 85)
        default:  return CGSize.init(width: UIScreen.main.bounds.width, height: 65)}
    }
    
    @available(iOS 6.0, *)
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        switch UIApplication.shared.statusBarOrientation {
        case .portrait,.portraitUpsideDown:
            return CGSize.init(width: UIScreen.main.bounds.width, height: 230)
        default:  return CGSize.init(width: UIScreen.main.bounds.width, height: 180)}
        
    }
}
