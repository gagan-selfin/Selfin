//
//  FiltersCoordinator.swift
//  Selfin
//
//  Created by cis on 04/01/2019.
//  Copyright © 2019 Selfin. All rights reserved.
//

import Foundation
import UIKit
class FiltersCoordinator: Coordinator<AppDeepLink> {
    let controller: FiltersViewController = FiltersViewController.from(from: .filters, with: .filters)
    weak var delegate : dismissCameraOnPostSuccess?
    var type: ScreenType = .camera
    
    override init(router: Router) {
        super.init(router: router)
        controller.delegate = self
        router.push(controller, animated: false, completion: nil)
    }
    
    func start(image : UIImage, screenType : ScreenType) {
        controller.image = image
        type = screenType
    }
    
    func moveToCreatePost(image: UIImage) {
        let createP = CreatePostCoordinator(router: router as! Router)
        createP.delegate = self
        createP.start(image: image)
        add(createP)
    }
}

extension FiltersCoordinator : FiltersViewDelegate, postSuccessfull {
    func didFinishPosting() {
        DispatchQueue.main.async {
            self.dismiss()
            self.delegate?.dismissCameraOnPostSuccess()
        }
    }
    
    func didPerformAction(action: actionOnCamera) {
        switch action {
        case .didCancel(): dismiss()
        case .didMoveToCreatePost(let image):
            if type == .camera {moveToCreatePost(image: image); return}
            selectedImage(image: image)
            delegate?.dismissCameraOnPostSuccess()
            dismiss()
        }
    }
    
    func dismiss() {
        remove(child: self)
        router.popModule(animated: false)
    }
    
    func selectedImage(image: UIImage) {
        let strData = image.pngData()
        if strData != nil {
            let encryptedDataText = strData!.base64EncodedString(options: NSData.Base64EncodingOptions())
            let dict: [String: Any] = ["image": encryptedDataText]
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "setProfileImage"), object: dict)
        }
    }
}
