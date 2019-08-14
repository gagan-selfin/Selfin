//
//  NotificationsSettingsTableView.swift
//  Selfin
//
//  Created by cis on 20/12/18.
//  Copyright © 2018 Selfin. All rights reserved.
//

import UIKit
import RealmSwift

class NotificationsSettingsTableView: UITableView, UITableViewDelegate, UITableViewDataSource {
    var arrOptions = [Any]()
    var viewModel = NotificationSettingsViewModel()
    
    override func awakeFromNib() {
        viewModel.delegate = self
        delegate = self
        dataSource = self
        tableFooterView = UIView()
    }
    
    func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int
    {return arrOptions.count}
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NotificationsSettingsTableViewCell", for: indexPath) as! NotificationsSettingsTableViewCell
        
        cell.selectionStyle = .none
        
        if arrOptions.count - 1 == indexPath.row {
            
            if UserStore.user?.isPromotional ?? false {
                cell.switchOptions.isOn = true
            } else {
                cell.switchOptions.isOn = false
            }
            tableView.separatorStyle = .none
        } else {
            if UserStore.user?.isPush ?? false {
                cell.switchOptions.isOn = true
            } else {
                cell.switchOptions.isOn = false
            }
            tableView.separatorStyle = .singleLine
        }
        cell.lblOptions.text = arrOptions[indexPath.row] as? String
        
        cell.switchOptions.tag = indexPath.row
        cell.switchOptions.addTarget(self, action: #selector(swicthValueChanged(sender:)), for: .valueChanged)
        
        return cell
    }
    
    func tableView(_: UITableView, heightForRowAt _: IndexPath) -> CGFloat
    {return 60}
    
    func display(options: [Any]) {
        arrOptions = options
        reloadData()
    }
    
    @objc func swicthValueChanged(sender: UISwitch) {
        var isPromotional = Bool()
        var isPush = Bool()
        if sender.tag == 0 { // Push
            if sender.isOn {isPush = true}
            else {isPush = false}
            
            if UserStore.user?.isPromotional ?? true {isPromotional = true}
            else {isPromotional = false}

            viewModel.notificationsettingsProcess(isPromotional: isPromotional, isPush: isPush)
        } else { // Promotional
            if sender.isOn {isPromotional = true}
            else {isPromotional = false}
            
            if UserStore.user?.isPush ?? true {isPush = true}
            else {isPush = false}

            viewModel.notificationsettingsProcess(isPromotional: isPromotional, isPush: isPush)
        }
    }
}

extension NotificationsSettingsTableView:NotificationsSettingDelegate {
    func didReceived(data: NotificationSettings) {
        if data.status {
            
            let realm = try! Realm()
            let userList:User = realm.objects(User.self).first ?? User()
            try! realm.write  {
                userList.isPromotional = data.promotionalNotification
                userList.isPush = data.pushNotification
            }
            self.reloadData()
        }
    }
    func didReceived(error: String) {}
}
