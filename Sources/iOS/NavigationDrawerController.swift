/*
 * Copyright (C) 2015 - 2017, Daniel Dahan and CosmicMind, Inc. <http://cosmicmind.com>.
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions are met:
 *
 *  *  Redistributions of source code must retain the above copyright notice, this
 *    list of conditions and the following disclaimer.
 *
 *  *  Redistributions in binary form must reproduce the above copyright notice,
 *    this list of conditions and the following disclaimer in the documentation
 *    and/or other materials provided with the distribution.
 *
 *  *  Neither the name of CosmicMind nor the names of its
 *    contributors may be used to endorse or promote products derived from
 *    this software without specific prior written permission.
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

@objc(NavigationDrawerPosition)
public enum NavigationDrawerPosition: Int {
  case left
  case right
}

extension UIViewController {
  /**
   A convenience property that provides access to the NavigationDrawerController.
   This is the recommended method of accessing the NavigationDrawerController
   through child UIViewControllers.
   */
  public var navigationDrawerController: NavigationDrawerController? {
    return traverseViewControllerHierarchyForClassType()
  }
}

@objc(NavigationDrawerControllerDelegate)
public protocol NavigationDrawerControllerDelegate {
  /**
   An optional delegation method that is fired before the
   NavigationDrawerController opens.
   - Parameter navigationDrawerController: A NavigationDrawerController.
   - Parameter position: The NavigationDrawerPosition.
   */
  @objc
  optional func navigationDrawerController(navigationDrawerController: NavigationDrawerController, willOpen position: NavigationDrawerPosition)
  
  /**
   An optional delegation method that is fired after the
   NavigationDrawerController opened.
   - Parameter navigationDrawerController: A NavigationDrawerController.
   - Parameter position: The NavigationDrawerPosition.
   */
  @objc
  optional func navigationDrawerController(navigationDrawerController: NavigationDrawerController, didOpen position: NavigationDrawerPosition)
  
  /**
   An optional delegation method that is fired before the
   NavigationDrawerController closes.
   - Parameter navigationDrawerController: A NavigationDrawerController.
   - Parameter position: The NavigationDrawerPosition.
   */
  @objc
  optional func navigationDrawerController(navigationDrawerController: NavigationDrawerController, willClose position: NavigationDrawerPosition)
  
  /**
   An optional delegation method that is fired after the
   NavigationDrawerController closed.
   - Parameter navigationDrawerController: A NavigationDrawerController.
   - Parameter position: The NavigationDrawerPosition.
   */
  @objc
  optional func navigationDrawerController(navigationDrawerController: NavigationDrawerController, didClose position: NavigationDrawerPosition)
  
  /**
   An optional delegation method that is fired when the
   NavigationDrawerController pan gesture begins.
   - Parameter navigationDrawerController: A NavigationDrawerController.
   - Parameter didBeginPanAt point: A CGPoint.
   - Parameter position: The NavigationDrawerPosition.
   */
  @objc
  optional func navigationDrawerController(navigationDrawerController: NavigationDrawerController, didBeginPanAt point: CGPoint, position: NavigationDrawerPosition)
  
  /**
   An optional delegation method that is fired when the
   NavigationDrawerController pan gesture changes position.
   - Parameter navigationDrawerController: A NavigationDrawerController.
   - Parameter didChangePanAt point: A CGPoint.
   - Parameter position: The NavigationDrawerPosition.
   */
  @objc
  optional func navigationDrawerController(navigationDrawerController: NavigationDrawerController, didChangePanAt point: CGPoint, position: NavigationDrawerPosition)
  
  /**
   An optional delegation method that is fired when the
   NavigationDrawerController pan gesture ends.
   - Parameter navigationDrawerController: A NavigationDrawerController.
   - Parameter didEndPanAt point: A CGPoint.
   - Parameter position: The NavigationDrawerPosition.
   */
  @objc
  optional func navigationDrawerController(navigationDrawerController: NavigationDrawerController, didEndPanAt point: CGPoint, position: NavigationDrawerPosition)
  
  /**
   An optional delegation method that is fired when the
   NavigationDrawerController tap gesture executes.
   - Parameter navigationDrawerController: A NavigationDrawerController.
   - Parameter didTapAt point: A CGPoint.
   - Parameter position: The NavigationDrawerPosition.
   */
  @objc
  optional func navigationDrawerController(navigationDrawerController: NavigationDrawerController, didTapAt point: CGPoint, position: NavigationDrawerPosition)
  
  /**
   An optional delegation method that is fired when the
   status bar is about to change display, isHidden or not.
   - Parameter navigationDrawerController: A NavigationDrawerController.
   - Parameter statusBar isHidden: A boolean.
   */
  @objc
  optional func navigationDrawerController(navigationDrawerController: NavigationDrawerController, statusBar isHidden: Bool)
}

