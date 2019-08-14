//
//  CreateUsernameViewController.swift
//  Selfin
//
//  Created by cis on 13/09/18.
//  Copyright © 2018 Selfin. All rights reserved.
//

import UIKit

protocol CreateUsernameViewControllerDelegate {
    func moveToEarnStars()
    func goBackToLogin()
}

class CreateUsernameViewController: UIViewController {
    @IBOutlet var txtUserName: UITextField!
    var delegate: CreateUsernameViewControllerDelegate?
    let viewModel = CreateUsernameViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.delegate = self
    }
    // MARK: - UI Action

    @IBAction func actionNext(_: UIButton) {
      guard let text = txtUserName.text else { return }
      guard text.count > 4 else { return }
      showLoader()
      viewModel.createUsername(username: txtUserName.text)
    }
    
    @IBAction func actionBackToLogin(_: Any) {
        delegate?.goBackToLogin()
    }
}

extension CreateUsernameViewController:CreateUsernameDelegate {
   func didCreateUser(username: Username) {
      hideLoader()
    //Register user's chat instance
      HSFireBase.sharedInstance.function_CreatAndUpdateUser(id: "\(username.user.userId )", name: username.user.userName , email: username.user.email , picture: username.user.profileImage)
      self.delegate?.moveToEarnStars()
   }

    func didReceived(err: String) {
      hideLoader()
      self.showAlert(str: err)
   }
}
