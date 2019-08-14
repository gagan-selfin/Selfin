//
//  cameraAction.swift
//  Selfin
//
//  Created by cis on 07/01/2019.
//  Copyright © 2019 Selfin. All rights reserved.
//

import Foundation
import UIKit

protocol FiltersViewDelegate : class {
    func didPerformAction(action: actionOnCamera)
}

enum actionOnCamera  {
    case didMoveToCreatePost(image : UIImage)
    case didCancel()
}

protocol dismissCameraOnPostSuccess : class {
    func dismissCameraOnPostSuccess()
}

protocol CameraDelegate : class  {
    func didPerformNavigationActionOnCamera(action : navActionOnCamera )
}

enum navActionOnCamera {
    case shouldDismissCamera()
    case didMoveToFilter(image : UIImage)
}

protocol CameraCoordinatorDelegate: class {
    func camereSelected()
}

enum ScreenType {
    case camera
    case editProfile
    case chat
}
