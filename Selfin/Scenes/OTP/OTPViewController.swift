//
//  OTPViewController.swift
//  Selfin
//
//  Created by cis on 13/09/18.
//  Copyright © 2018 Selfin. All rights reserved.
//

import PinCodeTextField
import UIKit

protocol OTPViewControllerDelegate {
    func moveToCreateUsername()
    func goBackToEnterPhoneScreen()
}

class OTPViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet var txtOTP: PinCodeTextField!
    @IBOutlet weak var textfieldOTP: UITextField!
    var delegate: OTPViewControllerDelegate?
    let viewModel = OTPViewModel()
    var isUpdate = false

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.delegate = self
        textfieldOTP.delegate = self
        textfieldOTP.defaultTextAttributes.updateValue(36.0,
                                                    forKey: NSAttributedString.Key.kern)
    }

    // MARK: -
    // MARK: - TextField Delegate

    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.tintColor = UIColor.lightGray
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text else { return true }
        let newLength = text.count + string.count - range.length
        return newLength <= 5
    }

    // MARK: -
    // MARK: - Custom Methods

    func verifyOTP(data:VerifyOTP, isResend:Bool) {
        
        hideLoader()
        if data.status {
            if !isUpdate { UserDefaults.standard.set("Username", forKey: Constants.show_screen.rawValue)}

            if isResend {self.showAlert(str: (data.msg))}
            else{self.delegate?.moveToCreateUsername()}
        } else {self.showAlert(str: (data.msg))}
    }
    
    // MARK: -
    // MARK: - UI Actions

    @IBAction func btnResendPinPressed(_: Any) {
        textfieldOTP.text = ""

        showLoader() // Calling methods via extension class
        if isUpdate {viewModel.resendOTPToUpdateNumber()}
        else {viewModel.resendOTPProcess()}
    }

    @IBAction func actionNext(_: Any) {
        if viewModel.validateOTP(txtOTP: textfieldOTP) == "" {
            showLoader() // Calling methods via extension class
            if isUpdate {
                if let otp = textfieldOTP.text {viewModel.verifyOTPToUpdatePhoneNumber(pin: Int(otp) ?? 0)}
            }else {if let otp = textfieldOTP.text {viewModel.verifyOTPProcess(pin: Int(otp) ?? 0)}}
        } else {
            showAlert(str: viewModel.validateOTP(txtOTP: textfieldOTP))
        }
    }

    @IBAction func actionBack(_: Any) {delegate?.goBackToEnterPhoneScreen()}
}

extension OTPViewController:verifyOTPDelegate {
    func didReceivedUpdateNumber(data: ReusableResponse) {
        hideLoader()
        textfieldOTP.text = ""
        self.showAlert(str: (data.message))
    }
    
    func didReceivedResendOtpData(data: VerifyOTP)
    {verifyOTP(data: data, isResend: true)}
    
    func didReceived(data: VerifyOTP) {verifyOTP(data: data, isResend: false)}
    
    func didReceived(err: String) {hideLoader()}
}
