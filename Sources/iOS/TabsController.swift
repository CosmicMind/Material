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

fileprivate var TabItemKey: UInt8 = 0

@objc(TabBarAlignment)
public enum TabBarAlignment: Int {
    case top
    case bottom
}

extension UIViewController {
    /// tabItem reference.
    public private(set) var tabItem: TabItem {
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
    
    /// An Array of UIViewControllers.
    open var viewControllers: [UIViewController] {
        didSet {
            selectedIndex = 0
            
            prepareRootViewController()
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
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        prepare()
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
        
        prepareViewControllers()
        prepareTabBar()
        prepareTabBarItems()
    }
}

internal extension TabsController {
    override func prepareRootViewController() {
        rootViewController = viewControllers[selectedIndex]
    }
}


fileprivate extension TabsController {
    /// Prepares all the view controllers.
    func prepareViewControllers() {
        for i in 0..<viewControllers.count {
            guard i != selectedIndex else {
                continue
            }
            
            viewControllers[i].view.isHidden = true
            prepareViewController(at: i)
        }
        
        prepareViewController(at: selectedIndex)
        prepareRootViewController()
    }
    
    /**
     Loads a view controller based on its index in the viewControllers Array
     and adds it as a child view controller.
     - Parameter at index: An Int for the viewControllers index.
     */
    func prepareViewController(at index: Int) {
        let v = viewControllers[index]
        
        guard !childViewControllers.contains(v) else {
            return
        }
        
        prepare(viewController: v, in: container)
    }
    
    /// Prepares the TabBar.
    func prepareTabBar() {
        tabBar.lineAlignment = .bottom == tabBarAlignment ? .top : .bottom
        view.addSubview(tabBar)
    }
    
    /// Prepares the `tabBar.tabItems`.
    func prepareTabBarItems() {
        var tabItems = [TabItem]()
        
        for v in viewControllers {
            let b = v.tabItem
            b.removeTarget(self, action: #selector(handle(tabItem:)), for: .touchUpInside)
            b.addTarget(self, action: #selector(handle(tabItem:)), for: .touchUpInside)
            tabItems.append(b)
        }
        
        tabBar.tabItems = tabItems
    }
}

fileprivate extension TabsController {
    /// Layout the container.
    func layoutContainer() {
        switch displayStyle {
        case .partial:
            let p = tabBar.height
            let y = view.height - p
            
            switch tabBarAlignment {
            case .top:
                container.y = p
                container.height = y
            case .bottom:
                container.y = 0
                container.height = y
            }
         
            container.width = view.width
            
        case .full:
            container.frame = view.bounds
        }
    }
    
    /// Layout the tabBar.
    func layoutTabBar() {
        tabBar.x = 0
        tabBar.y = .top == tabBarAlignment ? 0 : view.height - tabBar.height
        tabBar.width = view.width
    }
    
    /// Layout the rootViewController.
    func layoutRootViewController() {
        rootViewController.view.frame = container.bounds
    }
}

fileprivate extension TabsController {
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

fileprivate extension TabsController {
    /**
     Handles the tabItem.
     - Parameter tabItem: A TabItem.
     */
    @objc
    func handle(tabItem: TabItem) {
        guard let i = tabBar.tabItems.index(of: tabItem) else {
            return
        }
        
        guard i != selectedIndex else {
            return
        }
        
        transition(to: viewControllers[i]) { [weak self] (isFinished) in
            guard isFinished else {
                return
            }
            
            self?.selectedIndex = i
        }
    }
}
