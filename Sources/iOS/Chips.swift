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

@objc(ChipItemStyle)
public enum ChipItemStyle: Int {
    case pill
}

open class ChipItem: FlatButton {
    /// Configures the visual display of the chip.
    var chipItemStyle: ChipItemStyle {
        get {
            return associatedInstance.chipItemStyle
        }
        set(value) {
            associatedInstance.chipItemStyle = value
            layoutSubviews()
        }
    }
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        layoutChipItemStyle()
    }
}

fileprivate extension ChipItem {
    /// Lays out the chipItem based on its style.
    func layoutChipItemStyle() {
        if .pill == chipItemStyle {
            cornerRadius = height / 2
        }
    }
}

fileprivate struct AssociatedInstance {
    /// A ChipItemStyle value.
    var chipItemStyle: ChipItemStyle
}

/// A memory reference to the ChipItemStyle instance for ChipItem extensions.
fileprivate var ChipKey: UInt8 = 0

fileprivate extension ChipItem {
    /// AssociatedInstance reference.
    var associatedInstance: AssociatedInstance {
        get {
            return AssociatedObject.get(base: self, key: &ChipKey) {
                return AssociatedInstance(chipItemStyle: .pill)
            }
        }
        set(value) {
            AssociatedObject.set(base: self, key: &ChipKey, value: value)
        }
    }
}

@objc(ChipsDelegate)
public protocol ChipsDelegate {
    /**
     A delegation method that is executed when the chipItem will trigger the
     animation to the next chip.
     - Parameter chipBar: A Chips.
     - Parameter chipItem: A ChipItem.
     */
    @objc
    optional func chipBar(chipBar: Chips, willSelect chipItem: ChipItem)
    
    /**
     A delegation method that is executed when the chipItem did complete the
     animation to the next chip.
     - Parameter chipBar: A Chips.
     - Parameter chipItem: A ChipItem.
     */
    @objc
    optional func chipBar(chipBar: Chips, didSelect chipItem: ChipItem)
}

@objc(ChipsStyle)
public enum ChipsStyle: Int {
    case auto
    case nonScrollable
    case scrollable
}

open class Chips: Bar {
    /// A boolean indicating if the Chips line is in an animation state.
    open fileprivate(set) var isAnimating = false
    
    /// The total width of the chipItems.
    fileprivate var chipItemsTotalWidth: CGFloat {
        var w: CGFloat = 0
        
        for v in chipItems {
            w += v.sizeThatFits(CGSize(width: CGFloat.greatestFiniteMagnitude, height: contentView.height)).width + interimSpace
        }
        
        return w
    }
    
    /// An enum that determines the chip bar style.
    open var chipBarStyle = ChipsStyle.auto {
        didSet {
            layoutSubviews()
        }
    }
    
    /// A reference to the scroll view when the chip bar style is scrollable.
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
    open weak var delegate: ChipsDelegate?
    
    /// The currently selected chipItem.
    open fileprivate(set) var selected: ChipItem?
    
    /// A preset wrapper around chipItems contentEdgeInsets.
    open var chipItemsContentEdgeInsetsPreset: EdgeInsetsPreset {
        get {
            return scrollView.grid.contentEdgeInsetsPreset
        }
        set(value) {
            scrollView.grid.contentEdgeInsetsPreset = value
        }
    }
    
    /// A reference to EdgeInsets.
    @IBInspectable
    open var chipItemsContentEdgeInsets: EdgeInsets {
        get {
            return scrollView.grid.contentEdgeInsets
        }
        set(value) {
            scrollView.grid.contentEdgeInsets = value
        }
    }
    
    /// A preset wrapper around chipItems interimSpace.
    open var chipItemsInterimSpacePreset: InterimSpacePreset {
        get {
            return scrollView.grid.interimSpacePreset
        }
        set(value) {
            scrollView.grid.interimSpacePreset = value
        }
    }
    
    /// A wrapper around chipItems interimSpace.
    @IBInspectable
    open var chipItemsInterimSpace: InterimSpace {
        get {
            return scrollView.grid.interimSpace
        }
        set(value) {
            scrollView.grid.interimSpace = value
        }
    }
    
