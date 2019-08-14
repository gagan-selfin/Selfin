//
//  PhoneViewController.swift
//  Selfin
//
//  Created by cis on 13/09/18.
//  Copyright © 2018 Selfin. All rights reserved.
// z

import CountryPicker
import UIKit

protocol PhoneViewControllerDelegate {
    func moveToEnterOTP()
    func goBackToRegistration()
}

class PhoneViewController: UIViewController, UITextFieldDelegate, CountryPickerDelegate {
    @IBOutlet var countryCodePicker: CountryPicker!
    @IBOutlet var viewCountryCodePicker: UIView!
    @IBOutlet var viewBG: UIView!
    @IBOutlet var txtCountryCode: UITextField!
    @IBOutlet var txtPhoneNumber: UITextField!

    var onCancel: (() -> Void)?
    var delegate: PhoneViewControllerDelegate?

    let viewModel = PhoneViewModel()
    let gradient: CAGradientLayer = CAGradientLayer()
    var arrPickerValues = [Any]()
    var isUpdate:Bool?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
        viewModel.delegate = self
        let locale = Locale.current
        let code = (locale as NSLocale).object(forKey: NSLocale.Key.countryCode) as! String?
        // init Picker
        countryCodePicker.countryPickerDelegate = self
        countryCodePicker.showPhoneNumbers = true
        countryCodePicker.setCountry(code!)

        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(removeTimerView))
        viewBG.addGestureRecognizer(tapGesture)
    }

    // MARK: - CountryPicker Delegate

    func countryPhoneCodePicker(_: CountryPicker, didSelectCountryWithName _: String, countryCode _: String, phoneCode: String, flag _: UIImage) {
        // pick up anythink
        txtCountryCode.text = phoneCode
    }

    // MARK: -

    // MARK: - Button Actions

    @IBAction func btnCountryCodePresed(_: Any) {
        view.endEditing(true)
        viewCountryCodePicker.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
        view.addSubview(viewCountryCodePicker)
        gradient.frame = viewCountryCodePicker.bounds
        gradient.startPoint = CGPoint(x: 0.7, y: 0)
        gradient.endPoint = CGPoint(x: 1, y: 0.8)
        gradient.colors = [UIColor(red: 240 / 255, green: 48 / 255, blue: 193 / 255, alpha: 1), UIColor(red: 146 / 255, green: 116 / 255, blue: 221 / 255, alpha: 1)].map { $0.cgColor }
        viewBG.layer.insertSublayer(gradient, at: 0)
    }

    @IBAction func btnOkPickerPressed(_: Any) {
        viewCountryCodePicker.removeFromSuperview()
    }

    @IBAction func btnCancelPickerPressed(_: Any) {
        viewCountryCodePicker.removeFromSuperview()
    }

    @IBAction func actionNext(_: Any) {
        if viewModel.validatePhoneDetails(txtPhoneNumber: txtPhoneNumber) == "" {
            showLoader() // Calling methods via extension class

            if isUpdate ?? false
            {viewModel.updatePhoneNumber(mobileNumber: txtCountryCode.text! + txtPhoneNumber.text!)}
            else
            {viewModel.registerPhoneNumber(mobileNumber: txtCountryCode.text! + txtPhoneNumber.text!, id:"\(UserDefaults.standard.object(forKey: Constants.new_user_id.rawValue) ?? "")")}
        } else {
            showAlert(str: viewModel.validatePhoneDetails(txtPhoneNumber: txtPhoneNumber))
        }
    }

    @IBAction func actionBack(_: Any) {
        delegate?.goBackToRegistration()
    }

    // MARK: -
    // MARK: - Custom Methods

    @objc func removeTimerView() {
        viewCountryCodePicker.removeFromSuperview()
    }

    func applyGradient(colours: [UIColor], view: UIView) {
        view.applyGradient(colours: colours, locations: nil)
    }

    func applyGradient(colours: [UIColor], locations: [NSNumber]?) {
        gradient.frame = view.bounds
        gradient.colors = colours.map { $0.cgColor }
        gradient.locations = locations
        view.layer.insertSublayer(gradient, at: 0)
    }
}

extension PhoneViewController : RegisterPhoneDelegate {
    func didReceived(phone:OTP) {
        print(phone)
        self.hideLoader()
        if phone.status {
            self.delegate?.moveToEnterOTP()
        } else {
            self.showAlert(str: phone.msg)
        }
    }
    
    func didReceived(error msg : String) {}
}
