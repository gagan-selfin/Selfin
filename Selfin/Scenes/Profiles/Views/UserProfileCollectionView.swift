//
//  UserProfileCollectionView.swift
//  Selfin
//
//  Created by Marlon Monroy on 11/7/18.
//  Copyright © 2018 Selfin. All rights reserved.
//

import UIKit
enum profileType {
    case publicProfile
    case userProfile
}
class UserProfileCollectionView: UICollectionView, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    weak var headerView: ReusableProfileHeaderView?
    var currentStyle: UserProfileCollectionStyle = .grid
    weak var controller: UserFeedCollectionDelegate?
    let layout = UICollectionViewFlowLayout()
    var didSelectLayout: ((_ layout: UserProfileCollectionStyle) -> Void)?
    let viewModel = ProfileCollectionViewModel()
    var isSuccess: ((PostLikeResponse) -> Void)?
    fileprivate var isPrivate = false
    let layoutGrid = MosaicLayoutFlow()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setup()
        
       
    }

    func setup() {
        delegate = self
        dataSource = self
        viewModel.collection = self
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 5
        grid()

        collectionViewLayout = layout
        alwaysBounceVertical = true
        
        register(UINib(nibName: "ReusableProfileHeaderView", bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "profileHeader")

    }

    private func grid() {
        layout.sectionInset = UIEdgeInsets(top: 10, left: 4, bottom: 0, right: 4)
        layout.itemSize = CGSize(width: UIScreen.main.bounds.width / 4 - 5, height: UIScreen.main.bounds.width / 4 - 5)
    }

    private func list() {
        layout.sectionInset = UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 0)
         collectionViewLayout = layout
        layout.itemSize = CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height / 2)
    }

    private func layout(for style: UserProfileCollectionStyle) {
        if isPrivate {list(); return}
        switch style {
        case .grid, .tags,.mention, .heart: grid()
        case .list: list()
        }
        reloadData()
    }
    
    func collectionView(_: UICollectionView, willDisplay _: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        viewModel.handlePagination(currentStyle: currentStyle, indexPath: indexPath, controller: controller)
    }

    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "profileHeader", for: indexPath) as! ReusableProfileHeaderView

        self.headerView = headerView
        headerView.onStyleSelected = { [weak self] in
            self?.currentStyle = $0
            if $0 != .list && $0 != .grid {self?.viewModel.isFetched = false}
            self?.viewModel.setBaseLayout(style: self?.currentStyle ?? .grid , controller: self?.controller)
            self?.layout(for: $0)
            self?.didSelectLayout?($0);
            self?.controller?.userProfileCollectionActions(action: .switchLayout(style: $0))
        }
        
        headerView.didSelectProfileOptions = { [weak self](action,username) in
            self?.viewModel.actionOverUserProfileDetails(action: action, controller: self?.controller, username: username)
        }
        
        headerView.didSelectEditImage = {[weak self] in
            self?.controller?.userProfileCollectionActions(action: .editImage())
        }
        return headerView
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        headerView?.layoutIfNeeded()
        return CGSize(width: collectionView.frame.width, height: headerView?.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize).height ?? 320)
    }
    
    //MARK:- Custome methods
    func display(posts: [HomeFeed.Post], with style: UserProfileCollectionStyle, type :profileType) {
        if type == .publicProfile && posts.count == 0 {}else{
            viewModel.isFetched = true
            viewModel.hasMore = posts.count > 0
            if viewModel.page == 1 { viewModel.posts.removeAll() }
            viewModel.posts.append(contentsOf: posts)
            if currentStyle == .list || currentStyle == .grid {
                layout(for: style)}
        }
    }
    
    func display(data : [TaggedLikedPostResponse.Post], style : UserProfileCollectionStyle, type :profileType ) {
        if type == .publicProfile && data.count == 0 {}else{
        viewModel.isFetched = true
        if style == .heart {
            viewModel.hasMoreLikes = data.count > 0
            if viewModel.pageLike == 1 { viewModel.likedPost.removeAll() }
            viewModel.likedPost.append(contentsOf: data)
            if currentStyle == .heart {layout(for: style)}
            return}
        viewModel.hasMoreMention = data.count > 0
        if viewModel.pageMention == 1 { viewModel.mentionedPost.removeAll() }
        viewModel.mentionedPost.append(contentsOf: data)
        if currentStyle == .mention {layout(for: style)}
    }}
    
    func deletePost(id: Int, index: IndexPath){
        performBatchUpdates({
            viewModel.posts.remove(at: index.item)
            self.deleteItems(at: [index])
        }, completion: { (true) in
            self.reloadData()
        })
    }
    
    func updateNotificationSettings(feeds: HomeFeed.Post) {
        let index : Int = viewModel.posts.index(where: {$0.id == feeds.id}) ?? 0
        if viewModel.posts[index].is_notifying {viewModel.posts[index].is_notifying = false}else {viewModel.posts[index].is_notifying = true}
        reloadItems(at: [IndexPath.init(row: index, section: 0)])
    }
}

extension UserProfileCollectionView {
    func collectionView(_: UICollectionView, numberOfItemsInSection _: Int) -> Int {
        if isPrivate {return 1}
        switch currentStyle {
        case .grid,.list:
            return viewModel.countForUsersPost(collectionView: self, headerView: headerView)
        case .mention:
            return viewModel.countForTaggedPosts(collectionView: self, headerView: headerView)
        case .heart:
            return viewModel.countForUsersLikedPosts(collectionView: self, headerView: headerView)
        case .tags:
            return 0
        }
    }