@objc(NavigationDrawerController)
open class NavigationDrawerController: TransitionController {
  /// A boolean indicating if the panel is animating.
  fileprivate var isAnimating = false
  
  /**
   A CGFloat property that is used internally to track
   the original (x) position of the container view when panning.
   */
  fileprivate var originalX: CGFloat = 0
  
  /**
   A UIPanGestureRecognizer property internally used for the
   leftView pan gesture.
   */
  internal fileprivate(set) var leftPanGesture: UIPanGestureRecognizer?
  
  /**
   A UITapGestureRecognizer property internally used for the
   leftView tap gesture.
   */
  internal fileprivate(set) var leftTapGesture: UITapGestureRecognizer?
  
  /**
   A UIPanGestureRecognizer property internally used for the
   rightView pan gesture.
   */
  internal fileprivate(set) var rightPanGesture: UIPanGestureRecognizer?
  
  /**
   A UITapGestureRecognizer property internally used for the
   rightView tap gesture.
   */
  internal fileprivate(set) var rightTapGesture: UITapGestureRecognizer?
  
  /**
   A CGFloat property that accesses the leftView threshold of
   the NavigationDrawerController. When the panning gesture has
   ended, if the position is beyond the threshold,
   the leftView is opened, if it is below the threshold, the
   leftView is closed.
   */
  @IBInspectable
  open var leftThreshold: CGFloat = 64
  fileprivate var leftViewThreshold: CGFloat = 0
  
  /**
   A CGFloat property that accesses the rightView threshold of
   the NavigationDrawerController. When the panning gesture has
   ended, if the position is beyond the threshold,
   the rightView is closed, if it is below the threshold, the
   rightView is opened.
   */
  @IBInspectable
  open var rightThreshold: CGFloat = 64
  fileprivate var rightViewThreshold: CGFloat = 0
  
  /**
   A NavigationDrawerControllerDelegate property used to bind
   the delegation object.
   */
  open weak var delegate: NavigationDrawerControllerDelegate?
  
  /**
   A CGFloat property that sets the animation duration of the
   leftView when closing and opening. Defaults to 0.25.
   */
  @IBInspectable
  open var animationDuration: TimeInterval = 0.25
  
  /**
   A Boolean property that enables and disables the leftView from
   opening and closing. Defaults to true.
   */
  @IBInspectable
  open var isEnabled: Bool {
    get {
      return isLeftViewEnabled || isRightViewEnabled
    }
    set(value) {
      if nil != leftView {
        isLeftViewEnabled = value
      }
      
      if nil != rightView {
        isRightViewEnabled = value
      }
    }
  }
  
  /**
   A Boolean property that enables and disables the leftView from
   opening and closing. Defaults to true.
   */
  @IBInspectable
  open var isLeftViewEnabled = false {
    didSet {
      isLeftPanGestureEnabled = isLeftViewEnabled
      isLeftTapGestureEnabled = isLeftViewEnabled
    }
  }
  
  /// Enables the left pan gesture.
  @IBInspectable
  open var isLeftPanGestureEnabled = false {
    didSet {
      if isLeftPanGestureEnabled {
        prepareLeftPanGesture()
      } else {
        removeLeftPanGesture()
      }
    }
  }
  
  /// Enables the left tap gesture.
  @IBInspectable
  open var isLeftTapGestureEnabled = false {
    didSet {
      if isLeftTapGestureEnabled {
        prepareLeftTapGesture()
      } else {
        removeLeftTapGesture()
      }
    }
  }
  
  /**
   A Boolean property that enables and disables the rightView from
   opening and closing. Defaults to true.
   */
  @IBInspectable
  open var isRightViewEnabled = false {
    didSet {
      isRightPanGestureEnabled = isRightViewEnabled
      isRightTapGestureEnabled = isRightViewEnabled
    }
  }
  
  /// Enables the right pan gesture.
  @IBInspectable
  open var isRightPanGestureEnabled = false {
    didSet {
      if isRightPanGestureEnabled {
        prepareRightPanGesture()
      } else {
        removeRightPanGesture()
      }
    }
  }
  
  /// Enables the right tap gesture.
  @IBInspectable
  open var isRightTapGestureEnabled = false {
    didSet {
      if isRightTapGestureEnabled {
        prepareRightTapGesture()
      } else {
        removeRightTapGesture()
      }
    }
  }
  
  /**
   A Boolean property that triggers the status bar to be isHidden
   when the leftView is opened. Defaults to true.
   */
  @IBInspectable
  open var isHiddenStatusBarEnabled = true
  
  /**
   A DepthPreset property that is used to set the depth of the
   leftView when opened.
   */
  open var depthPreset = DepthPreset.depth1
  
  /**
   A UIView property that is used to hide and reveal the
   leftViewController. It is very rare that this property will
   need to be accessed externally.
   */
  open fileprivate(set) var leftView: UIView?
  
