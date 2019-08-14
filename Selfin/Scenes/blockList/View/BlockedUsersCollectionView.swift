//
//  BlockedUsersCollectionView.swift
//  Selfin
//
//  Created by cis on 04/02/2019.
//  Copyright © 2019 Selfin. All rights reserved.
//

import UIKit
import SkeletonView
import Nuke
protocol BlockedUsersCellDelegate : class {
    func didUnblockUser(username : String, index : Int)
}
protocol BlockedUsersCollectionViewDelegate : class {
    func didUnblockUser(username : String, index : Int)
    func fetchMore(page : Int)
}
class BlockedUsersCell : UICollectionViewCell {
    weak var delegate: BlockedUsersCellDelegate?
    @IBOutlet var imageview: UIImageView!
    @IBOutlet var labelUsername: UILabel!
    @IBOutlet var labelName: UILabel!
    @IBOutlet var buttonBlock: UIButton!
    var user : BlockList.User!
    var index : Int!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    @IBAction func actionUnBlockUser(_ sender: Any) {
        delegate?.didUnblockUser(username: user.username, index: index)
    }
    
    func configure(user : BlockList.User, index : IndexPath) {
        stopAnimate()
        self.index = index.item
        self.user = user
        labelName.text = user.name
        labelUsername.text = user.username
        if user.image != "" {
            if let urlProfile = URL(string: user.profileImage) {
                Nuke.loadImage(with: urlProfile, into: imageview)
            }
        }else {imageview.image = UIImage.init(named: "Placeholder_image")}
    }
    
    func skeleton() {
        [imageview, labelUsername, labelName,buttonBlock].forEach { v in
            v?.showAnimatedSkeleton()
        }
    }
    
    func stopAnimate(){
        [imageview, labelUsername, labelName,buttonBlock].forEach { v in
            v?.hideSkeleton()
        }
    }
}

class BlockedUsersCollectionView: UICollectionView {
    weak var controller: BlockedUsersCollectionViewDelegate?
    var blockedUsers : [BlockList.User] = []
    var page = 1
    var hasMore = true
    
    override func awakeFromNib() {
        super.awakeFromNib()
        delegate = self
        dataSource = self
        register(UINib(nibName: "ReusableFooterCollectionReusableView", bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: "FooterView")
    }
    
    func display(users : [BlockList.User]) {
        hasMore = users.count > 0
        if page == 1 { blockedUsers.removeAll() }
        blockedUsers.append(contentsOf: users)
        reloadData()
    }
    
    func displayUnblockResult(index: Int) {
        let index = IndexPath.init(row: index, section: 0)
        performBatchUpdates({
            blockedUsers.remove(at: index.item)
            self.deleteItems(at: [index])
        }) { (true) in
            self.reloadData()}
    }
}

extension BlockedUsersCollectionView : UICollectionViewDataSource, UICollectionViewDelegate {
    @available(iOS 8.0, *)
    public func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.item == blockedUsers.count - 1 && hasMore {
            page += 1
            controller?.fetchMore(page: page)
        }
    }
    
    @available(iOS 6.0, *)
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if hasMore {return blockedUsers.count > 0 ? blockedUsers.count: 10}else {return blockedUsers.count}}
    
    @available(iOS 6.0, *)
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = dequeueReusableCell(withReuseIdentifier: "BlockedUsersCell", for: indexPath) as! BlockedUsersCell
        if blockedUsers.count > 0 {cell.configure(user : blockedUsers[indexPath.item], index: indexPath); cell.delegate = self}else {cell.skeleton()}
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionView.elementKindSectionFooter:
            let footerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "FooterView", for: indexPath) as! ReusableFooterCollectionReusableView
            return footerView
        default:
            return UICollectionReusableView()
        }
    }
}

extension BlockedUsersCollectionView : UICollectionViewDelegateFlowLayout , BlockedUsersCellDelegate {
    func didUnblockUser(username: String, index: Int) {
        controller?.didUnblockUser(username: username, index: index)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize.init(width: UIScreen.main.bounds.width - 20, height: 80)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        if blockedUsers.count ==  0 {
            return CGSize(width: collectionView.frame.width, height: 25)}
        else {return CGSize(width: collectionView.frame.width, height: 0)}
    }
}
