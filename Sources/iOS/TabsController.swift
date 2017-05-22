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

/// A memory reference to the TabsBarItem instance for UIViewController extensions.
fileprivate var TabsBarItemKey: UInt8 = 0

open class TabsBarItem: FlatButton {
    open override func prepare() {
        super.prepare()
        pulseAnimation = .none
    }
}

@objc(TabBarAlignment)
public enum TabBarAlignment: Int {
    case top
    case bottom
    case hidden
}

extension UIViewController {
    /// pageMenuBarItem reference.
    public private(set) var pageMenuBarItem: TabsBarItem {
        get {
            return AssociatedObject(base: self, key: &TabsBarItemKey) {
                return TabsBarItem()
            }
        }
        set(value) {
            AssociateObject(base: self, key: &TabsBarItemKey, value: value)
        }
    }
}

extension UIViewController {
    /**
     A convenience property that provides access to the TabsController.
     This is the recommended method of accessing the TabsController
     through child UIViewControllers.
     */
    public var pageMenuController: TabsController? {
        var viewController: UIViewController? = self
        while nil != viewController {
            if viewController is TabsController {
                return viewController as? TabsController
            }
            viewController = viewController?.parent
        }
        return nil
    }
}

open class TabsController: UIViewController {
    /// A reference to the currently selected view controller index value.
    @IBInspectable
    open var selectedIndex = 0
    
    /// Enables and disables bouncing when swiping.
    open var isBounceEnabled: Bool {
        get {
            return scrollView.bounces
        }
        set(value) {
            scrollView.bounces = value
        }
    }
    
    /// The TabBar used to switch between view controllers.
    @IBInspectable
    open fileprivate(set) var tabBar: TabBar?
    
    /// The UIScrollView used to pan the application pages.
    @IBInspectable
    open let scrollView = UIScrollView()
    
    /// An Array of UIViewControllers.
    open var viewControllers: [UIViewController] {
        didSet {
            oldValue.forEach { [weak self] in
                self?.removeViewController(viewController: $0)
            }
            
            prepareViewControllers()
            prepareTabBar()
            layoutSubviews()
        }
    }
    
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
    
    /// Previous scroll view content offset.
    fileprivate var previousContentOffset: CGFloat = 0
    
    /// The number of views used in the scrollViewPool.
    open var viewPoolCount = 3 {
        didSet {
            layoutSubviews()
        }
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
        layoutTabBar()
        layoutScrollView()
        layoutViewControllers()
    }
    
    /**
     Prepares the view instance when intialized. When subclassing,
     it is recommended to override the prepare method
     to initialize property values and other setup operations.
     The super.prepare method should always be called immediately
     when subclassing.
     */
    open func prepare() {
        view.contentScaleFactor = Screen.scale
        prepareScrollView()
        prepareViewControllers()
        prepareTabBar()
    }
}

extension TabsController {
    /// Prepares the scrollView used to pan through view controllers.
    fileprivate func prepareScrollView() {
        scrollView.delegate = self
        scrollView.bounces = false
        scrollView.isPagingEnabled = true
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.contentScaleFactor = Screen.scale
        view.addSubview(scrollView)
    }
    
    /// Prepares the view controllers.
    fileprivate func prepareViewControllers() {
        let n = viewControllers.count
        
        guard 1 < n else {
            if 1 == n {
                prepareViewController(at: 0)
            }
            return
        }
        
        let m = viewPoolCount < n ? viewPoolCount : n
        
        if 0 == selectedIndex {
            for i in 0..<m {
                prepareViewController(at: i)
            }
        } else if n - 1 == selectedIndex {
            for i in 0..<m {
                prepareViewController(at: selectedIndex - i)
            }
        } else {
            prepareViewController(at: selectedIndex)
            prepareViewController(at: selectedIndex - 1)
            prepareViewController(at: selectedIndex + 1)
        }
    }
    
