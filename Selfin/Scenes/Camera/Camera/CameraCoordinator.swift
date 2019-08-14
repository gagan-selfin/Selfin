//
//  CameraCoordinator.swift
//  Selfin
//
//  Created by Marlon Monroy on 6/30/18.
//  Copyright © 2018 Selfin. All rights reserved.
//

import UIKit

class CameraCoordinator: Coordinator<AppDeepLink> {
    let cameraViewController: SelfinCameraViewController = SelfinCameraViewController.from(from: .camera, with: .camera)
    var type : ScreenType = .camera
    
    override init(router: Router) {
        super.init(router: router)
        cameraViewController.delegate = self
        router.setRootModule(cameraViewController, hideBar: true)
    }
    
    func start(screenType : ScreenType) {type = screenType}
}

extension CameraCoordinator : CameraDelegate, dismissCameraOnPostSuccess {
    
    func dismissCameraOnPostSuccess() {
        DispatchQueue.main.async {
            self.router.dismissModule(animated: true, completion: nil)
            self.remove(child: self)
        }
    }
    
    func didPerformNavigationActionOnCamera(action : navActionOnCamera ){
        switch action {
        case .didMoveToFilter(let image):
            let coordinator = FiltersCoordinator(router: self.router as! Router)
            coordinator.start(image: image, screenType: type)
            coordinator.delegate = self
            add(coordinator)
        case .shouldDismissCamera():
            router.dismissModule(animated: true, completion: nil)
            remove(child: self)
        }
    }
}
