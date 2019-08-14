//
//  testImageCoordinator.swift
//  Selfin
//
//  Created by cis on 04/03/19.
//  Copyright © 2019 Selfin. All rights reserved.
//

import UIKit

protocol testImageCoordinatorProtocol : class {
    func didMoveToCreatePost(image:UIImage)
}
class testImageCoordinator: Coordinator<AppDeepLink> {
    let cameraViewController: testImageViewController = testImageViewController.from(from: .testImage, with: .testImage)
    
    override init(router: Router) {
        super.init(router: router)
    }
    
    override func start() {
        cameraViewController.delegate = self
        router.setRootModule(cameraViewController, hideBar: true)
    }
    
    func moveToCreatePost(image: UIImage) {
        let createP = CreatePostCoordinator(router: router as! Router)
        createP.start(image: image)
        add(createP)
    }
}

extension testImageCoordinator: testImageCoordinatorProtocol{
    func didMoveToCreatePost(image: UIImage) {
        moveToCreatePost(image: image)
    }
}
