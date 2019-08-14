//
//  AppDelegate.swift
//  Selfin
//
//  Created by Marlon Monroy on 6/30/18.
//  Copyright © 2018 Selfin. All rights reserved.
//

import CoreLocation
import Crashlytics
import Fabric
import Firebase
import Nuke
import UIKit
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {
    var window: UIWindow?
    var appCoordinator: AppCoordinator?
    var locationManager = CLLocationManager()
    var orientationLock = UIInterfaceOrientationMask.all

    func application(_: UIApplication, supportedInterfaceOrientationsFor _: UIWindow?) -> UIInterfaceOrientationMask {return orientationLock}

    func application(_ application: UIApplication, didFinishLaunchingWithOptions _: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        Fabric.with([Crashlytics.self])
        window = UIWindow(frame: UIScreen.main.bounds)
        locationManager.requestWhenInUseAuthorization()

        if let window = window {
            if UserStore.user  != nil {
                appCoordinator = AppCoordinator(homeWindow: window)
            }else {appCoordinator = AppCoordinator(window: window)}
        }
		  Settings.setImageCachingSize()
        FirebaseApp.configure()
        window?.makeKeyAndVisible()

        // push Notification
        if #available(iOS 10.0, *) {
            let generalCategory = UNNotificationCategory(identifier: "New Notifications",
                                                         actions: [],
                                                         intentIdentifiers: [],
                                                         options: .customDismissAction)
            let center = UNUserNotificationCenter.current()
            center.getDeliveredNotifications { (arr) in
                var chatNotificationCount = 0
                for response in arr {
                    if response.request.content.categoryIdentifier ==
                        "New Notifications" {
                        chatNotificationCount += 1
                    }
                }
               //To show Chat notification
               let count = NotificationsCount()
               let notificationCount = UserStore.chatNotificationCount()
               if notificationCount > 0 {
                let totalCount = notificationCount + chatNotificationCount
                count.count = totalCount
                UserStore.save(notificationCout:count)
               }else {
                count.count = chatNotificationCount
                UserStore.save(notificationCout:count)
               }
            }
            
            center.setNotificationCategories([generalCategory])
            center.delegate = self
            center.requestAuthorization(options: [.badge, .alert, .sound]) { _, _ in
            }
            application.registerForRemoteNotifications()
        } else {
            let notificationTypes: UIUserNotificationType = [UIUserNotificationType.alert, UIUserNotificationType.badge, UIUserNotificationType.sound]
            let pushNotificationSettings = UIUserNotificationSettings(types: notificationTypes, categories: nil)
            application.registerUserNotificationSettings(pushNotificationSettings)
            application.registerForRemoteNotifications()
            // Fallback on earlier versions
        }
        return true
    }

    func applicationWillResignActive(_: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        application.applicationIconBadgeNumber = 0
    }

    func applicationWillTerminate(_: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

    func application(_: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        var pushToken = String(format: "%@", deviceToken as CVarArg)
        pushToken = pushToken.trimmingCharacters(in: CharacterSet(charactersIn: "<>"))
        pushToken = pushToken.replacingOccurrences(of: " ", with: "")
        print(pushToken)
        UserDefaults.standard.set("\(pushToken)", forKey: Constants.deviceToken.rawValue)
    }

    func application(_: UIApplication, didFailToRegisterForRemoteNotificationsWithError _: Error) {
        UserDefaults.standard.set("2caa9775c798de60d0c41e0e5833d5887ab758f54ab9a969ed24e25be04acaae", forKey: Constants.deviceToken.rawValue)
    }

    private func application(application _: UIApplication, didReceiveRemoteNotification userInfo: [NSObject: AnyObject]) {
    }
    
    private func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        if response.notification.request.content.categoryIdentifier ==
            "New Notifications" {
        }
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
    }
    
    func application(_: UIApplication, continue userActivity: NSUserActivity, restorationHandler _: @escaping ([UIUserActivityRestoring]?) -> Void) -> Bool {
        DeepLinkManager.shared.deepLinkMethod(userActivity: userActivity)
        let deeplink : deepLinkValues = DeepLinkManager.shared.deeplink
        switch deeplink {
        case .forgetPassword(email: _):
            DeepLinkManager.shared.isSuccess = {success, data in
                self.appCoordinator?.deepLinkNavigator(deeplink : data ?? .forgetPassword(email: ""))
            }
        default:
            if UserStore.user  != nil {
                appCoordinator?.deepLinkNavigator(deeplink : deeplink)
            }else {
                if let window = window {
                    appCoordinator = AppCoordinator(window: window)
                }
            }
            
        }
        return true
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        return true
    }
}
