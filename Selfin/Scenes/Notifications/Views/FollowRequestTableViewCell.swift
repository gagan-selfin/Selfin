//
//  FollowRequestTableViewCell.swift
//  Selfin
//
//  Created by cis on 27/11/18.
//  Copyright © 2018 Selfin. All rights reserved.
//

import UIKit
import Nuke

class FollowRequestTableViewCell: UITableViewCell {

    @IBOutlet weak var btnRequest: UIButton!
    @IBOutlet var imageViewRequest: UIImageView!
    @IBOutlet var labelRequestTime: UILabel!
    @IBOutlet var buttonAcceptRequest: UIButton!
    @IBOutlet var buttonDeclineRequest: UIButton!
    @IBOutlet var content: AttrTextView!
    
    let viewModel = NotificationViewModel()
    let viewModelFollow = PostDetailsViewModel()
    var userName = String()
    var notification : UserNotification.NotificationType!
    var index:Int?
     weak var delegate:navigationFromCells?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        viewModelFollow.controller = self
        viewModel.delegate = self
    }

    func configureFollowRequestCell(notification:UserNotification.NotificationType, username:String, index:Int, type : Type_Notification ) {
        self.index = index
        self.notification = notification
        userName = notification.targetUser.userName
        
        if notification.time != "" {labelRequestTime.text = notification.timeAgo}
        else {labelRequestTime.text = ""}
        
        let imageURL = notification.user.profile_Image
        
        if notification.user.profileImage == "" {
            imageViewRequest.image = #imageLiteral(resourceName: "Placeholder_image")
            imageViewRequest.backgroundColor = UIColor.clear
        } else {
            let url = URL(string: imageURL)
            Nuke.loadImage(with: url!, into: imageViewRequest)
            imageViewRequest.backgroundColor = UIColor.init(red: 242.0/255.0, green: 241/255.0, blue: 239/255.0, alpha: 1.0)
        }
        
        if notification.user.following {
            imageViewRequest.layer.cornerRadius = imageViewRequest.frame.height / 2
            imageViewRequest.clipsToBounds = true
        } else {
//            if notification.user.userName == username {
//                imageViewRequest.layer.cornerRadius = imageViewRequest.frame.height / 2
//                imageViewRequest.clipsToBounds = true
//            } else {
                imageViewRequest.layer.cornerRadius = 5
                imageViewRequest.clipsToBounds = true
            //}
        }

        content.setText(text: notification.description, type: .username, andCallBack: callBack(string:type:))
        
        if type == .type_self { requestStatusCheck(notification: notification); return}
        requestStatusCheckSocial(notification: notification)
       
    }
    
    func callBack(string : String , type : wordType){
        switch type {
        case .username:
            print(string)
            delegate?.didMove(to: .profile(username: string))
        default: break
        }
    }
    
    func buttonAcceptUI(text : String){
        buttonAcceptRequest.layer.borderColor = UIColor(red: 249 / 255, green: 64 / 255, blue: 148 / 255, alpha: 1).cgColor
        self.buttonAcceptRequest.setTitleColor(UIColor(red: 249 / 255, green: 64 / 255, blue: 148 / 255, alpha: 1), for: .normal)
        buttonAcceptRequest.layer.borderWidth = 1.5
       self.buttonAcceptRequest.setTitle(text, for: .normal)
    }
    
    func buttonDeclineUI(){
        buttonDeclineRequest.isHidden = false
        buttonDeclineRequest.layer.borderColor = UIColor(red: 74 / 255, green: 74 / 255, blue: 74 / 255, alpha: 1).cgColor
        buttonDeclineRequest.layer.borderWidth = 1.5
    }
    
    func requestStatusCheck(notification:UserNotification.NotificationType){
        if notification.targetUser.isRequestedAcceptedByYou {
            if notification.targetUser.following {//Logged in user following
                if notification.targetUser.isRequestedAcceptedFromThem {//show following
                    showFollowing()
                }else {//show pending
                    showPending()
                }
            }else {
               showFollow()
            }
        }else {
           acceptOrDeclineRequest()
        }
    }
    
    func requestStatusCheckSocial(notification:UserNotification.NotificationType){
            if notification.targetUser.following {//Logged in user following
                if notification.targetUser.isRequestedAcceptedFromThem {//show following
                    showFollowing()
                }else {//show pending
                    showPending()
                }
            }else {
                showFollow()
            }
    }
    
    func acceptOrDeclineRequest() {
        buttonAcceptUI(text: "Accept")
        buttonDeclineUI()
        buttonAcceptRequest.isUserInteractionEnabled = true
        buttonAcceptRequest.tag = 100
    }
    
    func showFollow() {
        buttonAcceptRequest.tag = 101
        buttonAcceptUI(text: "Follow")
        buttonAcceptRequest.setImage(#imageLiteral(resourceName: "follow"), for: .normal)
        buttonAcceptRequest.imageEdgeInsets.right = 10
        buttonAcceptRequest.isUserInteractionEnabled = true
        buttonDeclineRequest.isHidden = true
    }
    
    func showPending() {
        buttonAcceptRequest.setImage(nil, for: .normal)
        buttonAcceptRequest.imageEdgeInsets.right = 0
        self.buttonAcceptRequest.setTitleColor(UIColor(red: 74 / 255, green: 74 / 255, blue: 74 / 255, alpha: 1), for: .normal)
        self.buttonAcceptRequest.layer.borderColor = UIColor(red: 74 / 255, green: 74 / 255, blue: 74 / 255, alpha: 1).cgColor
        buttonAcceptRequest.layer.borderWidth = 1.5
        self.buttonAcceptRequest.setTitle("Pending", for: .normal)
        buttonAcceptRequest.isUserInteractionEnabled = false
        buttonDeclineRequest.isHidden = true
    }
    
    func showFollowing() {
        buttonAcceptRequest.setImage(nil, for: .normal)
        buttonAcceptRequest.imageEdgeInsets.right = 0
        buttonAcceptUI(text: "Following")
        buttonAcceptRequest.isUserInteractionEnabled = false
        buttonDeclineRequest.isHidden = true
        self.buttonAcceptRequest.setTitleColor(UIColor(red: 249 / 255, green: 64 / 255, blue: 148 / 255, alpha: 1), for: .normal)
        self.buttonAcceptRequest.layer.borderColor = UIColor(red: 249 / 255, green: 64 / 255, blue: 148 / 255, alpha: 1).cgColor
    }
    
    @IBAction func acceptRequestPressed(_ sender: UIButton) {
        if sender.tag == 101
        {viewModelFollow.callFollowUnfollowUserAPI(username: userName)}
        else{
            viewModel.accept(username: notification.targetUser.userName, id: notification.id)
        }
    }
    @IBAction func declineRequestPressed(_ sender: Any) {
        viewModel.decline(username: notification.targetUser.userName, id: notification.id)
    }

    func manageFollowStatus (data: followUnfollowUser) {
        if (data.status) {
                if data.isRequestApproved {
                    showFollowing()
                }else {
                     showPending()
                }
        }
    }
    
    func setUpRequestAccept(status:AcceptResquestResponse) {
            if !(status.notification.user.following) {
                showFollow()
            } else {
                showFollowing()
        }
    }
}

