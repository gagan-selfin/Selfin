//
//  RegistrationViewController.swift
//  Selfin
//
//  Created by Marlon Monroy on 8/17/18.
//  Copyright © 2018 Selfin. All rights reserved.
//

import UIKit

protocol RegistrationViewControllerDelegate {
    func moveToCreateUsernameScreen()
    func moveToOTPScreen()
    func moveToEnterPhoneScreen()
    func moveToMainScreen()
    func moveToForgetPasswordScreen()
    func moveToSettingsScreen()
    func moveToPolicyScreen()
    func moveToNewPwd(email: String)
}

class RegistrationViewController: UIViewController {
    @IBOutlet var constraintHeightConteinerImage: NSLayoutConstraint!
    @IBOutlet var lblPwd: UILabel!
    @IBOutlet var lblEmail: UILabel!
    @IBOutlet var viewLinePwd: UIView!
    @IBOutlet var username: UITextField!
    @IBOutlet var password: UITextField!
    @IBOutlet var fullname: UITextField!
    @IBOutlet var constraintHeightContainerView: NSLayoutConstraint!
    @IBOutlet var goButton: UIButton!
    @IBOutlet var segmentControl: CustomSegmentedControl!
    @IBOutlet var lblName: UILabel!
    @IBOutlet var lblForgotPwd: UILabel!
    @IBOutlet var imgViewForgotPwd: UIImageView!
    
    let viewModel = RegistrationViewModel()
    var delegate: RegistrationViewControllerDelegate?
    var isLogin = Bool()
    
    var arrayContactAllInfo = [Any]()
    var arrayFilterContactAllInfo = [Any]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        registerToReceiveNotification()
        viewModel.delegate = self
        
        // To avoid tutorial screen
        UserDefaults.standard.set("No", forKey: Constants.isFirstVisit.rawValue)
        
        if UserDefaults.standard.object(forKey: Constants.show_screen.rawValue) != nil {
            if UserDefaults.standard.object(forKey: Constants.show_screen.rawValue) as? String == "Phone" {
                delegate?.moveToEnterPhoneScreen()
            } else if UserDefaults.standard.object(forKey: Constants.show_screen.rawValue) as? String == "OTP" {
                delegate?.moveToOTPScreen()
            } else if UserDefaults.standard.object(forKey: Constants.show_screen.rawValue) as? String == "Username" {
                delegate?.moveToCreateUsernameScreen()
            }
        }
        navigationController?.isNavigationBarHidden = true
        
        lblForgotPwd.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        tap.delegate = self // This is not required
        lblForgotPwd.addGestureRecognizer(tap)
        
        fullname.text = ""
        username.text = ""
        password.text = ""
        lblForgotPwd.text = "FORGOT PASSWORD?"
        imgViewForgotPwd.isHidden = false
        
        lblName.text = "EMAIL"
        lblEmail.text = "PASSWORD"
        fullname.keyboardType = .emailAddress
        username.isSecureTextEntry = true
        
