//
//  MediaPickerViewController.swift
//  Selfin
//
//  Created by cis on 23/11/2018.
//  Copyright © 2018 Selfin. All rights reserved.
//

import UIKit

protocol MediaPickerDelegate : class {
    func didRecieveMedia(type : MessageType, image : UIImage? , videoURL : URL?)
}

class MediaPickerViewController: UIImagePickerController,UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    weak var mediaDelegate : MediaPickerDelegate?

    override func viewDidLoad() {
        super.viewDidLoad()
        delegate = self
        sourceType = .photoLibrary
        allowsEditing = true
        // Do any additional setup after loading the view.
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        // Local variable inserted by Swift 4.2 migrator.
        let info = convertFromUIImagePickerControllerInfoKeyDictionary(info)
        
        picker.dismiss(animated: true) {
            if let isData = info["UIImagePickerControllerMediaType"] as? String {
                if isData == "public.image" {
                    if let isImage = info[convertFromUIImagePickerControllerInfoKey(UIImagePickerController.InfoKey.editedImage)] as? UIImage {self.mediaDelegate?.didRecieveMedia(type: .image, image: isImage, videoURL: nil)
                    }
                } else {
                    if let videoURL = info["UIImagePickerControllerMediaURL"] as? URL {self.mediaDelegate?.didRecieveMedia(type: .video, image: nil, videoURL: videoURL)
                    }
                }
            }
        }
    }
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromUIImagePickerControllerInfoKeyDictionary(_ input: [UIImagePickerController.InfoKey: Any]) -> [String: Any] {
    return Dictionary(uniqueKeysWithValues: input.map { key, value in (key.rawValue, value) })
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromUIImagePickerControllerInfoKey(_ input: UIImagePickerController.InfoKey) -> String {
    return input.rawValue
}

