//
//  AppDelegate.swift
//  CQSwift
//
//  Created by 李超群 on 2019/7/28.
//  Copyright © 2019 李超群. All rights reserved.
//

import UIKit

@available(iOS 11.0, *)
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    var mainNavVC : CQMainNavController!
    

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
//        let setting = UIUserNotificationSettings(types: [.badge, .alert, .sound], categories: nil)
//        application.registerUserNotificationSettings(setting)

        self.window = UIWindow.init(frame: UIScreen.main.bounds)
        self.window?.makeKeyAndVisible()
        self.mainNavVC = CQMainNavController.init(rootViewController: CQMainController())
        self.window?.rootViewController = self.mainNavVC;
        
        CQCoreDataTool.shared.setupCoreDataWithModelName("CQSwiftData", "CQSwiftData.db")
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    // widget link url
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        CQLog(url.absoluteString)
        if url.absoluteString.hasPrefix(widgetScheme) {
            self.mainNavVC.widgetToSpecialPage(string: url.absoluteString)
            return true
        }
        if url.absoluteString.hasPrefix("other://metal.main") {
            if self.mainNavVC.topViewController?.classForCoder == CQMetalMainController.classForCoder() {
                return true
            }
            self.mainNavVC.pushViewController(CQMetalMainController(), animated: true)
        //} else if url.absoluteString.hasPrefix("other://swifter.desktop") {
        } else if url.absoluteString.hasPrefix("other://profile") {
            guard let topVC = self.mainNavVC.topViewController else {
                return true
            }
            if topVC.isKind(of: CQDesktopMenuController.self) {
                return true
            }
            self.mainNavVC.pushViewController(CQDesktopMenuController(), animated: true)
        } else {
            return true
        }
        // return NO if the application can't open for some reason
        return true
    }

}

