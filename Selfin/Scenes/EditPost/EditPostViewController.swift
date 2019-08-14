//
//  EditPostViewController.swift
//  Selfin
//
//  Created by cis on 20/12/2018.
//  Copyright © 2018 Selfin. All rights reserved.
//

import UIKit
import Nuke

class EditPostViewController: UIViewController {
    @IBOutlet var imageViewUser: UIImageView!
    @IBOutlet var labelUsername: UILabel!
    @IBOutlet var labelUserLocation: UILabel!
    @IBOutlet var imageViewPost: UIImageView!
    @IBOutlet var textView: WriteMessageTextView!
    @IBOutlet var textViewHEight: NSLayoutConstraint!
    @IBOutlet var buttonPost: UIButton!
    @IBOutlet var labelCurrentLocation: UILabel!
    @IBOutlet var viewTag: UIView!
    @IBOutlet var collectionViewTag: TaggedUserCollectionView!
    @IBOutlet var viewSchedulePost: SchedulePostTime!
    @IBOutlet var labelScheduledTime: UILabel!
    
    var scheduledPost : scheduledPostResponse.Post!
    var scheduleDate: String?
    let viewModel = EditPostViewModel()
    weak var delegate : CreatePostCoordinatorDelegate?
    var taggedUsers = [Int]()
    var taggedUser = [FollowingFollowersResponse.User]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
    }
    
    fileprivate func setUp() {
        backButton()
        self.navigationController?.isNavigationBarHidden = false
        if #available(iOS 11.0, *) {
            navigationController?.navigationBar.prefersLargeTitles = true
        } else {
            // Fallback on earlier versions
        }
        textView.viewHeight = textViewHEight
        textView.placeholderText = "  Add a caption"
        viewModel.delegate = self
        setUser()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        buttonPost.applyGradient(colours: [UIColor(red: 240 / 255, green: 48 / 255, blue: 193 / 255, alpha: 1), UIColor(red: 180 / 255, green: 89 / 255, blue: 210 / 255, alpha: 1)], locations: nil)
    }
    
    @IBAction func actionTagUser(_ sender: Any) {
       // delegate?.tagUsers(users: [])
    }
    
    @IBAction func actionPost(_ sender: Any) {
        showLoader()
        for ur in taggedUser {taggedUsers.append(ur.id)}
        
        viewModel.editPost(content: textView.text.trimmingCharacters(in: .whitespacesAndNewlines), scheduleTime: scheduleDate ?? "", taggedUsers: taggedUsers, id: scheduledPost.id)
    }
    
    @IBAction func actionSchedulePost(_ sender: Any) {
        viewSchedulePost.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height);
        UIApplication.shared.keyWindow?.addSubview(viewSchedulePost)
        
        viewSchedulePost.scheduleDate = { date in self.scheduleDate = date
            self.labelScheduledTime.text = " " + self.scheduleDate!
        }
    }
    
    //MARK:- Custom Actions
    func setUser() {
        //User
        imageViewUser.layer.cornerRadius = imageViewUser.bounds.width/2
        imageViewUser.clipsToBounds = true
        Nuke.loadImage(with: URL.init(string: scheduledPost.user.image)! , into: imageViewUser)
        labelUsername.text = scheduledPost.user.username
        labelUserLocation.text = scheduledPost.locationDetails.locationName
        
        //Set post
        Nuke.loadImage(with: URL.init(string: scheduledPost.Image)! , into: imageViewPost)
        textView.text = scheduledPost.content
        labelCurrentLocation.text = scheduledPost.locationDetails.locationName
        labelScheduledTime.text = " " + scheduledPost.scheduledTime
        
        //set tags
        tagUsers(users: scheduledPost.taggedUser)
    }
    
    func tagUsers(users: [FollowingFollowersResponse.User]) {
        taggedUsers.removeAll()
        collectionViewTag.didSelect = didSelect
        collectionViewTag.showTaggedUser(user: users)
        viewTag.isHidden = true
        for user in users {
            taggedUsers.append(user.id)
        }
    }
    
    func didSelect(users: [FollowingFollowersResponse.User])  {
        taggedUser = users
        delegate?.tagUsers(users: users)
    }
}
extension EditPostViewController : EditPostDelegate {
    func didReceived(result: ReusableResponse) {
        hideLoader()
        showAlert(str: result.message)
    }
    
    func didReceived(error msg: String) {
        hideLoader()
        showAlert(str: msg)
    }
}
