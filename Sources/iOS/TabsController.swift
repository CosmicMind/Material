/*
 * Copyright (C) 2015 - 2017, Daniel Dahan and CosmicMind, Inc. <http://cosmicmind.com>.
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

fileprivate var TabItemKey: UInt8 = 0

@objc(TabBarAlignment)
public enum TabBarAlignment: Int {
  case top
  case bottom
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
  open let tabBar = TabBar()
  
  
  /// A Boolean that indicates if the swipe feature is enabled..
  open var isSwipeEnabled = false {
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
      layoutSubviews()
    }
  }
  
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
  
  open override func viewWillLayoutSubviews() {
    super.viewWillLayoutSubviews()
    layoutSubviews()
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
  }
  
  open override func transition(to viewController: UIViewController, completion: ((Bool) -> Void)?) {
    transition(to: viewController, isTriggeredByUserInteraction: false, completion: completion)
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
    guard let fvcIndex = viewControllers.index(of: rootViewController) else {
      return
    }
    
    guard let tvcIndex = viewControllers.index(of: viewController) else {
      return
    }
    
    var isAuto = false
    
    switch motionTransitionType {
    case .auto:
      switch viewController.motionTransitionType {
      case .auto:
        isAuto = true
        MotionTransition.shared.setAnimationForNextTransition(fvcIndex < tvcIndex ? .slide(direction: .left) : .slide(direction: .right))
      default:break
      }
    default:break
    }
    
    if isTriggeredByUserInteraction {
      delegate?.tabsController?(tabsController: self, willSelect: viewController)
    }
    
    super.transition(to: viewController) { [weak self, viewController = viewController, completion = completion] (isFinishing) in
      guard let s = self else {
        return
      }
      
      if isAuto {
        MotionTransition.shared.setAnimationForNextTransition(.auto)
      }
      
      completion?(isFinishing)
      
      if isTriggeredByUserInteraction {
        s.delegate?.tabsController?(tabsController: s, didSelect: viewController)
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
    tabBar.lineAlignment = .bottom == tabBarAlignment ? .top : .bottom
    tabBar._delegate = self
    tabBar.delegate = self
    view.addSubview(tabBar)
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
  
  /// Prepare Swipe Gesture.
  func prepareSwipeGesture() {
    removeSwipeGesture()
    
    let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipeGesture(gesture:)))
    swipeRight.direction = .right
    view.addGestureRecognizer(swipeRight)
    
    let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipeGesture(gesture:)))
    swipeLeft.direction = .left
    view.addGestureRecognizer(swipeLeft)
  }
}

fileprivate extension TabsController {
  /// Remove Swipe Gesture.
  func removeSwipeGesture() {
    guard let v = view.gestureRecognizers else {
      return
    }
    
    for gesture in v {
      guard let recognizer = gesture as? UISwipeGestureRecognizer else {
        continue
      }
      
      if .left == recognizer.direction || .right == recognizer.direction {
        view.removeGestureRecognizer(recognizer)
      }
    }
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

fileprivate extension TabsController {
  /**
   Handles the swipe gesture.
   - Parameter gesture: A UIGestureRecognizer.
   */
  @objc
  func handleSwipeGesture(gesture: UIGestureRecognizer) {
    if let swipeGesture = gesture as? UISwipeGestureRecognizer {
      switch swipeGesture.direction {
      case .right:
        guard (selectedIndex - 1) >= 0 else { return }
        select(at: selectedIndex - 1)
      case .left:
        guard (selectedIndex + 1) < viewControllers.count else { return }
        select(at: selectedIndex + 1)
      default:
        break
      }
    }
  }
}

extension TabsController {
  /**
   Transitions to the view controller that is at the given index.
   - Parameter at index: An Int.
   */
  open func select(at index: Int) {
    guard index != selectedIndex else {
      return
    }
    
    Motion.async { [weak self] in
      guard let s = self else {
        return
      }
      
      s.tabBar.select(at: index)
      
      s.transition(to: s.viewControllers[index], isTriggeredByUserInteraction: false) { [weak self] (isFinishing) in
        guard isFinishing else {
          return
        }
        
        self?.selectedIndex = index
      }
    }
  }
}

extension TabsController: TabBarDelegate, _TabBarDelegate {
  @objc
  func _tabBar(tabBar: TabBar, willSelect tabItem: TabItem) {
    guard !(false == tabBar.delegate?.tabBar?(tabBar: tabBar, shouldSelect: tabItem)) else {
      return
    }
    
    guard let i = tabBar.tabItems.index(of: tabItem) else {
      return
    }
    
    guard i != selectedIndex else {
      return
    }
    
    guard !(false == delegate?.tabsController?(tabsController: self, shouldSelect: viewControllers[i])) else {
      return
    }
    
    transition(to: viewControllers[i], isTriggeredByUserInteraction: true) { [weak self] (isFinishing) in
      guard isFinishing else {
        return
      }
      
      self?.selectedIndex = i
    }
  }
}
