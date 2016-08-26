/*
 * Copyright (C) 2015 - 2016, Daniel Dahan and CosmicMind, Inc. <http://cosmicmind.io>.
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

/// A memory reference to the PageTabBarItem instance for UIViewController extensions.
private var PageTabBarItemKey: UInt8 = 0

open class PageTabBarItem: FlatButton {
    override open func prepareView() {
        super.prepareView()
        pulseAnimation = .none
    }
}

/// Grid extension for UIView.
extension UIViewController {
    /// Grid reference.
    public private(set) var pageTabBarItem: PageTabBarItem {
        get {
            return AssociatedObject(base: self, key: &PageTabBarItemKey) {
                return PageTabBarItem()
            }
        }
        set(value) {
            AssociateObject(base: self, key: &PageTabBarItemKey, value: value)
        }
    }
}

extension UIViewController {
    /**
     A convenience property that provides access to the PageController.
     This is the recommended method of accessing the PageController
     through child UIViewControllers.
     */
    public var pageController: PageController? {
        var viewController: UIViewController? = self
        while nil != viewController {
            if viewController is PageController {
                return viewController as? PageController
            }
            viewController = viewController?.parent
        }
        return nil
    }
}

@objc(PageControllerDelegate)
public protocol PageControllerDelegate {

}

@objc(PageController)
open class PageController: RootController {
    /// The currently selected UIViewController.
    open internal(set) var selectedIndex: Int = 0
    
    /// Reference to the TabBar.
    open internal(set) var tabBar: TabBar!
    
    /// Delegation handler.
    public weak var delegate: PageControllerDelegate?
    
    /// A reference to the instance when it is a UIPageViewController.
    open var pageViewController: UIPageViewController? {
        return rootViewController as? UIPageViewController
    }
    
    /// A reference to the UIViewControllers.
    open var viewControllers = [UIViewController]()
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    public override init(rootViewController: UIViewController) {
        super.init(rootViewController: UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil))
        viewControllers.append(rootViewController)
        setViewControllers(viewControllers, direction: .forward, animated: true, completion: nil)
    }
    
    public init(viewControllers: [UIViewController], selectedIndex: Int, direction: UIPageViewControllerNavigationDirection, animated: Bool) {
        super.init(rootViewController: UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil))
        self.selectedIndex = selectedIndex
        self.viewControllers.append(contentsOf: viewControllers)
        setViewControllers([self.viewControllers[selectedIndex]], direction: direction, animated: animated, completion: nil)
    }
    
    /**
     To execute in the order of the layout chain, override this
     method. LayoutSubviews should be called immediately, unless you
     have a certain need.
     */
    open override func layoutSubviews() {
        super.layoutSubviews()
        guard let v = tabBar else {
            return
        }
        
        let h = view.height
        let w = view.width
        let p = v.intrinsicContentSize.height + v.grid.layoutEdgeInsets.top + v.grid.layoutEdgeInsets.bottom
        let y = h - p
        
        v.y = y
        v.width = w + v.grid.layoutEdgeInsets.left + v.grid.layoutEdgeInsets.right
        v.height = p
        
        rootViewController.view.y = 0
        rootViewController.view.height = y
        
        v.divider.reload()
    }
    
    /**
     Prepares the view instance when intialized. When subclassing,
     it is recommended to override the prepareView method
     to initialize property values and other setup operations.
     The super.prepareView method should always be called immediately
     when subclassing.
     */
    open override func prepareView() {
        super.prepareView()
        prepareTabBar()
    }
    
    override func prepareRootViewController() {
        super.prepareRootViewController()
        
        guard let v = pageViewController else {
            return
        }
        
        v.delegate = self
        v.dataSource = self
        v.isDoubleSided = false
        
        for view in v.view.subviews {
            if view.isKind(of: UIScrollView.self) {
                (view as? UIScrollView)?.delegate = self
            }
        }
    }
    
    /// Prepares the pageTabBarItems.
    open func preparePageTabBarItems() {
        tabBar.buttons.removeAll()
        for x in viewControllers {
            tabBar.buttons.append(x.pageTabBarItem as UIButton)
        }
    }
    
    /// Prepares the tabBar.
    private func prepareTabBar() {
        if nil == tabBar {
            tabBar = TabBar()
            tabBar.zPosition = 1000
            view.addSubview(tabBar)
            tabBar.select(at: selectedIndex)
        }
    }
}

extension PageController {
    open func setViewControllers(_ viewControllers: [UIViewController]?, direction: UIPageViewControllerNavigationDirection, animated: Bool, completion: (@escaping (Bool) -> Void)? = nil) {
        pageViewController?.setViewControllers(viewControllers, direction: direction, animated: animated, completion: completion)
        preparePageTabBarItems()
    }
}

extension PageController: UIPageViewControllerDelegate {
    public func pageViewController(_ pageViewController: UIPageViewController, willTransitionTo pendingViewControllers: [UIViewController]) {
        guard let vc = pendingViewControllers.first else {
            return
        }
        
        guard let index = viewControllers.index(of: vc) else {
            return
        }
        
        selectedIndex = index
    }
    
    public func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        
        guard completed else {
            return
        }
        
        guard let vc = previousViewControllers.first else {
            return
        }
        
        guard let _ = viewControllers.index(of: vc) else {
            return
        }
        
        tabBar.select(at: selectedIndex)
    }
}

extension PageController: UIPageViewControllerDataSource {
    public func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let current = viewControllers.index(of: viewController) else {
            return nil
        }
        
        let previous = current - 1
        
        guard previous >= 0, viewControllers.count > previous else {
            return nil
        }
        
        return viewControllers[previous]
    }
    
    public func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let current = viewControllers.index(of: viewController) else {
            return nil
        }
        
        let next = current + 1
        let count = viewControllers.count
        
        guard count != next, count > next else {
            return nil
        }
        
        return viewControllers[next]
    }
}

extension PageController: UIScrollViewDelegate {
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard 0 < view.width else {
            return
        }
        
        guard let selected = tabBar.selected else {
            return
        }
        
        let x = (scrollView.contentOffset.x - view.width) / scrollView.contentSize.width * view.width
        
        tabBar.line.x = selected.x + x
    }
}
