
//  EditProfileViewController.swift
//  Selfin
//
//  Created by cis on 24/09/18.
//  Copyright © 2018 Selfin. All rights reserved.
//

import Nuke
import UIKit
import RealmSwift

class EditProfileViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    @IBOutlet var txtEmail: UITextField!
    @IBOutlet var txtStatus: UITextField!
    @IBOutlet var txtName: UITextField!
    @IBOutlet var txtUsername: UITextField!
    @IBOutlet var imgViewProfilePic: UIImageView!

    var viewModel = EditProfileViewModel()
    var delegate: EditProfileViewControllerDelegate?

    let imagePicker = UIImagePickerController()
    var isAvatarImageChange = Bool()
    var imgAvatar = UIImage()
    var isImage = Bool()
    var selectedImage = UIImage()

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.delegate = self
        setUp()
    }

    // MARK: -
    // MARK: - UIImagePickerControllerDelegate Methods

    func imagePickerController(_: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        // Local variable inserted by Swift 4.2 migrator.
        let info = convertFromUIImagePickerControllerInfoKeyDictionary(info)

        if let pickedImage = info[convertFromUIImagePickerControllerInfoKey(UIImagePickerController.InfoKey.originalImage)] as? UIImage {
            imgViewProfilePic.image = pickedImage

            let dict = [String: Any]()

            let str = APIs.changeAvatarApi.rawValue.replacingOccurrences(of: "USERNAME", with: UserStore.user?.userName ?? "")
            callChangeAvatarImageWebService(dictionary: dict, urlString: String(format: "/%@", str))
        }
        dismiss(animated: true, completion: nil)
    }

    func imagePickerController(picker _: UIImagePickerController, didFinishPickingImage _: UIImage!, editingInfo _: [NSObject: AnyObject]!) {
        dismiss(animated: true, completion: nil)
    }

    func imagePickerControllerDidCancel(_: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }

    // MARK: -

    // MARK: - API Call

    func callChangeAvatarImageWebService(dictionary: Dictionary<String, Any>, urlString: String) {
        if ConstantManagerSharedInstance.isNetworkConnected() {
            showLoader() // Show loader
            ConstantManagerSharedInstance.callPutServiceForSendingImage(postdata: dictionary as NSDictionary, urlString: urlString, isMultipart: true, isImage: true, imageObj: imgViewProfilePic.image!, imageParam: "avatar", consumer: { result, _ in

                DispatchQueue.main.async {
                    self.hideLoader() // Hide loader

                    if result["status"] as! Bool == true {
                        self.updateUserAvatarImage(image: result["profile_image"] as! String)
                        let dict = ["username":UserStore.user?.userName, "firstName":UserStore.user?.firstName, "lastName":UserStore.user?.lastName, "status":UserStore.user?.bio, "email":UserStore.user?.email,"avatar":UserStore.user?.userImage]
                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "updateUserInfo"), object: dict, userInfo: nil)
                        
                        HSFireBase.sharedInstance.function_CreatAndUpdateUser(id: "\(UserStore.user!.id)" , name: UserStore.user?.userName ?? "" , email: UserStore.user?.email ?? "" , picture: result["profile_image"] as! String)
                        
                        self.showAlert(str: result["msg"] as! String)
                    } else {
                        self.showAlert(str: result["message"] as! String)
                    }
                }
            })
        }
    }

    // MARK: -
    // MARK: - Custom Methods
    func updateInfo (data:EditProfile) {
        self.hideLoader() // Calling methods via extension class
        self.showAlert(str: (data.msg))
        self.txtName.text = String(format: "%@ %@", (data.profile.firstName), (data.profile.lastName))
        self.txtUsername.text = data.profile.username
        self.txtStatus.text = data.profile.bio
        self.txtEmail.text = data.profile.email
        
        // Saving data
        self.updateUser(data: data.profile)
        let id = UserStore.user?.id ?? 0
        
        HSFireBase.sharedInstance.function_CreatAndUpdateUser(id: "\(id)" , name: data.profile.username , email: data.profile.email , picture: String(describing: UserStore.user?.userImage))
        
        let dict = ["username":UserStore.user?.userName, "firstName":UserStore.user?.firstName, "lastName":UserStore.user?.lastName, "status":UserStore.user?.bio, "email":UserStore.user?.email,"avatar":UserStore.user?.userImage]
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "updateUserInfo"), object: dict, userInfo: nil)
    }

    func setUp () {
        backButton()
        
        if #available(iOS 11.0, *)
        {navigationController?.navigationBar.prefersLargeTitles = false}
        else {/*Fallback on earlier versions*/}
        
        isAvatarImageChange = false
        
        if UserStore.user?.userName != nil {
            txtUsername.text = UserStore.user?.userName
        }
        if UserStore.user?.fullname != nil {
            txtName.text = UserStore.user?.fullname
        }
        if  UserStore.user?.email != nil {
            txtEmail.text = UserStore.user?.email
        }
        if UserStore.user?.bio != nil {
            txtStatus.text = UserStore.user?.bio
        }
        
        activityIndicator.startAnimating()
        activityIndicator.isHidden = false
        
        if UserStore.user?.userImage == "" {
            imgViewProfilePic.image = #imageLiteral(resourceName: "Placeholder_image")
        } else {
            if let urlProfile = URL(string: UserStore.user?.userImage ?? "") {
                print(urlProfile)
                print(urlProfile.absoluteURL)
                Nuke.loadImage(with: urlProfile.absoluteURL, into: imgViewProfilePic)
                activityIndicator.stopAnimating()
                activityIndicator.isHidden = true
            }
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(selectedImage(notification:)), name: NSNotification.Name(rawValue: "setProfileImage"), object: nil)
    }
    
    // MARK: -
    // MARK: - Button Actions

    @IBAction func btnSubmitPressed(_: Any) {
        if viewModel.validDetails(txtName: txtName, txtUserName: txtUsername, txtStatus: txtStatus, txtEmail: txtEmail) == "" {
            showLoader()
            viewModel.editProfileProcess(name:txtName.text ?? "", username:txtUsername.text ?? "", email: txtEmail.text ?? "", bio:txtStatus.text  ?? "")
        } else {
            showAlert(str: viewModel.validDetails(txtName: txtName, txtUserName: txtUsername, txtStatus: txtStatus, txtEmail: txtEmail))
        }
    }

    @IBAction func btnChangeProfilePicPressed(_: Any) {
        delegate?.openCameraForEditingAvatar()
    }

    @objc func selectedImage(notification: Notification) {
        if notification.object != nil {
            let dict: [String: Any] = notification.object as! [String: Any]
            if let decodedImageData = Data(base64Encoded: dict["image"] as! String, options: .ignoreUnknownCharacters) {
                let image = UIImage(data: decodedImageData)
                imgViewProfilePic.image = image
                imgViewProfilePic.backgroundColor = UIColor.purple
                isAvatarImageChange = true
                let dict = [String: Any]()
                let str = APIs.changeAvatarApi.rawValue.replacingOccurrences(of: "USERNAME", with: UserStore.user?.userName ?? "")
                callChangeAvatarImageWebService(dictionary: dict, urlString: String(format: "/%@", str))
            }
        }
    }
}

