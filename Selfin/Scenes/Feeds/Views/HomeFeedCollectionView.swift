//
//  HomeFeedCollectionView.swift
//  Selfin
//
//  Created by Marlon Monroy on 11/6/18.
//  Copyright © 2018 Selfin. All rights reserved.
//

import SkeletonView
import UIKit
import OnlyPictures
extension HomeFeedCollectionView: OnlyPicturesDataSource {
    
    // ---------------------------------------------------
    // returns the total no of pictures
    
    func numberOfPictures() -> Int {
        return pictures.count
    }
    
    // ---------------------------------------------------
    // returns the no of pictures should be visible in screen.
    // In above preview, Left & Right formats are example of visible pictures, if you want pictures to be shown without count, remove this function, it's optional.
    
    func visiblePictures() -> Int {
        return 3
    }
    
    
    // ---------------------------------------------------
    // return the images you want to show. If you have URL's for images, use next function instead of this.
    // use .defaultPicture property to set placeholder image. This only work with local images. for URL's images we provided imageView instance, it's your responsibility to assign placeholder image in it. Check next function.
    // onlyPictures.defaultPicture = #imageLiteral(resourceName: "defaultProfilePicture")
//
    func pictureViews(index: Int) -> UIImage {
        return pictures[index]
    }
//
    
    // ---------------------------------------------------
    // If you do have URLs of images. Use below function to have UIImageView instance and index insted of 'pictureViews(index: Int) -> UIImage'
    // NOTE: It's your resposibility to assign any placeholder image till download & assignment completes.
    // I've used AlamofireImage here for image async downloading, assigning & caching, Use any library to allocate your image from url to imageView.
//
//    func pictureViews(_ imageView: UIImageView, index: Int) {
//
//        // Use 'index' to receive specific url from your collection. It's similar to indexPath.row in UITableView.
//        let url = URL(string: self.pictures[index])
//
//        imageView.image = #imageLiteral(resourceName: "Logo")   // placeholder image
//       // imageView.af_setImage(withURL: url!)
//
////        var url:NSURL = NSURL.URLWithString("http://myURL/ios8.png")
////        var data:NSData = NSData.dataWithContentsOfURL(url, options: nil, error: nil)
//        let data = try? Data(contentsOf: url!) //make sure your image in this url does exist, otherwise unwrap in a if let check / try-catch
//        imageView.image = UIImage(data: data!)
//
//    }
}
class HomeFeedCollectionView: UICollectionView {
    let viewModel = HomeFeedCollectionViewModel ()
    var feeds: [HomeFeed.Post] = []
    var page = 1
    var hasMore = true
    let layout = UICollectionViewFlowLayout()
    weak var delegateAction :UserFeedCollectionDelegate?
    var isExpanded = [Bool]()
    var pictures: [UIImage]  = [#imageLiteral(resourceName: "feed1"), #imageLiteral(resourceName: "fee2"), #imageLiteral(resourceName: "gallery"), #imageLiteral(resourceName: "feed1"), #imageLiteral(resourceName: "fee2"), #imageLiteral(resourceName: "gallery")]
    
    
        /*["http://insightstobehavior.com/wp-content/uploads/2017/08/testi-5.jpg", "https://cdn.wallpapersafari.com/79/67/oUExzR.jpg", "http://steezo.com/wp-content/uploads/2012/12/man-in-suit2-300x223.jpg","http://insightstobehavior.com/wp-content/uploads/2017/08/testi-5.jpg", "https://cdn.wallpapersafari.com/79/67/oUExzR.jpg", "http://steezo.com/wp-content/uploads/2012/12/man-in-suit2-300x223.jpg","http://insightstobehavior.com/wp-content/uploads/2017/08/testi-5.jpg"]
 */
    var isselected = false
    override func awakeFromNib() {
        super.awakeFromNib()
        
        setup()
    }

    func setup() {
        viewModel.collection = self
        delegate = self
        dataSource = self
        
        switch  UIDevice.current.orientation {
        case .portrait, .portraitUpsideDown:
            layout.itemSize = CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height / 2)
            layout.minimumInteritemSpacing = 5
            layout.minimumLineSpacing = 5
            collectionViewLayout = layout
            alwaysBounceVertical = true
            alwaysBounceHorizontal = false
        default:
            layout.itemSize = CGSize(width: UIScreen.main.bounds.width/2, height: UIScreen.main.bounds.height-30)
            layout.minimumInteritemSpacing = 5
            layout.minimumLineSpacing = 5
            collectionViewLayout = layout
            layout.scrollDirection = .horizontal
            alwaysBounceVertical = false
            alwaysBounceHorizontal = true
        }
        
    }

