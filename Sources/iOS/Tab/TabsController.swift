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

fileprivate var TabItemKey: UInt8 = 0

@objc(TabBarAlignment)
public enum TabBarAlignment: Int {
  case top
  case bottom
}

public enum TabBarThemingStyle {
  case auto
  case primary
  case secondary
}

extension UIViewController {
  /// TabItem reference.
  @objc
  open private(set) var tabItem: TabItem {
    get {
      return AssociatedObject.get(base: self, key: &TabItemKey) {
        return TabItem()
      }
    }
    set(value) {
      AssociatedObject.set(base: self, key: &TabItemKey, value: value)
    }
  }
}

extension UIViewController {
  /**
   A convenience property that provides access to the TabsController.
   This is the recommended method of accessing the TabsController
   through child UIViewControllers.
   */
  public var tabsController: TabsController? {
    return traverseViewControllerHierarchyForClassType()
  }
}

@objc(TabsControllerDelegate)
public protocol TabsControllerDelegate {
  /**
   A delegation method that is executed to determine if the TabsController should
   transition to the next view controller.
   - Parameter tabBar: A TabsController.
   - Parameter tabItem: A TabItem.
   - Returns: A Boolean.
   */
  @objc
  optional func tabsController(tabsController: TabsController, shouldSelect viewController: UIViewController) -> Bool
  
  /**
   A delegation method that is executed when the view controller will transitioned to.
   - Parameter tabsController: A TabsController.
   - Parameter viewController: A UIViewController.
   */
  @objc
  optional func tabsController(tabsController: TabsController, willSelect viewController: UIViewController)
  
  /**
   A delegation method that is executed when the view controller has been transitioned to.
   - Parameter tabsController: A TabsController.
   - Parameter viewController: A UIViewController.
   */
  @objc
  optional func tabsController(tabsController: TabsController, didSelect viewController: UIViewController)
  
  /**
   A delegation method that is executed when the interactive transition to view controller
   will be cancelled.
   - Parameter tabsController: A TabsController.
   - Parameter viewController: A UIViewController.
   */
  @objc
  optional func tabsController(tabsController: TabsController, willCancelSelecting viewController: UIViewController)
  
  /**
   A delegation method that is executed when the interactive transition to view controller
   has been cancelled.
   - Parameter tabsController: A TabsController.
   - Parameter viewController: A UIViewController.
   */
  @objc
  optional func tabsController(tabsController: TabsController, didCancelSelecting viewController: UIViewController)
}

open class TabsController: TransitionController {
  /**
   A Display value to indicate whether or not to
   display the rootViewController to the full view
   bounds, or up to the toolbar height.
   */
  open var displayStyle = DisplayStyle.partial {
    didSet {
      layoutSubviews()
    }
  }
  
  /// The TabBar used to switch between view controllers.
  @IBInspectable
  public let tabBar = TabBar()
  
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
  
  /// A delegation reference.
  open weak var delegate: TabsControllerDelegate?
  
  /// An Array of UIViewControllers.
  open var viewControllers: [UIViewController] {
    didSet {
      selectedIndex = 0
      
      prepareSelectedIndexViewController()
      prepareTabBar()
      layoutSubviews()
    }
  }
  
  /// A reference to the currently selected view controller index value.
  @IBInspectable
  open fileprivate(set) var selectedIndex = 0
  
  /// The tabBar alignment.
  open var tabBarAlignment = TabBarAlignment.bottom {
    didSet {
      updateTabBarAlignment()
      layoutSubviews()
    }
  }
  
  /// The tabBar theming style.
  open var tabBarThemingStyle = TabBarThemingStyle.auto
  
  /**
   A UIPanGestureRecognizer property internally used for the interactive
   swipe.
   */
  public private(set) var interactiveSwipeGesture: UIPanGestureRecognizer?
  
  /**
   A private integer for storing index of target view controller
   during interactive transition.
   */
  private var targetIndex = -1
  
  /**
   An initializer that initializes the object with a NSCoder object.
   - Parameter aDecoder: A NSCoder instance.
   */
  public required init?(coder aDecoder: NSCoder) {
    viewControllers = []
    super.init(coder: aDecoder)
  }
  
  /**
   An initializer that accepts an Array of UIViewControllers.
   - Parameter viewControllers: An Array of UIViewControllers.
   */
  public init(viewControllers: [UIViewController], selectedIndex: Int = 0) {
    self.viewControllers = viewControllers
    self.selectedIndex = selectedIndex
    super.init(nibName: nil, bundle: nil)
  }
  
  fileprivate override init(rootViewController: UIViewController) {
    self.viewControllers = []
    super.init(rootViewController: rootViewController)
  }
  
  open override func layoutSubviews() {
    super.layoutSubviews()
    layoutTabBar()
    layoutContainer()
    layoutRootViewController()
  }
  
  open override func prepare() {
    super.prepare()
    view.backgroundColor = .white
    view.contentScaleFactor = Screen.scale
    
    isSwipeEnabled = true
    
    prepareTabBar()
    prepareTabItems()
    prepareSelectedIndexViewController()
    applyCurrentTheme()
  }
  
