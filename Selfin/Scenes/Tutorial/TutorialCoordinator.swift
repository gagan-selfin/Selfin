//
//  TutorialCoordinator.swift
//  Selfin
//
//  Created by cis on 19/09/18.
//  Copyright © 2018 Selfin. All rights reserved.
//

import UIKit

protocol TutorialCoordinatorDelegate {
    func moveToMainVC()
}

class TutorialCoordinator: Coordinator<AppDeepLink> {
    var delegate: TutorialCoordinatorDelegate?

    lazy var tutorialViewController: TutorialViewController = {
        let controller: TutorialViewController = TutorialViewController.from(from: .tutorial, with: .tutorial)
        controller.delegate = self
        return controller
    }()

    override init(router: Router) {
        super.init(router: router)
        // router.push(tutorialViewController, animated: true, completion: nil)
    }
    
    func start(with link: AppDeepLink?, email:String) {
        switch link {
        case .root?:
             router.push(tutorialViewController, animated: true, completion: nil)
        case .details?:
            moveToRegistartionScreen(type:.details, email: email)
        case .none:
            print("none")
        }
    }

    func moveToRegistartionScreen(type:AppDeepLink?, email:String) {
        let coordinator = RegistrationCoordinator(router: router as! Router)
        coordinator.delegate = self
        coordinator.start(with: type, email: email)
        add(coordinator)
    }
}

extension TutorialCoordinator: RegistrationCoordinatorDelegate {
    func moveToApplicationMainView() {
        delegate?.moveToMainVC()
    }
}

extension TutorialCoordinator: TutorialViewControllerDelegate {
    func skipTutorial() {
        moveToRegistartionScreen(type: .root, email: "")
    }
}
