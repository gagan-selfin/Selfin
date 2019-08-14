//
//  ForgotPasswordViewController.swift
//  Selfin
//
//  Created by cis on 17/09/18.
//  Copyright © 2018 Selfin. All rights reserved.
//

import UIKit

protocol ForgotPasswordViewControllerDelegate {
    func moveBackToLogin()
}

class ForgotPasswordViewController: UIViewController {
    @IBOutlet var txtEmail: UITextField!

    var delegate: ForgotPasswordViewControllerDelegate?
    let viewModel = ForgotpasswordViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: -
    // MARK: - Button Actions

    @IBAction func btnBackPressed(_: Any)
    {delegate?.moveBackToLogin()}

    @IBAction func btnForgotPwdPressed(_: Any) {
        if viewModel.validEmailDetails(txtEmail: txtEmail) == "" {
            showLoader()
            viewModel.forgotPasswordProcess(email: txtEmail.text ?? "")
            viewModel.isSuccess = { success, data in
                self.hideLoader()
                if success {
                    self.showAlert(str: data?.message ?? "")
                    self.txtEmail.text = ""
                }
            }
        } else {
            showAlert(str: viewModel.validEmailDetails(txtEmail: txtEmail))
        }
    }
}

extension ForgotPasswordViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField)
    {textField.tintColor = UIColor.lightGray}

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