extension EditProfileViewController: captureImageDelegate {

    func selectedImageToSetProfile(image: UIImage) {}
    
    func updateUserAvatarImage(image : String) {
        let realm = try! Realm()
        let userList:User = realm.objects(User.self).first ?? User()
        try! realm.write {
            userList.profileImage = image
        }
    }
    
    func updateUser(data : EditProfile.editProfileData?) {
        let realm = try! Realm()
        let userList:User = realm.objects(User.self).first ?? User()
         try! realm.write {
            userList.profileImage = data?.profileImage ?? ""
            userList.bio = data?.bio ?? ""
            userList.email = data?.email ?? ""
            userList.firstName = data?.firstName ?? ""
            userList.lastName = data?.lastName ?? ""
            userList.fullname = userList.firstName + " " + userList.lastName
            userList.userName = data?.username ?? ""
         }
    }
}

extension EditProfileViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.tintColor = UIColor.lightGray
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromUIImagePickerControllerInfoKeyDictionary(_ input: [UIImagePickerController.InfoKey: Any]) -> [String: Any] {
    return Dictionary(uniqueKeysWithValues: input.map { key, value in (key.rawValue, value) })
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromUIImagePickerControllerInfoKey(_ input: UIImagePickerController.InfoKey) -> String {
    return input.rawValue
}


extension EditProfileViewController:EditProfileAPIDelegate {
    func didReceived(response: EditProfileResponse) {
        switch response {
        case .success(data: let data):
            if data.status {updateInfo(data: data)}
            else {
                self.hideLoader()
                self.showAlert(str: data.msg)
            }
        case .error(err: _):
            self.hideLoader()
        }
    }
}
