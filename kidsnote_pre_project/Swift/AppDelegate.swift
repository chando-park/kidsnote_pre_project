//
//  AppDelegate.swift
//  kidsnote_pre_project
//
//  Created by Chando Park on 6/23/24.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        self.setRootViewController()
        return true
    }
    
    private func setRootViewController(){
        
        window = UIWindow(frame: UIScreen.main.bounds)
        
        let rootViewController = ViewControllerFactory.shared.makeSerchListViewController()
        let navigationController = UINavigationController(rootViewController: rootViewController)
        navigationController.view.backgroundColor = .white
        
        // 루트 뷰 컨트롤러 설정
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
        
        
    }
}

