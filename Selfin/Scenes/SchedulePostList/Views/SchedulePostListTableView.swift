//
//  SchedulePostListTableView.swift
//  Selfin
//
//  Created by cis on 17/12/18.
//  Copyright © 2018 Selfin. All rights reserved.
//

import UIKit

class SchedulePostListTableView: UITableView, UITableViewDelegate, UITableViewDataSource {
    var controller:SchedulePostTableDelegate?
    var feeds: [scheduledPostResponse.Post] = []
    var page = 1
    var hasMore = true

    override func awakeFromNib() {
        delegate = self
        dataSource = self
        isScrollEnabled = true
        bounces = true
        alwaysBounceVertical = true
    }
    
    func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int
    {return feeds.count}
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "SchedulePostListTableViewCell", for: indexPath) as! SchedulePostListTableViewCell
            cell.selectionStyle = .none
            
            cell.configure(with: feeds[indexPath.row])
            
            cell.btnDropDown.tag = indexPath.row
            cell.btnDropDown.addTarget(self, action: #selector(btnDropDownPressed(sender:)), for: .touchUpInside)
            
            return cell
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let cell = dequeueReusableCell(withIdentifier: "FooterView")
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if feeds.count ==  0 {return 55.0}
        return 0.0
    }
    
    func tableView(_: UITableView, heightForRowAt _: IndexPath) -> CGFloat
    {return UITableView.automaticDimension}
    
    func tableView(_: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath)
    {handlePagination(controller: controller, indexPath: indexPath)}
    
    func display(feed: [scheduledPostResponse.Post], localPage : Int) {
        hasMore = feed.count > 0
        if page == 1 || localPage == 1 {feeds.removeAll()}
        feeds.append(contentsOf: feed)
        reloadData()
    }
    
    func handlePagination(controller : SchedulePostTableDelegate?, indexPath : IndexPath)
    {
        if indexPath.row == feeds.count - 1 && hasMore {
            page += 1
            controller?.setData(page: page)}
    }
    
    func deletePost (index:Int) {
        if #available(iOS 11.0, *) {
            performBatchUpdates({
                self.feeds.remove(at: index)
                self.deleteRows(at: [IndexPath.init(row: index, section: 0)], with: .automatic)
            }, completion:{ (true) in
                self.reloadData()
            })
        } else {
            // Fallback on earlier versions
        }
    }

    func updateScheduleTime(updatedTime:String, index:Int) {
        self.feeds[index].updatedAt = updatedTime
        
        let indexPosition = IndexPath(row: index, section: 0)
        reloadRows(at: [indexPosition], with: .none)
    }
    
    @objc func btnDropDownPressed(sender: UIButton)
    {schedulePressed!(sender.tag)}
    
    var schedulePressed: ((_ postId: Int) -> Void)?
}
