//
//  SchedulePostListAction.swift
//  Selfin
//
//  Created by cis on 17/12/18.
//  Copyright © 2018 Selfin. All rights reserved.
//

import Foundation
protocol SchedulePostListViewControllerDelegate {
    func popBackToProfile()
    func schedulePost(postId: Int)
    func editSchedulePost(postId: Int, scheduleTime: String, postDetails: String, postImage: String, locationName: String, latitude: String, longitude: String, tags: [UserDetails])
    func editPost(data:scheduledPostResponse.Post)
}

enum SchedulePostAPIResponse {
    case list(data:scheduledPostResponse)
    case error(err:String)
    case delete(response:ReusableResponse)
    case editTime(response:ReusableResponse)

}

protocol SchedulePostControllerDelegate: class {
    func didReceived(response_type:SchedulePostAPIResponse)
}

enum SchedulePosthandlerCases : String {
    case edit = "Edit Post"
    case scheduleTime = "Edit Schedule Time"
    case share = "Share It Now"
    case delete = "Delete"
}

protocol SchedulePostTableDelegate: class
{func setData (page:Int)}
