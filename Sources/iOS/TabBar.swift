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

@objc(TabBarLineAlignment)
public enum TabBarLineAlignment: Int {
	case top
	case bottom
}

@objc(TabBarDelegate)
public protocol TabBarDelegate {
    /**
     A delegation method that is executed when the button will trigger the
     animation to the next tab.
     - Parameter tabBar: A TabBar.
     - Parameter button: A UIButton.
     */
    @objc
    optional func tabBar(tabBar: TabBar, willSelect button: UIButton)
    
    /**
     A delegation method that is executed when the button did complete the
     animation to the next tab.
     - Parameter tabBar: A TabBar.
     - Parameter button: A UIButton.
     */
    @objc
    optional func tabBar(tabBar: TabBar, didSelect button: UIButton)
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
    
    /// The total width of the buttons.
    fileprivate var buttonsTotalWidth: CGFloat {
        var w: CGFloat = 0
            
        for v in buttons {
            w += v.sizeThatFits(CGSize(width: CGFloat.greatestFiniteMagnitude, height: contentView.height)).width + interimSpace
        }
            
        return w
    }
    
    /// Enables and disables bouncing when swiping.
    open var isBounceEnabled: Bool {
        get {
            return scrollView.bounces
        }
        set(value) {
            scrollView.bounces = value
        }
    }
    
    /// An enum that determines the tab bar style.
    open var tabBarStyle = TabBarStyle.auto {
        didSet {
            layoutSubviews()
        }
    }
    
    /// A reference to the scroll view when the tab bar style is scrollable.
    open let scrollView = UIScrollView()
    
    /// Does the scroll view bounce. 
    open var isScrollBounceEnabled = true {
        didSet {
            scrollView.bounces = true
        }
    }
    
    /// A delegation reference.
    open weak var delegate: TabBarDelegate?
    
    /// The currently selected button.
    open fileprivate(set) var selected: UIButton?
    
    /// A preset wrapper around contentEdgeInsets.
    open override var contentEdgeInsetsPreset: EdgeInsetsPreset {
        get {
            return contentView.grid.contentEdgeInsetsPreset
        }
        set(value) {
            contentView.grid.contentEdgeInsetsPreset = value
        }
    }
    
    /// A reference to EdgeInsets.
    @IBInspectable
    open override var contentEdgeInsets: EdgeInsets {
        get {
            return contentView.grid.contentEdgeInsets
        }
        set(value) {
            contentView.grid.contentEdgeInsets = value
        }
    }
    
    /// A preset wrapper around interimSpace.
    open override var interimSpacePreset: InterimSpacePreset {
        get {
            return contentView.grid.interimSpacePreset
        }
        set(value) {
            contentView.grid.interimSpacePreset = value
        }
    }
    
    /// A wrapper around contentView.grid.interimSpace.
    @IBInspectable
    open override var interimSpace: InterimSpace {
        get {
            return contentView.grid.interimSpace
        }
        set(value) {
            contentView.grid.interimSpace = value
        }
    }
    
	/// Buttons.
	open var buttons = [UIButton]() {
		didSet {
			for b in oldValue {
                b.removeFromSuperview()
            }
			
            prepareButtons()
			layoutSubviews()
		}
	}
    
