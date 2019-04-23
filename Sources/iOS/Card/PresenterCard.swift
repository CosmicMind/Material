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

open class PresenterCard: Card {
  /// A preset wrapper around presenterViewEdgeInsets.
  open var presenterViewEdgeInsetsPreset = EdgeInsetsPreset.none {
    didSet {
      presenterViewEdgeInsets = EdgeInsetsPresetToValue(preset: presenterViewEdgeInsetsPreset)
    }
  }
  
  /// A reference to presenterViewEdgeInsets.
  @IBInspectable
  open var presenterViewEdgeInsets = EdgeInsets.zero {
    didSet {
      layoutSubviews()
    }
  }
  
  /// A reference to the presenterView.
  @IBInspectable
  open var presenterView: UIView? {
    didSet {
      oldValue?.removeFromSuperview()
      
      if let v = presenterView {
        v.clipsToBounds = true
        container.addSubview(v)
      }
      
      layoutSubviews()
    }
  }
  
  open override func reload() {
    var h: CGFloat = 0
    
    if let v = toolbar {
      h = prepare(view: v, with: toolbarEdgeInsets, from: h)
    }
    
    if let v = presenterView {
      h = prepare(view: v, with: presenterViewEdgeInsets, from: h)
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
}
