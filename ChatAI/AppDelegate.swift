//
//  AppDelegate.swift
//  ChatAI
//
//  Created by Volynets Vladislav on 01.03.2024.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(_ application: UIApplication, 
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow()
        
        let chatsListViewController = UINavigationController(rootViewController: ChatsListViewController())
        chatsListViewController.isNavigationBarHidden = true
        window?.rootViewController = chatsListViewController
        window?.makeKeyAndVisible()
        
        return true
    }
}
