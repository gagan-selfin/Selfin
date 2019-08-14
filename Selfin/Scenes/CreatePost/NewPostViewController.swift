//
//  NewPostViewController.swift
//  Selfin
//
//  Created by cis on 13/12/2018.
//  Copyright © 2018 Selfin. All rights reserved.
//

import UIKit
import Nuke

class NewPostViewController: UIViewController {
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
    
    var image : UIImage?
    var latitude: Double?
    var longitude: Double?
    var placeName: String?
    var scheduleDate: String?
    let viewModel = CreatePostViewModel()
    weak var delegate : CreatePostCoordinatorDelegate?
    var taggedUsers = [Int]()

    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
    }
    
    fileprivate func setUp() {
        AppUtility.lockOrientation(.portrait, andRotateTo: .portrait)
        backButton()
        self.navigationController?.isNavigationBarHidden = false
        if #available(iOS 11.0, *) {
            navigationController?.navigationBar.prefersLargeTitles = true
        } else {
            // Fallback on earlier versions
        }
        
        textView.viewHeight = textViewHEight
        textView.placeholderText = "  Add a caption"
        textView.text = "  Add a caption"
        viewModel.delegate = self

        setUser()
        setLocation()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        round()
        buttonPost.applyGradient(colours: [UIColor(red: 240 / 255, green: 48 / 255, blue: 193 / 255, alpha: 1), UIColor(red: 180 / 255, green: 89 / 255, blue: 210 / 255, alpha: 1)], locations: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        AppUtility.lockOrientation(.all)
    }
    
    //MARK:-
    //MARK:- UI Action
    
    @IBAction func actionAddLocation(_ sender: Any) {
        setLocation()
    }
    
    @IBAction func actionTagUser(_ sender: Any) {
        delegate?.tagUsers(users: [])
    }
    
    @IBAction func actionRemoveLocation(_ sender: Any) {
        placeName = nil
        longitude = nil
        latitude = nil
        labelCurrentLocation.text = "Add Location"
    }
    
    @IBAction func actionPost(_ sender: Any) {
        showLoader()
        viewModel.createPost(image: imageViewPost.image ?? UIImage(), locationName: placeName ?? "", long: longitude ?? 0.0, lat: latitude ?? 0.0 , content: textView.text!.trimmingCharacters(in: .whitespacesAndNewlines), scheduleTime: scheduleDate ?? "", taggedUsers: taggedUsers)
    }
    
    @IBAction func actionSchedulePost(_ sender: Any) {
        viewSchedulePost.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height);
        UIApplication.shared.keyWindow?.addSubview(viewSchedulePost)
        viewSchedulePost.scheduleDate = { date in self.scheduleDate = date}
    }
    
    //MARK:- Custom Actions
    
    func setUser() {
        imageViewUser.layer.cornerRadius = imageViewUser.bounds.width/2
        imageViewUser.clipsToBounds = true
        Nuke.loadImage(with: URL.init(string: UserStore.user?.userImage ?? "")! , into: imageViewUser)
        labelUsername.text = UserStore.user?.userName
        imageViewPost.image = image
    }
    
    func setLocation() {
        // Saving lat long in user defaults
        if viewModel.locationManager.location?.coordinate != nil {
            viewModel.getUserCurrentLocation(coordinates: (viewModel.locationManager.location?.coordinate)!)
            viewModel.isLocation = { location in
                self.labelCurrentLocation.text = location
                self.labelUserLocation.text = location
                self.placeName = location
            }
            latitude = viewModel.locationManager.location?.coordinate.latitude
            longitude = viewModel.locationManager.location?.coordinate.longitude
        }
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
    
    func didSelect(users: [FollowingFollowersResponse.User])  {delegate?.tagUsers(users: users)}
    
    func round() {
        let mask = UIBezierPath(roundedRect: imageViewPost.bounds, byRoundingCorners: [.topLeft,.topRight], cornerRadii: CGSize(width: 15, height: 15))
        let shape = CAShapeLayer()
        shape.frame = imageViewPost.bounds
        shape.path = mask.cgPath
        imageViewPost.layer.mask = shape
    }
}

extension NewPostViewController : createPostDelegate,HorizontalDisplayable {
    func didReceived(result : NSDictionary ) {
        hideLoader()
        delegate?.postSuccessfull()
    }
    
    func didReceived(error msg:String) {
        hideLoader()
        showAlert(str: msg)
    }
}
