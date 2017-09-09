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

open class TabItem: FlatButton {
    open override func prepare() {
        super.prepare()
        pulseAnimation = .none
    }
}

@objc(TabBarLineAlignment)
public enum TabBarLineAlignment: Int {
	case top
	case bottom
}

@objc(TabBarDelegate)
public protocol TabBarDelegate {
    /**
     A delegation method that is executed to determine if the TabBar should
     transition to the next tab.
     - Parameter tabBar: A TabBar.
     - Parameter tabItem: A TabItem.
     - Returns: A Boolean.
     */
    @objc
    optional func tabBar(tabBar: TabBar, shouldSelect tabItem: TabItem) -> Bool
    
    /**
     A delegation method that is executed when the tabItem will trigger the
     animation to the next tab.
     - Parameter tabBar: A TabBar.
     - Parameter tabItem: A TabItem.
     */
    @objc
    optional func tabBar(tabBar: TabBar, willSelect tabItem: TabItem)
    
    /**
     A delegation method that is executed when the tabItem did complete the
     animation to the next tab.
     - Parameter tabBar: A TabBar.
     - Parameter tabItem: A TabItem.
     */
    @objc
    optional func tabBar(tabBar: TabBar, didSelect tabItem: TabItem)
}

@objc(TabBarStyle)
public enum TabBarStyle: Int {
    case auto
    case nonScrollable
    case scrollable
}

open class TabBar: Bar {
    /// Only for inital load to get the line animation correct.
    fileprivate var shouldNotAnimateLineView = false
    
    /// The total width of the tabItems.
    fileprivate var tabItemsTotalWidth: CGFloat {
        var w: CGFloat = 0
        let q = 2 * tabItemsInterimSpace
        let p = q + tabItemsInterimSpace
        
        for v in tabItems {
            let x = v.sizeThatFits(CGSize(width: .greatestFiniteMagnitude, height: scrollView.height)).width
            w += x
            w += p
        }
        
        w -= tabItemsInterimSpace
        
        return w
    }
    
    /// An enum that determines the tab bar style.
    open var tabBarStyle = TabBarStyle.auto {
        didSet {
            layoutSubviews()
        }
    }
    
    /// A reference to the scroll view when the tab bar style is scrollable.
    open let scrollView = UIScrollView()
    
    /// Enables and disables bouncing when swiping.
    open var isScrollBounceEnabled: Bool {
        get {
            return scrollView.bounces
        }
        set(value) {
            scrollView.bounces = value
        }
    }
    
    /// A delegation reference.
    open weak var delegate: TabBarDelegate?
    
    /// The currently selected tabItem.
    open internal(set) var selectedTabItem: TabItem?
    
    /// A preset wrapper around tabItems contentEdgeInsets.
    open var tabItemsContentEdgeInsetsPreset: EdgeInsetsPreset {
        get {
            return contentView.grid.contentEdgeInsetsPreset
        }
        set(value) {
            contentView.grid.contentEdgeInsetsPreset = value
        }
    }
    
    /// A reference to EdgeInsets.
    @IBInspectable
    open var tabItemsContentEdgeInsets: EdgeInsets {
        get {
            return contentView.grid.contentEdgeInsets
        }
        set(value) {
            contentView.grid.contentEdgeInsets = value
        }
    }
    
    /// A preset wrapper around tabItems interimSpace.
    open var tabItemsInterimSpacePreset: InterimSpacePreset {
        get {
            return contentView.grid.interimSpacePreset
        }
        set(value) {
            contentView.grid.interimSpacePreset = value
        }
    }
    
    /// A wrapper around tabItems interimSpace.
    @IBInspectable
    open var tabItemsInterimSpace: InterimSpace {
        get {
            return contentView.grid.interimSpace
        }
        set(value) {
            contentView.grid.interimSpace = value
        }
    }
    
	/// TabItems.
	open var tabItems = [TabItem]() {
		didSet {
			for b in oldValue {
                b.removeFromSuperview()
            }
			
            prepareTabItems()
			layoutSubviews()
		}
	}
    
    /// A reference to the line UIView.
    open let line = UIView()
    
    /// The line color.
    open var lineColor: UIColor? {
        get {
            return line.backgroundColor
        }
        set(value) {
            line.backgroundColor = value
        }
    }
    
    /// A value for the line alignment.
    open var lineAlignment = TabBarLineAlignment.bottom {
        didSet {
            layoutSubviews()
        }
    }
    
    /// The line height.
    open var lineHeight: CGFloat {
        get {
            return line.height
        }
        set(value) {
            line.height = value
        }
    }
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        guard willLayout else {
            return
        }
        
        layoutScrollView()
        layoutLine()
        
        updateScrollView()
	}
    
    open override func prepare() {
        super.prepare()
        contentEdgeInsetsPreset = .none
        interimSpacePreset = .interimSpace6
        tabItemsInterimSpacePreset = .interimSpace4
        
        prepareContentView()
        prepareScrollView()
        prepareDivider()
        prepareLine()
    }
}