    /// Buttons.
    open var chipItems = [ChipItem]() {
        didSet {
            for b in oldValue {
                b.removeFromSuperview()
            }
            
            prepareChipItems()
            layoutSubviews()
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
            if let b = v as? ChipItem {
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
            if let b = v as? ChipItem {
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
        
        if .scrollable == chipBarStyle || (.auto == chipBarStyle && chipItemsTotalWidth > bounds.width) {
            var w: CGFloat = chipItemsContentEdgeInsets.left
            let q = 2 * chipItemsInterimSpace
            let p = q + chipItemsInterimSpace
            
            for v in chipItems {
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
            
            w += chipItemsContentEdgeInsets.right - chipItemsInterimSpace
            
            scrollView.contentSize = CGSize(width: w, height: scrollView.height - chipItemsContentEdgeInsets.top - chipItemsContentEdgeInsets.bottom)
        } else {
            scrollView.grid.views = chipItems
            scrollView.grid.axis.columns = chipItems.count
            scrollView.contentSize = CGSize(width: scrollView.width, height: scrollView.height - chipItemsContentEdgeInsets.top - chipItemsContentEdgeInsets.bottom)
        }
        
        grid.commit()
        contentView.grid.commit()
        
        layoutDivider()
    }
    
    open override func prepare() {
        super.prepare()
        contentEdgeInsetsPreset = .square2
        interimSpacePreset = .interimSpace6
        chipItemsInterimSpacePreset = .interimSpace4
        
        prepareContentView()
        prepareScrollView()
        prepareDivider()
    }
}

fileprivate extension Chips {
    /// Prepares the divider.
    func prepareDivider() {
        dividerColor = Color.grey.lighten3
    }
    
    /// Prepares the chipItems.
    func prepareChipItems() {
        for v in chipItems {
            v.grid.columns = 0
            v.cornerRadius = 0
            v.contentEdgeInsets = .zero
            
            v.removeTarget(self, action: #selector(handle(chipItem:)), for: .touchUpInside)
            v.addTarget(self, action: #selector(handle(chipItem:)), for: .touchUpInside)
        }
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
        centerViews = [scrollView]
    }
}

fileprivate extension Chips {
    /// Handles the chipItem touch event.
    @objc
    func handle(chipItem: ChipItem) {
        animate(to: chipItem, isTriggeredByUserInteraction: true)
    }
}

extension Chips {
    /**
     Selects a given index from the chipItems array.
     - Parameter at index: An Int.
     - Paramater completion: An optional completion block.
     */
    open func select(at index: Int, completion: ((ChipItem) -> Void)? = nil) {
        guard -1 < index, index < chipItems.count else {
            return
        }
        animate(to: chipItems[index], isTriggeredByUserInteraction: false, completion: completion)
    }
    
    /**
     Animates to a given chipItem.
     - Parameter to chipItem: A ChipItem.
     - Parameter completion: An optional completion block.
     */
    open func animate(to chipItem: ChipItem, completion: ((ChipItem) -> Void)? = nil) {
        animate(to: chipItem, isTriggeredByUserInteraction: false, completion: completion)
    }
}

fileprivate extension Chips {
    /**
     Animates to a given chipItem.
     - Parameter to chipItem: A ChipItem.
     - Parameter isTriggeredByUserInteraction: A boolean indicating whether the
     state was changed by a user interaction, true if yes, false otherwise.
     - Parameter completion: An optional completion block.
     */
    func animate(to chipItem: ChipItem, isTriggeredByUserInteraction: Bool, completion: ((ChipItem) -> Void)? = nil) {
        if isTriggeredByUserInteraction {
            delegate?.chipBar?(chipBar: self, willSelect: chipItem)
        }
        
        selected = chipItem
        isAnimating = true
        
        if !scrollView.bounds.contains(chipItem.frame) {
            let contentOffsetX = (chipItem.x < scrollView.bounds.minX) ? chipItem.x : chipItem.frame.maxX - scrollView.bounds.width
            let normalizedOffsetX = min(max(contentOffsetX, 0), scrollView.contentSize.width - scrollView.bounds.width)
            scrollView.setContentOffset(CGPoint(x: normalizedOffsetX, y: 0), animated: true)
        }
    }
}
