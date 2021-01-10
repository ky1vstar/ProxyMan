//
//  AppDelegate.swift
//  Proxyman
//
//  Created by KY1VSTAR on 25.12.2020.
//

import UIKit
import Swinject

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions
            launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        setupDependencies()
        return true
    }
    
    private func setupDependencies() {
        let container = Container.shared
        
        container.register(\.proxyRepository, DefaultProxyRepository())
    }

    // MARK: UISceneSession Lifecycle

    func application(
        _ application: UIApplication,
        configurationForConnecting
            connectingSceneSession: UISceneSession,
        options: UIScene.ConnectionOptions
    ) -> UISceneConfiguration {
        return UISceneConfiguration(
            name: "Default Configuration",
            sessionRole: connectingSceneSession.role
        )
    }

    func application(
        _ application: UIApplication,
        didDiscardSceneSessions sceneSessions: Set<UISceneSession>
    ) {
    }
}