    /**
     Prepares the tabBar buttons.
     - Parameter _ buttons: An Array of UIButtons.
     */
    fileprivate func prepareTabBarButtons(_ buttons: [UIButton]) {
        guard let v = tabBar else {
            return
        }
        
        v.buttons = buttons
        
        for b in v.buttons {
            b.removeTarget(self, action: #selector(handleTabBarButton(button:)), for: .touchUpInside)
            b.addTarget(self, action: #selector(handleTabBarButton(button:)), for: .touchUpInside)
        }
    }
    
    fileprivate func prepareTabBar() {
        var buttons = [UIButton]()
        
        for v in viewControllers {
            let button = v.pageMenuBarItem as UIButton
            buttons.append(button)
        }
        
        guard 0 < buttons.count else {
            tabBar?.removeFromSuperview()
            tabBar = nil
            return
        }
        
        guard nil == tabBar else {
            prepareTabBarButtons(buttons)
            return
        }
        
        tabBar = TabBar()
        tabBar?.isLineAnimated = false
        tabBar?.lineAlignment = .top
        view.addSubview(tabBar!)
        
        prepareTabBarButtons(buttons)
    }
    
    /**
     Loads a view controller based on its index in the viewControllers Array
     and adds it as a child view controller.
     - Parameter at index: An Int for the viewControllers index.
     */
    fileprivate func prepareViewController(at index: Int) {
        let vc = viewControllers[index]
        
        guard !childViewControllers.contains(vc) else {
            return
        }
        
        addChildViewController(vc)
        vc.didMove(toParentViewController: self)
        vc.view.clipsToBounds = true
        vc.view.contentScaleFactor = Screen.scale
        scrollView.addSubview(vc.view)
    }
    
    /**
     Transitions from one view controller to another.
     - Parameter from: The index of the view controller to transition from.
     - Parameter to: The index of the view controller to transition to.
     */
    fileprivate func prepareViewControllersForTransition(from: Int, to: Int) {
        let fromVC = viewControllers[from]
        let toVC = viewControllers[to]
        
        fromVC.present(toVC, animated: true)
    }
}

extension TabsController {
    fileprivate func layoutScrollView() {
        let w = view.bounds.width
        scrollView.contentSize = CGSize(width: w * CGFloat(viewControllers.count), height: scrollView.height)
        scrollView.contentOffset = CGPoint(x: w * CGFloat(selectedIndex), y: 0)
        
        guard let v = tabBar else {
            scrollView.frame = view.bounds
            return
        }
        
        let p = v.height
        let y = view.height - p
        
        switch tabBarAlignment {
        case .top:
            scrollView.y = p
            scrollView.height = y
        case .bottom:
            scrollView.y = 0
            scrollView.height = y
        case .hidden:
            scrollView.y = 0
            scrollView.height = view.height
        }
        
        scrollView.width = w
    }
    
    fileprivate func layoutViewControllers() {
        let n = viewControllers.count
        
        guard 1 < n else {
            layoutViewController(at: 0, position: 0)
            return
        }
        
        let m = viewPoolCount < n ? viewPoolCount : n
        
        if 0 == selectedIndex {
            for i in 0..<m {
                layoutViewController(at: i, position: i)
            }
        } else if n - 1 == selectedIndex {
            var q = 0
            for i in 0..<m {
                q = selectedIndex - i
                layoutViewController(at: q, position: q)
            }
        } else {
            layoutViewController(at: selectedIndex, position: selectedIndex)
            layoutViewController(at: selectedIndex - 1, position: selectedIndex - 1)
            layoutViewController(at: selectedIndex + 1, position: selectedIndex + 1)
        }
    }
    
    /**
     Positions a view controller within the scrollView.
     - Parameter position: An Int for the position of the view controller.
     */
    fileprivate func layoutViewController(at index: Int, position: Int) {
        let w = scrollView.width
        viewControllers[index].view.frame = CGRect(x: CGFloat(position) * w, y: 0, width: w, height: scrollView.height)
    }
    
    /**
     Layout the TabBar.
     */
    fileprivate func layoutTabBar() {
        guard let v = tabBar else {
            return
        }
        
        let p = v.height
        let y = view.height - p
        
        v.width = view.width
        
        switch tabBarAlignment {
        case .top:
            v.isHidden = false
            v.y = 0
        case .bottom:
            v.isHidden = false
            v.y = y
        case .hidden:
            v.isHidden = true
        }
    }
}

extension TabsController {
    /// Removes the view controllers not within the scrollView.
    fileprivate func removeViewControllers() {
        let n = viewControllers.count
        
        guard 1 < n else {
            return
        }
        
        if 0 == selectedIndex {
            for i in 1..<n {
                removeViewController(at: i)
            }
        } else if n - 1 == selectedIndex {
            for i in 0..<n - 2 {
                removeViewController(at: i)
            }
        } else {
            for i in 0..<selectedIndex {
                removeViewController(at: i)
            }
            
            let x = selectedIndex + 1
            
            if x < n {
                for i in x..<n {
                    removeViewController(at: i)
                }
            }
        }
    }
    
    /**
     Removes the view controller as a child view controller with
     the given index.
     - Parameter at index: An Int for the view controller position.
     */
    fileprivate func removeViewController(at index: Int) {
        let v = viewControllers[index]
        
        guard childViewControllers.contains(v) else {
            return
        }
        
        removeViewController(viewController: v)
    }
    
    /**
     Removes a given view controller from the childViewControllers array.
     - Parameter at index: An Int for the view controller position.
     */
    fileprivate func removeViewController(viewController: UIViewController) {
        viewController.willMove(toParentViewController: nil)
        viewController.view.removeFromSuperview()
        viewController.removeFromParentViewController()
    }
}

extension TabsController {
    /**
     Handles the pageTabBarButton.
     - Parameter button: A UIButton.
     */
    @objc
    fileprivate func handleTabBarButton(button: UIButton) {
        guard let v = tabBar else {
            return
        }
        
        guard let i = v.buttons.index(of: button) else {
            return
        }
        
        guard i != selectedIndex else {
            return
        }
        
        selectedIndex = i
        v.select(at: i)
        
        removeViewControllers()
        prepareViewControllers()
        prepareTabBar()
        layoutSubviews()
    }
}

extension TabsController: UIScrollViewDelegate {
    @objc
    open func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let w = scrollView.width
        let p = Int(floor((scrollView.contentOffset.x - w / 2) / w) + 1)
        
        selectedIndex = p
        
        removeViewControllers()
        prepareViewControllers()
        prepareTabBar()
        layoutSubviews()
    }
}
