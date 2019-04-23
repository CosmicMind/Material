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

@objc(ContentViewAlignment)
public enum ContentViewAlignment: Int {
  case full
  case center
}

open class Bar: View {
  /// Will layout the view.
  open var willLayout: Bool {
    return 0 < bounds.width && 0 < bounds.height && nil != superview && !grid.isDeferred
  }
  
  open override var intrinsicContentSize: CGSize {
    return bounds.size
  }
  
  /// Should center the contentView.
  open var contentViewAlignment = ContentViewAlignment.full {
    didSet {
      layoutSubviews()
    }
  }
  
  /// A preset wrapper around contentEdgeInsets.
  open var contentEdgeInsetsPreset: EdgeInsetsPreset {
    get {
      return grid.contentEdgeInsetsPreset
    }
    set(value) {
      grid.contentEdgeInsetsPreset = value
    }
  }
  
  /// A reference to EdgeInsets.
  @IBInspectable
  open var contentEdgeInsets: EdgeInsets {
    get {
      return grid.contentEdgeInsets
    }
    set(value) {
      grid.contentEdgeInsets = value
    }
  }
  
  /// A preset wrapper around interimSpace.
  open var interimSpacePreset: InterimSpacePreset {
    get {
      return grid.interimSpacePreset
    }
    set(value) {
      grid.interimSpacePreset = value
    }
  }
  
  /// A wrapper around grid.interimSpace.
  @IBInspectable
  open var interimSpace: InterimSpace {
    get {
      return grid.interimSpace
    }
    set(value) {
      grid.interimSpace = value
    }
  }
  
  /// Grid cell factor.
  @IBInspectable
  open var gridFactor: CGFloat = 12 {
    didSet {
      assert(0 < gridFactor, "[Material Error: gridFactor must be greater than 0.]")
      layoutSubviews()
    }
  }
  
  /// ContentView that holds the any desired subviews.
  public let contentView = UIView()
  
  /// Left side UIViews.
  open var leftViews = [UIView]() {
    didSet {
      oldValue.forEach {
        $0.removeFromSuperview()
      }
      
      layoutSubviews()
    }
  }
  
  /// Right side UIViews.
  open var rightViews = [UIView]() {
    didSet {
      oldValue.forEach {
        $0.removeFromSuperview()
      }
      
      layoutSubviews()
    }
  }
  
  /// Center UIViews.
  open var centerViews: [UIView] {
    get {
      return contentView.grid.views
    }
    set(value) {
      contentView.grid.views = value
    }
  }
  
  /**
   An initializer that initializes the object with a NSCoder object.
   - Parameter aDecoder: A NSCoder instance.
   */
  public required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }
  
  /**
   An initializer that initializes the object with a CGRect object.
   If AutoLayout is used, it is better to initilize the instance
   using the init() initializer.
   - Parameter frame: A CGRect instance.
   */
  public override init(frame: CGRect) {
    super.init(frame: frame)
  }
  
  /**
   A convenience initializer with parameter settings.
   - Parameter leftViews: An Array of UIViews that go on the left side.
   - Parameter rightViews: An Array of UIViews that go on the right side.
   - Parameter centerViews: An Array of UIViews that go in the center.
   */
  public convenience init(leftViews: [UIView]? = nil, rightViews: [UIView]? = nil, centerViews: [UIView]? = nil) {
    self.init()
    self.leftViews = leftViews ?? []
    self.rightViews = rightViews ?? []
    self.centerViews = centerViews ?? []
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
      
      v.frame.size.width = v.intrinsicContentSize.width
      v.sizeToFit()
      v.grid.columns = Int(ceil(v.bounds.width / gridFactor)) + 2
      
      lc += v.grid.columns
      
      grid.views.append(v)
    }
    
    grid.views.append(contentView)
    
    for v in rightViews {
      if let b = v as? UIButton {
        b.contentEdgeInsets = .zero
        b.titleEdgeInsets = .zero
      }
      
      v.frame.size.width = v.intrinsicContentSize.width
      v.sizeToFit()
      v.grid.columns = Int(ceil(v.bounds.width / gridFactor)) + 2
      
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
    
    let p = bounds.width - l - r - contentEdgeInsets.left - contentEdgeInsets.right
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
    grid.commit()
    contentView.grid.commit()
    
    layoutDivider()
  }
  
  open override func prepare() {
    super.prepare()
    heightPreset = .normal
    autoresizingMask = .flexibleWidth
    interimSpacePreset = .interimSpace3
    contentEdgeInsetsPreset = .square1
    
    prepareContentView()
  }
}

extension Bar {
  /// Prepares the contentView.
  fileprivate func prepareContentView() {
    contentView.contentScaleFactor = Screen.scale
  }
}
