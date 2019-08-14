//
//  NotificationsViewController.swift
//  Selfin
//
//  Created by Marlon Monroy on 6/30/18.
//  Copyright © 2018 Selfin. All rights reserved.
//

import UIKit

class NotificationsViewController: UIViewController {
    @IBOutlet var tableView: NotificationsTableView!
    let viewModel = NotificationViewModel()
    var notificationType:Type_Notification = .type_self
    weak var delegate:NotificationCoordinatorDelegate?
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action:
            #selector(handleRefresh(_:)),
                                 for: .valueChanged)
        return refreshControl
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.addSubview(refreshControl)
        tableView.delegateAction = self
        tabBarItem.selectedImage = #imageLiteral(resourceName: "notificationsSelected").withRenderingMode(.alwaysOriginal)

        tableView.onSelection = onSelection
        getNotification(type: notificationType)
        
        navigationController?.navigationBar.barTintColor = UIColor.white
        navigationController?.navigationBar.shadowImage = UIImage()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        navigationController?.hidesBarsOnSwipe = false
        self.navigationController?.isNavigationBarHidden = false
        if #available(iOS 11.0, *){navigationController?.navigationBar.prefersLargeTitles = true}
        else {/* Fallback on earlier versions*/}
    }
    
    // MARK: - Custom Methods
    func setupTable (data: UserNotification, notificationType:Type_Notification) {
        if data.status {
            tableView.display(list: data.notification, notificationType: notificationType)
        }
    }

    func getNotification(type: Type_Notification) {
        viewModel.controller = self
        tableView.controller = self
        viewModel.getNotification(notificationType: type, page: 1)
    }
    
    func onSelection(type:Type_Notification) {
        notificationType = type
        if tableView.notificationList.count  == 0 || tableView.socialList.count == 0 {
            getNotification(type: type)
            return}
       tableView.switchNotificationType(type:type)
    }
    
    @objc func handleRefresh(_ refreshControl: UIRefreshControl) {
        tableView.prepareToRefresh(type: notificationType)
        viewModel.getNotification(notificationType: notificationType, page: 1)
    }
}

extension NotificationsViewController:NotificationController, NotificationsTableDelegate, NotificationDelegate {
    func showPostDetails(postId:Int)
    {delegate?.showPostDetails(postId: postId)}
    
    func setData(page: Int, type: Type_Notification)
    {viewModel.getNotification(notificationType: type, page: page)}
    
    func showProfile(username: String)
    {delegate?.showProfile(username: username)}
    
    func didReceived(data:UserNotification, notificationType:Type_Notification)
    {refreshControl.endRefreshing();setupTable(data: data, notificationType: notificationType)}
    
    func didReceived(erorr msg:String) {print(msg)}
}
