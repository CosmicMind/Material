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

open class NavigationBar: UINavigationBar, Themeable {
  /// Will layout the view.
  open var willLayout: Bool {
    return 0 < bounds.width && 0 < bounds.height && nil != superview
  }
  
  /// Detail UILabel when in landscape for iOS 11.
  fileprivate var toolbarToText: [Toolbar: String?]?
  
  open override var intrinsicContentSize: CGSize {
    return CGSize(width: bounds.width, height: bounds.height)
  }
  
  /// A preset wrapper around contentEdgeInsets.
  open var contentEdgeInsetsPreset = EdgeInsetsPreset.square1 {
    didSet {
      contentEdgeInsets = EdgeInsetsPresetToValue(preset: contentEdgeInsetsPreset)
    }
  }
  
  /// A reference to EdgeInsets.
  @IBInspectable
  open var contentEdgeInsets = EdgeInsetsPresetToValue(preset: .square1) {
    didSet {
      layoutSubviews()
    }
  }
  
  /// A preset wrapper around interimSpace.
  open var interimSpacePreset = InterimSpacePreset.interimSpace3 {
    didSet {
      interimSpace = InterimSpacePresetToValue(preset: interimSpacePreset)
    }
  }
  
  /// A wrapper around grid.interimSpace.
  @IBInspectable
  open var interimSpace = InterimSpacePresetToValue(preset: .interimSpace3) {
    didSet {
      layoutSubviews()
    }
  }
  
  /**
   The back button image writes to the backIndicatorImage property and
   backIndicatorTransitionMaskImage property.
   */
  @IBInspectable
  open var backButtonImage: UIImage? {
    get {
      return backIndicatorImage
    }
    set(value) {
      let image: UIImage? = value
      backIndicatorImage = image
      backIndicatorTransitionMaskImage = image
    }
  }
  
  /// A property that accesses the backing layer's background
  @IBInspectable
  open override var backgroundColor: UIColor? {
    get {
      return barTintColor
    }
    set(value) {
      barTintColor = value
    }
  }
  
  /**
   An initializer that initializes the object with a NSCoder object.
   - Parameter aDecoder: A NSCoder instance.
   */
  public required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    prepare()
  }
  
  /**
   An initializer that initializes the object with a CGRect object.
   If AutoLayout is used, it is better to initilize the instance
   using the init() initializer.
   - Parameter frame: A CGRect instance.
   */
  public override init(frame: CGRect) {
    super.init(frame: frame)
    prepare()
  }
  
  open override func sizeThatFits(_ size: CGSize) -> CGSize {
    return intrinsicContentSize
  }
  
  open override func layoutSubviews() {
    super.layoutSubviews()
    layoutShape()
    layoutShadowPath()
    
    //iOS 11 added left/right layout margin in subviews of UINavigationBar
    //since we do not want to unsafely access private views directly, we
    //iterate through the subviews to set `layoutMargins` to zero
    for v in subviews {
      if #available(iOS 13.0, *) {
        let margins = v.layoutMargins
        v.frame.origin.x = -margins.left
        v.frame.size.width += margins.left + margins.right
      } else {
        v.layoutMargins = .zero
      }
    }
    
    if let v = topItem {
      layoutNavigationItem(item: v)
    }
    
    if let v = backItem {
      layoutNavigationItem(item: v)
    }
    
    layoutDivider()
  }
  
  /**
   Prepares the view instance when intialized. When subclassing,
   it is recommended to override the prepare method
   to initialize property values and other setup operations.
   The super.prepare method should always be called immediately
   when subclassing.
   */
  open func prepare() {
    barStyle = .black
    isTranslucent = false
    depthPreset = .none
    contentScaleFactor = Screen.scale
    backButtonImage = Icon.cm.arrowBack
    
    if #available(iOS 11, *) {
      toolbarToText = [:]
    }
    
    let image = UIImage()
    shadowImage = image
    setBackgroundImage(image, for: .default)
    backgroundColor = .white
    applyCurrentTheme()
  }
  
  /**
   Applies the given theme.
   - Parameter theme: A Theme.
   */
  open func apply(theme: Theme) {
    backgroundColor = theme.primary
    items?.forEach {
      apply(theme: theme, to: $0)
    }
  }
  
  /**
   Applies the given theme to the navigation item.
   - Parameter theme: A Theme.
   - Parameter to item: A UINavigationItem.
   */
  private func apply(theme: Theme, to item: UINavigationItem) {
    Theme.apply(theme: theme, to: item.toolbar)
  }
}

internal extension NavigationBar {
  /**
   Lays out the UINavigationItem.
   - Parameter item: A UINavigationItem to layout.
   */
  func layoutNavigationItem(item: UINavigationItem) {
    guard willLayout else {
      return
    }
    
    if isThemingEnabled {
      apply(theme: .current, to: item)
    }
    
    let toolbar = item.toolbar
    toolbar.backgroundColor = .clear
    toolbar.interimSpace = interimSpace
    toolbar.contentEdgeInsets = contentEdgeInsets
    
    if #available(iOS 11, *) {
      if Application.shouldStatusBarBeHidden {
        toolbar.contentEdgeInsetsPreset = .none
        
        if nil != toolbar.detailLabel.text {
          toolbarToText?[toolbar] = toolbar.detailLabel.text
          toolbar.detailLabel.text = nil
        }
      } else if nil != toolbarToText?[toolbar] {
        toolbar.detailLabel.text = toolbarToText?[toolbar] ?? nil
        toolbarToText?[toolbar] = nil
      }
    }
    
    item.titleView = toolbar
    item.titleView!.frame = bounds
  }
}
