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
  
  open override func prepare() {
    super.prepare()
    pulseAnimation = .none
  }
}

fileprivate extension ChipItem {
  /// Lays out the chipItem based on its style.
  func layoutChipItemStyle() {
    if .pill == chipItemStyle {
      layer.cornerRadius = bounds.height / 2
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

@objc(ChipBarDelegate)
public protocol ChipBarDelegate {
  /**
   A delegation method that is executed when the chipItem will trigger the
   animation to the next chip.
   - Parameter chipBar: A ChipBar.
   - Parameter chipItem: A ChipItem.
   */
  @objc
  optional func chipBar(chipBar: ChipBar, willSelect chipItem: ChipItem)
  
  /**
   A delegation method that is executed when the chipItem did complete the
   animation to the next chip.
   - Parameter chipBar: A ChipBar.
   - Parameter chipItem: A ChipItem.
   */
  @objc
  optional func chipBar(chipBar: ChipBar, didSelect chipItem: ChipItem)
}

@objc(ChipBarStyle)
public enum ChipBarStyle: Int {
  case auto
  case nonScrollable
  case scrollable
}

open class ChipBar: Bar {
  /// The total width of the chipItems.
  fileprivate var chipItemsTotalWidth: CGFloat {
    var w: CGFloat = 0
    let q = 2 * chipItemsInterimSpace
    let p = q + chipItemsInterimSpace
    
    for v in chipItems {
      let x = v.sizeThatFits(CGSize(width: .greatestFiniteMagnitude, height: scrollView.bounds.height)).width
      w += x
      w += p
    }
    
    w -= chipItemsInterimSpace
    
    return w
  }
  
  /// An enum that determines the chip bar style.
  open var chipBarStyle = ChipBarStyle.auto {
    didSet {
      layoutSubviews()
    }
  }
  
  /// A reference to the scroll view when the chip bar style is scrollable.
  public let scrollView = UIScrollView()
  
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
  open weak var delegate: ChipBarDelegate?
  
  /// The currently selected chipItem.
  open fileprivate(set) var selectedChipItem: ChipItem?
  
  /// A preset wrapper around chipItems contentEdgeInsets.
  open var chipItemsContentEdgeInsetsPreset: EdgeInsetsPreset {
    get {
      return contentView.grid.contentEdgeInsetsPreset
    }
    set(value) {
      contentView.grid.contentEdgeInsetsPreset = value
    }
  }
  
  /// A reference to EdgeInsets.
  @IBInspectable
  open var chipItemsContentEdgeInsets: EdgeInsets {
    get {
      return contentView.grid.contentEdgeInsets
    }
    set(value) {
      contentView.grid.contentEdgeInsets = value
    }
  }
  
  /// A preset wrapper around chipItems interimSpace.
  open var chipItemsInterimSpacePreset: InterimSpacePreset {
    get {
      return contentView.grid.interimSpacePreset
    }
    set(value) {
      contentView.grid.interimSpacePreset = value
    }
  }
  
  /// A wrapper around chipItems interimSpace.
  @IBInspectable
  open var chipItemsInterimSpace: InterimSpace {
    get {
      return contentView.grid.interimSpace
    }
    set(value) {
      contentView.grid.interimSpace = value
    }
  }
  
  /// Buttons.
  open var chipItems = [ChipItem]() {
    didSet {
      oldValue.forEach {
        $0.removeFromSuperview()
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
    
    layoutScrollView()
    
    updateScrollView()
  }
  
  open override func prepare() {
    super.prepare()
    interimSpacePreset = .interimSpace3
    contentEdgeInsetsPreset = .square1
    chipItemsInterimSpacePreset = .interimSpace4
    chipItemsContentEdgeInsetsPreset = .square2
    chipItemsContentEdgeInsets.left = 0
    chipItemsContentEdgeInsets.right = 0
    
    prepareContentView()
    prepareScrollView()
    prepareDivider()
  }
}

fileprivate extension ChipBar {
  /// Prepares the divider.
  func prepareDivider() {
    dividerColor = Color.grey.lighten2
  }
  
  /// Prepares the chipItems.
  func prepareChipItems() {
    for v in chipItems {
      v.grid.columns = 0
      v.layer.cornerRadius = 0
      v.contentEdgeInsets = .zero
      
      v.removeTarget(self, action: #selector(handle(chipItem:)), for: .touchUpInside)
      v.addTarget(self, action: #selector(handle(chipItem:)), for: .touchUpInside)
    }
  }
  
  /// Prepares the contentView.
  func prepareContentView() {
    contentView.layer.zPosition = 6000
  }
  
  /// Prepares the scroll view.
  func prepareScrollView() {
    scrollView.showsVerticalScrollIndicator = false
    scrollView.showsHorizontalScrollIndicator = false
    centerViews = [scrollView]
  }
}

fileprivate extension ChipBar {
  /// Layout the scrollView.
  func layoutScrollView() {
    contentView.grid.reload()
    
    if .scrollable == chipBarStyle || (.auto == chipBarStyle && chipItemsTotalWidth > scrollView.bounds.width) {
      var w: CGFloat = 0
      let q = 2 * chipItemsInterimSpace
      let p = q + chipItemsInterimSpace
      
      for v in chipItems {
        let x = v.sizeThatFits(CGSize(width: .greatestFiniteMagnitude, height: scrollView.bounds.height)).width
        v.frame.size.height = scrollView.bounds.height
        v.frame.size.width = x + q
        v.frame.origin.x = w
        w += x
        w += p
        
        if scrollView != v.superview {
          scrollView.addSubview(v)
        }
      }
      
      w -= chipItemsInterimSpace
      
      scrollView.contentSize = CGSize(width: w, height: scrollView.bounds.height)
      
    } else {
      scrollView.grid.begin()
      scrollView.grid.views = chipItems
      scrollView.grid.axis.columns = chipItems.count
      scrollView.grid.contentEdgeInsets = chipItemsContentEdgeInsets
      scrollView.grid.interimSpace = chipItemsInterimSpace
      scrollView.grid.commit()
      scrollView.contentSize = scrollView.frame.size
    }
  }
}

fileprivate extension ChipBar {
  /// Handles the chipItem touch event.
  @objc
  func handle(chipItem: ChipItem) {
    animate(to: chipItem, isTriggeredByUserInteraction: true)
  }
}

extension ChipBar {
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

fileprivate extension ChipBar {
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
    
    selectedChipItem = chipItem
    updateScrollView()
  }
}

fileprivate extension ChipBar {
  /// Updates the scrollView.
  func updateScrollView() {
    guard let v = selectedChipItem else {
      return
    }
    
    if !scrollView.bounds.contains(v.frame) {
      let contentOffsetX = (v.frame.origin.x < scrollView.bounds.minX) ? v.frame.origin.x : v.frame.maxX - scrollView.bounds.width
      let normalizedOffsetX = min(max(contentOffsetX, 0), scrollView.contentSize.width - scrollView.bounds.width)
      scrollView.setContentOffset(CGPoint(x: normalizedOffsetX, y: 0), animated: true)
    }
  }
}
