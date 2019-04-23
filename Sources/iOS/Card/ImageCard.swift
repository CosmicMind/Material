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

open class ImageCard: Card {
  /**
   A Display value to indicate whether or not to
   display the imageView to the full view
   bounds.
   */
  open var displayStyle = DisplayStyle.partial {
    didSet {
      layoutSubviews()
    }
  }
  
  /// A preset wrapper around imageViewEdgeInsets.
  open var imageViewEdgeInsetsPreset = EdgeInsetsPreset.none {
    didSet {
      imageViewEdgeInsets = EdgeInsetsPresetToValue(preset: imageViewEdgeInsetsPreset)
    }
  }
  
  /// A reference to imageViewEdgeInsets.
  @IBInspectable
  open var imageViewEdgeInsets = EdgeInsets.zero {
    didSet {
      layoutSubviews()
    }
  }
  
  /// A reference to the imageView.
  @IBInspectable
  open var imageView: UIImageView? {
    didSet {
      oldValue?.removeFromSuperview()
      
      if let v = imageView {
        container.addSubview(v)
      }
      
      layoutSubviews()
    }
  }
  
  /// An ImageCardToolbarAlignment value.
  open var toolbarAlignment = ToolbarAlignment.bottom {
    didSet {
      layoutSubviews()
    }
  }
  
  /// Reloads the view.
  open override func reload() {
    var h: CGFloat = 0
    
    if let v = imageView {
      h = prepare(view: v, with: imageViewEdgeInsets, from: h)
      container.sendSubviewToBack(v)
    }
    
    if let v = toolbar {
      prepare(view: v, with: toolbarEdgeInsets, from: h)
      v.frame.origin.y = .top == toolbarAlignment ? toolbarEdgeInsets.top : h - v.bounds.height - toolbarEdgeInsets.bottom
      container.bringSubviewToFront(v)
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
