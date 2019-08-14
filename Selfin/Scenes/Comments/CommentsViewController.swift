//
//  CommentsViewController.swift
//  Selfin
//
//  Created by cis on 18/09/2018.
//  Copyright © 2018 Selfin. All rights reserved.
//

import UIKit
import Nuke

class CommentsViewController: UIViewController {
    @IBOutlet var textView: WriteMessageTextView!
    @IBOutlet var tableViewComments: CommentsTableView!
    @IBOutlet var imageViewProfileImage: UIImageView!
    @IBOutlet var commentViewHeight: NSLayoutConstraint!
    @IBOutlet var viewBottomConstraints: NSLayoutConstraint!
    @IBOutlet var viewBottom: UIView!
    let viewModel = CommentsViewModel()
    var postId = Int()
    var commentsCount = 0
    weak var delegate: CommentsCoordinatorDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
    }

    // MARK: - Custom Methods
    func setUp() {
        backButton()
        tableViewComments.estimatedRowHeight = 100
        tableViewComments.rowHeight = UITableView.automaticDimension
        tableViewComments.delegateAction = self
        tableViewComments.postId = postId
        textView.viewHeight = commentViewHeight
        getComments()
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardNotification), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardNotification), name: UIResponder.keyboardWillHideNotification, object: nil)
        applyGradientBorder()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.view.backgroundColor = .red
        if #available(iOS 11.0, *){
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationItem.largeTitleDisplayMode = .always
        }
        else {/*Fallback on earlier versions*/}
    }
    
    func getComments() {
        viewModel.controller = self
        viewModel.fetchPostComments(id: postId, pageNumber: 1)
    }

    func displayComments(commentList: PostCommentsResponse) {
        if commentList.status {
            if commentList.comment.count > 0 {
                self.commentsCount += commentList.comment.count
                self.navigationItem.title = "\(self.commentsCount) Comments"
            }
            tableViewComments.display(comments: commentList.comment)
        }
    }
    
    func addComment(comment: PostCommentResponse) {
        self.textView.text = ""
        self.tableViewComments.displayAdded(comment: comment)
        self.commentsCount += 1
        self.navigationItem.title = "\(self.commentsCount) Comments"
    }

    func applyGradientBorder() {
        if UserStore.user?.profileImage == ""
        {imageViewProfileImage.image = #imageLiteral(resourceName: "Placeholder_image")}
        else {
            let imageURLProfile = UserStore.user?.userImage
            if let urlProfile = URL(string: imageURLProfile!) {
                Nuke.loadImage(with: urlProfile, into: imageViewProfileImage)
            }
        }
        // add gradient border
        imageViewProfileImage.layer.cornerRadius = imageViewProfileImage.frame.height / 2
        imageViewProfileImage.clipsToBounds = true
    }

    @objc func handleKeyboardNotification(_ notification: Notification) {
        if let userInfo = notification.userInfo {
            let keyboardFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as AnyObject).cgRectValue
            let isKeyboardShowing = notification.name == UIResponder.keyboardWillShowNotification
            viewBottomConstraints?.constant = isKeyboardShowing ? -keyboardFrame!.height : 0
            UIView.animate(withDuration: 0.5, animations: { () -> Void in
                self.view.layoutIfNeeded()
            })
        }
    }

    // MARK: - UI Actions

    @IBAction func actionCommentTouched(_: Any) {
        viewModel.postComment(postId: postId, comment: textView.text?.trimmingCharacters(in: .whitespaces) ?? "")
        self.textView.text = ""
    }
}

extension CommentsViewController:CommentViewDelegate, CommentTableDelegate, CommentsDelegate {
    func showProfile(username: String) {
        delegate?.showProfile(username: username)
    }
    
    func setData(page: Int)
    {viewModel.fetchPostComments(id: postId, pageNumber: page)}

    func didReceived(commentList:PostCommentsResponse)
    {displayComments(commentList: commentList)}
    
    func didReceived(comment:PostCommentResponse)
    {addComment(comment: comment)}
    
    func didReceived(like:ReusableResponse) {}
    
    func didReceived(erorr msg:String) {}
}
