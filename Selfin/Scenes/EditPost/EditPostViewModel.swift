//
//  EditPostViewModel.swift
//  Selfin
//
//  Created by cis on 20/12/2018.
//  Copyright © 2018 Selfin. All rights reserved.
//

import Foundation
import UIKit

protocol EditPostDelegate : class  {
    func didReceived(result : ReusableResponse )
    func didReceived(error msg:String)
}
final class EditPostViewModel {
    weak var delegate:EditPostDelegate?
    
    let task = UserTask(username: "")

    func editPost(content: String, scheduleTime : String, taggedUsers : [Int], id : Int) {
        task.editScheduledPost(param: UserTaskParams.EditScheduledPost(content:content, scheduleTime:scheduleTime, taggedUsers : taggedUsers), id: id)
        .done{self.delegate?.didReceived(result: $0)}
        .catch {self.delegate?.didReceived(error: String(describing: $0.localizedDescription))}
    }
    
    
//    func createPost(image : UIImage, locationName : String, long : Double, lat : Double, content : String, scheduleTime : String, taggedUsers : [Int], postId : Int) {
//
//        let dict = ["location_name":locationName, "longtitude":long, "latitude":lat, "post_content":content, "scheduled_time":scheduleTime,"tag_users":taggedUsers] as [String : Any]
//
//        if ConstantManagerSharedInstance.isNetworkConnected() {
//            //let url = "http://54.153.51.29:8055" + "v1/user/scheduled-post/\(postId)/";
//            let url = API.BASE_URL.rawValue + "v1/user/scheduled-post/\(postId)/";
//            ConstantManagerSharedInstance.callPostServiceForSendingImage(postdata: dict as NSDictionary, urlString: url, isMultipart: true, isImage: true, imageObj: image, imageParam: "image") { (result, error) in
//                print(result)
//                if result["status"] as! Bool == true {
//                    self.delegate?.didReceived(result: result)
//                }else {
//                    print(error?.localizedDescription ?? "")
//                    self.delegate?.didReceived(error: error?.localizedDescription ?? "")
//                }
//            }
//        }
//    }

}
