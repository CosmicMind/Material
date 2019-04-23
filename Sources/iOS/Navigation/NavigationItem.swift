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

/// A memory reference to the NavigationItem instance.
fileprivate var NavigationItemKey: UInt8 = 0
fileprivate var NavigationItemContext: UInt8 = 0

fileprivate class NavigationItem: NSObject {
  /// A reference to the toolbar.
  @objc
  let toolbar = Toolbar()
  
  /// Back Button.
  lazy var backButton = IconButton()
  
  /// An optional reference to the NavigationBar.
  var navigationBar: NavigationBar? {
    var v = toolbar.contentView.superview
    while nil != v {
      if let navigationBar = v as? NavigationBar {
        return navigationBar
      }
      v = v?.superview
    }
    return nil
  }
}

fileprivate extension UINavigationItem {
  /// NavigationItem reference.
  var navigationItem: NavigationItem {
    get {
      return AssociatedObject.get(base: self, key: &NavigationItemKey) {
        return NavigationItem()
      }
    }
    set(value) {
      AssociatedObject.set(base: self, key: &NavigationItemKey, value: value)
    }
  }
}

internal extension UINavigationItem {
  /// A reference to the NavigationItem Toolbar.
  var toolbar: Toolbar {
    return navigationItem.toolbar
  }
}

extension UINavigationItem {
  /// Should center the contentView.
  open var contentViewAlignment: ContentViewAlignment {
    get {
      return toolbar.contentViewAlignment
    }
    set(value) {
      toolbar.contentViewAlignment = value
    }
  }
  
  /// Content View.
  open var contentView: UIView {
    return toolbar.contentView
  }
  
  /// Back Button.
  open var backButton: IconButton {
    return navigationItem.backButton
  }
  
  /// Title Label.
  open var titleLabel: UILabel {
    return toolbar.titleLabel
  }
  
  /// Detail Label.
  open var detailLabel: UILabel {
    return toolbar.detailLabel
  }
  
  /// Left side UIViews.
  open var leftViews: [UIView] {
    get {
      return toolbar.leftViews
    }
    set(value) {
      toolbar.leftViews = value
    }
  }
  
  /// Right side UIViews.
  open var rightViews: [UIView] {
    get {
      return toolbar.rightViews
    }
    set(value) {
      toolbar.rightViews = value
    }
  }
  
  /// Center UIViews.
  open var centerViews: [UIView] {
    get {
      return toolbar.centerViews
    }
    set(value) {
      toolbar.centerViews = value
    }
  }
}
