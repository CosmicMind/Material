/*
 * Copyright (C) 2015 - 2018, Daniel Dahan and CosmicMind, Inc. <http://cosmicmind.com>.
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
