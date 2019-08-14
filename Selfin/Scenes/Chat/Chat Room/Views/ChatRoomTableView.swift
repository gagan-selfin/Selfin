//
//  ChatListCell.swift
//  Selfin
//
//  Created by cis on 25/09/18.
//  Copyright © 2018 Selfin. All rights reserved.
//

import AVKit

class ChatRoomTableView: UITableView, UITableViewDelegate, UITableViewDataSource {
    
    var tableData: [HSBubble] = []
    weak var controller : ChatRoomOpenMediaDelegate?
    var lastMessageId = String()

    override func awakeFromNib() {
        super.awakeFromNib()
        delegate = self
        dataSource = self
        transform = CGAffineTransform(rotationAngle: -CGFloat(Double.pi))
    }

    func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        return tableData.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let userid : Int = UserStore.user?.id ?? 0
        
        if userid == tableData[indexPath.row].id {
            if tableData[indexPath.row].type == MessageType.text.rawValue {
                return configure(index: indexPath, identifier: .sentMessages)
            } else {return configure(index: indexPath, identifier: .sentMedia)}
        } else {
            if tableData[indexPath.row].type == MessageType.text.rawValue {
                return configure(index: indexPath, identifier: .receivedMessages)
            } else {return configure(index: indexPath, identifier: .receivedMedia)}
        }
    }

    func tableView(_: UITableView, heightForRowAt _: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func configure(index : IndexPath, identifier : chatRoomIdentifiers) -> UITableViewCell {
        if tableData[index.row].type == MessageType.text.rawValue {
            let cell = self.dequeueReusableCell(withIdentifier: identifier.rawValue) as! TextMessagesTableViewCell
            cell.configure(message: tableData[index.row])
            return cell
        } else {
            let cell = self.dequeueReusableCell(withIdentifier: identifier.rawValue) as! MediaMessagesTableViewCell
            cell.configure(message: tableData[index.row], tag: index.row)
            cell.delegate = self
            return cell
        }
    }

    func display(message: HSBubble) {
        tableData.insert(message, at: 0)
        reloadData()
        lastMessageId = tableData.last?.chatID ?? ""
    }
}

extension ChatRoomTableView : ChatRoomTableViewCellDelegate {
    func didPerformOperationOnMediaMessage(type: MessageType, mediaPath: String) {
        controller?.openMediaFiles(type: type, mediaPath: mediaPath)
    }
}
