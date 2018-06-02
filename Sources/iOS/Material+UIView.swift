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
  @objc
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
  @objc
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
