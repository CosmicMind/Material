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
import Motion

public protocol Themeable: class {
  /**
   Applies given theme.
   - Parameter theme: A Theme.
   */
  func apply(theme: Theme)
  
  /// A boolean indicating if theming is enabled.
  var isThemingEnabled: Bool { get set }
}

public struct Theme: Hashable {
  /// The color displayed most frequently across the app.
  public var primary = Color.blue.darken2
  
  /// Accent color for some components such as FABMenu.
  public var secondary = Color.blue.base
  
  /// Background color for view controllers and some components.
  public var background = Color.white
  
  /// Background color for components such as cards, and dialogs.
  public var surface = Color.white
  
  /// Error color for components such as ErrorTextField.
  public var error = Color.red.base
  
  
  /// Text and iconography color to be used on primary color.
  public var onPrimary = Color.white
  
  /// Text and iconography color to be used on secondary color.
  public var onSecondary = Color.white
  
  /// Text and iconography color to be used on background color.
  public var onBackground = Color.black
  
  /// Text and iconography color to be used on surface color.
  public var onSurface = Color.black
  
  /// Text and iconography color to be used on error color.
  public var onError = Color.white
  
  /// A boolean indicating if theming is enabled globally.
  public static var isEnabled = false
  
  /// Global font for app.
  public static var font: FontType.Type = RobotoFont.self
  
  /// An initializer.
  public init() { }
}

public extension Theme {
  /// Current theme for Material.
  static private(set) var current = Theme.light
  
  /// A light theme.
  static var light = Theme()
  
  /// A dark theme.
  static var dark: Theme = {
    var t = Theme()
    t.primary = UIColor(rgb: 0x202020)
    t.secondary = Color.teal.base
    t.background = UIColor(rgb: 0x303030)
    t.surface = t.background
    t.onBackground = .white
    t.onSurface = .white
    return t
  }()
}

public extension Theme {
  /**
   Applies theme to the entire app.
   - Parameter theme: A Theme.
   */
  static func apply(theme: Theme) {
    current = theme
    guard let v = Application.rootViewController else {
      return
    }
    
    apply(theme: theme, to: v)
  }
  
  /**
   Applies theme to the hierarchy of given view.
   - Parameter theme: A Theme.
   - Parameter to view: A UIView.
   */
  static func apply(theme: Theme, to view: UIView) {
    guard !((view as? Themeable)?.isThemingEnabled == false), !view.isProcessed else {
      return
    }
    
    view.subviews.forEach {
      apply(theme: theme, to: $0)
    }
    
    (view as? Themeable)?.apply(theme: theme)
  }
  
  /**
   Applies theme to the hierarchy of given view controller.
   - Parameter theme: A Theme.
   - Parameter to viewController: A UIViewController.
   */
  static func apply(theme: Theme, to viewController: UIViewController) {
    guard !((viewController as? Themeable)?.isThemingEnabled == false) else {
      return
    }
    
    viewController.allChildren.forEach {
      apply(theme: theme, to: $0)
      $0.view.isProcessed = true
    }
    
    apply(theme: theme, to: viewController.view)
    
    viewController.allChildren.forEach {
      $0.view.isProcessed = false
    }
    
    (viewController as? Themeable)?.apply(theme: theme)
  }
  
  /**
   Applies provided theme for the components created within the given block
   without chaging app's theme.
   - Parameter theme: A Theme.
   - Parameter for block: A code block.
   */
  static func applying(theme: Theme, for execute: () -> Void) {
    let v = current
    current = theme
    execute()
    current = v
  }
}


/// A memory reference to the isThemingEnabled for Themeable NSObject subclasses.
private var IsThemingEnabledKey: UInt8 = 0

public extension Themeable where Self: NSObject {
  /// A class-wide boolean indicating if theming is enabled.
  static var isThemingEnabled: Bool {
    get {
      return Theme.isEnabled && AssociatedObject.get(base: self, key: &IsThemingEnabledKey) {
        true
      }
    }
    set(value) {
      AssociatedObject.set(base: self, key: &IsThemingEnabledKey, value: value)
    }
  }
  
  /// A boolean indicating if theming is enabled.
  var isThemingEnabled: Bool {
    get {
      return type(of: self).isThemingEnabled && AssociatedObject.get(base: self, key: &IsThemingEnabledKey) {
        true
      }
    }
    set(value) {
      AssociatedObject.set(base: self, key: &IsThemingEnabledKey, value: value)
    }
  }
  
  /// Applies current theme to itself if theming is enabled.
  internal func applyCurrentTheme() {
    guard isThemingEnabled else {
      return
    }
    
    apply(theme: .current)
  }
}

private extension UIViewController {
  /// Returns all possible child view controllers.
  var allChildren: [UIViewController] {
    var all = children
    
    if let v = self as? TabsController {
      all += v.viewControllers
    }
    
    if let v = presentedViewController, v.presentingViewController === self {
      all.append(v)
    }
    
    return all
  }
}

/// A memory reference to the isProcessed for UIView.
private var IsProcessedKey: UInt8 = 0

private extension UIView {
  /// A boolean indicating if view is already themed.
  var isProcessed: Bool {
    get {
      return AssociatedObject.get(base: self, key: &IsProcessedKey) {
        false
      }
    }
    set(value) {
      AssociatedObject.set(base: self, key: &IsProcessedKey, value: value)
    }
  }
}
