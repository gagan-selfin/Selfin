//
//  TagListViewController.swift
//  Selfin
//
//  Created by cis on 04/10/2018.
//  Copyright © 2018 Selfin. All rights reserved.
//

import UIKit

class TagListViewController: UIViewController {

    @IBOutlet var tableView: TagListTableView!
    @IBOutlet var buttonNext: UIButton!
    @IBOutlet var headerView: UIView!
    
    var delegate: TagListViewControllerDelegate?
    var viewModel = TagListViewModel()
    var arraySelectedUsers = [FollowingFollowersResponse.User]()
    var isAlreadyPicked = false

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        buttonNext.applyGradient(colours: [UIColor(red: 240 / 255, green: 48 / 255, blue: 193 / 255, alpha: 1), UIColor(red: 180 / 255, green: 89 / 255, blue: 210 / 255, alpha: 1)])
    }
    
    fileprivate func setup () {
        backButton()
        viewModel.controller = self
        tableView.controller = self
        showUsers(string: "")
        
        
        //To show selected user when user come again to select more user
        if isAlreadyPicked && arraySelectedUsers.count > 0 {self.tableView.displaySelectedUserAtTop(user:self.arraySelectedUsers)
        }
    }

    func showUsers(string: String) {
        showLoader()
        viewModel.searchApplicationsUsersToTag(searchString: string, pageNumber: 1)
    }
    
    @IBAction func actionSearch(_: Any) {}

    @IBAction func actionNext(_: Any) {
         if arraySelectedUsers.count > 0 {
            delegate?.taggedUser(Users: arraySelectedUsers)
         }
    }
}

extension TagListViewController : tagViewModelDelegate,TagListTableDelegate {
    
    func didReceived(data:[FollowingFollowersResponse.User]) {
        var arrayTags = [[String: Any]]()
        for user in data {
            if self.arraySelectedUsers.contains(where: { ($0 as FollowingFollowersResponse.User).id == user.id}) {
                arrayTags.append(["user": user, "isSelected": true])
            } else {
                arrayTags.append(["user": user, "isSelected": false])
            }
        }
        self.tableView.display(user: arrayTags)
        self.hideLoader()
    }
    
    func didReceived(error msg:String) {}
    
    func fetchData(searchString : String, page :Int) {
        viewModel.searchApplicationsUsersToTag(searchString: searchString, pageNumber: page)
    }
    
    func selectedUsers(taggedUser : [FollowingFollowersResponse.User]) {
        arraySelectedUsers = taggedUser
    }
}
