//
//  AppDelegate.swift
//  BottomNavigationController
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

    lazy var videoViewController: VideoViewController = {
        return UIStoryboard.viewController(identifier: "VideoViewController") as! VideoViewController
    }()
    
    lazy var audioViewController: AudioViewController = {
        return UIStoryboard.viewController(identifier: "AudioViewController") as! AudioViewController
    }()
    
    lazy var photoViewController: PhotoViewController = {
        return UIStoryboard.viewController(identifier: "PhotoViewController") as! PhotoViewController
    }()
    
    lazy var remindersViewController: RemindersViewController = {
        return UIStoryboard.viewController(identifier: "RemindersViewController") as! RemindersViewController
    }()
    
    lazy var searchViewController: SearchViewController = {
        return UIStoryboard.viewController(identifier: "SearchViewController") as! SearchViewController
    }()

    func applicationDidFinishLaunching(_ application: UIApplication) {
        window = UIWindow(frame: UIScreen.main.bounds)
        window!.rootViewController = AppBottomNavigationController(viewControllers: [PhotoViewController(), VideoViewController(), AudioViewController(), RemindersViewController(), SearchViewController()])
        window!.makeKeyAndVisible()
    }
}

