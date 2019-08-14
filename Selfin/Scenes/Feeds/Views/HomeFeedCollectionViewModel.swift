//
//  HomeFeedCollectionViewModel.swift
//  Selfin
//
//  Created by cis on 13/12/18.
//  Copyright © 2018 Selfin. All rights reserved.
//

import Foundation
import Nuke

protocol HomeFeedCollection: class {
    func didReceived(feed: PostLikeResponse)
    func didReceived(error msg: String)
}

final class HomeFeedCollectionViewModel {
    let task = PostTask ()
    weak var collection:HomeFeedCollection?
    func like (postId:Int,action:likeAction) {
        task.like(id: postId, params: PostTaskParams.Like(action:action.rawValue))
            .done{self.collection?.didReceived(feed: $0)}
            .catch{self.collection?.didReceived(error: String(describing: $0))}
    }
    
    var didImageFetch: ((_ index: Int) -> Void)?
    func manageSizeOfCellForDiffrentModes(feed : [HomeFeed.Post], index : IndexPath) -> CGSize {
        switch UIDevice.current.orientation {
        case .portrait,.portraitUpsideDown:
            if UIScreen.main.bounds.width > UIScreen.main.bounds.height {
                return  CGSize(width: UIScreen.main.bounds.height, height: UIScreen.main.bounds.width/2)
            }else {
                return CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height/2)
            }
        case .landscapeRight, .landscapeLeft :
            if feed.count > 0 {
                let imgView = UIImageView()
                imgView.tag = index.item
                let post = feed[index.item]
                if let postUrl = URL(string: post.postImage) {
                    Nuke.loadImage(with: postUrl, options: ImageLoadingOptions.shared, into: imgView, progress: nil) { _, _ in
                        self.didImageFetch?(imgView.tag)
                    }
                }
                return imgView.image?.size ?? CGSize(width: UIScreen.main.bounds.width / 2, height: UIScreen.main.bounds.height)
            }else {
                if UIScreen.main.bounds.width > UIScreen.main.bounds.height {
                    return CGSize(width: UIScreen.main.bounds.width / 2, height: UIScreen.main.bounds.height)
                }else {
                    return CGSize(width: UIScreen.main.bounds.height / 2, height: UIScreen.main.bounds.width)
                }
            }
        case .unknown, .faceUp, .faceDown:
            switch UIApplication.shared.statusBarOrientation {
            case .portrait,.portraitUpsideDown:
                if UIScreen.main.bounds.width > UIScreen.main.bounds.height {
                    return  CGSize(width: UIScreen.main.bounds.height, height: UIScreen.main.bounds.width/2)
                }else {
                    return CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height/2)
                }
            default:
                if feed.count > 0 {
                    let imgView = UIImageView()
                    imgView.tag = index.item
                    let post = feed[index.item]
                    if let postUrl = URL(string: post.postImage) {
                        Nuke.loadImage(with: postUrl, options: ImageLoadingOptions.shared, into: imgView, progress: nil) { _, _ in
                            self.didImageFetch?(imgView.tag)
                        }
                    }
                    return imgView.image?.size ?? CGSize(width: UIScreen.main.bounds.width / 2, height: UIScreen.main.bounds.height)
                }else {
                    if UIScreen.main.bounds.width > UIScreen.main.bounds.height {
                        return CGSize(width: UIScreen.main.bounds.width / 2, height: UIScreen.main.bounds.height)
                    }else {
                        return CGSize(width: UIScreen.main.bounds.height / 2, height: UIScreen.main.bounds.width)
                    }
                }
            }
        }
    }
}
