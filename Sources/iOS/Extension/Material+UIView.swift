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

extension UIView {
  /// A property that accesses the backing layer's shadow
  @objc
  open var shadowColor: UIColor? {
    get {
      guard let v = layer.shadowColor else {
        return nil
      }
      
      return UIColor(cgColor: v)
    }
    set(value) {
      layer.shadowColor = value?.cgColor
    }
  }
  
  /// A property that accesses the layer.borderColor property.
  @objc
  open var borderColor: UIColor? {
    get {
      guard let v = layer.borderColor else {
        return nil
      }
      return UIColor(cgColor: v)
    }
    set(value) {
      layer.borderColor = value?.cgColor
    }
  }
  
  /// HeightPreset value.
  open var heightPreset: HeightPreset {
    get {
      return layer.heightPreset
    }
    set(value) {
      layer.heightPreset = value
    }
  }
  
  /**
   A property that manages the overall shape for the object. If either the
   width or height property is set, the other will be automatically adjusted
   to maintain the shape of the object.
   */
  @objc
  open var shapePreset: ShapePreset {
    get {
      return layer.shapePreset
    }
    set(value) {
      layer.shapePreset = value
    }
  }
  
  /// A preset value for Depth.
  open var depthPreset: DepthPreset {
    get {
      return layer.depthPreset
    }
    set(value) {
      layer.depthPreset = value
    }
  }
  
  /// Depth reference.
  open var depth: Depth {
    get {
      return layer.depth
    }
    set(value) {
      layer.depth = value
    }
  }
  
  /// Enables automatic shadowPath sizing.
  @IBInspectable
  @objc
  open var isShadowPathAutoSizing: Bool {
    get {
      return layer.isShadowPathAutoSizing
    }
    set(value) {
      layer.isShadowPathAutoSizing = value
    }
  }
  
  /// A property that sets the cornerRadius of the backing layer.
  @objc
  open var cornerRadiusPreset: CornerRadiusPreset {
    get {
      return layer.cornerRadiusPreset
    }
    set(value) {
      layer.cornerRadiusPreset = value
    }
  }
  
  /// A preset property to set the borderWidth.
  @objc
  open var borderWidthPreset: BorderWidthPreset {
    get {
      return layer.borderWidthPreset
    }
    set(value) {
      layer.borderWidthPreset = value
    }
  }
}

internal extension UIView {
  /// Manages the layout for the shape of the view instance.
  func layoutShape() {
    layer.layoutShape()
  }
  
  /// Sets the shadow path.
  func layoutShadowPath() {
    layer.layoutShadowPath()
  }
}
