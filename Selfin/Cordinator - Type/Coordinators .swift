//
//  Coordinators .swift
//  Selfin
//
//  Created by Marlon Monroy on 7/15/18.
//  Copyright © 2018 Selfin. All rights reserved.
//
import UIKit

public protocol Presentable {
    func toPresentable() -> UIViewController
}

extension UIViewController: Presentable {
    public func toPresentable() -> UIViewController {
        return self
    }
}

public protocol RouterType: class, Presentable {
    var navigationController: selfinNavigationController { get }

    var rootViewController: UIViewController? { get }
    func present(_ module: Presentable, animated: Bool)
    func dismissModule(animated: Bool, completion: (() -> Void)?)
    func push(_ module: Presentable, animated: Bool, completion: (() -> Void)?)
    func popModule(animated: Bool)
    func setRootModule(_ module: Presentable, hideBar: Bool)
    func popToRootModule(animated: Bool)
}

public final class Router: NSObject, RouterType, UINavigationControllerDelegate {
    private var completions: [UIViewController: () -> Void]
    
    public var rootViewController: UIViewController? {
        return navigationController.viewControllers.first
    }

    public var hasRootController: Bool {
        return rootViewController != nil
    }

    public var navigationController: selfinNavigationController

    public init(navigationController: selfinNavigationController = selfinNavigationController()) {
        self.navigationController = navigationController
        completions = [:]
        super.init()
        self.navigationController.delegate = self
    }

    public func present(_ module: Presentable, animated: Bool = true) {
        navigationController.present(module.toPresentable(), animated: animated, completion: nil)
    }

    public func dismissModule(animated: Bool = true, completion: (() -> Void)? = nil) {
        navigationController.dismiss(animated: animated, completion: completion)
    }

    public func push(_ module: Presentable, animated: Bool = true, completion: (() -> Void)? = nil) {
        let controller = module.toPresentable()

        // Avoid pushing UINavigationController onto stack
        guard controller is UINavigationController == false else {
            return
        }

        if let completion = completion {
            completions[controller] = completion
        }
        navigationController.pushViewController(controller, animated: animated)
    }

    public func popModule(animated: Bool = true) {
        if let controller = navigationController.popViewController(animated: animated) {
            runCompletion(for: controller)
        }
    }

    public func setRootModule(_ module: Presentable, hideBar: Bool = false) {
        // Call all completions so all coordinators can be deallocated
        completions.forEach { $0.value() }
        navigationController.setViewControllers([module.toPresentable()], animated: false)

        navigationController.isNavigationBarHidden = hideBar
    }

    public func popToRootModule(animated: Bool) {
        if let controllers = navigationController.popToRootViewController(animated: animated) {
            controllers.forEach { runCompletion(for: $0) }
        }
    }

    fileprivate func runCompletion(for controller: UIViewController) {
        guard let completion = completions[controller] else { return }
        completion()
        completions.removeValue(forKey: controller)
    }

    // MARK: Presentable

    public func toPresentable() -> UIViewController {
        return navigationController
    }

    // MARK: UINavigationControllerDelegate
    public func navigationController(_ navigationController: UINavigationController, didShow _: UIViewController, animated _: Bool) {
        // Ensure the view controller is popping
        guard let poppedViewController = navigationController.transitionCoordinator?.viewController(forKey: .from),
            !navigationController.viewControllers.contains(poppedViewController) else {
            return
        }
        runCompletion(for: poppedViewController)
    }
}

public protocol BaseCoordinatorType: class {
    associatedtype DeepLinkType
    func start()
    func start(with link: DeepLinkType?)
}

public protocol PresentableCoordinatorType: BaseCoordinatorType, Presentable {}

open class PresentableCoordinator<DeepLinkType>: NSObject, PresentableCoordinatorType {
    public override init() {
        super.init()
    }

    open func start() { start(with: nil) }
    open func start(with _: DeepLinkType?) {}

    open func toPresentable() -> UIViewController {
        fatalError("Must override toPresentable()")
    }
}

public protocol CoordinatorType: PresentableCoordinatorType {
    var router: RouterType { get }
}

class Coordinator<Link>: PresentableCoordinator<Link>, CoordinatorType {
    var router: RouterType
    var childCoordinators: [Coordinator<Link>] = []

    init(router: Router) {
        self.router = router
    }

    func add(_ child: Coordinator<Link>) {
        if !childCoordinators.contains(child) {
            childCoordinators.append(child)
        }
    }

    func remove(child: Coordinator<Link>?) {
        if let child = child, let index = childCoordinators.index(of: child) {
            childCoordinators.remove(at: index)
        }
    }

    override func toPresentable() -> UIViewController {
        return router.toPresentable()
    }
}

public class selfinNavigationController: UINavigationController {
    public override func viewDidLoad() {
        super.viewDidLoad()
		
    }

    public override var shouldAutorotate: Bool {
        if (topViewController() as? HomeFeedViewController) != nil {
            return true
        }
        if (topViewController() as? DiscoverViewController) != nil {
            return true
        }
        return false
    }

    public override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if (topViewController() as? HomeFeedViewController) != nil {
            //the type of currentVC is MyViewController inside the if statement, use it as you want to
            return UIInterfaceOrientationMask.all
        }
        if (topViewController() as? DiscoverViewController) != nil {
            return UIInterfaceOrientationMask.all
        }
        return UIInterfaceOrientationMask.portrait
    }

    func topViewController(controller: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        if controller is UINavigationController {
            if let rootController = controller as? UINavigationController {
                if rootController.topViewController is MainViewController {
                    if let tabController = rootController.topViewController as? UITabBarController {
                        if let navController = tabController.selectedViewController as? UINavigationController {
                            return navController.topViewController
                        }
                    }
                }
            }
        }

        return controller
    }
}
