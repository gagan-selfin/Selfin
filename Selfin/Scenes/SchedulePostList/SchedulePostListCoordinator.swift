//
//  SchedulePostListCoordinator.swift
//  Selfin
//
//  Created by cis on 04/10/18.
//  Copyright © 2018 Selfin. All rights reserved.
//

import UIKit

protocol SchedulePostListCoordinatorDelegate {
    func popToProfileFromSchedulePost()
}

class SchedulePostListCoordinator: Coordinator<AppDeepLink> {
    var delegate: SchedulePostListCoordinatorDelegate?

    var isCallRefreshLocal = Bool()
    var isShowPickerLocal = Bool()
    var isShareNowLocal = Bool()

    var locationNameLocal = String()
    var postIdLocal = Int()
    var scheduleTimeLocal = String()
    var postImageLocal = String()
    var postDetailsLocal = String()
    var latLocal = String()
    var longLocal = String()
    var arrAlreadyTagged = [UserDetails]()

    lazy var controller: SchedulePostListViewController = {
        let controller: SchedulePostListViewController = SchedulePostListViewController.from(from: .schedule_post_list, with: .schedule_post_list)
        controller.delegate = self
        return controller
    }()

    override init(router: Router) {
        super.init(router: router)
    }
    
    override func toPresentable() -> UIViewController {
        return controller
    }

    lazy var createP: CreatePostCoordinator = {
        let nav = selfinNavigationController()
        let router = Router(navigationController: nav)
        let coordinator = CreatePostCoordinator(router: router)
        return coordinator
    }()
}

extension SchedulePostListCoordinator: SchedulePostListViewControllerDelegate {
    
    func editPost(data: scheduledPostResponse.Post) {
        let editPost = EditPostCoordinator(router: router as! Router)
        editPost.start(post : data)
        add(editPost)
//        navigator?.hidesCamera(hides: true)
        self.router.push(editPost, animated: true, completion: {[weak self, editPost] in
            self?.remove(child: editPost)
        })
    }
    
    func editSchedulePost(postId: Int, scheduleTime: String, postDetails: String, postImage: String, locationName: String, latitude: String, longitude: String, tags: [UserDetails]) {
        locationNameLocal = locationName
        postIdLocal = postId
        scheduleTimeLocal = scheduleTime
       // postImageLocal = postImage
        postDetailsLocal = postDetails
        latLocal = latitude
        longLocal = longitude
        arrAlreadyTagged = tags
    }

    func dismissViewToEditScheduleTime(isCallRefresh: Bool) {
        isCallRefreshLocal = isCallRefresh
        router.dismissModule(animated: true, completion: nil)
       // remove(child: actionMore)
    }

    func dismissView(isCallRefresh: Bool, isShowPicker: Bool, isShareNow: Bool) {
        isCallRefreshLocal = isCallRefresh
        isShowPickerLocal = isShowPicker
        isShareNowLocal = isShareNow

        router.dismissModule(animated: true, completion: nil)
       // remove(child: actionMore)
    }

//    func deletePostAndRefreshView(data: [Feed]) {
//        router.dismissModule(animated: true, completion: nil)
//    }

    func actionCancel() {
        router.dismissModule(animated: true, completion: nil)
       // remove(child: actionMore)
    }

    func refreshProfileView() {
        if isCallRefreshLocal {
            isCallRefreshLocal = false

            createP = CreatePostCoordinator(router: router as! Router)
//            createP.isSchedulePost = true
//            createP.postId = postIdLocal
//            createP.postDetails = postDetailsLocal
//            createP.scheduleTime = scheduleTimeLocal
//            createP.postImage = postImageLocal
//            createP.locationName = locationNameLocal
//            createP.latitude = latLocal
//            createP.longitude = longLocal
//            createP.isShowPicker = isShowPickerLocal
//            createP.arrAlreadyTagged = arrAlreadyTagged

            if isShowPickerLocal {
                isShowPickerLocal = false
            }

            createP.start()
            add(createP)
        } else {
            //            if UserDefaults.standard.object(forKey: "isShare") != nil {
            //                UserDefaults.standard.removeObject(forKey: "isShare")
            //                controller.shareItNow()
            //            }
        }
    }

    func schedulePost(postId: Int) {
//        actionMore = ActionOnPostCoordinate(router: router as! Router)
//        print(actionMore)
//        actionMore.isFeed = false
//        actionMore.postId = postId
//        actionMore.isSchedule = true
//        actionMore.delegate = self
//        actionMore.start()
//        add(actionMore)
    }

    func popBackToProfile() {
        delegate?.popToProfileFromSchedulePost()
    }
}