  /**
   A UIView property that is used to hide and reveal the
   rightViewController. It is very rare that this property will
   need to be accessed externally.
   */
  open fileprivate(set) var rightView: UIView?
  
  /// Indicates whether the leftView or rightView is opened.
  open var isOpened: Bool {
    return isLeftViewOpened || isRightViewOpened
  }
  
  /// indicates if the leftView is opened.
  open var isLeftViewOpened: Bool {
    guard let v = leftView else {
      return false
    }
    return v.frame.origin.x != -leftViewWidth
  }
  
  /// Indicates if the rightView is opened.
  open var isRightViewOpened: Bool {
    guard let v = rightView else {
      return false
    }
    return v.frame.origin.x != Screen.width
  }
  
  /**
   Content view controller to encompase the entire component. This is
   primarily used when the StatusBar is being isHidden. The alpha value of
   the rootViewController decreases, and shows the StatusBar. To avoid
   this, and to add a isHidden transition viewController for complex
   situations, the contentViewController was added.
   */
  open fileprivate(set) lazy var contentViewController = UIViewController()
  
  /**
   A UIViewController property that references the
   active left UIViewController.
   */
  open fileprivate(set) var leftViewController: UIViewController?
  
  /**
   A UIViewController property that references the
   active right UIViewController.
   */
  open fileprivate(set) var rightViewController: UIViewController?
  
  /**
   A CGFloat property to access the width that the leftView
   opens up to.
   */
  @IBInspectable
  open fileprivate(set) var leftViewWidth: CGFloat = 0
  
  /**
   A CGFloat property to access the width that the rightView
   opens up to.
   */
  @IBInspectable
  open fileprivate(set) var rightViewWidth: CGFloat = 0
  
