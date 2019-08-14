//
//  EarnStartViewController.swift
//  Selfin
//
//  Created by cis on 14/09/2018.
//  Copyright © 2018 Selfin. All rights reserved.
//

import UIKit

protocol EarnStarsViewControllerDelegate {
    func moveToMainScreen()
    func moveToReferFriendScreen(referal_code: String)
    func popToSettings()
}

class EarnStarsViewController: UIViewController {
    
    @IBOutlet var btnSkip: UIButton!
    @IBOutlet var btnGetMoreStar: UIButton!
    @IBOutlet var lblReferralCode: UILabel!
    @IBOutlet var viewInvitationCode: UIView!

    var viewModel = EarnStarsViewModel()
    var screen = String()
    var delegate: EarnStarsViewControllerDelegate?
    let gradient: CAGradientLayer = CAGradientLayer()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.isNavigationBarHidden = true
        viewModel.delegate = self
        btnGetMoreStar.isEnabled = false
        btnSkip.setTitle(screen, for: .normal)

        viewInvitationCode.layer.borderColor = UIColor.gray.cgColor
        viewInvitationCode.layer.borderWidth = 1.0
        viewInvitationCode.layer.cornerRadius = 5.0

        // Calling API to provide user referral code
        showLoader()
        viewModel.referralCodeProcess()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        applyGradient(colours: [UIColor(red: 240 / 255, green: 48 / 255, blue: 193 / 255, alpha: 1), UIColor(red: 180 / 255, green: 89 / 255, blue: 210 / 255, alpha: 1)], view: btnGetMoreStar)
    }

    // MARK: -
    // MARK: - Custom Method
    
    func getReferralCode(data:ReferralCode) {
        hideLoader()
        if (data.status) {
            self.lblReferralCode.text = data.referralCode
            self.btnGetMoreStar.isEnabled = true
        } else {
            self.showAlert(str: (data.message))
        }
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

    func displayShareSheet(shareContent: String) {
        let activityViewController = UIActivityViewController(activityItems: [shareContent as NSString], applicationActivities: nil)
        present(activityViewController, animated: true, completion: {})
    }

    // MARK: -
    // MARK: - UI Actions
    
    @IBAction func shareCodePressed(_: Any) {
        if self.lblReferralCode.text != "" {
           displayShareSheet(shareContent: self.lblReferralCode.text ?? "")
        }
    }

    @IBAction func actionSkip(_: Any) {
        if btnSkip.titleLabel?.text == "Cancel" {
            delegate?.popToSettings()
        } else {
            delegate?.moveToMainScreen()
        }
    }

    @IBAction func actionGetMoreStars(_: Any) {
        showLoader()
        delegate?.moveToReferFriendScreen(referal_code: lblReferralCode.text!)
    }
}

extension EarnStarsViewController:EarnStarDelegate {
    func didReceived(data: ReferralCode) {getReferralCode(data: data)}
    
    func didReceived(error: String) {}
}
