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

open class TransitionController: ViewController {
  /**
   A Boolean property used to enable and disable interactivity
   with the rootViewController.
   */
  @IBInspectable
  open var isUserInteractionEnabled: Bool {
    get {
      return rootViewController.view.isUserInteractionEnabled
    }
    set(value) {
      rootViewController.view.isUserInteractionEnabled = value
    }
  }
  
  /// A Boolean indicating whether the controller is in transitioning state.
  open var isTransitioning: Bool {
    return MotionTransition.shared.isTransitioning && MotionTransition.shared.fromViewController == rootViewController
  }
  
  open override var childForStatusBarStyle: UIViewController? {
    return isTransitioning ? MotionTransition.shared.toViewController ?? rootViewController : rootViewController
  }
  
  open override var childForStatusBarHidden: UIViewController? {
    return childForStatusBarStyle
  }
  
  open override var childForHomeIndicatorAutoHidden: UIViewController? {
    return childForStatusBarStyle
  }
  
  open override var childForScreenEdgesDeferringSystemGestures: UIViewController? {
    return childForStatusBarStyle
  }
  
  /// A reference to the container view.
  @IBInspectable
  public let container = UIView()
  
  /**
   A UIViewController property that references the active
   main UIViewController. To swap the rootViewController, it
   is recommended to use the transitionFromRootViewController
   helper method.
   */
  open internal(set) var rootViewController: UIViewController! {
    didSet {
      guard oldValue != rootViewController else {
        return
      }
      
      if let v = oldValue {
        removeViewController(viewController: v)
      }
      
      prepare(viewController: rootViewController, in: container)
    }
  }
  
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
   An initializer for the BarController.
   - Parameter rootViewController: The main UIViewController.
   */
  public init(rootViewController: UIViewController) {
    super.init(nibName: nil, bundle: nil)
    self.rootViewController = rootViewController
  }
  
  open override var shouldAutomaticallyForwardAppearanceMethods: Bool {
    return false
  }
  
  open override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    rootViewController.beginAppearanceTransition(true, animated: animated)
  }
  
  open override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    rootViewController.endAppearanceTransition()
  }
  
  open override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    rootViewController.beginAppearanceTransition(false, animated: animated)
  }
  
  open override func viewDidDisappear(_ animated: Bool) {
    super.viewDidDisappear(animated)
    rootViewController.endAppearanceTransition()
  }
  
  /**
   A method to swap rootViewController objects.
   - Parameter toViewController: The UIViewController to swap
   with the active rootViewController.
   - Parameter completion: A completion block that is execited after
   the transition animation from the active rootViewController
   to the toViewController has completed.
   */
  open func transition(to viewController: UIViewController, completion: ((Bool) -> Void)? = nil) {
    prepare(viewController: viewController, in: container)
    
    if case .auto = viewController.motionTransitionType {
      viewController.motionTransitionType = motionTransitionType
    }
    
    view.isUserInteractionEnabled = false
    MotionTransition.shared.transition(from: rootViewController, to: viewController, in: container) { [weak self] isFinishing in
      guard let s = self else {
        return
      }
      
      defer {
        s.view.isUserInteractionEnabled = true
        completion?(isFinishing)
      }
      
      guard isFinishing else {
        s.removeViewController(viewController: viewController)
        s.removeViewController(viewController: s.rootViewController)
        s.prepare(viewController: s.rootViewController, in: s.container)
        return
      }
      
      s.rootViewController = viewController
    }
  }
  
  open override func prepare() {
    super.prepare()
    
    prepareContainer()
    
    guard let v = rootViewController else {
      return
    }
    
    prepare(viewController: v, in: container)
  }
}

internal extension TransitionController {
  /// Prepares the container view.
  func prepareContainer() {
    container.frame = view.bounds
    container.clipsToBounds = true
    container.contentScaleFactor = Screen.scale
    container.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    view.addSubview(container)
  }
  
  /**
   A method that adds the passed in controller as a child of
   the BarController within the passed in
   container view.
   - Parameter viewController: A UIViewController to add as a child.
   - Parameter in container: A UIView that is the parent of the
   passed in controller view within the view hierarchy.
   */
  func prepare(viewController: UIViewController, in container: UIView) {
    addChild(viewController)
    container.addSubview(viewController.view)
    viewController.didMove(toParent: self)
    viewController.view.frame = container.bounds
    viewController.view.clipsToBounds = true
    viewController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    viewController.view.contentScaleFactor = Screen.scale
  }
}

internal extension TransitionController {
  /**
   Removes a given view controller from the childViewControllers array.
   - Parameter at index: An Int for the view controller position.
   */
  func removeViewController(viewController: UIViewController) {
    viewController.willMove(toParent: nil)
    viewController.view.removeFromSuperview()
    viewController.removeFromParent()
  }
}
