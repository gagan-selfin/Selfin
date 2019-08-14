//
//  TagListTableView.swift
//  Selfin
//
//  Created by cis on 04/10/2018.
//  Copyright © 2018 Selfin. All rights reserved.
//

import Nuke
import UIKit

protocol TagListTableDelegate : class {
    func fetchData(searchString : String, page :Int)
    func selectedUsers(taggedUser : [FollowingFollowersResponse.User])
}

class TagListTableViewCell: UITableViewCell {
    @IBOutlet var imageViewUser: UIImageView!
    @IBOutlet var labelUsername: UILabel!
    @IBOutlet var labelFullname: UILabel!
    @IBOutlet var buttonSelect: UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()
        imageViewUser.layer.cornerRadius = imageViewUser.frame.height / 2
        imageViewUser.clipsToBounds = true
    }

    func configure(with user: [String: Any]) {
        let userDetails: FollowingFollowersResponse.User = user["user"] as! FollowingFollowersResponse.User

        labelUsername.text = userDetails.username
        labelFullname.text = userDetails.firstName + " " + userDetails.lastName

        if userDetails.profileImage == "" {
            imageViewUser.image = #imageLiteral(resourceName: "Placeholder_image")
        } else {
            let imageURLProfile = environment.imageHost + userDetails.profileImage
            if let urlProfile = URL(string: imageURLProfile) {
                Nuke.loadImage(with: urlProfile, into: imageViewUser)
            }
        }
        
        if user["isSelected"] as! Bool {
            buttonSelect.isSelected = true
        } else {
            buttonSelect.isSelected = false
        }
    }
}

class TagListTableView: UITableView, UITableViewDelegate, UITableViewDataSource {
    var tableData = [[String: Any]]()
    var page_no = Int()
    var isMore = Bool()
    var arraySelectedUsers = [FollowingFollowersResponse.User]()
    var viewH : TagHeaderView?
    weak var controller:TagListTableDelegate?
    var page = 1
    var hasMore = true
    var strSearch = ""
    var isSearched = false

    override func awakeFromNib() {
        super.awakeFromNib()
        delegate = self
        dataSource = self
        viewH  = Bundle.main.loadNibNamed("TagHeaderView", owner: self, options: nil)?.first as? TagHeaderView
        
        layer.cornerRadius = 15
        clipsToBounds = true
    }

    func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        return tableData.count
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        //UI: this will round rect the corners of first and last cell
        if indexPath.row == 0 {cell.round(corners: [.topLeft, .topRight], withRadius: 15)}
        else if indexPath.row == tableData.count - 1 {cell.round(corners: [.bottomLeft, .bottomRight], withRadius: 15)}
        else {cell.round(corners: [.bottomLeft, .bottomRight], withRadius: 0)}
        
        if indexPath.row == tableData.count - 1 && hasMore {
            page += 1
            controller?.fetchData(searchString: strSearch, page: page)
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "TagList") as? TagListTableViewCell else {
            fatalError("urg")
        }
        cell.configure(with: tableData[indexPath.row])
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(arraySelectedUsers.count)
        
        tableView.deselectRow(at: indexPath, animated: true)
        let cell = tableView.cellForRow(at: indexPath) as! TagListTableViewCell

        if cell.buttonSelect.isSelected {
            cell.buttonSelect.isSelected = false
            tableData[indexPath.row]["isSelected"] = false
        } else {
            cell.buttonSelect.isSelected = true
            tableData[indexPath.row]["isSelected"] = true
        }
        let user = tableData[indexPath.row]["user"] as! FollowingFollowersResponse.User
        
        if arraySelectedUsers.contains(where: { ($0 as FollowingFollowersResponse.User).id == user.id }) {
             print(arraySelectedUsers.count)
            let index = arraySelectedUsers.index(where: { ($0 as FollowingFollowersResponse.User).id == user.id })
            arraySelectedUsers.remove(at: index!)
            
        } else {
            arraySelectedUsers.append(user)
        }
          print(arraySelectedUsers.count)
        //To load top collection view
        viewH?.didSelectCollection(user: arraySelectedUsers)
        
        //To show radio  button in table view
        tableView.reloadRows(at: [indexPath], with: .automatic)
        
        //pass values controller in order to send them to create post screen
        controller?.selectedUsers(taggedUser : arraySelectedUsers)
    }

    func tableView(_: UITableView, heightForRowAt _: IndexPath) -> CGFloat {
        return 70
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        viewH?.performSearch = { (stringSearch) in
            self.strSearch = stringSearch
            if self.strSearch == "" {self.isSearched = false}else {self.isSearched = true}
            self.page = 1
            self.controller?.fetchData(searchString: self.strSearch, page: self.page)
            return
        }
        return viewH
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if arraySelectedUsers.count > 0 {
            viewH?.heightConstrait.constant = CGFloat(SearchHeaderSize.TaggedUserViewHeight.rawValue)
            return CGFloat(SearchHeaderSize.headerSize.rawValue)}
        viewH?.heightConstrait.constant = CGFloat(SearchHeaderSize.initailCollectionHeight.rawValue)
        return CGFloat(SearchHeaderSize.SearchViewHeight.rawValue)
    }

    // MARK: -
    // MARK: - Custom Methods
    func display(user: [[String: Any]]) {
        hasMore = user.count > 0
        if page == 1 { tableData.removeAll() }
        tableData.append(contentsOf: user)
        reloadData()
    }
    
    func displaySelectedUserAtTop(user : [FollowingFollowersResponse.User]) {
        arraySelectedUsers.append(contentsOf: user)
        viewH?.didSelectCollection(user: arraySelectedUsers)
    }
    
    
}
