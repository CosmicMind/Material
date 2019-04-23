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

open class Toolbar: Bar, Themeable {
  /// A convenience property to set the titleLabel.text.
  @IBInspectable
  open var title: String? {
    get {
      return titleLabel.text
    }
    set(value) {
      titleLabel.text = value
      layoutSubviews()
    }
  }
  
  /// Title label.
  @IBInspectable
  public let titleLabel = UILabel()
  
  /// A convenience property to set the detailLabel.text.
  @IBInspectable
  open var detail: String? {
    get {
      return detailLabel.text
    }
    set(value) {
      detailLabel.text = value
      layoutSubviews()
    }
  }
  
  /// Detail label.
  @IBInspectable
  public let detailLabel = UILabel()
  
  open override var leftViews: [UIView] {
    didSet {
      prepareIconButtons(leftViews)
    }
  }
  
  open override var centerViews: [UIView] {
    didSet {
      prepareIconButtons(centerViews)
    }
  }
  
  open override var rightViews: [UIView] {
    didSet {
      prepareIconButtons(rightViews)
    }
  }
  
  deinit {
    titleLabelTextAlignmentObserver.invalidate()
    titleLabelTextAlignmentObserver = nil
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
  
  open override func layoutSubviews() {
    super.layoutSubviews()
    guard willLayout else {
      return
    }
    
    if 0 < titleLabel.text?.utf16.count ?? 0 {
      if nil == titleLabel.superview {
        contentView.addSubview(titleLabel)
      }
      titleLabel.frame = contentView.bounds
    } else {
      titleLabel.removeFromSuperview()
    }
    
    if 0 < detailLabel.text?.utf16.count ?? 0 {
      if nil == detailLabel.superview {
        contentView.addSubview(detailLabel)
      }
      
      if nil == titleLabel.superview {
        detailLabel.frame = contentView.bounds
      } else {
        titleLabel.sizeToFit()
        detailLabel.sizeToFit()
        
        let diff: CGFloat = (contentView.bounds.height - titleLabel.bounds.height - detailLabel.bounds.height) / 2
        
        titleLabel.frame.size.height += diff
        titleLabel.frame.size.width = contentView.bounds.width
        
        detailLabel.frame.size.height += diff
        detailLabel.frame.size.width = contentView.bounds.width
        detailLabel.frame.origin.y = titleLabel.bounds.height
      }
    } else {
      detailLabel.removeFromSuperview()
    }
  }
  
  open override func prepare() {
    super.prepare()
    contentViewAlignment = .center
    
    prepareTitleLabel()
    prepareDetailLabel()
  }
  
  /**
   Applies the given theme.
   - Parameter theme: A Theme.
   */
  open func apply(theme: Theme) {
    backgroundColor = theme.primary
    (leftViews + rightViews + centerViews).forEach {
      guard let v = $0 as? IconButton, v.isThemingEnabled else {
        return
      }
      
      v.apply(theme: theme)
    }
    
    if !((titleLabel as? Themeable)?.isThemingEnabled == false) {
      titleLabel.textColor = theme.onPrimary
    }
    
    if !((detailLabel as? Themeable)?.isThemingEnabled == false) {
      detailLabel.textColor = theme.onPrimary
    }
  }
  
  /// A reference to titleLabel.textAlignment observation.
  private var titleLabelTextAlignmentObserver: NSKeyValueObservation!
}

private extension Toolbar {
  /// Prepares the titleLabel.
  func prepareTitleLabel() {
    titleLabel.textAlignment = .center
    titleLabel.contentScaleFactor = Screen.scale
    titleLabel.font = Theme.font.medium(with: 17)
    titleLabel.textColor = Color.darkText.primary
    titleLabelTextAlignmentObserver = titleLabel.observe(\.textAlignment) { [weak self] titleLabel, _ in
      self?.contentViewAlignment = .center == titleLabel.textAlignment ? .center : .full
    }
  }
  
  /// Prepares the detailLabel.
  func prepareDetailLabel() {
    detailLabel.textAlignment = .center
    detailLabel.contentScaleFactor = Screen.scale
    detailLabel.font = Theme.font.regular(with: 12)
    detailLabel.textColor = Color.darkText.secondary
  }
  
  func prepareIconButtons(_ views: [UIView]) {
    views.forEach {
      ($0 as? IconButton)?.themingStyle = .onPrimary
    }
    
    applyCurrentTheme()
  }
}