  /**
   An initializer that initializes the object with a NSCoder object.
   - Parameter aDecoder: A NSCoder instance.
   */
  public required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    prepare()
  }
  
  /**
   An initializer that initializes the object with an Optional nib and bundle.
   - Parameter nibNameOrNil: An Optional String for the nib.
   - Parameter bundle: An Optional NSBundle where the nib is located.
   */
  public override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
    super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    prepare()
  }
  
  /**
   An initializer for the NavigationDrawerController.
   - Parameter rootViewController: The main UIViewController.
   - Parameter leftViewController: An Optional left UIViewController.
   - Parameter rightViewController: An Optional right UIViewController.
   */
  public init(rootViewController: UIViewController, leftViewController: UIViewController? = nil, rightViewController: UIViewController? = nil) {
    super.init(rootViewController: rootViewController)
    self.leftViewController = leftViewController
    self.rightViewController = rightViewController
    prepare()
  }
  
  open override func transition(to viewController: UIViewController, completion: ((Bool) -> Void)? = nil) {
    super.transition(to: viewController) { [weak self, completion = completion] (result) in
      guard let `self` = self else {
        return
      }
      
      self.view.sendSubview(toBack: self.contentViewController.view)
      completion?(result)
    }
  }
  
  /// Layout subviews.
  open override func layoutSubviews() {
    super.layoutSubviews()
    toggleStatusBar()
    
    if let v = leftView {
      v.frame.size.width = leftViewWidth
      v.frame.size.height = view.bounds.height
      leftViewThreshold = leftViewWidth / 2
      
      if let vc = leftViewController {
        vc.view.frame = v.bounds
        vc.view.frame.size.width = leftViewWidth
      }
    }
    
    if let v = rightView {
      v.frame.size.width = rightViewWidth
      v.frame.size.height = view.bounds.height
      rightViewThreshold = view.bounds.width - rightViewWidth / 2
      
      if let vc = rightViewController {
        vc.view.frame = v.bounds
        vc.view.frame.size.width = rightViewWidth
      }
    }
    
    rootViewController.view.frame = container.bounds
  }
  
  open override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    leftViewController?.beginAppearanceTransition(true, animated: animated)
    rightViewController?.beginAppearanceTransition(true, animated: animated)
  }
  
  open override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    leftViewController?.endAppearanceTransition()
    rightViewController?.endAppearanceTransition()
  }
  
  open override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    leftViewController?.beginAppearanceTransition(false, animated: animated)
    rightViewController?.beginAppearanceTransition(false, animated: animated)
  }
  
  open override func viewDidDisappear(_ animated: Bool) {
    super.viewDidDisappear(animated)
    leftViewController?.endAppearanceTransition()
    rightViewController?.endAppearanceTransition()
  }
  
  open override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
    super.viewWillTransition(to: size, with: coordinator)
    // Ensures the view is isHidden.
    guard let v = rightView else {
      return
    }
    
    v.layer.position.x = size.width + (isRightViewOpened ? -v.bounds.width : v.bounds.width) / 2
  }
  
  open override func prepare() {
    super.prepare()
    prepareContentViewController()
    prepareLeftView()
    prepareRightView()
  }
  
  /**
   A method that is used to set the width of the leftView when
   opened. This is the recommended method of setting the leftView
   width.
   - Parameter width: A CGFloat value to set as the new width.
   - Parameter isHidden: A Boolean value of whether the leftView
   should be isHidden after the width has been updated or not.
   - Parameter animated: A Boolean value that indicates to animate
   the leftView width change.
   */
  open func setLeftViewWidth(width: CGFloat, isHidden: Bool, animated: Bool, duration: TimeInterval = 0.5) {
    guard let v = leftView else {
      return
    }
    
    leftViewWidth = width
    
    var hide = isHidden
    
    if isRightViewOpened {
      hide = true
    }
    
    if animated {
      v.isShadowPathAutoSizing = false
      
      if hide {
        UIView.animate(withDuration: duration,
                       animations: { [weak self, v = v] in
                        guard let `self` = self else {
                          return
                        }
                        
                        v.bounds.size.width = width
                        v.layer.position.x = -width / 2
                        self.rootViewController.view.alpha = 1
                        
        }) { [weak self, v = v] _ in
          guard let `self` = self else {
            return
          }
          
          v.isShadowPathAutoSizing = true
          self.layoutSubviews()
          self.hideView(container: v)
        }
        
      } else {
        UIView.animate(withDuration: duration,
                       animations: { [weak self, v = v] in
                        guard let `self` = self else {
                          return
                        }
                        
                        v.bounds.size.width = width
                        v.layer.position.x = width / 2
                        self.rootViewController.view.alpha = 0.5
                        
        }) { [weak self, v = v] _ in
          guard let `self` = self else {
            return
          }
          
          v.isShadowPathAutoSizing = true
          self.layoutSubviews()
          self.showView(container: v)
        }
      }
    } else {
      v.bounds.size.width = width
      
      if hide {
        hideView(container: v)
        v.layer.position.x = -v.bounds.width / 2
        rootViewController.view.alpha = 1
        
      } else {
        showView(container: v)
        v.layer.position.x = width / 2
        rootViewController.view.alpha = 0.5
      }
      
      layoutSubviews()
    }
  }
  
  /**
   A method that is used to set the width of the rightView when
   opened. This is the recommended method of setting the rightView
   width.
   - Parameter width: A CGFloat value to set as the new width.
   - Parameter isHidden: A Boolean value of whether the rightView
   should be isHidden after the width has been updated or not.
   - Parameter animated: A Boolean value that indicates to animate
   the rightView width change.
   */
  open func setRightViewWidth(width: CGFloat, isHidden: Bool, animated: Bool, duration: TimeInterval = 0.5) {
    guard let v = rightView else {
      return
    }
    
    rightViewWidth = width
    
    var hide = isHidden
    
    if isLeftViewOpened {
      hide = true
    }
    
    if animated {
      v.isShadowPathAutoSizing = false
      
      if hide {
        UIView.animate(withDuration: duration,
                       animations: { [weak self, v = v] in
                        guard let `self` = self else {
                          return
                        }
                        
                        v.bounds.size.width = width
                        v.layer.position.x = self.view.bounds.width + width / 2
                        self.rootViewController.view.alpha = 1
                        
        }) { [weak self, v = v] _ in
          guard let `self` = self else {
            return
          }
          
          v.isShadowPathAutoSizing = true
          self.layoutSubviews()
          self.hideView(container: v)
        }
        
      } else {
        UIView.animate(withDuration: duration,
                       animations: { [weak self, v = v] in
                        guard let `self` = self else {
                          return
                        }
                        
                        v.bounds.size.width = width
                        v.layer.position.x = self.view.bounds.width - width / 2
                        self.rootViewController.view.alpha = 0.5
                        
        }) { [weak self, v = v] _ in
          guard let `self` = self else {
            return
          }
          
          v.isShadowPathAutoSizing = true
          self.layoutSubviews()
          self.showView(container: v)
        }
      }
    } else {
      v.bounds.size.width = width
      
      if hide {
        hideView(container: v)
        v.layer.position.x = view.bounds.width + v.bounds.width / 2
        rootViewController.view.alpha = 1
        
      } else {
        showView(container: v)
        v.layer.position.x = view.bounds.width - width / 2
        rootViewController.view.alpha = 0.5
      }
      
      layoutSubviews()
    }
  }
  
  /**
   A method that toggles the leftView opened if previously closed,
   or closed if previously opened.
   - Parameter velocity: A CGFloat value that sets the
   velocity of the user interaction when animating the
   leftView. Defaults to 0.
   */
  open func toggleLeftView(velocity: CGFloat = 0) {
    isLeftViewOpened ? closeLeftView(velocity: velocity) : openLeftView(velocity: velocity)
  }
  
  /**
   A method that toggles the rightView opened if previously closed,
   or closed if previously opened.
   - Parameter velocity: A CGFloat value that sets the
   velocity of the user interaction when animating the
   leftView. Defaults to 0.
   */
  open func toggleRightView(velocity: CGFloat = 0) {
    isRightViewOpened ? closeRightView(velocity: velocity) : openRightView(velocity: velocity)
  }
  
  /**
   A method that opens the leftView.
   - Parameter velocity: A CGFloat value that sets the
   velocity of the user interaction when animating the
   leftView. Defaults to 0.
   */
  open func openLeftView(velocity: CGFloat = 0) {
    guard !isAnimating else {
      return
    }
    
    guard isLeftViewEnabled else {
      return
    }
    
    guard let v = leftView else {
      return
    }
    
    isAnimating = true
    
    hideStatusBar()
    showView(container: v)
    
    isUserInteractionEnabled = false
    
    delegate?.navigationDrawerController?(navigationDrawerController: self, willOpen: .left)
    
    UIView.animate(withDuration: TimeInterval(0 == velocity ? animationDuration : fmax(0.1, fmin(1, Double(v.frame.origin.x / velocity)))),
                   animations: { [weak self, v = v] in
                    guard let `self` = self else {
                      return
                    }
                    
                    v.layer.position.x = v.bounds.width / 2
                    self.rootViewController.view.alpha = 0.5
                    
    }) { [weak self] _ in
      guard let `self` = self else {
        return
      }
      
      self.isAnimating = false
      self.delegate?.navigationDrawerController?(navigationDrawerController: self, didOpen: .left)
    }
  }
  
  /**
   A method that opens the rightView.
   - Parameter velocity: A CGFloat value that sets the
   velocity of the user interaction when animating the
   leftView. Defaults to 0.
   */
  open func openRightView(velocity: CGFloat = 0) {
    guard !isAnimating else {
      return
    }
    
    guard isRightViewEnabled else {
      return
    }
    
    guard let v = rightView else {
      return
    }
    
    isAnimating = true
    
    hideStatusBar()
    showView(container: v)
    
    isUserInteractionEnabled = false
    
    delegate?.navigationDrawerController?(navigationDrawerController: self, willOpen: .right)
    
    UIView.animate(withDuration: TimeInterval(0 == velocity ? animationDuration : fmax(0.1, fmin(1, Double(v.frame.origin.x / velocity)))),
                   animations: { [weak self, v = v] in
                    guard let `self` = self else {
                      return
                    }
                    
                    v.layer.position.x = self.view.bounds.width - v.bounds.width / 2
                    self.rootViewController.view.alpha = 0.5
                    
    }) { [weak self] _ in
      guard let `self` = self else {
        return
      }
      
      self.isAnimating = false
      
      self.delegate?.navigationDrawerController?(navigationDrawerController: self, didOpen: .right)
    }
  }
  
  /**
   A method that closes the leftView.
   - Parameter velocity: A CGFloat value that sets the
   velocity of the user interaction when animating the
   leftView. Defaults to 0.
   */
  open func closeLeftView(velocity: CGFloat = 0) {
    guard !isAnimating else {
      return
    }
    
    guard isLeftViewEnabled else {
      return
    }
    
    guard let v = leftView else {
      return
    }
    
    isAnimating = true
    
    delegate?.navigationDrawerController?(navigationDrawerController: self, willClose: .left)
    
    UIView.animate(withDuration: TimeInterval(0 == velocity ? animationDuration : fmax(0.1, fmin(1, Double(v.frame.origin.x / velocity)))),
                   animations: { [weak self, v = v] in
                    guard let `self` = self else {
                      return
                    }
                    
                    v.layer.position.x = -v.bounds.width / 2
                    self.rootViewController.view.alpha = 1
                    
    }) { [weak self, v = v] _ in
      guard let `self` = self else {
        return
      }
      
      self.hideView(container: v)
      self.toggleStatusBar()
      
      self.isAnimating = false
      self.isUserInteractionEnabled = true
      
      self.delegate?.navigationDrawerController?(navigationDrawerController: self, didClose: .left)
    }
  }
  
  /**
   A method that closes the rightView.
   - Parameter velocity: A CGFloat value that sets the
   velocity of the user interaction when animating the
   leftView. Defaults to 0.
   */
  open func closeRightView(velocity: CGFloat = 0) {
    guard !isAnimating else {
      return
    }
    
    guard isRightViewEnabled else {
      return
    }
    
    guard let v = rightView else {
      return
    }
    
    isAnimating = true
    
    delegate?.navigationDrawerController?(navigationDrawerController: self, willClose: .right)
    
    UIView.animate(withDuration: TimeInterval(0 == velocity ? animationDuration : fmax(0.1, fmin(1, Double(v.frame.origin.x / velocity)))),
                   animations: { [weak self, v = v] in
                    guard let `self` = self else {
                      return
                    }
                    
                    v.layer.position.x = self.view.bounds.width + v.bounds.width / 2
                    self.rootViewController.view.alpha = 1
                    
    }) { [weak self, v = v] _ in
      guard let `self` = self else {
        return
      }
      
      self.hideView(container: v)
      self.toggleStatusBar()
      
      self.isAnimating = false
      self.isUserInteractionEnabled = true
      
      self.delegate?.navigationDrawerController?(navigationDrawerController: self, didClose: .right)
    }
  }
  
  /// A method that removes the passed in pan and leftView tap gesture recognizers.
  fileprivate func removeLeftViewGestures() {
    removeLeftPanGesture()
    removeLeftTapGesture()
  }
  
  /// Removes the left pan gesture.
  fileprivate func removeLeftPanGesture() {
    guard let v = leftPanGesture else {
      return
    }
    
    view.removeGestureRecognizer(v)
    leftPanGesture = nil
  }
  
  /// Removes the left tap gesture.
  fileprivate func removeLeftTapGesture() {
    guard let v = leftTapGesture else {
      return
    }
    
    view.removeGestureRecognizer(v)
    leftTapGesture = nil
  }
  
  /// A method that removes the passed in pan and rightView tap gesture recognizers.
  fileprivate func removeRightViewGestures() {
    removeRightPanGesture()
    removeRightTapGesture()
    
  }
  
  /// Removes the right pan gesture.
  fileprivate func removeRightPanGesture() {
    guard let v = rightPanGesture else {
      return
    }
    
    view.removeGestureRecognizer(v)
    rightPanGesture = nil
  }
  
  /// Removes the right tap gesture.
  fileprivate func removeRightTapGesture() {
    guard let v = rightTapGesture else {
      return
    }
    
    view.removeGestureRecognizer(v)
    rightTapGesture = nil
  }
  
  /// Shows the statusBar.
  fileprivate func showStatusBar() {
    Motion.async { [weak self] in
      guard let v = Application.keyWindow else {
        return
      }
      
      v.windowLevel = UIWindowLevelNormal
      
      guard let `self` = self else {
        return
      }
      
      self.delegate?.navigationDrawerController?(navigationDrawerController: self, statusBar: false)
    }
  }
  
  /// Hides the statusBar.
  fileprivate func hideStatusBar() {
    guard isHiddenStatusBarEnabled else {
      return
    }
    
    Motion.async { [weak self] in
      guard let v = Application.keyWindow else {
        return
      }
      
      v.windowLevel = UIWindowLevelStatusBar + 1
      
      guard let `self` = self else {
        return
      }
      
      self.delegate?.navigationDrawerController?(navigationDrawerController: self, statusBar: true)
    }
  }
  
  /// Toggles the statusBar
  fileprivate func toggleStatusBar() {
    if isOpened {
      hideStatusBar()
    } else {
      showStatusBar()
    }
  }
  
  /**
   A method that determines whether the passed point is
   contained within the bounds of the leftViewThreshold
   and height of the NavigationDrawerController view frame
   property.
   - Parameter point: A CGPoint to test against.
   - Returns: A Boolean of the result, true if yes, false
   otherwise.
   */
  fileprivate func isPointContainedWithinLeftThreshold(point: CGPoint) -> Bool {
    return point.x <= leftThreshold
  }
  
  /**
   A method that determines whether the passed point is
   contained within the bounds of the rightViewThreshold
   and height of the NavigationDrawerController view frame
   property.
   - Parameter point: A CGPoint to test against.
   - Returns: A Boolean of the result, true if yes, false
   otherwise.
   */
  fileprivate func isPointContainedWithinRighThreshold(point: CGPoint) -> Bool {
    return point.x >= view.bounds.width - rightThreshold
  }
  
  /**
   A method that determines whether the passed in point is
   contained within the bounds of the passed in container view.
   - Parameter container: A UIView that sets the bounds to test
   against.
   - Parameter point: A CGPoint to test whether or not it is
   within the bounds of the container parameter.
   - Returns: A Boolean of the result, true if yes, false
   otherwise.
   */
  fileprivate func isPointContainedWithinView(container: UIView, point: CGPoint) -> Bool {
    return container.bounds.contains(point)
  }
  
  /**
   A method that shows a view.
   - Parameter container: A container view.
   */
  fileprivate func showView(container: UIView) {
    container.depthPreset = depthPreset
    container.isHidden = false
  }
  
  /**
   A method that hides a view.
   - Parameter container: A container view.
   */
  fileprivate func hideView(container: UIView) {
    container.depthPreset = .none
    container.isHidden = true
  }
}

