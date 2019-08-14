//
//  EditProfileCoordinator.swift
//  Selfin
//
//  Created by cis on 24/09/18.
//  Copyright © 2018 Selfin. All rights reserved.
//

import UIKit

protocol captureImageDelegate {
    func selectedImageToSetProfile(image: UIImage)
}

protocol EditProfileCoordinatorDelegate {
    func popBackToPreviousScreen(isAvatarImageChange: Bool)
    func callProfileApi(isAvatarImageChange: Bool)
}

extension EditProfileCoordinatorDelegate {
    func popBackToPreviousScreen(isAvatarImageChange _: Bool) {}
    func callProfileApi(isAvatarImageChange _: Bool) {}
}

class EditProfileCoordinator: Coordinator<AppDeepLink> {
    var heading = String()
    var delegate: EditProfileCoordinatorDelegate?
    var delegateCapture: captureImageDelegate?
    var imgAvatar = UIImage()
    var isImage = Bool()

    lazy var controller: EditProfileViewController = {
        let controller: EditProfileViewController = EditProfileViewController.from(from: .edit_profile, with: .edit_profile)
        controller.delegate = self
        return controller
    }()

    override init(router: Router) {
        super.init(router: router)
    }

    override func start() {
        controller.delegate = self
        controller.isImage = isImage
        controller.imgAvatar = imgAvatar
    }
    
    override func toPresentable() -> UIViewController {
        return controller
    }

    func camereSelected() {
        let nav = selfinNavigationController()
        let cameraRouter = Router(navigationController: nav)
        let coordinator = CameraCoordinator(router: cameraRouter)
        coordinator.start(screenType: .editProfile)
        router.present(coordinator, animated: true)
        add(coordinator)
    }

}

extension EditProfileCoordinator: EditProfileViewControllerDelegate {
    func openCameraForEditingAvatar() {
        camereSelected()
    }

    func callProfileApi(isAvatarImageChange: Bool) {
        delegate?.callProfileApi(isAvatarImageChange: isAvatarImageChange)
    }

    func moveToPreviousScreen(isAvatarImageChange _: Bool) {
        router.popModule(animated: true)
        remove(child: self)
    }
}

