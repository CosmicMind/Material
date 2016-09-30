//
//  AppDelegate.swift
//  PageTabBarController
//
//  Created by Adam Dahan on 2016-09-29.
//  Copyright © 2016 CosmicMind. All rights reserved.
//

import UIKit

extension UIStoryboard {
    class func viewController(identifier: String) -> UIViewController {
        return UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: identifier)
    }
}

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    lazy var blueViewController: BlueViewController = {
        return UIStoryboard.viewController(identifier: "BlueViewController") as! BlueViewController
    }()
    
    lazy var greenViewController: GreenViewController = {
        return UIStoryboard.viewController(identifier: "GreenViewController") as! GreenViewController
    }()
    
    lazy var redViewController: RedViewController = {
        return UIStoryboard.viewController(identifier: "RedViewController") as! RedViewController
    }()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        window!.rootViewController = AppPageTabBarController(viewControllers: [redViewController, greenViewController, blueViewController], selectedIndex: 0)
        window!.makeKeyAndVisible()
        return true
    }
}