fileprivate extension TabBar {
    // Prepares the line.
    func prepareLine() {
        line.zPosition = 10000
        lineColor = Color.blue.base
        lineHeight = 3
        scrollView.addSubview(line)
    }
    
    /// Prepares the divider.
    func prepareDivider() {
        dividerColor = Color.grey.lighten2
        dividerAlignment = .top
    }
    
    /// Prepares the tabItems.
    func prepareTabItems() {
        shouldNotAnimateLineView = true
        
        for v in tabItems {
            v.grid.columns = 0
            v.contentEdgeInsets = .zero
            
            prepareLineAnimationHandler(tabItem: v)
        }
        
        selectedTabItem = tabItems.first
    }
    
    /**
     Prepares the line animation handlers.
     - Parameter tabItem: A TabItem.
     */
    func prepareLineAnimationHandler(tabItem: TabItem) {
        removeLineAnimationHandler(tabItem: tabItem)
        tabItem.addTarget(self, action: #selector(handleLineAnimation(tabItem:)), for: .touchUpInside)
    }
    
    /// Prepares the contentView.
    func prepareContentView() {
        contentView.zPosition = 6000
    }
    
    /// Prepares the scroll view. 
    func prepareScrollView() {
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        centerViews = [scrollView]
    }
}

fileprivate extension TabBar {
    /// Layout the scrollView.
    func layoutScrollView() {
        contentView.grid.reload()
        
        if .scrollable == tabBarStyle || (.auto == tabBarStyle && tabItemsTotalWidth > scrollView.width) {
            var w: CGFloat = 0
            let q = 2 * tabItemsInterimSpace
            let p = q + tabItemsInterimSpace
            
            for v in tabItems {
                let x = v.sizeThatFits(CGSize(width: .greatestFiniteMagnitude, height: scrollView.height)).width
                v.height = scrollView.height
                v.width = x + q
                v.x = w
                w += x
                w += p
                
                if scrollView != v.superview {
                    v.removeFromSuperview()
                    scrollView.addSubview(v)
                }
            }
            
            w -= tabItemsInterimSpace
            
            scrollView.contentSize = CGSize(width: w, height: scrollView.height)
            
        } else {
            scrollView.grid.begin()
            scrollView.grid.views = tabItems
            scrollView.grid.axis.columns = tabItems.count
            scrollView.grid.contentEdgeInsets = tabItemsContentEdgeInsets
            scrollView.grid.interimSpace = tabItemsInterimSpace
            scrollView.grid.commit()
            scrollView.contentSize = scrollView.frame.size
        }
    }
    
    /// Layout the line view.
    func layoutLine() {
        guard let v = selectedTabItem else {
            return
        }
        
        guard shouldNotAnimateLineView else {
            line.animate(.duration(0),
                         .size(CGSize(width: v.width, height: lineHeight)),
                         .position(CGPoint(x: v.center.x, y: .bottom == lineAlignment ? height - lineHeight / 2 : lineHeight / 2)))
            return
        }
        
        line.frame = CGRect(x: v.x, y: .bottom == lineAlignment ? scrollView.height - lineHeight : 0, width: v.width, height: lineHeight)
        
        shouldNotAnimateLineView = false
    }
}

fileprivate extension TabBar {
    /**
     Removes the line animation handlers.
     - Parameter tabItem: A TabItem.
     */
    func removeLineAnimationHandler(tabItem: TabItem) {
        tabItem.removeTarget(self, action: #selector(handleLineAnimation(tabItem:)), for: .touchUpInside)
    }
}

fileprivate extension TabBar {
    /// Handles the tabItem touch event.
    @objc
    func handleLineAnimation(tabItem: TabItem) {
        guard !(false == delegate?.tabBar?(tabBar: self, shouldSelect: tabItem)) else {
            return
        }
        
        animate(to: tabItem, isTriggeredByUserInteraction: true)
    }
}

extension TabBar {
    /**
     Selects a given index from the tabItems array.
     - Parameter at index: An Int.
     - Paramater completion: An optional completion block.
     */
    open func select(at index: Int, completion: ((TabItem) -> Void)? = nil) {
        guard -1 < index, index < tabItems.count else {
            return
        }
        
        animate(to: tabItems[index], isTriggeredByUserInteraction: false, completion: completion)
    }
    
    /**
     Animates to a given tabItem.
     - Parameter to tabItem: A TabItem.
     - Parameter completion: An optional completion block.
     */
    open func animate(to tabItem: TabItem, completion: ((TabItem) -> Void)? = nil) {
        animate(to: tabItem, isTriggeredByUserInteraction: false, completion: completion)
    }
}

fileprivate extension TabBar {
    /**
     Animates to a given tabItem.
     - Parameter to tabItem: A TabItem.
     - Parameter isTriggeredByUserInteraction: A boolean indicating whether the
     state was changed by a user interaction, true if yes, false otherwise.
     - Parameter completion: An optional completion block.
     */
    func animate(to tabItem: TabItem, isTriggeredByUserInteraction: Bool, completion: ((TabItem) -> Void)? = nil) {
        if isTriggeredByUserInteraction {
            delegate?.tabBar?(tabBar: self, willSelect: tabItem)
        }
        
        selectedTabItem = tabItem
        
        line.animate(.duration(0.25),
                     .size(CGSize(width: tabItem.width, height: lineHeight)),
                     .position(CGPoint(x: tabItem.center.x, y: .bottom == lineAlignment ? height - lineHeight / 2 : lineHeight / 2)),
                     .completion { [weak self, isTriggeredByUserInteraction = isTriggeredByUserInteraction, tabItem = tabItem, completion = completion] _ in
                        guard let s = self else {
                            return
                        }
        
                        if isTriggeredByUserInteraction {
                            s.delegate?.tabBar?(tabBar: s, didSelect: tabItem)
                        }
                        
                        completion?(tabItem)
                     })
        
        updateScrollView()
    }
}

fileprivate extension TabBar {
    /// Updates the scrollView.
    func updateScrollView() {
        guard let v = selectedTabItem else {
            return
        }
        
        if !scrollView.bounds.contains(v.frame) {
            let contentOffsetX = (v.x < scrollView.bounds.minX) ? v.x : v.frame.maxX - scrollView.bounds.width
            let normalizedOffsetX = min(max(contentOffsetX, 0), scrollView.contentSize.width - scrollView.bounds.width)
            scrollView.setContentOffset(CGPoint(x: normalizedOffsetX, y: 0), animated: true)
        }
    }
}
