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

open class Card: PulseView {
  /// A container view for subviews.
  public let container = UIView()
  
  @IBInspectable
  open override var cornerRadiusPreset: CornerRadiusPreset {
    didSet {
      container.cornerRadiusPreset = cornerRadiusPreset
    }
  }
  
  @IBInspectable
  open var cornerRadius: CGFloat {
    get {
      return container.layer.cornerRadius
    }
    set(value) {
      container.layer.cornerRadius = value
    }
  }
  
  open override var shapePreset: ShapePreset {
    didSet {
      container.shapePreset = shapePreset
    }
  }
  
  @IBInspectable
  open override var backgroundColor: UIColor? {
    didSet {
      container.backgroundColor = backgroundColor
    }
  }
  
  /// A reference to the toolbar.
  @IBInspectable
  open var toolbar: Toolbar? {
    didSet {
      oldValue?.removeFromSuperview()
      
      if let v = toolbar {
        container.addSubview(v)
      }
      
      layoutSubviews()
    }
  }
  
  /// A preset wrapper around toolbarEdgeInsets.
  open var toolbarEdgeInsetsPreset = EdgeInsetsPreset.none {
    didSet {
      toolbarEdgeInsets = EdgeInsetsPresetToValue(preset: toolbarEdgeInsetsPreset)
    }
  }
  
  /// A reference to toolbarEdgeInsets.
  @IBInspectable
  open var toolbarEdgeInsets = EdgeInsets.zero {
    didSet {
      layoutSubviews()
    }
  }
  
  /// A reference to the contentView.
  @IBInspectable
  open var contentView: UIView? {
    didSet {
      oldValue?.removeFromSuperview()
      
      if let v = contentView {
        v.clipsToBounds = true
        container.addSubview(v)
      }
      
      layoutSubviews()
    }
  }
  
  /// A preset wrapper around contentViewEdgeInsets.
  open var contentViewEdgeInsetsPreset = EdgeInsetsPreset.none {
    didSet {
      contentViewEdgeInsets = EdgeInsetsPresetToValue(preset: contentViewEdgeInsetsPreset)
    }
  }
  
  /// A reference to contentViewEdgeInsets.
  @IBInspectable
  open var contentViewEdgeInsets = EdgeInsets.zero {
    didSet {
      layoutSubviews()
    }
  }
  
  /// A reference to the bottomBar.
  @IBInspectable
  open var bottomBar: Bar? {
    didSet {
      oldValue?.removeFromSuperview()
      
      if let v = bottomBar {
        container.addSubview(v)
      }
      
      layoutSubviews()
    }
  }
  
  /// A preset wrapper around bottomBarEdgeInsets.
  open var bottomBarEdgeInsetsPreset = EdgeInsetsPreset.none {
    didSet {
      bottomBarEdgeInsets = EdgeInsetsPresetToValue(preset: bottomBarEdgeInsetsPreset)
    }
  }
  
  /// A reference to bottomBarEdgeInsets.
  @IBInspectable
  open var bottomBarEdgeInsets = EdgeInsets.zero {
    didSet {
      layoutSubviews()
    }
  }
  
  /**
   An initializer that accepts a NSCoder.
   - Parameter coder aDecoder: A NSCoder.
   */
  public required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }
  
  /**
   An initializer that accepts a CGRect.
   - Parameter frame: A CGRect.
   */
  public override init(frame: CGRect) {
    super.init(frame: frame)
  }
  
  /**
   A convenience initiazlier.
   - Parameter toolbar: An optional Toolbar.
   - Parameter contentView: An optional UIView.
   - Parameter bottomBar: An optional Bar.
   */
  public convenience init?(toolbar: Toolbar?, contentView: UIView?, bottomBar: Bar?) {
    self.init(frame: .zero)
    prepareProperties(toolbar: toolbar, contentView: contentView, bottomBar: bottomBar)
  }
  
  open override func layoutSubviews() {
    super.layoutSubviews()
    container.frame.size.width = bounds.width
    reload()
  }
  
  /// Reloads the layout.
  open func reload() {
    var h: CGFloat = 0
    
    if let v = toolbar {
      h = prepare(view: v, with: toolbarEdgeInsets, from: h)
    }
    
    if let v = contentView {
      h = prepare(view: v, with: contentViewEdgeInsets, from: h)
    }
    
    if let v = bottomBar {
      h = prepare(view: v, with: bottomBarEdgeInsets, from: h)
    }
    
    container.frame.size.height = h
    bounds.size.height = h
  }
  
  open override func prepare() {
    super.prepare()
    pulseAnimation = .none
    cornerRadiusPreset = .cornerRadius1
    
    prepareContainer()
  }
  
  /**
   Prepare the view size from a given top position.
   - Parameter view: A UIView.
   - Parameter edge insets: An EdgeInsets.
   - Parameter from top: A CGFloat.
   - Returns: A CGFloat.
   */
  @discardableResult
  open func prepare(view: UIView, with insets: EdgeInsets, from top: CGFloat) -> CGFloat {
    let y = insets.top + top
    
    view.frame.origin.y = y
    view.frame.origin.x = insets.left
    
    let w = container.bounds.width - insets.left - insets.right
    var h = view.bounds.height
    
    if 0 == h || nil != view as? UILabel {
      (view as? UILabel)?.sizeToFit()
      h = view.sizeThatFits(CGSize(width: w, height: .greatestFiniteMagnitude)).height
    }
    
    view.frame.size.width = w
    view.frame.size.height = h
    
    return y + h + insets.bottom
  }
  
  /**
   A preparation method that sets the base UI elements.
   - Parameter toolbar: An optional Toolbar.
   - Parameter contentView: An optional UIView.
   - Parameter bottomBar: An optional Bar.
   */
  internal func prepareProperties(toolbar: Toolbar?, contentView: UIView?, bottomBar: Bar?) {
    self.toolbar = toolbar
    self.contentView = contentView
    self.bottomBar = bottomBar
  }
}

extension Card {
  /// Prepares the container.
  fileprivate func prepareContainer() {
    container.clipsToBounds = true
    addSubview(container)
  }
}
