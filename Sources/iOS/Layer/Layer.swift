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

@objc(Layer)
open class Layer: CAShapeLayer {
  /**
   A CAShapeLayer used to manage elements that would be affected by
   the clipToBounds property of the backing layer. For example, this
   allows the dropshadow effect on the backing layer, while clipping
   the image to a desired shape within the visualLayer.
   */
  public let visualLayer = CAShapeLayer()
  
  /**
   A property that manages an image for the visualLayer's contents
   property. Images should not be set to the backing layer's contents
   property to avoid conflicts when using clipsToBounds.
   */
  @IBInspectable
  open var image: UIImage? {
    didSet {
      visualLayer.contents = image?.cgImage
    }
  }
  
  /**
   Allows a relative subrectangle within the range of 0 to 1 to be
   specified for the visualLayer's contents property. This allows
   much greater flexibility than the contentsGravity property in
   terms of how the image is cropped and stretched.
   */
  open override var contentsRect: CGRect {
    didSet {
      visualLayer.contentsRect = contentsRect
    }
  }
  
  /**
   A CGRect that defines a stretchable region inside the visualLayer
   with a fixed border around the edge.
   */
  open override var contentsCenter: CGRect {
    didSet {
      visualLayer.contentsCenter = contentsCenter
    }
  }
  
  /**
   A floating point value that defines a ratio between the pixel
   dimensions of the visualLayer's contents property and the size
   of the layer. By default, this value is set to the Screen.scale.
   */
  @IBInspectable
  open override var contentsScale: CGFloat {
    didSet {
      visualLayer.contentsScale = contentsScale
    }
  }
  
  /// Determines how content should be aligned within the visualLayer's bounds.
  @IBInspectable
  open override var contentsGravity: CALayerContentsGravity {
    get {
      return visualLayer.contentsGravity
    }
    set(value) {
      visualLayer.contentsGravity = value
    }
  }
  
  /**
   A property that sets the cornerRadius of the backing layer. If the shape
   property has a value of .circle when the cornerRadius is set, it will
   become .none, as it no longer maintains its circle shape.
   */
  @IBInspectable
  open override var cornerRadius: CGFloat {
    didSet {
      layoutShadowPath()
      shapePreset = .none
    }
  }
  
  /**
   An initializer that initializes the object with a NSCoder object.
   - Parameter aDecoder: A NSCoder instance.
   */
  public required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    prepareVisualLayer()
  }
  
  /**
   An initializer the same as init(). The layer parameter is ignored
   to avoid crashes on certain architectures.
   - Parameter layer: Any.
   */
  public override init(layer: Any) {
    super.init(layer: layer)
    prepareVisualLayer()
  }
  
  /// A convenience initializer.
  public override init() {
    super.init()
    prepareVisualLayer()
  }
  
  /**
   An initializer that initializes the object with a CGRect object.
   - Parameter frame: A CGRect instance.
   */
  public convenience init(frame: CGRect) {
    self.init()
    self.frame = frame
  }
  
  open override func layoutSublayers() {
    super.layoutSublayers()
    layoutShape()
    layoutVisualLayer()
    layoutShadowPath()
  }
}

fileprivate extension Layer {
  /// Prepares the visualLayer property.
  func prepareVisualLayer() {
    contentsGravity = .resizeAspectFill
    visualLayer.zPosition = 0
    visualLayer.masksToBounds = true
    addSublayer(visualLayer)
  }
  
  /// Manages the layout for the visualLayer property.
  func layoutVisualLayer() {
    visualLayer.frame = bounds
    visualLayer.cornerRadius = cornerRadius
  }
}
