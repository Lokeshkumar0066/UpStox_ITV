//
//  AppDelegate.swift
//  UpStox_ITV
//
//  Created by Lokesh Agarwal on 15/11/24.
//

import UIKit
import CoreData

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        self.startNetworkMonitoring()
        self.rootVC()
        return true
    }
    
    // MARK: - Root View Controller Setup
    // This method sets up the root view controller of the application
    private func rootVC() {
        self.window = UIWindow(frame: UIScreen.main.bounds)
        let coinVC = CryptoCoinClassVC()
        let navigationController = UINavigationController(rootViewController: coinVC)
        self.window?.rootViewController = navigationController
        self.window?.makeKeyAndVisible()
    }

    // MARK: - Network Monitoring
    // This method starts network monitoring to check Internet connection
    private func startNetworkMonitoring() {
        NetworkReachability.shared.startMonitoring()
    }
}
