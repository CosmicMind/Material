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

extension UIViewController {
  /**
   A convenience property that provides access to the BottomNavigationController.
   This is the recommended method of accessing the BottomNavigationController
   through child UIViewControllers.
   */
  public var bottomNavigationController: BottomNavigationController? {
    return traverseViewControllerHierarchyForClassType()
  }
}

private class MaterialTabBar: UITabBar {
  override func sizeThatFits(_ size: CGSize) -> CGSize {
    var v = super.sizeThatFits(size)
    let offset = v.height - HeightPreset.normal.rawValue
    v.height = heightPreset.rawValue + offset
    return v
  }
}

open class BottomNavigationController: UITabBarController, Themeable {
  /// A Boolean that controls if the swipe feature is enabled.
  open var isSwipeEnabled = true {
    didSet {
      guard isSwipeEnabled else {
        removeSwipeGesture()
        return
      }
      
      prepareSwipeGesture()
    }
  }
  
  /**
   A UIPanGestureRecognizer property internally used for the interactive
   swipe.
   */
  public private(set) var interactiveSwipeGesture: UIPanGestureRecognizer?
  
  /**
   A private integer for storing index of current view controller
   during interactive transition.
   */
  private var currentIndex = -1
  
  /**
   An initializer that initializes the object with a NSCoder object.
   - Parameter aDecoder: A NSCoder instance.
   */
  public required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    setTabBarClass()
  }
  
  /**
   An initializer that initializes the object with an Optional nib and bundle.
   - Parameter nibNameOrNil: An Optional String for the nib.
   - Parameter bundle: An Optional NSBundle where the nib is located.
   */
  public override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
    super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    setTabBarClass()
  }
  
  /// An initializer that accepts no parameters.
  public init() {
    super.init(nibName: nil, bundle: nil)
    setTabBarClass()
  }
  
  /**
   An initializer that initializes the object an Array of UIViewControllers.
   - Parameter viewControllers: An Array of UIViewControllers.
   */
  public init(viewControllers: [UIViewController]) {
    super.init(nibName: nil, bundle: nil)
    setTabBarClass()
    self.viewControllers = viewControllers
  }
  
  open override func viewDidLoad() {
    super.viewDidLoad()
    prepare()
  }
  
  open override func viewWillLayoutSubviews() {
    super.viewWillLayoutSubviews()
    layoutSubviews()
  }
  
  /**
   To execute in the order of the layout chain, override this
   method. `layoutSubviews` should be called immediately, unless you
   have a certain need.
   */
  open func layoutSubviews() {
    tabBar.layoutDivider()
  }
  
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
    
    prepareTabBar()
    isSwipeEnabled = true
    isMotionEnabled = true
    applyCurrentTheme()
  }
  
  /**
   Applies the given theme.
   - Parameter theme: A Theme.
   */
  open func apply(theme: Theme) {
    tabBar.tintColor = theme.secondary
    tabBar.barTintColor = theme.background
    tabBar.dividerColor = theme.onSurface.withAlphaComponent(0.12)
    
    if #available(iOS 10.0, *) {
      tabBar.unselectedItemTintColor = theme.onSurface.withAlphaComponent(0.54)
    }
  }
}

private extension BottomNavigationController {
  /**
   A target method contolling interactive swipe transition based on
   gesture recognizer.
   - Parameter _ gesture: A UIPanGestureRecognizer.
   */
  @objc
  func handleTransitionPan(_ gesture: UIPanGestureRecognizer) {
    guard selectedIndex != NSNotFound else {
      return
    }
    
    let translationX = gesture.translation(in: nil).x
    let velocityX = gesture.velocity(in: nil).x
    
    switch gesture.state {
    case .began, .changed:
      let isSlidingLeft = currentIndex == -1 ? velocityX < 0 : translationX < 0
      
      if currentIndex == -1 {
        currentIndex = selectedIndex
      }
      
      let nextIndex = currentIndex + (isSlidingLeft ? 1 : -1)
      
      if selectedIndex != nextIndex {
        /// 5 point threshold
        guard abs(translationX) > 5 else {
          return
        }
        
        if currentIndex != selectedIndex {
          MotionTransition.shared.cancel(isAnimated: false)
        }
        
        guard canSelect(at: nextIndex) else {
          return
        }
        
        selectedIndex = nextIndex
        MotionTransition.shared.setCompletionCallbackForNextTransition { [weak self] isFinishing in
          guard let `self` = self, isFinishing else {
            return
          }
          
          self.delegate?.tabBarController?(self, didSelect: self.viewControllers![nextIndex])
        }
      } else {
        let progress = abs(translationX / view.bounds.width)
        MotionTransition.shared.update(Double(progress))
      }
      
    default:
      let progress = (translationX + velocityX) / view.bounds.width
      
      let isUserHandDirectionLeft = progress < 0
      let isTargetHandDirectionLeft = selectedIndex > currentIndex
      
      if isUserHandDirectionLeft == isTargetHandDirectionLeft && abs(progress) > 0.5 {
        MotionTransition.shared.finish()
      } else {
        MotionTransition.shared.cancel()
      }
      
      currentIndex = -1
    }
  }
  
  /// Prepares interactiveSwipeGesture.
  func prepareSwipeGesture() {
    guard nil == interactiveSwipeGesture else {
      return
    }
    
    interactiveSwipeGesture = UIPanGestureRecognizer(target: self, action: #selector(handleTransitionPan))
    view.addGestureRecognizer(interactiveSwipeGesture!)
  }
  
  /// Removes interactiveSwipeGesture.
  func removeSwipeGesture() {
    guard let v = interactiveSwipeGesture else {
      return
    }
    
    view.removeGestureRecognizer(v)
    interactiveSwipeGesture = nil
  }
}

private extension BottomNavigationController {
  /// Sets tabBar class to MaterialTabBar.
  func setTabBarClass() {
    guard object_getClass(tabBar) === UITabBar.self else {
      return
    }
    
    object_setClass(tabBar, MaterialTabBar.self)
  }
}

private extension BottomNavigationController {
  /**
   Checks if the view controller at a given index can be selected.
   - Parameter at index: An Int.
   */
  func canSelect(at index: Int) -> Bool {
    guard index != selectedIndex else {
      return false
    }
    
    let lastTabIndex = (tabBar.items?.count ?? 1) - 1
    guard (0...lastTabIndex).contains(index) else {
      return false
    }
    
    guard !(index == lastTabIndex && tabBar.items?.last == moreNavigationController.tabBarItem) else {
      return false
    }
    
    let vc = viewControllers![index]
    guard delegate?.tabBarController?(self, shouldSelect: vc) != false else {
      return false
    }
    
    return true
  }
}

private extension BottomNavigationController {
  /// Prepares the tabBar.
  func prepareTabBar() {
    tabBar.isTranslucent = false
    tabBar.heightPreset = .normal
    tabBar.dividerColor = Color.grey.lighten2
    tabBar.dividerAlignment = .top
    
    let image = UIImage()
    tabBar.shadowImage = image
    tabBar.backgroundImage = image
    tabBar.backgroundColor = .white
  }
}
