//
//  UIViewControllerExt.swift
//  Selfin
//
//  Created by Marlon Monroy on 11/7/18.
//  Copyright © 2018 Selfin. All rights reserved.
//

import Foundation

import UIKit

extension UIViewController:UIGestureRecognizerDelegate {
    
    private func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if gestureRecognizer.isEqual(navigationController?.interactivePopGestureRecognizer) {
             navigationController?.popViewController(animated: true)
        }
        return false
    }
    
    static func from<T>(storyboard: Storyboard) -> T {
        guard let controller = UIStoryboard(name: storyboard.rawValue, bundle: nil).instantiateInitialViewController() as? T else {
            fatalError("unable to instantiate view controller")
        }
        return controller
    }

	static func from<T>(from storyboard: Storyboard, with identifier: StoryboardIdentifier) -> T {
        guard let controller = UIStoryboard(name: storyboard.rawValue, bundle: nil).instantiateViewController(withIdentifier: identifier.rawValue) as? T else {
            fatalError("unable to instantiate view controller")
        }
        return controller
    }
	
    func crossButton(tint:UIColor = .black) {
        navigationItem.hidesBackButton = true
        let back = UIBarButtonItem(image: UIImage(named: "X"),
                                   style: .plain,
                                   target: navigationController,
                                   action: #selector(UINavigationController.popViewController(animated:)))
        navigationItem.rightBarButtonItem = back
        back.tintColor = tint
    }
    
	func backButton(tint:UIColor = .gray) {
		let back = UIBarButtonItem(image: UIImage(named: "backGrey"),
											style: .plain,
											target: navigationController,
											action: #selector(UINavigationController.popViewController(animated:)))
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
		navigationItem.leftBarButtonItem = back
		back.tintColor = tint
	}
    
//    @objc func  pop()  {
//        self.navigationController?.popViewController(animated: true)
//      //  UINavigationController.popViewController(animated:)
//    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "TabBarBrokenConstraits"), object: nil)
//    }
}



extension HorizontalDisplayable where Self: UIViewController {
    func handleRotation(orientation: UIDeviceOrientation) {
        switch orientation {
        case .landscapeLeft, .landscapeRight:
            tabBarController?.tabBar.isHidden = true
            parent?.navigationController?.isNavigationBarHidden = true
            view.layoutIfNeeded()
        case .portrait, .portraitUpsideDown:
            tabBarController?.tabBar.isHidden = false
            parent?.navigationController?.isNavigationBarHidden = true
            view.layoutIfNeeded()
        default:
            break
        }
    }
}

extension UIAlertController {
    static func PostAction(titles: String..., handler: @escaping (UIAlertAction) -> Void) -> UIAlertController {
        let PostOptions = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        titles.forEach { title in
            let action = UIAlertAction(title: title, style: .default, handler: handler)
            PostOptions.addAction(action)
        }

        let cancel = UIAlertAction(title: "Cancel", style: .cancel)

        PostOptions.addAction(cancel)
        return PostOptions
    }
}
