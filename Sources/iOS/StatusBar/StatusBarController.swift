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

extension UIViewController {
  /**
   A convenience property that provides access to the StatusBarController.
   This is the recommended method of accessing the StatusBarController
   through child UIViewControllers.
   */
  public var statusBarController: StatusBarController? {
    return traverseViewControllerHierarchyForClassType()
  }
}

open class StatusBarController: TransitionController {
  /**
   A Display value to indicate whether or not to
   display the rootViewController to the full view
   bounds, or up to the toolbar height.
   */
  open var displayStyle = DisplayStyle.full {
    didSet {
      layoutSubviews()
    }
  }
  
  /// Device status bar style.
  open var statusBarStyle: UIStatusBarStyle {
    get {
      return Application.statusBarStyle
    }
    set(value) {
      Application.statusBarStyle = value
    }
  }
  
  /// Device visibility state.
  open var isStatusBarHidden: Bool {
    get {
      return Application.isStatusBarHidden
    }
    set(value) {
      Application.isStatusBarHidden = value
      statusBar.isHidden = isStatusBarHidden
    }
  }
  
  /// An adjustment based on the rules for displaying the statusBar.
  open var statusBarOffsetAdjustment: CGFloat {
    return Application.shouldStatusBarBeHidden || statusBar.isHidden ? 0 : statusBar.bounds.height
  }
  
  /// A boolean that indicates to hide the statusBar on rotation.
  open var shouldHideStatusBarOnRotation = false
  
  /// A reference to the statusBar.
  public let statusBar = UIView()
  
  open override func layoutSubviews() {
    super.layoutSubviews()
    
    if shouldHideStatusBarOnRotation {
      statusBar.isHidden = Application.shouldStatusBarBeHidden
    }
    
    statusBar.frame.size.width = view.bounds.width
    
    if #available(iOS 11, *) {
      let v = topLayoutGuide.length
      statusBar.frame.size.height = 0 < v ? v : 20
    } else {
      statusBar.frame.size.height = 20
    }
    
    switch displayStyle {
    case .partial:
      let h = statusBar.bounds.height
      container.frame.origin.y = h
      container.frame.size.height = view.bounds.height - h
      
    case .full:
      container.frame = view.bounds
    }
    
    rootViewController.view.frame = container.bounds
    
    container.layer.zPosition = statusBar.layer.zPosition + (Application.shouldStatusBarBeHidden ? 1 : -1)
  }
  
  open override func prepare() {
    super.prepare()
    prepareStatusBar()
  }
  
  open override func apply(theme: Theme) {
    super.apply(theme: theme)
    
    statusBar.backgroundColor = theme.primary.darker
  }
}

fileprivate extension StatusBarController {
  /// Prepares the statusBar.
  func prepareStatusBar() {
    if nil == statusBar.backgroundColor {
      statusBar.backgroundColor = .white
    }
    
    view.addSubview(statusBar)
  }
}