    func display(feeds: [HomeFeed.Post]) {
        hasMore = feeds.count > 0
        if page == 1 {self.feeds.removeAll()}
        self.feeds.append(contentsOf: feeds)
        isExpanded = Array(repeating: false, count: self.feeds.count)
        reloadData()
    }
    
    func updateNotificationSettings(feeds: HomeFeed.Post) {
        let index : Int = self.feeds.index(where: {$0.id == feeds.id}) ?? 0
        if self.feeds[index].is_notifying {self.feeds[index].is_notifying = false}else {self.feeds[index].is_notifying = true}
        reloadItems(at: [IndexPath.init(row: index, section: 0)])
    }
    
    func hideReportedPost(index : Int) {
        let indexPath = IndexPath.init(row: index, section: 0)
        performBatchUpdates({
            feeds.remove(at: index)
            self.deleteItems(at: [indexPath])
        }, completion: { (true) in
            self.reloadData()
        })
    }

    func collectionView(_: UICollectionView, willDisplay _: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.row == feeds.count - 1 && hasMore {
            page += 1
            delegateAction?.userProfileCollectionActions(action: .fetchMore(page: page))
            isExpanded = Array(repeating: false, count: feeds.count)
        }
    }
    var isSuccess: ((PostLikeResponse) -> Void)?
}

