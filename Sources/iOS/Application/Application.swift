/*
 * The MIT License (MIT)
 *
 * Copyright (C) 2019, CosmicMind, Inc. <http://cosmicmind.com>.
 * All rights reserved.
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

import UIKit

public struct Application {
  
  /// A reference to UIApplication.shared application which doesn't trigger linker errors when Material is included in an extension
  /// Note that this will crash if actually called from within an extension
  public static var shared: UIApplication {
    let sharedSelector = NSSelectorFromString("sharedApplication")
    guard UIApplication.responds(to: sharedSelector) else {
      fatalError("[Material: Extensions cannot access Application]")
    }
    
    let shared = UIApplication.perform(sharedSelector)
    return shared?.takeUnretainedValue() as! UIApplication
  }
  
  /// An optional reference to the main UIWindow.
  public static var keyWindow: UIWindow? {
    return Application.shared.keyWindow
  }
  
  /// An optional reference to the top most view controller.
  public static var rootViewController: UIViewController? {
    return keyWindow?.rootViewController
  }
  
  /// A boolean indicating if the device is in Landscape mode.
  public static var isLandscape: Bool {
    return Application.shared.statusBarOrientation.isLandscape
  }
  
  /// A boolean indicating if the device is in Portrait mode.
  public static var isPortrait: Bool {
    return !isLandscape
  }
  
  /// The current UIInterfaceOrientation value.
  public static var orientation: UIInterfaceOrientation {
    return Application.shared.statusBarOrientation
  }
  
  /// Retrieves the device status bar style.
  public static var statusBarStyle: UIStatusBarStyle {
    get {
      return Application.shared.statusBarStyle
    }
    set(value) {
      Application.shared.statusBarStyle = value
    }
  }
  
  /// Retrieves the device status bar hidden state.
  public static var isStatusBarHidden: Bool {
    get {
      return Application.shared.isStatusBarHidden
    }
    set(value) {
      Application.shared.isStatusBarHidden = value
    }
  }
  
  /**
   A boolean that indicates based on iPhone rules if the
   status bar should be shown.
   */
  public static var shouldStatusBarBeHidden: Bool {
    return isLandscape && .phone == Device.userInterfaceIdiom
  }
  
  /// A reference to the user interface layout direction.
  public static var userInterfaceLayoutDirection: UIUserInterfaceLayoutDirection {
    return Application.shared.userInterfaceLayoutDirection
  }
}
