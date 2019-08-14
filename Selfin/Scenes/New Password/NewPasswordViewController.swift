//
//  NewPasswordViewController.swift
//  Selfin
//
//  Created by cis on 17/09/18.
//  Copyright © 2018 Selfin. All rights reserved.
//

import UIKit
protocol NewPasswordDelegate {
    func moveBack()
}

class NewPasswordViewController: UIViewController {
    @IBOutlet weak var txtConfirmPassword: UITextField!
    @IBOutlet weak var txtNewPassword: UITextField!
    var viewModel = NewPasswordViewModel ()
    var email = String()
    var delegate:NewPasswordDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.isNavigationBarHidden = true
    }
    
    @IBAction func btnBackPressed(_ sender: Any) {
        delegate?.moveBack()
    }
    
    @IBAction func btnSubmitPressed(_ sender: Any) {
        showLoader()
        if viewModel.validDetails(txtNewPwd: txtNewPassword, txtConfirmPwd: txtConfirmPassword) == "" {
            viewModel.resetPassword(email: email, password: txtConfirmPassword.text!)
            viewModel.isSuccess = {success, data in
                self.hideLoader()
                self.txtNewPassword.text = ""
                self.txtConfirmPassword.text = ""
                if success {
                    self.showAlert(str: data?.message ?? "")
                }
            }
        }else {
            showAlert(str: viewModel.validDetails(txtNewPwd: txtNewPassword, txtConfirmPwd: txtConfirmPassword))
        }
    }
}

extension NewPasswordViewController:UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
        return true
    }
}