extension HomeFeedCollectionView : UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    
    @available(iOS 6.0, *)
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        switch UIApplication.shared.statusBarOrientation {
        case .portrait,.portraitUpsideDown:
            return UIEdgeInsets.init(top: 0, left: 0, bottom: 0, right: 0)
        default: return UIEdgeInsets.init(top: 12, left: 0, bottom: 0, right: 0)
        }
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if feeds.count != 0  {
            if !(isExpanded[indexPath.row]) {
                isExpanded[indexPath.row] = !isExpanded[indexPath.row]
                isselected = true
            }
            collectionView.reloadItems(at: [indexPath])
        }
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if feeds.count != 0  {
            switch UIDevice.current.orientation{
            case  .portrait, .portraitUpsideDown:
                clipsToBounds = true
                layout.scrollDirection = .vertical
                alwaysBounceVertical = true
                alwaysBounceHorizontal = false
                bounces = true
                layout.invalidateLayout()
                
                if UIScreen.main.bounds.width > UIScreen.main.bounds.height {
                    
                    if isExpanded[indexPath.row] == true {
                        
                        return CGSize(width: UIScreen.main.bounds.width, height: 500)
                    }else{
                        return CGSize(width: UIScreen.main.bounds.height, height: UIScreen.main.bounds.width/2)
                    }
                }else {
                  
                    if isExpanded[indexPath.row] == true {
                        
                        return CGSize(width: UIScreen.main.bounds.width, height: 500)
                    }else{
                    return CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height/2)
                }
                }
            case .landscapeLeft, .landscapeRight:
                clipsToBounds = false
                
                layout.scrollDirection = .horizontal
                alwaysBounceVertical = false
                alwaysBounceHorizontal = true
                bounces = true
                layout.invalidateLayout()
                
                if UIScreen.main.bounds.width > UIScreen.main.bounds.height {
                  
                    if isExpanded[indexPath.row] == true {
                        
                        return CGSize(width: UIScreen.main.bounds.width / 2, height: UIScreen.main.bounds.height)
                    }else{
                         return CGSize(width: UIScreen.main.bounds.width / 2.3, height: UIScreen.main.bounds.height-35)
                    }
                    
                }else {
                    
                    return CGSize(width: UIScreen.main.bounds.height / 2.3, height: UIScreen.main.bounds.width-35)
                }
               
            default:
                break
            }
            

        }
        return CGSize(width: UIScreen.main.bounds.width, height: 320)
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return cell(for: indexPath)
    }

    func collectionView(_: UICollectionView, numberOfItemsInSection _: Int) -> Int
    {if hasMore {return feeds.count > 0 ? feeds.count: 10}else {return feeds.count}
      //  return feeds.count > 0 ? feeds.count : 10
    }
    
    func cell(for index: IndexPath) -> UICollectionViewCell {
        let cell = dequeueReusable(index) as ReusableFeedCollectionViewCell
        
        cell.delegate = self
        cell.bottomHeightConst.constant = 0
        cell.viewBottom.isHidden = true
        if feeds.count == 0 { cell.skeleton() } else {
            
            
            switch UIDevice.current.orientation{
            case .portrait, .portraitUpsideDown:
                
                cell.leftConst.constant = 40
                cell.rightConst.constant = 40
            case .landscapeLeft, .landscapeRight :
                cell.leftConst.constant = 10
                cell.rightConst.constant = 10
            default:
                print("Another")
            }
            
            if isExpanded[index.row] == true {
                if isselected == true {
                    UIView.animate(withDuration: 0.06, delay: 0.0, options: UIView.AnimationOptions.curveEaseIn, animations: {
                        self.layout.minimumInteritemSpacing = 0
                        cell.leftConst.constant = 0
                        cell.rightConst.constant = 0
                        cell.mainView.layer.cornerRadius = 0
                        cell.bottomHeightConst.constant = 120
                        cell.viewBottom.isHidden = false
                        cell.onlyPictures.dataSource = self
                        cell.onlyPictures.backgroundColorForCount = .white
                        cell.onlyPictures.textColorForCount = .black
                        cell.constantTrailing_imgViewProfile.constant = 55.00
                        cell.constantLeading_imgViewLike.constant = 50.0
                        cell.onlyPictures.layoutIfNeeded()
                        cell.layoutIfNeeded()
                        
                        
                    }, completion: nil)
                   
                }
            }
            else{
                    UIView.animate(withDuration: 0.06, delay: 0.0, options: UIView.AnimationOptions.curveEaseIn, animations: {
                        cell.mainView.layer.cornerRadius = 10
                        cell.bottomHeightConst.constant = 0
                        cell.viewBottom.isHidden = true
                        cell.constantTrailing_imgViewProfile.constant = 10.0
                        cell.constantLeading_imgViewLike.constant = 15.0
                        cell.layoutIfNeeded()
                     }, completion: nil)
            
            }

            cell.layoutIfNeeded()
            cell.configure(with: feeds[index.row])
        }
        return cell
    }

    func performLikeDislikeOperation(gestureRecongnizer: UIGestureRecognizer, like : likeTypes) {
        let tappedPoint = gestureRecongnizer.location(in: self)
        let tappedIndexpath = indexPathForItem(at: tappedPoint)
        if let indexpath = tappedIndexpath {
        let action : likeAction!
        let cell = cellForItem(at: indexpath) as! ReusableFeedCollectionViewCell
        
        if like == .like {
            if cell.imgViewLike.image == #imageLiteral(resourceName: "feed_like") {action = likeAction.dislike}
            else if cell.imgViewLike.image == #imageLiteral(resourceName: "feed_superlike") {action = likeAction.dislike}
            else {action = likeAction.like}
            
            viewModel.like(postId: feeds[(tappedIndexpath?.row)!].id, action: action)
            isSuccess = {data in
                if data.status {
                    if data.message == likeActionResponse.liked.rawValue{
                        cell.imgViewLike.image = #imageLiteral(resourceName: "feed_like")
                        self.feeds[(tappedIndexpath?.row)!].is_liked = true
                        self.feeds[(tappedIndexpath?.row)!].is_super_liked = false
                    }
                    else{
                        cell.imgViewLike.image = #imageLiteral(resourceName: "feed_dislike")
                        self.feeds[(tappedIndexpath?.row)!].is_liked = false
                        self.feeds[(tappedIndexpath?.row)!].is_super_liked = false
                    }
                }
            }
        }else {
            if cell.imgViewLike.image == #imageLiteral(resourceName: "feed_superlike") {action = likeAction.dislike}
            else {action = likeAction.superlike}
            
            viewModel.like(postId: feeds[(tappedIndexpath?.row)!].id, action: action)
            isSuccess = {data in
                if data.status {
                    if data.message == likeActionResponse.superliked.rawValue {
                        cell.imgViewLike.image = #imageLiteral(resourceName: "feed_superlike")
                        self.feeds[(tappedIndexpath?.row)!].is_super_liked = true
                        self.feeds[(tappedIndexpath?.row)!].is_liked = false
                    }else{
                        cell.imgViewLike.image = #imageLiteral(resourceName: "feed_dislike")
                        self.feeds[(tappedIndexpath?.row)!].is_liked = false
                        self.feeds[(tappedIndexpath?.row)!].is_super_liked = false
                    }
                }
            }
        }}
    }
	/*
    func updateLayout(for orientation: UIDeviceOrientation) {
        switch orientation {
        case  .portrait, .portraitUpsideDown:
            clipsToBounds = true
            if UIScreen.main.bounds.width > UIScreen.main.bounds.height {
                layout.itemSize = CGSize(width: UIScreen.main.bounds.height, height: UIScreen.main.bounds.width/2)
            }else {
               layout.itemSize = CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height/2)
            }
            layout.scrollDirection = .vertical
            alwaysBounceVertical = true
            alwaysBounceHorizontal = false
            bounces = true
            layout.invalidateLayout()
        case .landscapeLeft, .landscapeRight:
            clipsToBounds = false
            if UIScreen.main.bounds.width > UIScreen.main.bounds.height {
                
                
                layout.itemSize = CGSize(width: UIScreen.main.bounds.width / 2, height: UIScreen.main.bounds.height)
            }else {
                layout.itemSize = CGSize(width: UIScreen.main.bounds.height / 2.5, height: UIScreen.main.bounds.width-30)
                
            }
            layout.scrollDirection = .horizontal
            alwaysBounceVertical = false
            alwaysBounceHorizontal = true
            bounces = true
            layout.invalidateLayout()
            return
        default:
            break
        }
    }
*/
    func prepareForRefresh() {
        page = 1
        feeds.removeAll()
    }
    
	func update(_ item:HomeFeed.Post) {
		guard let i = feeds.index(where:{$0.id == item.id})else { return }
		deleteItems(at: [IndexPath(row: i, section: 0)])
	}
}

extension HomeFeedCollectionView : UserProfileFeedItemDelegate, HomeFeedCollection {
    func didReceived(feed: PostLikeResponse) {isSuccess?(feed)}
   
    func didReceived(error msg: String) {}
    
    func userFeedItemActions(action: UserProfilePostItemAction) {
        switch action {
        case .likeButtonPressed( _, let like, let gesture):
            performLikeDislikeOperation(gestureRecongnizer: gesture, like: like)
        case .postSelected(let post):
            print(post)
            
        delegateAction?.userProfileCollectionActions(action: .postSelected(post: post))
        default:
            delegateAction?.userProfileCollectionActions(action: .postAction(action: action))
        }
    }
}
