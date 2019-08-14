//
//  SettingsViewController.swift
//  Selfin
//
//  Created by cis on 20/09/18.
//  Copyright © 2018 Selfin. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {
    @IBOutlet var tblViewSettings: SettingsTableView!

    var delegate: SettingsViewControllerDelegate?
    let viewModel = SettingsViewModel()
    var isAvatarImageChange = Bool()

    override func viewDidLoad() {
        super.viewDidLoad()
        setUp ()
        backButton()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = false
        
        if #available(iOS 11.0, *)
        {navigationController?.navigationBar.prefersLargeTitles = false}
        else {/*Fallback on earlier versions*/}
    }

    func setUp () {
        var arrOptions = [Any]()
        var arrImgOptions = [Any]()

        tblViewSettings.didSelect = didSelect
        viewModel.delegate = self
        
        arrOptions = [SettingsTableViewOptions.editProfile.rawValue, SettingsTableViewOptions.faq.rawValue, SettingsTableViewOptions.notifications.rawValue, SettingsTableViewOptions.accountType.rawValue,
            SettingsTableViewOptions.BlockedUser.rawValue,
            SettingsTableViewOptions.earnStars.rawValue, SettingsTableViewOptions.privacyPolicy.rawValue, SettingsTableViewOptions.terms.rawValue,SettingsTableViewOptions.mobile.rawValue, SettingsTableViewOptions.changePwd.rawValue, SettingsTableViewOptions.contactUs.rawValue, SettingsTableViewOptions.logout.rawValue]
        arrImgOptions = [#imageLiteral(resourceName: "edit profile"), #imageLiteral(resourceName: "FAQ"), #imageLiteral(resourceName: "Notifications"), #imageLiteral(resourceName: "Account Type"), #imageLiteral(resourceName: "EarnStar_Setting"), #imageLiteral(resourceName: "blocklist"), #imageLiteral(resourceName: "Privacy Policy"), #imageLiteral(resourceName: "Terms of Condition"), #imageLiteral(resourceName: "Privacy Policy"),#imageLiteral(resourceName: "Change_Pwd"), #imageLiteral(resourceName: "Contact Us")]
        
        tblViewSettings.display(option: arrOptions, image: arrImgOptions)
    }
    
    func logoutUser(success:Bool) {
        if success {
            UserStore.delete()
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            _ = AppCoordinator(window: appDelegate.window!)
        }
    }
    
    func didSelect(id: Int) {
        if id == 11 
        {showPermissionAlert(str: "Are you sure, you want to logout?")
        {self.viewModel.performLogout()}}
        else
        {delegate?.didSelect(index: id)}
    }
}

extension SettingsViewController:SettingsDelegate {
    func didReceived(success: Bool){logoutUser(success: success)}
    func didReceived(error msg:String) {
       showAlert(str: msg)
    }
}