  open override func transition(to viewController: UIViewController, completion: ((Bool) -> Void)?) {
    transition(to: viewController, isTriggeredByUserInteraction: false, completion: completion)
  }
  
  open override func apply(theme: Theme) {
    super.apply(theme: theme)
    
    switch tabBarThemingStyle {
    case .auto where (parent is NavigationController || parent is ToolbarController) && tabBarAlignment == .top:
      fallthrough
      
    case .primary:
      applyPrimary(theme: theme)
      
    default:
      applySecondary(theme: theme)
    }
  }
}

private extension TabsController {
  /**
   Applies theming taking primary color as base.
   - Parameter theme: A Theme
   */
  func applyPrimary(theme: Theme) {
    tabBar.lineColor = theme.onPrimary.withAlphaComponent(0.68)
    tabBar.backgroundColor = theme.primary
    tabBar.setTabItemsColor(theme.onPrimary, for: .normal)
    tabBar.setTabItemsColor(theme.onPrimary, for: .selected)
    tabBar.setTabItemsColor(theme.onPrimary, for: .highlighted)
    tabBar.isDividerHidden = true
  }
  
  /**
   Applies theming taking secondary color as base.
   - Parameter theme: A Theme
   */
  func applySecondary(theme: Theme) {
    tabBar.lineColor = theme.secondary
    tabBar.backgroundColor = theme.background
    tabBar.setTabItemsColor(theme.onSurface.withAlphaComponent(0.60), for: .normal)
    tabBar.setTabItemsColor(theme.secondary, for: .selected)
    tabBar.setTabItemsColor(theme.secondary, for: .highlighted)
    tabBar.dividerColor = theme.onSurface.withAlphaComponent(0.12)
  }
}

fileprivate extension TabsController {
  /**
   Transitions to the given view controller.
   - Parameter to viewController: A UIViewController.
   - Parameter isTriggeredByUserInteraction: A Boolean.
   - Parameter completion: An optional completion block.
   */
  func transition(to viewController: UIViewController, isTriggeredByUserInteraction: Bool, completion: ((Bool) -> Void)?) {
    guard let fvcIndex = viewControllers.firstIndex(of: rootViewController) else {
      return
    }
    
    guard let tvcIndex = viewControllers.firstIndex(of: viewController) else {
      return
    }
    
    if case .auto = motionTransitionType, case .auto = viewController.motionTransitionType {
      MotionTransition.shared.setAnimationForNextTransition(fvcIndex < tvcIndex ? .slide(direction: .left) : .slide(direction: .right))
    }
    
    if isTriggeredByUserInteraction {
      delegate?.tabsController?(tabsController: self, willSelect: viewController)
    }
    
    super.transition(to: viewController) { [weak self] (isFinishing) in
      guard let `self` = self else {
        return
      }
      
      completion?(isFinishing)
      
      if isTriggeredByUserInteraction && isFinishing {
        self.delegate?.tabsController?(tabsController: self, didSelect: viewController)
      } else {
        self.delegate?.tabsController?(tabsController: self, didCancelSelecting: viewController)
      }
    }
  }
}

fileprivate extension TabsController {
  /// Prepares the view controller at the selectedIndex.
  func prepareSelectedIndexViewController() {
    rootViewController = viewControllers[selectedIndex]
  }
  
  /// Prepares the TabBar.
  func prepareTabBar() {
    tabBar._delegate = self
    view.addSubview(tabBar)
    updateTabBarAlignment()
  }
  
  func updateTabBarAlignment() {
    tabBar.lineAlignment = .bottom == tabBarAlignment ? .top : .bottom
    tabBar.dividerAlignment = .bottom == tabBarAlignment ? .top : .bottom
  }
  
  /// Prepares the `tabBar.tabItems`.
  func prepareTabItems() {
    var tabItems = [TabItem]()
    
    for v in viewControllers {
      // Expectation that viewDidLoad() triggers update of tabItem:
      if #available(iOS 9.0, *) {
        v.loadViewIfNeeded()
        
      } else {
        _ = v.view
      }
      
      tabItems.append(v.tabItem)
    }
    
    tabBar.tabItems = tabItems
    tabBar.selectedTabItem = tabItems[selectedIndex]
  }
}

