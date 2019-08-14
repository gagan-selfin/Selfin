//
//  SettingsTableView.swift
//  Selfin
//
//  Created by cis on 06/12/18.
//  Copyright © 2018 Selfin. All rights reserved.
//

import UIKit
import RealmSwift

class SettingsTableView: UITableView, UITableViewDelegate, UITableViewDataSource {
    var options = [Any]()
    var image = [Any]()
    var viewModel = SettingsViewModel()
   // var user = [String: Any]()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        layer.cornerRadius = 10
        delegate = self
        dataSource = self
        tableFooterView = UIView()
    }
    
    //MARK:-
    //MARK:- TableView Datasource
    
    func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int
    {return options.count}
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {return cell(for: indexPath)}
    
    //MARK:-
    //MARK:- TableView Delegate

    func tableView(_: UITableView, heightForRowAt _: IndexPath) -> CGFloat
    {return UITableView.automaticDimension}
    
    func tableView(_: UITableView, didSelectRowAt indexPath: IndexPath)
    {didSelect!(indexPath.row)}
    
    //MARK:-
    //MARK:- Custom Methods

    func cell (for index:IndexPath) -> UITableViewCell {
        let cell = dequeueReusableCell(withIdentifier: "SettingsTableViewCell", for: index) as! SettingsTableViewCell
        
        cell.selectionStyle = .none
        cell.configureCell(image: image, options: options, index: index.row)
        cell.switchAccountType.addTarget(self, action: #selector(swicthValueChanged(sender:)), for: .valueChanged)
        
        if index.row == 3 {
           // if user[Constants.private_account.rawValue] != nil {
            if UserStore.user?.isPrivate ?? false {
                    cell.imgPublic.image = #imageLiteral(resourceName: "public unselected")
                    cell.imgPrivate.image = #imageLiteral(resourceName: "private selected")
                    cell.switchAccountType.isOn = true
                } else {
                    cell.imgPublic.image = #imageLiteral(resourceName: "public")
                    cell.imgPrivate.image = #imageLiteral(resourceName: "private")
                    cell.switchAccountType.isOn = false
                }
           // }
        }
        if index.row == options.count - 1
        {self.separatorStyle = .none}
        else
        {self.separatorStyle = .singleLine}
        return cell
    }
    
    func setAccountType (data:accountSettings) {
        if data.status {
            let realm = try! Realm()
            let userList:User = realm.objects(User.self).first ?? User()
            try! realm.write {userList.isPrivate = data.isPrivate}

            self.reloadData()
        }
    }
    
    func display(option: [Any], image: [Any]) {
        options = option
        self.image = image
        reloadData()
    }
    
    @objc func swicthValueChanged(sender: UISwitch) {
        var isPrivate = Bool()
        if sender.isOn {isPrivate = true}
        else {isPrivate = false}
        viewModel.delegate = self
        viewModel.setAccountTypeProcess(isPrivate: isPrivate)
    }
    var didSelect: ((_ feedID: Int) -> Void)?
}

extension SettingsTableView:SettingsDelegate {
    func didReceived(data:accountSettings)
    {setAccountType(data: data)}
    
    func didReceived(error msg:String) {}
    
}
