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

extension NavigationController {
  /// Device status bar style.
  open var statusBarStyle: UIStatusBarStyle {
    get {
      return Application.statusBarStyle
    }
    set(value) {
      Application.statusBarStyle = value
    }
  }
}

open class NavigationController: UINavigationController {
  /**
   An initializer that initializes the object with a NSCoder object.
   - Parameter aDecoder: A NSCoder instance.
   */
  public required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }
  
  /**
   An initializer that initializes the object with an Optional nib and bundle.
   - Parameter nibNameOrNil: An Optional String for the nib.
   - Parameter bundle: An Optional NSBundle where the nib is located.
   */
  public override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
    super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
  }
  
  /**
   An initializer that initializes the object with a rootViewController.
   - Parameter rootViewController: A UIViewController for the rootViewController.
   */
  public override init(rootViewController: UIViewController) {
    super.init(navigationBarClass: NavigationBar.self, toolbarClass: nil)
    setViewControllers([rootViewController], animated: false)
  }
  
  public init(rootViewController: UIViewController, navigationBarClass: Swift.AnyClass?) {
    super.init(navigationBarClass: navigationBarClass, toolbarClass: nil)
    setViewControllers([rootViewController], animated: false)
  }
  
  open override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    guard let v = interactivePopGestureRecognizer else {
      return
    }
    
    guard let x = navigationDrawerController else {
      return
    }
    
    if let l = x.leftPanGesture {
      l.require(toFail: v)
    }
    
    if let r = x.rightPanGesture {
      r.require(toFail: v)
    }
  }
  
  open override func viewDidLoad() {
    super.viewDidLoad()
    prepare()
  }
  
  open override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    guard let v = navigationBar as? NavigationBar else {
      return
    }
    
    guard let item = v.topItem else {
      return
    }
    
    v.layoutNavigationItem(item: item)
  }
  
  open override func viewWillLayoutSubviews() {
    super.viewWillLayoutSubviews()
    layoutSubviews()
  }
  
  /**
   Prepares the view instance when intialized. When subclassing,
   it is recommended to override the prepare method
   to initialize property values and other setup operations.
   The super.prepare method should always be called immediately
   when subclassing.
   */
  open func prepare() {
    navigationBar.frame.size.width = view.bounds.width
    navigationBar.heightPreset = .normal
    
    view.clipsToBounds = true
    view.backgroundColor = .white
    view.contentScaleFactor = Screen.scale
    
    // This ensures the panning gesture is available when going back between views.
    if let v = interactivePopGestureRecognizer {
      v.isEnabled = true
      v.delegate = self
    }
  }
  
  /// Calls the layout functions for the view heirarchy.
  open func layoutSubviews() {
    navigationBar.setNeedsUpdateConstraints()
    navigationBar.updateConstraintsIfNeeded()
    navigationBar.setNeedsLayout()
    navigationBar.layoutIfNeeded()
  }
  
  /**
   Sets whether the navigation bar is hidden.
   - Parameter _ hidden: Specify true to hide the navigation bar or false to show it.
   - Parameter animated: Specify true if you want to animate the change in visibility or false if you want the navigation bar to appear immediately.
   */
  open override func setNavigationBarHidden(_ hidden: Bool, animated: Bool) {
    super.setNavigationBarHidden(hidden, animated: animated)
    guard let items = navigationBar.items, items.count > 1 else {
      return
    }
    
    items.forEach {
      prepareBackButton(for: $0, in: navigationBar)
    }
  }
}

extension NavigationController: UINavigationBarDelegate {
  /**
   Delegation method that is called when a new UINavigationItem is about to be pushed.
   This is used to prepare the transitions between UIViewControllers on the stack.
   - Parameter navigationBar: A UINavigationBar that is used in the NavigationController.
   - Parameter item: The UINavigationItem that will be pushed on the stack.
   - Returns: A Boolean value that indicates whether to push the item on to the stack or not.
   True is yes, false is no.
   */
  public func navigationBar(_ navigationBar: UINavigationBar, shouldPush item: UINavigationItem) -> Bool {
    prepareBackButton(for: item, in: navigationBar)
    return true
  }
  
  public func navigationBar(_ navigationBar: UINavigationBar, didPop item: UINavigationItem) {
    removeBackButton(from: item)
  }
}

internal extension NavigationController {
  /// Handler for the backbutton.
  @objc
  func handle(backButton: UIButton) {
    popViewController(animated: true)
  }
  
  /**
   Prepares back button of the navigation item in navigation bar.
   - Parameter for item: A UINavigationItem.
   - Parameter in navigationBar: A UINavigationBar.
   */
  func prepareBackButton(for item: UINavigationItem, in navigationBar: UINavigationBar) {
    guard let v = navigationBar as? NavigationBar else {
      return
    }
    
    if nil == item.backButton.image && nil == item.backButton.title {
      item.backButton.image = v.backButtonImage
    }
    
    if !item.backButton.isHidden && !item.leftViews.contains(item.backButton) {
      item.leftViews.insert(item.backButton, at: 0)
    }
    
    item.backButton.addTarget(self, action: #selector(handle(backButton:)), for: .touchUpInside)
    
    item.hidesBackButton = false
    item.setHidesBackButton(true, animated: false)
    
    v.layoutNavigationItem(item: item)
  }
  
  /**
   Removes back button of the navigation item.
   - Parameter from item: A UINavigationItem.
   */
  func removeBackButton(from item: UINavigationItem) {
    if let index = item.leftViews.firstIndex(of: item.backButton) {
      item.leftViews.remove(at: index)
    }
    
    item.backButton.removeTarget(self, action: #selector(handle(backButton:)), for: .touchUpInside)
  }
}

extension NavigationController: UIGestureRecognizerDelegate {
  /**
   Detects the gesture recognizer being used. This is necessary when using
   NavigationDrawerController. It eliminates the conflict in panning.
   - Parameter gestureRecognizer: A UIGestureRecognizer to detect.
   - Parameter touch: The UITouch event.
   - Returns: A Boolean of whether to continue the gesture or not, true yes, false no.
   */
  public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
    return interactivePopGestureRecognizer == gestureRecognizer && nil != navigationBar.backItem
  }
}
