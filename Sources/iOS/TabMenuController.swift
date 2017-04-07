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

/// A memory reference to the TabMenuBarItem instance for UIViewController extensions.
fileprivate var TabMenuBarItemKey: UInt8 = 0

open class TabMenuBarItem: FlatButton {
    open override func prepare() {
        super.prepare()
        pulseAnimation = .none
    }
}

@objc(TabMenuAlignment)
public enum TabMenuAlignment: Int {
    case top
    case bottom
}

extension UIViewController {
    /// tabMenuBarItem reference.
    public private(set) var tabMenuBarItem: TabMenuBarItem {
        get {
            return AssociatedObject(base: self, key: &TabMenuBarItemKey) {
                return TabMenuBarItem()
            }
        }
        set(value) {
            AssociateObject(base: self, key: &TabMenuBarItemKey, value: value)
        }
    }
}

extension UIViewController {
    /**
     A convenience property that provides access to the TabMenuController.
     This is the recommended method of accessing the TabMenuController
     through child UIViewControllers.
     */
    public var tabMenuBarController: TabMenuController? {
        var viewController: UIViewController? = self
        while nil != viewController {
            if viewController is TabMenuController {
                return viewController as? TabMenuController
            }
            viewController = viewController?.parent
        }
        return nil
    }
}

open class TabMenuController: UIViewController {
    @IBInspectable
    open let tabBar = TabBar()
    
    open var viewControllers: [UIViewController] {
        didSet {
            oldValue.forEach {
                $0.willMove(toParentViewController: nil)
                $0.view.removeFromSuperview()
                $0.removeFromParentViewController()
            }
            
            prepareViewControllers()
            layoutSubviews()
        }
    }
    
    @IBInspectable
    open var selectedIndex: Int {
        didSet {
            scrollView.setContentOffset(CGPoint(x: scrollView.width * CGFloat(selectedIndex), y: 0), animated: true)
        }
    }
    
    @IBInspectable
    open let scrollView = UIScrollView()
    
    /**
     An initializer that initializes the object with a NSCoder object.
     - Parameter aDecoder: A NSCoder instance.
     */
    public required init?(coder aDecoder: NSCoder) {
        viewControllers = []
        selectedIndex = 0
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
        prepareTabBar()
        prepareScrollView()
        prepareViewControllers()
    }
}

extension TabMenuController {
    fileprivate func prepareTabBar() {
        tabBar.isLineAnimated = false
        tabBar.lineAlignment = .top
    }
    
    fileprivate func prepareScrollView() {
        scrollView.delegate = self
        scrollView.bounces = false
        scrollView.isPagingEnabled = true
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        view.addSubview(scrollView)
    }
    
    fileprivate func prepareViewControllers() {
        for v in viewControllers {
            addChildViewController(v)
            scrollView.addSubview(v.view)
            v.didMove(toParentViewController: self)
            v.view.clipsToBounds = true
            v.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            v.view.contentScaleFactor = Screen.scale
        }
    }
}

extension TabMenuController {
    fileprivate func layoutScrollView() {
        scrollView.frame = view.bounds
        scrollView.contentSize = CGSize(width: scrollView.width * CGFloat(viewControllers.count), height: scrollView.height)
        print(selectedIndex)
        scrollView.contentOffset = CGPoint(x: scrollView.width * CGFloat(selectedIndex), y: 0)
    }
    
    fileprivate func layoutViewControllers() {
        for i in 0..<viewControllers.count {
            let v = viewControllers[i]
            v.view.frame = CGRect(x: CGFloat(i) * scrollView.width, y: 0, width: scrollView.width, height: scrollView.height)
        }
    }
}

extension TabMenuController: UIScrollViewDelegate {
    @objc
    open func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        selectedIndex = lround(Double(scrollView.contentOffset.x / scrollView.width))
    }
}
