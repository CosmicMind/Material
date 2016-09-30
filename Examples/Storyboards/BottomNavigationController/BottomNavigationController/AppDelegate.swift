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
}

