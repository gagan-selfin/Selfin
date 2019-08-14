//
//  TextMessagesTableViewCell.swift
//  Selfin
//
//  Created by cis on 23/11/2018.
//  Copyright © 2018 Selfin. All rights reserved.
//

import UIKit
import Nuke

class TextMessagesTableViewCell: UITableViewCell {
    @IBOutlet var labelName: UILabel!
    @IBOutlet var labelTime: UILabel!
    @IBOutlet var viewBackground: CustomRoundCornerView!
    @IBOutlet var labelMessage: UILabel!
    @IBOutlet var userImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configure(message : HSBubble){
        labelMessage.text = "\(message.message)"
        let date = Date(timeIntervalSince1970: TimeInterval(message.time))
        labelTime.text = timeAgoSince(date)

        if userImageView != nil {
        if message.image != "" {
            let url = URL(string: message.image)
             Nuke.loadImage(with: url!, into: userImageView)
        }else {userImageView.image = UIImage.init(named: "Placeholder_image")}}
        
        transform = CGAffineTransform(rotationAngle: -CGFloat(Double.pi))
    }
}

class MediaMessagesTableViewCell: UITableViewCell {
    
    @IBOutlet var imageViewMedia: UIImageView!
    @IBOutlet var buttonOpenMedia: UIButton!
    @IBOutlet var labelTime: UILabel!
    weak var delegate : ChatRoomTableViewCellDelegate?
    var mediaMessage = HSBubble()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configure(message : HSBubble, tag : Int){
        mediaMessage = message
        if message.type == "image" {
            if message.message == "" {
                imageViewMedia.image = #imageLiteral(resourceName: "Placeholder_image")
            } else {
                let imageURLProfile = message.message
                
                if let urlProfile = URL(string: imageURLProfile) {
                    Nuke.loadImage(with: urlProfile, into: imageViewMedia)
                }
            }
            buttonOpenMedia.setTitle("", for: .normal)
        } else {
            imageViewMedia.image = nil
            buttonOpenMedia.setTitle("Play", for: .normal)
        }
        buttonOpenMedia.tag = tag
        buttonOpenMedia.addTarget(self, action: #selector(actionOpenPost(_:)), for: .touchUpInside)
        let date = Date(timeIntervalSince1970: TimeInterval(message.time))
        labelTime.text = timeAgoSince(date)
        transform = CGAffineTransform(rotationAngle: -CGFloat(Double.pi))
    }
    
    @objc func actionOpenPost(_ sender: UIButton) {
        if mediaMessage.type == "image" {delegate?.didPerformOperationOnMediaMessage(type: .image, mediaPath: mediaMessage.message)
        } else {delegate?.didPerformOperationOnMediaMessage(type: .video, mediaPath: mediaMessage.message)
        }
    }
}