    @available(iOS 6.0, *)
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if isPrivate {
            let cell = dequeueReusable(indexPath) as PrivateAccountCollectionViewCell
            return cell
        }
        return cell(for: indexPath)
    }
    
	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if !isPrivate { viewModel.didSelectPost(currentStyle: currentStyle, indexPath: indexPath, controller: controller)}
	}
    
    func cell(for index: IndexPath) -> UICollectionViewCell {
        switch currentStyle {
        case .grid, .tags:
            let cell = dequeueReusable(index) as DiscoverReusableCollectionViewCell
            if viewModel.posts.count == 0 { cell.skeleton() } else {
                cell.configure(with: viewModel.posts[index.row])}
            return cell
        case .list:
            let cell = dequeueReusable(index) as ReusableFeedCollectionViewCell
				cell.delegate = self
            cell.tag = index.item
            if viewModel.posts.count == 0 { cell.skeleton() } else {
                cell.configure(with: viewModel.posts[index.row]) }
            return cell
        case .mention:
            let cell = dequeueReusable(index) as DiscoverReusableCollectionViewCell
            if viewModel.mentionedPost.count == 0 { cell.skeleton() } else {
                cell.configure(with: viewModel.mentionedPost[index.row])}
            return cell
        case .heart:
            let cell = dequeueReusable(index) as DiscoverReusableCollectionViewCell
            if viewModel.likedPost.count == 0 { cell.skeleton() } else {
                cell.configure(with: viewModel.likedPost[index.row])}
            return cell
        }
    }
    
    func performLikeDislikeOperation(gestureRecongnizer: UIGestureRecognizer, like : likeTypes) {
        let tappedPoint = gestureRecongnizer.location(in: self)
        let tappedIndexpath = indexPathForItem(at: tappedPoint)
       if let indexpath = tappedIndexpath {
        let action : likeAction!
        let cell = cellForItem(at: indexpath) as! ReusableFeedCollectionViewCell
        
        if like == .like {
            if cell.imgViewLike.image == #imageLiteral(resourceName: "likelite") {action = likeAction.dislike}
            else if cell.imgViewLike.image == #imageLiteral(resourceName: "likeSelected") {action = likeAction.dislike}
            else {action = likeAction.like}
            
            viewModel.like(postId: viewModel.posts[(tappedIndexpath?.row)!].id, action: action)
            isSuccess = {data in
                if data.status {
                    if data.message == likeActionResponse.liked.rawValue{
                        cell.imgViewLike.image = #imageLiteral(resourceName: "likelite")
                        self.viewModel.posts[(tappedIndexpath?.row)!].is_liked = true
                        self.viewModel.posts[(tappedIndexpath?.row)!].is_super_liked = false
                    }
                    else{
                        cell.imgViewLike.image = #imageLiteral(resourceName: "likeCount")
                        self.viewModel.posts[(tappedIndexpath?.row)!].is_liked = false
                        self.viewModel.posts[(tappedIndexpath?.row)!].is_super_liked = false
                    }
                }
            }
        }else {
            if cell.imgViewLike.image == #imageLiteral(resourceName: "likeSelected") {action = likeAction.dislike}
            else {action = likeAction.superlike}
            
            viewModel.like(postId: viewModel.posts[(tappedIndexpath?.row)!].id, action: action)
            isSuccess = {data in
                if data.status {
                    if data.message == likeActionResponse.superliked.rawValue || data.message == "Super Liked."{
                        cell.imgViewLike.image = #imageLiteral(resourceName: "likeSelected")
                        self.viewModel.posts[(tappedIndexpath?.row)!].is_super_liked = true
                        self.viewModel.posts[(tappedIndexpath?.row)!].is_liked = false
                    }
                    else{
                        cell.imgViewLike.image = #imageLiteral(resourceName: "likeCount")
                        self.viewModel.posts[(tappedIndexpath?.row)!].is_liked = false
                        self.viewModel.posts[(tappedIndexpath?.row)!].is_super_liked = false
                    }
                }
            }
        }}
    }
    
    func updateLayout(for orientation: UIDeviceOrientation) {
        if orientation.isLandscape {
            clipsToBounds = false
            layout.itemSize = CGSize(width: UIScreen.main.bounds.height / 2, height: UIScreen.main.bounds.width - 30)
            layout.scrollDirection = .horizontal
            layout.invalidateLayout()
            return
        }
        clipsToBounds = true
        layout.itemSize = CGSize(width: UIScreen.main.bounds.height, height: UIScreen.main.bounds.width / 2)
        layout.scrollDirection = .vertical
        layout.invalidateLayout()
    }
    
    func prepareForRefresh() {
        viewModel.refreshData(currentStyle: currentStyle, collectionView: self, controller: controller)
    }
}

extension UserProfileCollectionView: UserProfileFeedItemDelegate, ProfileCollection {
    
    func didReceived(data: followUnfollowUser) {
        headerView?.didFollowUnfollow()
    }
    
    func userFeedItemActions(action: UserProfilePostItemAction) {
        switch action {
        case .likeButtonPressed( _, let like, let gesture):
            performLikeDislikeOperation(gestureRecongnizer: gesture, like: like)
        case .postSelected(let post):
            controller?.userProfileCollectionActions(action: .postSelected(post: post))
        default:
            controller?.userProfileCollectionActions(action: .postAction(action: action))
        }
    }
    
    func display(profile: Profile) {
        headerView?.display(profile: profile)
    }
    
    func display(profile: OthersProfile) {
        if profile.user.isPrivate && !profile.user.isRequestedAccepted {
            isPrivate = profile.user.isPrivate
            list()
            reloadData()
        }
        headerView?.display(profile: profile)
    }
    
    func didReceived(feed: PostLikeResponse) {isSuccess?(feed)}
    
    func didReceived(error msg: String) {}
}




