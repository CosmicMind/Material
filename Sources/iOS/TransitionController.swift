/*
 * Copyright (C) 2015 - 2018, Daniel Dahan and CosmicMind, Inc. <http://cosmicmind.com>.
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions are met:
 *
 *	*	Redistributions of source code must retain the above copyright notice, this
 *		list of conditions and the following disclaimer.
 *
 *	*	Redistributions in binary form must reproduce the above copyright notice,
 *		this list of conditions and the following disclaimer in the documentation
 *		and/or other materials provided with the distribution.
 *
 *	*	Neither the name of CosmicMind nor the names of its
 *		contributors may be used to endorse or promote products derived from
 *		this software without specific prior written permission.
 *
 * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
 * AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
 * IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
 * DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE
 * FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
 * DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
 * SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
 * CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
 * OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
 * OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */

import UIKit
import Motion

open class TransitionController: UIViewController {
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
  
  /// A reference to the container view.
  @IBInspectable
  open let container = UIView()
  
  /**
   A UIViewController property that references the active
   main UIViewController. To swap the rootViewController, it
   is recommended to use the transitionFromRootViewController
   helper method.
   */
  open internal(set) var rootViewController: UIViewController! {
    willSet {
      guard newValue != rootViewController else {
        return
      }
      
      guard let v = rootViewController else {
        return
      }
      
      removeViewController(viewController: v)
    }
    didSet {
      guard oldValue != rootViewController else {
        return
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
  
  open override func viewDidLoad() {
    super.viewDidLoad()
    prepare()
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
  
  open override func viewWillLayoutSubviews() {
    super.viewWillLayoutSubviews()
    layoutSubviews()
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
    
    switch motionTransitionType {
    case .auto:break
    default:
      switch viewController.motionTransitionType {
      case .auto:
        viewController.motionTransitionType = motionTransitionType
      default:break
      }
    }
    
    view.isUserInteractionEnabled = false
    MotionTransition.shared.transition(from: rootViewController, to: viewController, in: container) { [weak self, viewController = viewController, completion = completion] (isFinishing) in
      guard let s = self else {
        return
      }
      
      s.rootViewController = viewController
      s.view.isUserInteractionEnabled = true
      completion?(isFinishing)
    }
  }
  
  /**
   To execute in the order of the layout chain, override this
   method. `layoutSubviews` should be called immediately, unless you
   have a certain need.
   */
  open func layoutSubviews() {}
  
  /**
   Prepares the view instance when intialized. When subclassing,
   it is recommended to override the prepare method
   to initialize property values and other setup operations.
   The super.prepare method should always be called immediately
   when subclassing.
   */
  open func prepare() {
    view.clipsToBounds = true
    view.backgroundColor = .white
    view.contentScaleFactor = Screen.scale
    
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
    addChildViewController(viewController)
    container.addSubview(viewController.view)
    viewController.didMove(toParentViewController: self)
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
    viewController.willMove(toParentViewController: nil)
    viewController.view.removeFromSuperview()
    viewController.removeFromParentViewController()
  }
}