extension NavigationDrawerController {
  /// Prepares the contentViewController.
  fileprivate func prepareContentViewController() {
    contentViewController.view.backgroundColor = .black
    prepare(viewController: contentViewController, in: view)
    view.sendSubview(toBack: contentViewController.view)
  }
  
  /// A method that prepares the leftView.
  fileprivate func prepareLeftView() {
    guard let v = leftViewController else {
      return
    }
    
    isLeftViewEnabled = true
    
    leftViewWidth = .phone == Device.userInterfaceIdiom ? 280 : 320
    leftView = UIView()
    leftView!.frame = CGRect(x: 0, y: 0, width: leftViewWidth, height: view.bounds.height)
    leftView!.backgroundColor = .white
    view.addSubview(leftView!)
    
    leftView!.isHidden = true
    leftView!.layer.position.x = -leftViewWidth / 2
    leftView!.layer.zPosition = 2000
    
    prepare(viewController: v, in: leftView!)
  }
  
  /// A method that prepares the leftView.
  fileprivate func prepareRightView() {
    guard let v = rightViewController else {
      return
    }
    
    isRightViewEnabled = true
    
    rightViewWidth = .phone == Device.userInterfaceIdiom ? 280 : 320
    rightView = UIView()
    rightView!.frame = CGRect(x: view.bounds.width, y: 0, width: rightViewWidth, height: view.bounds.height)
    rightView!.backgroundColor = .white
    view.addSubview(rightView!)
    
    rightView!.isHidden = true
    rightView!.layer.position.x = view.bounds.width + rightViewWidth / 2
    rightView!.layer.zPosition = 2000
    
    prepare(viewController: v, in: rightView!)
  }
  
