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
    /// A boolean indicating if the TabBar line is in an animation state.
    open fileprivate(set) var isAnimating = false
    
    /// The total width of the tabItems.
    fileprivate var tabItemsTotalWidth: CGFloat {
        var w: CGFloat = 0
            
        for v in tabItems {
            w += v.sizeThatFits(CGSize(width: CGFloat.greatestFiniteMagnitude, height: contentView.height)).width + interimSpace
        }
            
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
    open fileprivate(set) var selected: TabItem?
    
    /// A preset wrapper around tabItems contentEdgeInsets.
    open var tabItemsContentEdgeInsetsPreset: EdgeInsetsPreset {
        get {
            return scrollView.grid.contentEdgeInsetsPreset
        }
        set(value) {
            scrollView.grid.contentEdgeInsetsPreset = value
        }
    }
    
    /// A reference to EdgeInsets.
    @IBInspectable
    open var tabItemsContentEdgeInsets: EdgeInsets {
        get {
            return scrollView.grid.contentEdgeInsets
        }
        set(value) {
            scrollView.grid.contentEdgeInsets = value
        }
    }
    
    /// A preset wrapper around tabItems interimSpace.
    open var tabItemsInterimSpacePreset: InterimSpacePreset {
        get {
            return scrollView.grid.interimSpacePreset
        }
        set(value) {
            scrollView.grid.interimSpacePreset = value
        }
    }
    
    /// A wrapper around tabItems interimSpace.
    @IBInspectable
    open var tabItemsInterimSpace: InterimSpace {
        get {
            return scrollView.grid.interimSpace
        }
        set(value) {
            scrollView.grid.interimSpace = value
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
    
    /// A boolean to animate the line when touched.
    @IBInspectable
    open var isLineAnimated = true {
        didSet {
            for b in tabItems {
                if isLineAnimated {
                    prepareLineAnimationHandler(tabItem: b)
                } else {
                    removeLineAnimationHandler(tabItem: b)
                }
            }
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
        
        var lc = 0
        var rc = 0
        
        grid.begin()
        grid.views.removeAll()
        
        for v in leftViews {
            if let b = v as? TabItem {
                b.contentEdgeInsets = .zero
                b.titleEdgeInsets = .zero
            }
            
            v.width = v.intrinsicContentSize.width
            v.sizeToFit()
            v.grid.columns = Int(ceil(v.width / gridFactor)) + 2
            
            lc += v.grid.columns
            
            grid.views.append(v)
        }
        
        grid.views.append(contentView)
        
        for v in rightViews {
            if let b = v as? TabItem {
                b.contentEdgeInsets = .zero
                b.titleEdgeInsets = .zero
            }
            
            v.width = v.intrinsicContentSize.width
            v.sizeToFit()
            v.grid.columns = Int(ceil(v.width / gridFactor)) + 2
            
            rc += v.grid.columns
            
            grid.views.append(v)
        }
        
        contentView.grid.begin()
        contentView.grid.offset.columns = 0
        
        var l: CGFloat = 0
        var r: CGFloat = 0
        
        if .center == contentViewAlignment {
            if leftViews.count < rightViews.count {
                r = CGFloat(rightViews.count) * interimSpace
                l = r
            } else {
                l = CGFloat(leftViews.count) * interimSpace
                r = l
            }
        }
        
        let p = width - l - r - contentEdgeInsets.left - contentEdgeInsets.right
        let columns = Int(ceil(p / gridFactor))
        
        if .center == contentViewAlignment {
            if lc < rc {
                contentView.grid.columns = columns - 2 * rc
                contentView.grid.offset.columns = rc - lc
            } else {
                contentView.grid.columns = columns - 2 * lc
                rightViews.first?.grid.offset.columns = lc - rc
            }
        } else {
            contentView.grid.columns = columns - lc - rc
        }
        
        grid.axis.columns = columns
        
        if .scrollable == tabBarStyle || (.auto == tabBarStyle && tabItemsTotalWidth > bounds.width) {
            var w: CGFloat = tabItemsContentEdgeInsets.left
            let q = scrollView.height / 2
            let p = q + tabItemsInterimSpace
            
            for v in tabItems {
                let x = v.sizeThatFits(CGSize(width: CGFloat.greatestFiniteMagnitude, height: scrollView.height)).width
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
            
            w += tabItemsContentEdgeInsets.right - tabItemsInterimSpace
            
            scrollView.contentSize = CGSize(width: w, height: scrollView.height - tabItemsContentEdgeInsets.top - tabItemsContentEdgeInsets.bottom)
        } else {
            scrollView.grid.views = tabItems
            scrollView.grid.axis.columns = tabItems.count
            scrollView.contentSize = CGSize(width: scrollView.width, height: scrollView.height - tabItemsContentEdgeInsets.top - tabItemsContentEdgeInsets.bottom)
        }
        
        grid.commit()
        contentView.grid.commit()
        
        layoutDivider()
        layoutLine()
	}
    
    open override func prepare() {
        super.prepare()
        contentEdgeInsetsPreset = .none
        interimSpacePreset = .interimSpace6
        tabItemsInterimSpacePreset = .none
        
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
    }
    
    /// Prepares the divider.
    func prepareDivider() {
        dividerColor = Color.grey.lighten3
        dividerAlignment = .top
    }
    
    /// Prepares the tabItems.
    func prepareTabItems() {
        for v in tabItems {
            v.grid.columns = 0
            v.cornerRadius = 0
            v.contentEdgeInsets = .zero
            
            if isLineAnimated {
                prepareLineAnimationHandler(tabItem: v)
            }
        }
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
        scrollView.isPagingEnabled = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.addSubview(line)
        centerViews = [scrollView]
    }
}

fileprivate extension TabBar {
    /// Layout the line view.
    func layoutLine() {
        guard 0 < tabItems.count else {
            return
        }
        
        if nil == selected {
            selected = tabItems.first
        }
        
        guard let v = selected else {
            return
        }
        
        line.frame = CGRect(x: v.x, y: .bottom == lineAlignment ? height - lineHeight: 0, width: v.width, height: lineHeight)
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
        
        selected = tabItem
        isAnimating = true
        
        line.animate(.duration(0.25),
                     .size(CGSize(width: tabItem.width, height: lineHeight)),
                     .position(CGPoint(x: tabItem.center.x, y: .bottom == lineAlignment ? height - lineHeight / 2 : lineHeight / 2)),
                     .completion { [weak self, isTriggeredByUserInteraction = isTriggeredByUserInteraction, tabItem = tabItem, completion = completion] _ in
                        guard let s = self else {
                            return
                        }
                        
                        s.isAnimating = false
                        
                        if isTriggeredByUserInteraction {
                            s.delegate?.tabBar?(tabBar: s, didSelect: tabItem)
                        }
                        
                        completion?(tabItem)
            })
        
        if !scrollView.bounds.contains(tabItem.frame) {
            let contentOffsetX = (tabItem.x < scrollView.bounds.minX) ? tabItem.x : tabItem.frame.maxX - scrollView.bounds.width
            let normalizedOffsetX = min(max(contentOffsetX, 0), scrollView.contentSize.width - scrollView.bounds.width)
            scrollView.setContentOffset(CGPoint(x: normalizedOffsetX, y: 0), animated: true)
        }
    }
}