    /// A boolean to animate the line when touched.
    @IBInspectable
    open var isLineAnimated = true {
        didSet {
            for b in buttons {
                if isLineAnimated {
                    prepareLineAnimationHandler(button: b)
                } else {
                    removeLineAnimationHandler(button: b)
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
            if let b = v as? UIButton {
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
            if let b = v as? UIButton {
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
        
        if .scrollable == tabBarStyle || (.auto == tabBarStyle && buttonsTotalWidth > bounds.width) {
            var w: CGFloat = 0
            for v in buttons {
                let x = v.sizeThatFits(CGSize(width: CGFloat.greatestFiniteMagnitude, height: contentView.height)).width + interimSpace
                scrollView.addSubview(v)
                v.height = scrollView.height
                v.width = x
                v.x = w
                w += x
            }
            
            scrollView.contentSize = CGSize(width: w, height: height)
        } else {
            scrollView.grid.views = buttons
            scrollView.grid.axis.columns = buttons.count
            scrollView.contentSize = CGSize(width: scrollView.width, height: height)
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
    
    /// Prepares the buttons.
    func prepareButtons() {
        for v in buttons {
            v.grid.columns = 0
            v.cornerRadius = 0
            v.contentEdgeInsets = .zero
            
            if isLineAnimated {
                prepareLineAnimationHandler(button: v)
            }
        }
    }
    
    /**
     Prepares the line animation handlers.
     - Parameter button: A UIButton.
     */
    func prepareLineAnimationHandler(button: UIButton) {
        removeLineAnimationHandler(button: button)
        button.addTarget(self, action: #selector(handleLineAnimation(button:)), for: .touchUpInside)
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
        guard 0 < buttons.count else {
            return
        }
        
        if nil == selected {
            selected = buttons.first
        }
        
        line.animate(.duration(0),
                     .size(CGSize(width: selected!.width, height: lineHeight)),
                     .position(CGPoint(x: selected!.center.x, y: .bottom == lineAlignment ? height - lineHeight / 2 : lineHeight / 2)))
    }
}

extension TabBar {
    /**
     Removes the line animation handlers.
     - Parameter button: A UIButton.
     */
    fileprivate func removeLineAnimationHandler(button: UIButton) {
        button.removeTarget(self, action: #selector(handleLineAnimation(button:)), for: .touchUpInside)
    }
}

extension TabBar {
    /// Handles the button touch event.
    @objc
    fileprivate func handleLineAnimation(button: UIButton) {
        animate(to: button, isTriggeredByUserInteraction: true)
    }
}

extension TabBar {
    /**
     Selects a given index from the buttons array.
     - Parameter at index: An Int.
     - Paramater completion: An optional completion block.
     */
    open func select(at index: Int, completion: ((UIButton) -> Void)? = nil) {
        guard -1 < index, index < buttons.count else {
            return
        }
        animate(to: buttons[index], isTriggeredByUserInteraction: false, completion: completion)
    }
    
    /**
     Animates to a given button.
     - Parameter to button: A UIButton.
     - Parameter completion: An optional completion block.
     */
    open func animate(to button: UIButton, completion: ((UIButton) -> Void)? = nil) {
        animate(to: button, isTriggeredByUserInteraction: false, completion: completion)
    }
    
    /**
     Animates to a given button.
     - Parameter to button: A UIButton.
     - Parameter isTriggeredByUserInteraction: A boolean indicating whether the
     state was changed by a user interaction, true if yes, false otherwise.
     - Parameter completion: An optional completion block.
     */
    fileprivate func animate(to button: UIButton, isTriggeredByUserInteraction: Bool, completion: ((UIButton) -> Void)? = nil) {
        if isTriggeredByUserInteraction {
            delegate?.tabBar?(tabBar: self, willSelect: button)
        }
        
        selected = button
        isAnimating = true
        
        line.animate(.duration(0.25),
                     .size(CGSize(width: button.width, height: lineHeight)),
                     .position(CGPoint(x: button.center.x, y: .bottom == lineAlignment ? height - lineHeight / 2 : lineHeight / 2)),
                     .completion { [weak self, isTriggeredByUserInteraction = isTriggeredByUserInteraction, button = button, completion = completion] _ in
                        guard let s = self else {
                            return
                        }
                        
                        s.isAnimating = false
                        
                        if isTriggeredByUserInteraction {
                            s.delegate?.tabBar?(tabBar: s, didSelect: button)
                        }
                        
                        completion?(button)
                     })
        
        if !scrollView.bounds.contains(button.frame) {
            let contentOffsetX = (button.x < scrollView.bounds.minX) ? button.x : button.frame.maxX - scrollView.bounds.width
            let normalizedOffsetX = min(max(contentOffsetX, 0), scrollView.contentSize.width - scrollView.bounds.width)
            scrollView.setContentOffset(CGPoint(x: normalizedOffsetX, y: 0), animated: true)
        }
    }
}
