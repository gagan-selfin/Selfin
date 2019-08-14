//
//  ChatRoomViewController.swift
//  Selfin
//
//  Created by cis on 26/09/18.
//  Copyright © 2018 Selfin. All rights reserved.
//

import AVKit
import Nuke
import UIKit

class ChatRoomViewController: UIViewController {
    @IBOutlet var tableViewChatRoom: ChatRoomTableView!
    @IBOutlet var textView: WriteMessageTextView!
    @IBOutlet var bottomViewHeight: NSLayoutConstraint!
    @IBOutlet var bottomViewConstrait: NSLayoutConstraint!
    let picker = MediaPickerViewController()
    let viewModel = ChatRoomViewModel()
    let imageViewUser = UIImageView()
    var user = HSChatUsers()
    weak var delegate : openSelfInCamera?
   
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        navigationController?.hidesBarsOnSwipe = false
        if #available(iOS 11.0, *) {
            navigationController?.navigationBar.prefersLargeTitles = true
        } else {// Fallback on earlier versions
        }
    }

    fileprivate func setup() {
        backButton()
        
        let tap = UITapGestureRecognizer.init(target: self , action: #selector(viewUserProfile))
        imageViewUser.addGestureRecognizer(tap)

        self.navigationItem.title = user.name
        navigationItem.rightBarButtonItem = viewModel.showUserImageAtTop(imageViewUser)

        textView.viewHeight = bottomViewHeight
        textView.placeholderText = "Type a message..."
        textView.text = "Type a message..."
        
        viewModel.delegate = self
        tableViewChatRoom.controller = self
        picker.mediaDelegate = self

        viewModel.function_LoadData(pageingID: user.lastMessage, ChatId: user.chatID)

        if user.image != "" {
            Nuke.loadImage(with: URL(string: user.image)!, into: imageViewUser)
        }else {imageViewUser.image = UIImage.init(named: "Placeholder_image")}
        
        didRegisterKeyboardNotification()
        didRegisterCameraNotification()
    }

    //MARK:- UI Actions
    @IBAction func actionAttachMedia(_ sender: Any) {
        showPostSheet()
    }

    @IBAction func actionSendMessage(_ sender: Any) {
        if textView.text != textView.placeholderText &&  textView.text != "" {
            viewModel.sendMessage(type: .text, senderDetail: user, textMessage: textView.text!, image: nil, video: nil, lastMessage: tableViewChatRoom?.lastMessageId ?? "")
            textView.text = ""
            bottomViewHeight.constant = 60.0
        }
    }

    //MARK:- Custom Method
    @objc func selectedImage(notification: Notification) {
        if notification.object != nil {
            let dict: [String: Any] = notification.object as! [String: Any]
            if let decodedImageData = Data(base64Encoded: dict["image"] as! String, options: .ignoreUnknownCharacters) {
                let image = UIImage(data: decodedImageData)
                showLoader()
                 viewModel.sendMessage(type: .image, senderDetail: user, textMessage: nil, image: image, video: nil, lastMessage: tableViewChatRoom?.lastMessageId ?? "")
            }}
    }
    
    func showPostSheet() {
        let actionSheet = UIAlertController.PostAction(titles: MessageType.image.rawValue,MessageType.camera.rawValue, handler: postActionHandler)
        self.present(actionSheet, animated: true)
    }

    func postActionHandler(_ alert:UIAlertAction) {
        guard let title = alert.title else { return}
        switch title {
        case MessageType.image.rawValue:
            self.present(picker, animated: true, completion: nil)
        case MessageType.video.rawValue:
            picker.mediaTypes = ["public.movie"]
            self.present(picker, animated: true, completion: nil)
        case MessageType.camera.rawValue:
            delegate?.openCamera()
        default:
            break
        }
    }

    func showVideo(url : String) {
        if let videoURL = URL(string: url) {
            let playerViewController = AVPlayerViewController()
            playerViewController.player = AVPlayer(url: videoURL)
            self.present(playerViewController, animated: true) {
                if let isPLayer = playerViewController.player {
                    isPLayer.play()
                }
            }
        }
    }

    func showImage(url : String) {
        let showImage = HSImageSlider(nibName: "HSImageSlider", bundle: nil)
        showImage.imageStringUrl = [url]
        showImage.selectedIndex = 0
        self.present(showImage, animated: true, completion: nil)
    }
    
    func didRegisterKeyboardNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardNotification), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardNotification), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func didRegisterCameraNotification() {
         NotificationCenter.default.addObserver(self, selector: #selector(selectedImage(notification:)), name: NSNotification.Name(rawValue: "setProfileImage"), object: nil)
    }
    
    @objc func handleKeyboardNotification(_ notification: Notification) {
        if let userInfo = notification.userInfo {
            let keyboardFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as AnyObject).cgRectValue
            let isKeyboardShowing = notification.name == UIResponder.keyboardWillShowNotification
            bottomViewConstrait?.constant = isKeyboardShowing ? -keyboardFrame!.height : 0
            UIView.animate(withDuration: 0.5, animations: { () -> Void in
                self.view.layoutIfNeeded()
            })
        }
    }
    
    @objc func viewUserProfile(){delegate?.didMoveToProfile(username: user.name)}
}

extension ChatRoomViewController : ChatRoomViewDelegate, ChatRoomOpenMediaDelegate {
    func didReceived(error msg: String) {hideLoader()}

    func mediaMessageSentSuccess(){hideLoader()}

    func openMediaFiles(type: MessageType, mediaPath: String) {
        switch type {
        case .image:
            showImage(url: mediaPath)
        case .video:
            showVideo(url: mediaPath)
        default :
            break
        }
    }

    func didRecieveMessage(user : HSBubble) {
        user.image = self.user.image;
        self.tableViewChatRoom.display(message: user)}
}

extension ChatRoomViewController : MediaPickerDelegate {
    func didRecieveMedia(type :MessageType, image: UIImage?, videoURL: URL?) {
        showLoader()
        if type == .image {
            viewModel.sendMessage(type: .image, senderDetail: self.user, textMessage: nil, image: image, video: nil, lastMessage: tableViewChatRoom?.lastMessageId ?? "")
            return
        }
        viewModel.sendMessage(type: .video, senderDetail: self.user, textMessage: nil, image: nil, video: videoURL, lastMessage: tableViewChatRoom?.lastMessageId ?? "")
    }
}
