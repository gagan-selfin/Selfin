//
//  SchedulePostListViewController.swift
//  Selfin
//
//  Created by cis on 04/10/18.
//  Copyright © 2018 Selfin. All rights reserved.
//

import UIKit

class SchedulePostListViewController: UIViewController {
    var delegate: SchedulePostListViewControllerDelegate?
    @IBOutlet var tblView: SchedulePostListTableView!
    var viewModel = SchedulePostListViewModel()
    var feed: [scheduledPostResponse.Post] = []
    var index = Int()
    var scheduleTime:String?
    @IBOutlet var viewSchedulePost: SchedulePostTime!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.delegate = self
        backButton()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if #available(iOS 11.0, *)
        {navigationController?.navigationBar.prefersLargeTitles = true
            navigationController?.navigationItem.largeTitleDisplayMode = .always
        } else {/*Fallback on earlier versions*/}
        tblView.schedulePressed = schedulePost
        viewModel.getSchedulePostListProcess(page: 1)
    }

    // MARK: -
    // MARK: - API Call
    func callEditSchedulePostWebService(dictionary: Dictionary<String, Any>, urlString: String) {
        if ConstantManagerSharedInstance.isNetworkConnected() {
            let img = UIImage()
            showLoader() // Show loader
            ConstantManagerSharedInstance.callPutServiceForSendingImage(postdata: dictionary as NSDictionary, urlString: urlString, isMultipart: true, isImage: false, imageObj: img, imageParam: "image1", consumer: { result, _ in

                DispatchQueue.main.async {
                    self.hideLoader() // Hide loader
                    if result["status"] as! Bool == true {

                    } else {
                        // self.showAlert(str: result["msg"] as! String)
                    }
                }
            })
        }
    }

    // MARK: -
    // MARK: - Custom Methods

    func schedulePost(id: Int){
        index = id
        showPostSheet()
    }
    
    func showPostSheet() {
        let actionSheet = UIAlertController.PostAction(titles: SchedulePosthandlerCases.edit.rawValue,SchedulePosthandlerCases.scheduleTime.rawValue,SchedulePosthandlerCases.share.rawValue,SchedulePosthandlerCases.delete.rawValue, handler: postActionHandler)
        self.present(actionSheet, animated: true, completion: nil)
    }
    
    func postActionHandler(_ alert:UIAlertAction) {
        guard let title = alert.title else { return}
        switch title {
        case SchedulePosthandlerCases.edit.rawValue:
            delegate?.editPost(data: feed[index])
        case SchedulePosthandlerCases.scheduleTime.rawValue:
            viewSchedulePost.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height);
            UIApplication.shared.keyWindow?.addSubview(viewSchedulePost)
            viewSchedulePost.scheduleDate = { date in
                self.scheduleTime = date
                self.viewModel.shareNow(postId: self.feed[self.index].id, scheduled_time: date)}
        case SchedulePosthandlerCases.share.rawValue:
            showPermissionAlert(str: "Are you sure, you want to share this post now?")
            {self.viewModel.shareNow(postId: self.feed[self.index].id, scheduled_time: "")}
        case SchedulePosthandlerCases.delete.rawValue:
            showPermissionAlert(str: "Are you sure, you want to delete this post?")
            {self.viewModel.deleteSchedulePost(postId: self.feed[self.index].id)}
        default:break
        }
    }

    func editScheduleTime (resp:ReusableResponse) {
        if resp.status {
            showAlert(str: resp.message)
            if resp.message == "Post shared" {
                self.feed.remove(at: index)
                self.tblView.display(feed: self.feed, localPage: 1)
            }
            else {
                self.tblView.updateScheduleTime(updatedTime: self.scheduleTime!, index: self.index)
            }
        }
    }
    
    // MARK: -
    // MARK: - Button Actions
    
    @IBAction func btnCrossPressed(_: Any) {delegate?.popBackToProfile()}
}

extension SchedulePostListViewController:SchedulePostControllerDelegate, SchedulePostTableDelegate {
    func setData(page: Int) {viewModel.getSchedulePostListProcess(page: page)}
    
    func didReceived(response_type: SchedulePostAPIResponse) {
        switch response_type {
        case .list(data: let data):
            if (data.status){
                feed.removeAll()
                feed.append(contentsOf: data.post)
                self.tblView.display(feed: feed, localPage: 1)
            }
        case .error(err: _):
            break
        case .delete(let response):
            if response.status {self.tblView.deletePost(index: index)}
        case .editTime(let response):
            if response.status {editScheduleTime(resp: response)}
        }
    }
}
