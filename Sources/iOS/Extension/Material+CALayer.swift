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

fileprivate class MaterialLayer {
  /// A reference to the CALayer.
  fileprivate weak var layer: CALayer?
  
  /// A property that sets the height of the layer's frame.
  fileprivate var heightPreset = HeightPreset.default {
    didSet {
      layer?.height = heightPreset.rawValue
    }
  }
  
  /// A property that sets the cornerRadius of the backing layer.
  fileprivate var cornerRadiusPreset = CornerRadiusPreset.none {
    didSet {
      layer?.cornerRadius = CornerRadiusPresetToValue(preset: cornerRadiusPreset)
    }
  }
  
  /// A preset property to set the borderWidth.
  fileprivate var borderWidthPreset = BorderWidthPreset.none {
    didSet {
      layer?.borderWidth = borderWidthPreset.cgFloatValue
    }
  }
  
  /// A preset property to set the shape.
  fileprivate var shapePreset = ShapePreset.none {
    didSet {
      layer?.layoutShape()
    }
  }
  
  /// A preset value for Depth.
  fileprivate var depthPreset: DepthPreset {
    get {
      return depth.preset
    }
    set(value) {
      depth.preset = value
    }
  }
  
  /// Grid reference.
  fileprivate var depth = Depth.zero {
    didSet {
      guard let v = layer else {
        return
      }
      
      v.shadowOffset = depth.offset.asSize
      v.shadowOpacity = depth.opacity
      v.shadowRadius = depth.radius
      v.layoutShadowPath()
    }
  }
  
  /// Enables automatic shadowPath sizing.
  fileprivate var isShadowPathAutoSizing = false
  
  /**
   Initializer that takes in a CALayer.
   - Parameter view: A CALayer reference.
   */
  fileprivate init(layer: CALayer?) {
    self.layer = layer
  }
}

fileprivate var MaterialLayerKey: UInt8 = 0

extension CALayer {
  /// MaterialLayer Reference.
  fileprivate var materialLayer: MaterialLayer {
    get {
      return AssociatedObject.get(base: self, key: &MaterialLayerKey) {
        return MaterialLayer(layer: self)
      }
    }
    set(value) {
      AssociatedObject.set(base: self, key: &MaterialLayerKey, value: value)
    }
  }
  
  /// A property that accesses the frame.origin.x property.
  @IBInspectable
  open var x: CGFloat {
    get {
      return frame.origin.x
    }
    set(value) {
      frame.origin.x = value
      
      layoutShadowPath()
    }
  }
  
  /// A property that accesses the frame.origin.y property.
  @IBInspectable
  open var y: CGFloat {
    get {
      return frame.origin.y
    }
    set(value) {
      frame.origin.y = value
      
      layoutShadowPath()
    }
  }
  
  /// A property that accesses the frame.size.width property.
  @IBInspectable
  open var width: CGFloat {
    get {
      return frame.size.width
    }
    set(value) {
      frame.size.width = value
      
      if .none != shapePreset {
        frame.size.height = value
        layoutShape()
      }
      
      layoutShadowPath()
    }
  }
  
  /// A property that accesses the frame.size.height property.
  @IBInspectable
  open var height: CGFloat {
    get {
      return frame.size.height
    }
    set(value) {
      frame.size.height = value
      
      if .none != shapePreset {
        frame.size.width = value
        layoutShape()
      }
      
      layoutShadowPath()
    }
  }
  
  /// HeightPreset value.
  open var heightPreset: HeightPreset {
    get {
      return materialLayer.heightPreset
    }
    set(value) {
      materialLayer.heightPreset = value
    }
  }
  
  /**
   A property that manages the overall shape for the object. If either the
   width or height property is set, the other will be automatically adjusted
   to maintain the shape of the object.
   */
  open var shapePreset: ShapePreset {
    get {
      return materialLayer.shapePreset
    }
    set(value) {
      materialLayer.shapePreset = value
    }
  }
  
  /// A preset value for Depth.
  open var depthPreset: DepthPreset {
    get {
      return depth.preset
    }
    set(value) {
      depth.preset = value
    }
  }
  
  /// Grid reference.
  open var depth: Depth {
    get {
      return materialLayer.depth
    }
    set(value) {
      materialLayer.depth = value
    }
  }
  
  /// Enables automatic shadowPath sizing.
  @IBInspectable
  open var isShadowPathAutoSizing: Bool {
    get {
      return materialLayer.isShadowPathAutoSizing
    }
    set(value) {
      materialLayer.isShadowPathAutoSizing = value
    }
  }
  
  /// A property that sets the cornerRadius of the backing layer.
  open var cornerRadiusPreset: CornerRadiusPreset {
    get {
      return materialLayer.cornerRadiusPreset
    }
    set(value) {
      materialLayer.cornerRadiusPreset = value
    }
  }
  
  /// A preset property to set the borderWidth.
  open var borderWidthPreset: BorderWidthPreset {
    get {
      return materialLayer.borderWidthPreset
    }
    set(value) {
      materialLayer.borderWidthPreset = value
    }
  }
}

extension CALayer {
  /// Manages the layout for the shape of the view instance.
  open func layoutShape() {
    guard .none != shapePreset else {
      return
    }
    
    if 0 == bounds.width {
      bounds.size.width = bounds.height
    }
    
    if 0 == bounds.height {
      bounds.size.height = bounds.width
    }
    
    guard .circle == shapePreset else {
      cornerRadius = 0
      return
    }
    
    cornerRadius = bounds.width / 2
  }
  
  /// Sets the shadow path.
  open func layoutShadowPath() {
    guard isShadowPathAutoSizing else {
      return
    }
    
    if case .none = depthPreset.rawValue {
      shadowPath = nil
    } else if nil == shadowPath {
      shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius).cgPath
    } else {
      animate(.shadow(path: UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius).cgPath))
    }
  }
}
