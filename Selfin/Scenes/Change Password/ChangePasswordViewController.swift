//
//  ChangePasswordViewController.swift
//  Selfin
//
//  Created by cis on 27/09/18.
//  Copyright © 2018 Selfin. All rights reserved.
//

import UIKit

class ChangePasswordViewController: UIViewController, UITextFieldDelegate {
    var viewModel = ChangepasswordViewModel()

    @IBOutlet weak var lblConfirmPwd: UILabel!
    @IBOutlet weak var lblNewPwd: UILabel!
    @IBOutlet weak var lblOldPwd: UILabel!
    @IBOutlet var txtNewPwd: UITextField!
    @IBOutlet var txtConfirmPwd: UITextField!
    @IBOutlet var txtOldPwd: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()

        viewModel.delegate = self
        backButton()
        if #available(iOS 11.0, *)
        {navigationController?.navigationBar.prefersLargeTitles = true}
        else {/*Fallback on earlier versions*/}
        
        let singleTapGestureForOldPwd = UITapGestureRecognizer(target: self, action: #selector(oldPwdTapped(gestureRecongnizer:)))
        singleTapGestureForOldPwd.numberOfTapsRequired = 1
        lblOldPwd.addGestureRecognizer(singleTapGestureForOldPwd)
        
        let singleTapGestureForNewPwd = UITapGestureRecognizer(target: self, action: #selector(newPwdTapped(gestureRecongnizer:)))
        singleTapGestureForNewPwd.numberOfTapsRequired = 1
        lblNewPwd.addGestureRecognizer(singleTapGestureForNewPwd)

        let singleTapGestureForConfirmPwd = UITapGestureRecognizer(target: self, action: #selector(confirmPwdTapped(gestureRecongnizer:)))
        singleTapGestureForConfirmPwd.numberOfTapsRequired = 1
        lblConfirmPwd.addGestureRecognizer(singleTapGestureForConfirmPwd)
    }
    
    // MARK: -
    // MARK: - Custom Methods

    @objc func oldPwdTapped(gestureRecongnizer: UITapGestureRecognizer)
    {txtOldPwd.becomeFirstResponder()}
    
    @objc func newPwdTapped(gestureRecongnizer: UITapGestureRecognizer)
    {txtNewPwd.becomeFirstResponder()}

    @objc func confirmPwdTapped(gestureRecongnizer: UITapGestureRecognizer)
    {txtConfirmPwd.becomeFirstResponder()}

    // MARK: -
    // MARK: - TextField Delegate

    func textFieldDidBeginEditing(_ textField: UITextField)
    {textField.tintColor = UIColor.lightGray}

    func textFieldShouldReturn(_: UITextField) -> Bool {
        view.endEditing(true)
        return true
    }

    // MARK: -
    // MARK: - Button Actions

    @IBAction func btnSubmitPressed(_: Any) {
        if viewModel.validDetails(txtOldPwd: txtOldPwd, txtNewPwd: txtNewPwd, txtConfirmPwd: txtConfirmPwd) == "" {
            
            showLoader()
            viewModel.changePasswordProcess(password: txtOldPwd.text ?? "", newPassword: txtNewPwd.text ?? "")
        } else {
            showAlert(str: viewModel.validDetails(txtOldPwd: txtOldPwd, txtNewPwd: txtNewPwd, txtConfirmPwd: txtConfirmPwd))
        }
    }
}

extension ChangePasswordViewController:ChangePasswordDelegate {
    func didReceived(data: ReusableResponse) {
        self.hideLoader()
        self.txtOldPwd.text = ""
        self.txtNewPwd.text = ""
        self.txtConfirmPwd.text = ""
        self.showAlert(str: data.message)
    }
    
    func didReceived(error: String) {self.hideLoader()}
}
