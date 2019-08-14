//
//  SchedulePostListViewModel.swift
//  Selfin
//
//  Created by cis on 12/10/18.
//  Copyright © 2018 Selfin. All rights reserved.
//

import Foundation

final class SchedulePostListViewModel {
    let task = UserTask(username: "")
    weak var delegate:SchedulePostControllerDelegate?

    func getSchedulePostListProcess(page:Int) {
        task.scheduledPost(page:page)
            .done {self.delegate?.didReceived(response_type: .list(data: $0))}
            .catch{self.delegate?.didReceived(response_type: .error(err: String(describing: $0)))}
    }
    
    func deleteSchedulePost(postId:Int){
        task.deleteScheduledPost(id: postId)
            .done{self.delegate?.didReceived(response_type: .delete(response: $0))}
            .catch{self.delegate?.didReceived(response_type: .error(err: String(describing: $0)))}
    }
    
    func shareNow(postId:Int, scheduled_time:String) {
        task.shareNow(with: UserTaskParams.EditScheduleTime(scheduled_time:scheduled_time), id: postId)
            .done{self.delegate?.didReceived(response_type: SchedulePostAPIResponse.editTime(response: $0))}
            .catch{self.delegate?.didReceived(response_type: .error(err: String(describing: $0)))}
    }

    func editSchedulePostProcess(postId: Int, dict: [String: Any]) {
//        task.editPost(postId: postId, dict: dict).done { data in
//
//            print(data)
//            self.isSuccess!(true, data)
//        }.catch { _ in
//            self.isSuccess!(false, nil)
//        }
    }
}
