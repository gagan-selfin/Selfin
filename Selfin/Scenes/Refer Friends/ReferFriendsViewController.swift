//
//  ReferFriendsViewController.swift
//  Selfin
//
//  Created by cis on 21/09/18.
//  Copyright © 2018 Selfin. All rights reserved.
//

import ContactsUI
import UIKit

protocol ReferFriendsViewControllerDelegate {
    func skipEarnMoreStart()
    func popToSettings()
}

class ReferFriendsViewController: UIViewController, CNContactPickerDelegate {
    @IBOutlet var viewRefer: UIView!
    @IBOutlet var imgView: UIImageView!
    @IBOutlet var btnDontWantStars: UIButton!
    @IBOutlet var btnGetStars: UIButton!

    var screen = String()
    var context = CIContext(options: nil)
    var delegate: ReferFriendsViewControllerDelegate?
    let gradient: CAGradientLayer = CAGradientLayer()
    var arrContact = [String]()
    var referal_code = String()
    var viewModel = ReferFriendsViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()

        viewModel.delegate = self
        viewRefer.layer.cornerRadius = 10.0
        btnDontWantStars.layer.cornerRadius = 5.0
        btnDontWantStars.layer.borderWidth = 1.0
        btnDontWantStars.layer.borderColor = UIColor.gray.cgColor
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        blurEffect()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        applyGradient(colours: [UIColor(red: 240 / 255, green: 48 / 255, blue: 193 / 255, alpha: 1), UIColor(red: 180 / 255, green: 89 / 255, blue: 210 / 255, alpha: 1)], view: btnGetStars)
    }

    func blurEffect() {
        let currentFilter = CIFilter(name: "CIGaussianBlur")
        let beginImage = CIImage(image: imgView.image!)
        currentFilter!.setValue(beginImage, forKey: kCIInputImageKey)
        currentFilter!.setValue(10, forKey: kCIInputRadiusKey)

        let cropFilter = CIFilter(name: "CICrop")
        cropFilter!.setValue(currentFilter!.outputImage, forKey: kCIInputImageKey)
        cropFilter!.setValue(CIVector(cgRect: beginImage!.extent), forKey: "inputRectangle")

        let output = cropFilter!.outputImage
        let cgimg = context.createCGImage(output!, from: output!.extent)
        let processedImage = UIImage(cgImage: cgimg!)
        imgView.image = processedImage
        hideLoader()
    }

    // MARK: -
    // MARK: - CNContactPickerDelegate Method

    func contactPicker(_: CNContactPickerViewController, didSelect contacts: [CNContact]) {
        arrContact.removeAll()
        contacts.forEach { contact in

            for num in contact.phoneNumbers {
                let numVal = num.value
                if num.label == CNLabelPhoneNumberMobile {
                    arrContact.append(numVal.stringValue)
                }
            }
        }

        if arrContact.count > 0 {

            var strCountryCode = ""
            if let countryCode = (Locale.current as NSLocale).object(forKey: .countryCode) as? String {
                strCountryCode = "+" + getCountryPhonceCode(countryCode)
            }

            viewModel.referFriendProcess(code: strCountryCode, contacts: arrContact)
        }
    }

    func contactPickerDidCancel(_: CNContactPickerViewController) {
        print("Cancel Contact Picker")
    }

    // MARK: -
    // MARK: - Custom Methods

    func applyGradient(colours: [UIColor], view: UIView) {
        view.applyGradient(colours: colours, locations: nil)
    }

    func applyGradient(colours: [UIColor], locations: [NSNumber]?) {
        gradient.frame = view.bounds
        gradient.colors = colours.map { $0.cgColor }
        gradient.locations = locations
        view.layer.insertSublayer(gradient, at: 0)
    }

    // MARK: -

    // MARK: - Button Actions

    @IBAction func btnDontWantStarsPressed(_: Any) {
        if screen == "Cancel" {
            delegate?.popToSettings()
        } else {
            delegate?.skipEarnMoreStart()
        }
    }

    @IBAction func btnGetStarsPressed(_: Any) {
        // Fetch contacts
        let cnPicker = CNContactPickerViewController()
        cnPicker.delegate = self
        present(cnPicker, animated: true, completion: nil)
    }
}

extension ReferFriendsViewController:ReferFriendsDelegate {
    func didReceived(data: ReferralCode) {
        if (data.status) {
            self.showAlert(str: (data.message))
            self.arrContact.removeAll()
        }
    }
    
    func didReceived(error: String) {}
}
