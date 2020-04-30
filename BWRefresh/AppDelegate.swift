//
//  AppDelegate.swift
//  BWRefresh
//
//  Created by 冉彬 on 2020/4/23.
//  Copyright © 2020 BigWhite. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        //如果是用默认的storyboard，下面的代码可以不写
        window = UIWindow.init()
        window?.frame = UIScreen.main.bounds
        window?.rootViewController = UINavigationController(rootViewController: BWRefreshTestVC.init())
        window?.makeKeyAndVisible()
        
        
        return true
    }

    

}