extension FollowRequestTableViewCell:NotificationControllerDelegate,PostDetailController {
    func viewModalActions(action: PostViewModalAction) {
        switch action {
        case let .followUnFollow(follows):
            manageFollowStatus(data: follows)
        default:
            break
        }
    }

    func didReceived(status:AcceptResquestResponse)
    {setUpRequestAccept(status: status)}
    
    func didReceived(status:ReusableResponse){
        if status.status {
            let dict = ["index":index]
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "declineRequest"), object: dict, userInfo: nil)
        }
    }
    
    func didFailed(error msg:String){print(msg)}
}

extension UITapGestureRecognizer {
    
    func didTapAttributedTextInLabel(label: UILabel, inRange targetRange: NSRange) -> Bool {
        // Create instances of NSLayoutManager, NSTextContainer and NSTextStorage
        let layoutManager = NSLayoutManager()
        let textContainer = NSTextContainer(size: CGSize.zero)
        let textStorage = NSTextStorage(attributedString: label.attributedText!)
        
        // Configure layoutManager and textStorage
        layoutManager.addTextContainer(textContainer)
        textStorage.addLayoutManager(layoutManager)
        
        // Configure textContainer
        textContainer.lineFragmentPadding = 0.0
        textContainer.lineBreakMode = label.lineBreakMode
        textContainer.maximumNumberOfLines = label.numberOfLines
        let labelSize = label.bounds.size
        textContainer.size = labelSize
        
        // Find the tapped character location and compare it to the specified range
        let locationOfTouchInLabel = self.location(in: label)
        let textBoundingBox = layoutManager.usedRect(for: textContainer)
        
        let textContainerOffset = CGPoint(x: (labelSize.width - textBoundingBox.size.width) * 0.5 - textBoundingBox.origin.x, y: (labelSize.height - textBoundingBox.size.height) * 0.5 - textBoundingBox.origin.y)
        
        let locationOfTouchInTextContainer = CGPoint(x: locationOfTouchInLabel.x - textContainerOffset.x, y: locationOfTouchInLabel.y - textContainerOffset.y)
        let indexOfCharacter = layoutManager.characterIndex(for: locationOfTouchInTextContainer, in: textContainer, fractionOfDistanceBetweenInsertionPoints: nil)
        return NSLocationInRange(indexOfCharacter, targetRange)
    }
    
}

extension Range where Bound == String.Index {
    var nsRange:NSRange {
        return NSRange(location: self.lowerBound.encodedOffset,
                       length: self.upperBound.encodedOffset -
                        self.lowerBound.encodedOffset)
    }
}