        isLogin = true
        updateUI(isHidden: true, isAnimated: false, containerHeight: 378.0, containerImageHeight: 445.0)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        segmentControl.indexPos = { index in
            self.view.endEditing(true)
            
            if index == 0 { // It means login
                self.fullname.text = ""
                self.username.text = ""
                self.password.text = ""
                self.lblForgotPwd.text = "FORGOT PASSWORD?"
                self.imgViewForgotPwd.isHidden = false
                
                self.lblName.text = "EMAIL"
                self.lblEmail.text = "PASSWORD"
                self.fullname.keyboardType = .emailAddress
                self.username.isSecureTextEntry = true
                
                self.isLogin = true
                self.updateUI(isHidden: true, isAnimated: true, containerHeight: 378.0, containerImageHeight: 445)
            } else { // It means signup
                self.lblName.text = "FULL NAME"
                self.lblEmail.text = "EMAIL"
                self.lblPwd.text = "PASSWORD"
                self.lblForgotPwd.text = "* By Signing Up I agree to Terms of Service and Privacy Policy."
                self.imgViewForgotPwd.isHidden = true
                
                self.fullname.text = ""
                self.username.text = ""
                self.password.text = ""
                
                self.fullname.keyboardType = .alphabet
                self.username.isSecureTextEntry = false
                self.isLogin = false
                self.updateUI(isHidden: false, isAnimated: true, containerHeight: 465.0, containerImageHeight: 485)
            }
        }
    }
    
    // MARK: - Custom Methods
    
    func registerToReceiveNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(showNewPwdScreenForDeepLink(notification:)), name: NSNotification.Name(rawValue: "postNotificationForgotPwd"), object: nil)
    }
    
    @objc func showNewPwdScreenForDeepLink(notification:Notification) {
        showLoader()
        if notification.object != nil {
            let dict:[String:String] = notification.object as! [String:String]
            delegate?.moveToNewPwd(email: dict["email"] ?? "")
            hideLoader()
        }
    }
    
    @objc func handleTap(_: UITapGestureRecognizer) {
        if isLogin {delegate?.moveToForgetPasswordScreen()}
        else {delegate?.moveToPolicyScreen()}
    }
    
    func updateUI(isHidden: Bool, isAnimated: Bool, containerHeight: Float, containerImageHeight _: Float) {
        viewLinePwd.isHidden = isHidden
        lblPwd.isHidden = isHidden
        password.isHidden = isHidden
        
        if isAnimated {
            UIView.animate(withDuration: 0.2, animations: {
                self.constraintHeightConteinerImage.constant = CGFloat(containerHeight)
                self.constraintHeightContainerView.constant = CGFloat(containerHeight)
                
            }, completion: nil)
        } else {
            constraintHeightContainerView.constant = CGFloat(containerHeight)
            constraintHeightConteinerImage.constant = CGFloat(containerHeight)
        }
        view.layoutIfNeeded()
    }
    
    // MARK: -
    // MARK: - Button Actions
    
    @IBAction func goButtonPressed(_: Any) {
        view.endEditing(true) // To hide keyboard
        
        if isLogin { // It means login
            if viewModel.validLoginDetails(txtEmail: fullname, txtPwd: username) == "" {
                if let token = UserDefaults.standard.object(forKey: Constants.deviceToken.rawValue) {
                    showLoader() // Calling methods via extension class
                    viewModel.login(email: fullname.text ?? "",password: username.text ?? "", deviceToken: token as! String, deviceType: "I")
                }else{showAlert(str: "Something went wrong please try again later.")}
            } else {
                showAlert(str: viewModel.validLoginDetails(txtEmail: fullname, txtPwd: username))
            }
        } else { // It means signup
            if viewModel.validRegistrationDetails(txtUserName: fullname, txtEmail: username, txtPwd: password) == "" {
                if let token = UserDefaults.standard.object(forKey: Constants.deviceToken.rawValue) {
                showLoader() // Calling methods via extension class
                    viewModel.registrationProcess(full_name: fullname.text ?? "", email: username.text ?? "", password: password.text ?? "" , deviceToken: token as! String, deviceType: "I", referral_code: "")
                }else{showAlert(str: "Something went wrong please try again later.")}
            } else {
                showAlert(str: viewModel.validRegistrationDetails(txtUserName: fullname, txtEmail: username, txtPwd: password))
            }
        }
    }
}

extension RegistrationViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.tintColor = UIColor.lightGray
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

extension RegistrationViewController : RegistrationControllDelegate {
    func didReceived(login: Login) {
        self.hideLoader()
        if login.status {
            // Saving user data
            UserStore.save(user: saveUser(login: login))
            //Register user's chat instance
            HSFireBase.sharedInstance.function_CreatAndUpdateUser(id: "\(login.user.userId )", name: login.user.userName , email: login.user.email , picture: login.user.profileImage)
            //"\(environment.host)\(login.user.profileImage )"
            self.delegate?.moveToMainScreen()
        } else {
            self.showAlert(str: login.msg)
        }
    }
    
    func didReceived(registration: Registration) {
        self.hideLoader()
        if registration.status {
            UserDefaults.standard.set(registration.new_user_id, forKey: Constants.new_user_id.rawValue)
            UserDefaults.standard.set("Phone", forKey: Constants.show_screen.rawValue)
            self.delegate?.moveToEnterPhoneScreen()
        } else {
            if registration.user_active {
                self.showAlert(str: registration.msg)
            } else if registration.new_user_id == 0 {
                self.showAlert(str: registration.msg)
            }else{
                UserDefaults.standard.set(registration.new_user_id, forKey: Constants.new_user_id.rawValue)
                UserDefaults.standard.set("Phone", forKey: Constants.show_screen.rawValue)
                self.delegate?.moveToEnterPhoneScreen()
            }
        }
    }
    
    func didReceived(error msg: String) {}
    
    func saveUser(login: Login) -> User {
        let createdUser = User()
        createdUser.bio  = login.user.bio
        createdUser.userName = login.user.userName
        createdUser.email = login.user.email
        createdUser.firstName = login.user.firstName
        createdUser.lastName = login.user.lastName
        createdUser.id = login.user.userId
        createdUser.isPrivate = login.user.private_account
        createdUser.isPromotional = login.user.promotional_notification
        createdUser.isPush = login.user.push_notification
        createdUser.profileImage = login.user.profileImage
        createdUser.fullname = login.user.firstName + " " + login.user.lastName
        
        //Save Auth Token
        let authToken = AuthToken()
        authToken.token = "Token" + " " + login.token
        UserStore.save(token: authToken)
        
        return createdUser
    }
}