  /// Prepare the left pan gesture.
  fileprivate func prepareLeftPanGesture() {
    guard nil == leftPanGesture else {
      return
    }
    
    leftPanGesture = UIPanGestureRecognizer(target: self, action: #selector(handleLeftViewPanGesture(recognizer:)))
    leftPanGesture!.delegate = self
    leftPanGesture!.cancelsTouchesInView = false
    view.addGestureRecognizer(leftPanGesture!)
  }
  
  /// Prepare the left tap gesture.
  fileprivate func prepareLeftTapGesture() {
    guard nil == leftTapGesture else {
      return
    }
    
    leftTapGesture = UITapGestureRecognizer(target: self, action: #selector(handleLeftViewTapGesture(recognizer:)))
    leftTapGesture!.delegate = self
    leftTapGesture!.cancelsTouchesInView = false
    view.addGestureRecognizer(leftTapGesture!)
  }
  
  /// Prepares the right pan gesture.
  fileprivate func prepareRightPanGesture() {
    guard nil == rightPanGesture else {
      return
    }
    
    rightPanGesture = UIPanGestureRecognizer(target: self, action: #selector(handleRightViewPanGesture(recognizer:)))
    rightPanGesture!.delegate = self
    rightPanGesture!.cancelsTouchesInView = false
    view.addGestureRecognizer(rightPanGesture!)
  }
  
  /// Prepares the right tap gesture.
  fileprivate func prepareRightTapGesture() {
    guard nil == rightTapGesture else {
      return
    }
    
    rightTapGesture = UITapGestureRecognizer(target: self, action: #selector(handleRightViewTapGesture(recognizer:)))
    rightTapGesture!.delegate = self
    rightTapGesture!.cancelsTouchesInView = false
    view.addGestureRecognizer(rightTapGesture!)
  }
}

extension NavigationDrawerController: UIGestureRecognizerDelegate {
  /**
   Detects the gesture recognizer being used.
   - Parameter gestureRecognizer: A UIGestureRecognizer to detect.
   - Parameter touch: The UITouch event.
   - Returns: A Boolean of whether to continue the gesture or not.
   */
  @objc
  open func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
    if !isRightViewOpened && gestureRecognizer == leftPanGesture && (isLeftViewOpened || isPointContainedWithinLeftThreshold(point: touch.location(in: view))) {
      return true
    }
    
    if !isLeftViewOpened && gestureRecognizer == rightPanGesture && (isRightViewOpened || isPointContainedWithinRighThreshold(point: touch.location(in: view))) {
      return true
    }
    
    if isLeftViewOpened && gestureRecognizer == leftTapGesture {
      return true
    }
    
    if isRightViewOpened && gestureRecognizer == rightTapGesture {
      return true
    }
    
    return false
  }
  
  /**
   A method that is fired when the pan gesture is recognized
   for the leftView.
   - Parameter recognizer: A UIPanGestureRecognizer that is
   passed to the handler when recognized.
   */
  @objc
  fileprivate func handleLeftViewPanGesture(recognizer: UIPanGestureRecognizer) {
    guard isLeftViewEnabled && (isLeftViewOpened || !isRightViewOpened && isPointContainedWithinLeftThreshold(point: recognizer.location(in: view))) else {
      return
    }
    
    guard let v = leftView else {
      return
    }
    
    let point = recognizer.location(in: view)
    
    // Animate the panel.
    switch recognizer.state {
    case .began:
      originalX = v.layer.position.x
      showView(container: v)
      
      delegate?.navigationDrawerController?(navigationDrawerController: self, didBeginPanAt: point, position: .left)
      
    case .changed:
      let w = v.bounds.width
      let translationX = recognizer.translation(in: v).x
      
      v.layer.position.x = originalX + translationX > (w / 2) ? (w / 2) : originalX + translationX
      
      let a = 1 - v.layer.position.x / v.bounds.width
      rootViewController.view.alpha = 0.5 < a && v.layer.position.x <= v.bounds.width / 2 ? a : 0.5
      
      if translationX >= leftThreshold {
        hideStatusBar()
      }
      
      delegate?.navigationDrawerController?(navigationDrawerController: self, didChangePanAt: point, position: .left)
      
    case .ended, .cancelled, .failed:
      let p = recognizer.velocity(in: recognizer.view)
      let x = p.x >= 1000 || p.x <= -1000 ? p.x : 0
      
      delegate?.navigationDrawerController?(navigationDrawerController: self, didEndPanAt: point, position: .left)
      
      if v.frame.origin.x <= -leftViewWidth + leftViewThreshold || x < -1000 {
        closeLeftView(velocity: x)
      } else {
        openLeftView(velocity: x)
      }
      
    case .possible:break
    }
  }
  
  /**
   A method that is fired when the pan gesture is recognized
   for the rightView.
   - Parameter recognizer: A UIPanGestureRecognizer that is
   passed to the handler when recognized.
   */
  @objc
  fileprivate func handleRightViewPanGesture(recognizer: UIPanGestureRecognizer) {
    guard isRightViewEnabled && (isRightViewOpened || !isLeftViewOpened && isPointContainedWithinRighThreshold(point: recognizer.location(in: view))) else {
      return
    }
    
    guard let v = rightView else {
      return
    }
    
    let point = recognizer.location(in: view)
    
    // Animate the panel.
    switch recognizer.state {
    case .began:
      originalX = v.layer.position.x
      showView(container: v)
      
      delegate?.navigationDrawerController?(navigationDrawerController: self, didBeginPanAt: point, position: .right)
      
    case .changed:
      let w = v.bounds.width
      let translationX = recognizer.translation(in: v).x
      
      v.layer.position.x = originalX + translationX < view.bounds.width - (w / 2) ? view.bounds.width - (w / 2) : originalX + translationX
      
      let a = 1 - (view.bounds.width - v.layer.position.x) / v.bounds.width
      rootViewController.view.alpha = 0.5 < a && v.layer.position.x >= v.bounds.width / 2 ? a : 0.5
      
      if translationX <= -rightThreshold {
        hideStatusBar()
      }
      
      delegate?.navigationDrawerController?(navigationDrawerController: self, didChangePanAt: point, position: .right)
      
    case .ended, .cancelled, .failed:
      let p = recognizer.velocity(in: recognizer.view)
      let x = p.x >= 1000 || p.x <= -1000 ? p.x : 0
      
      delegate?.navigationDrawerController?(navigationDrawerController: self, didEndPanAt: point, position: .right)
      
      if v.frame.origin.x >= rightViewThreshold || x > 1000 {
        closeRightView(velocity: x)
      } else {
        openRightView(velocity: x)
      }
      
    case .possible:break
    }
  }
  
  /**
   A method that is fired when the tap gesture is recognized
   for the leftView.
   - Parameter recognizer: A UITapGestureRecognizer that is
   passed to the handler when recognized.
   */
  @objc
  fileprivate func handleLeftViewTapGesture(recognizer: UITapGestureRecognizer) {
    guard isLeftViewOpened else {
      return
    }
    
    guard let v = leftView else {
      return
    }
    
    delegate?.navigationDrawerController?(navigationDrawerController: self, didTapAt: recognizer.location(in: view), position: .left)
    
    guard isLeftViewEnabled && isLeftViewOpened && !isPointContainedWithinView(container: v, point: recognizer.location(in: v)) else {
      return
    }
    
    closeLeftView()
  }
  
  /**
   A method that is fired when the tap gesture is recognized
   for the rightView.
   - Parameter recognizer: A UITapGestureRecognizer that is
   passed to the handler when recognized.
   */
  @objc
  fileprivate func handleRightViewTapGesture(recognizer: UITapGestureRecognizer) {
    guard isRightViewOpened else {
      return
    }
    
    guard let v = rightView else {
      return
    }
    
    delegate?.navigationDrawerController?(navigationDrawerController: self, didTapAt: recognizer.location(in: view), position: .right)
    
    guard isRightViewEnabled && isRightViewOpened && !isPointContainedWithinView(container: v, point: recognizer.location(in: v)) else {
      return
    }
    
    closeRightView()
  }
}