private extension TabsController {
  /**
   A target method contolling interactive swipe transition based on
   gesture recognizer.
   - Parameter _ gesture: A UIPanGestureRecognizer.
   */
  @objc
  func handleTransitionPan(_ gesture: UIPanGestureRecognizer) {
    let translationX = gesture.translation(in: nil).x
    let velocityX = gesture.velocity(in: nil).x
    
    switch gesture.state {
    case .began, .changed:
      let isSlidingLeft = targetIndex == -1 ? velocityX < 0 : translationX < 0
      let nextIndex = selectedIndex + (isSlidingLeft ? 1 : -1)
      
      guard nextIndex >= 0, nextIndex < viewControllers.count else {
        return
      }
      
      if targetIndex != nextIndex {
        /// 5 point threshold
        guard abs(translationX) > 5 else {
          return
        }
        
        if targetIndex != -1 {
          delegate?.tabsController?(tabsController: self, willCancelSelecting: viewControllers[targetIndex])
          tabBar.cancelLineTransition(isAnimated: false)
          MotionTransition.shared.cancel(isAnimated: false)
        }
        
        if internalSelect(at: nextIndex, isTriggeredByUserInteraction: true, selectTabItem: false)  {
          tabBar.startLineTransition(for: nextIndex, duration: 0.35)
          targetIndex = nextIndex
        }
      } else {
        let progress = abs(translationX / view.bounds.width)
        tabBar.updateLineTransition(progress)
        MotionTransition.shared.update(Double(progress))
      }
      
    default:
      guard targetIndex != -1 else {
        return
      }
      
      let progress = (translationX + velocityX) / view.bounds.width
      
      let isUserHandDirectionLeft = progress < 0
      let isTargetHandDirectionLeft = targetIndex > selectedIndex
      
      if isUserHandDirectionLeft == isTargetHandDirectionLeft && abs(progress) > 0.5 {
        tabBar.finishLineTransition()
        MotionTransition.shared.finish()
      } else {
        tabBar.cancelLineTransition()
        MotionTransition.shared.cancel()
        delegate?.tabsController?(tabsController: self, willCancelSelecting: viewControllers[targetIndex])
      }
      targetIndex = -1
    }
  }
  
  /// Prepares interactiveSwipeGesture.
  func prepareSwipeGesture() {
    guard nil == interactiveSwipeGesture else {
      return
    }
    
    interactiveSwipeGesture = UIPanGestureRecognizer(target: self, action: #selector(handleTransitionPan))
    container.addGestureRecognizer(interactiveSwipeGesture!)
  }
  
  /// Removes interactiveSwipeGesture.
  func removeSwipeGesture() {
    guard let v = interactiveSwipeGesture else {
      return
    }
    
    container.removeGestureRecognizer(v)
    interactiveSwipeGesture = nil
  }
}

fileprivate extension TabsController {
  /// Layout the container.
  func layoutContainer() {
    switch displayStyle {
    case .partial:
      let p = tabBar.bounds.height
      let y = view.bounds.height - p
      
      switch tabBarAlignment {
      case .top:
        container.frame.origin.y = p
        container.frame.size.height = y
        
      case .bottom:
        container.frame.origin.y = 0
        container.frame.size.height = y
      }
      
      container.frame.size.width = view.bounds.width
      
    case .full:
      container.frame = view.bounds
    }
  }
  
  /// Layout the tabBar.
  func layoutTabBar() {
    if #available(iOS 11, *) {
      if .bottom == tabBarAlignment {
        let v = bottomLayoutGuide.length
        
        if 0 < v {
          tabBar.heightPreset = { tabBar.heightPreset }()
          tabBar.frame.size.height += v
          tabBar.grid.layoutEdgeInsets.bottom = v
        }
      }
    }
    
    tabBar.frame.origin.x = 0
    tabBar.frame.origin.y = .top == tabBarAlignment ? 0 : view.bounds.height - tabBar.bounds.height
    tabBar.frame.size.width = view.bounds.width
  }
  
  /// Layout the rootViewController.
  func layoutRootViewController() {
    rootViewController.view.frame = container.bounds
  }
}

extension TabsController {
  /**
   Transitions to the view controller that is at the given index.
   - Parameter at index: An Int.
   */
  open func select(at index: Int) {
    internalSelect(at: index, isTriggeredByUserInteraction: false, selectTabItem: true)
  }
  
  /**
   Transitions to the view controller that is at the given index.
   - Parameter at index: An Int.
   - Parameter isTriggeredByUserInteraction: A boolean indicating whether the
   state was changed by a user interaction, true if yes, false otherwise.
   - Returns: A boolean indicating whether the transition will take place.
   */
  @discardableResult
  private func internalSelect(at index: Int, isTriggeredByUserInteraction: Bool, selectTabItem: Bool) -> Bool {
    guard index != selectedIndex else {
      return false
    }
    
    if isTriggeredByUserInteraction {
      guard !(false == delegate?.tabsController?(tabsController: self, shouldSelect: viewControllers[index])) else {
        return false
      }
    }
    
    if selectTabItem {
      tabBar.select(at: index)
    }
    
    transition(to: viewControllers[index], isTriggeredByUserInteraction: isTriggeredByUserInteraction) { [weak self] (isFinishing) in
      guard isFinishing else {
        return
      }
      
      self?.selectedIndex = index
      self?.tabBar.selectedTabItem = self?.tabBar.tabItems[index]
    }
    
    return true
  }
}

extension TabsController: _TabBarDelegate {
  @objc
  func _tabBar(tabBar: TabBar, shouldSelect tabItem: TabItem) -> Bool {
    guard let i = tabBar.tabItems.firstIndex(of: tabItem) else {
      return false
    }
    
    return internalSelect(at: i, isTriggeredByUserInteraction: true, selectTabItem: false)
  }
}
