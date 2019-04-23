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

open class View: UIView {
  open override var intrinsicContentSize: CGSize {
    return bounds.size
  }
  
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
    get {
      guard let v = visualLayer.contents else {
        return nil
      }
      
      return UIImage(cgImage: v as! CGImage)
    }
    set(value) {
      visualLayer.contents = value?.cgImage
    }
  }
  
  /**
   Allows a relative subrectangle within the range of 0 to 1 to be
   specified for the visualLayer's contents property. This allows
   much greater flexibility than the contentsGravity property in
   terms of how the image is cropped and stretched.
   */
  @IBInspectable
  open var contentsRect: CGRect {
    get {
      return visualLayer.contentsRect
    }
    set(value) {
      visualLayer.contentsRect = value
    }
  }
  
  /**
   A CGRect that defines a stretchable region inside the visualLayer
   with a fixed border around the edge.
   */
  @IBInspectable
  open var contentsCenter: CGRect {
    get {
      return visualLayer.contentsCenter
    }
    set(value) {
      visualLayer.contentsCenter = value
    }
  }
  
  /**
   A floating point value that defines a ratio between the pixel
   dimensions of the visualLayer's contents property and the size
   of the view. By default, this value is set to the Screen.scale.
   */
  @IBInspectable
  open var contentsScale: CGFloat {
    get {
      return visualLayer.contentsScale
    }
    set(value) {
      visualLayer.contentsScale = value
    }
  }
  
  /// Determines how content should be aligned within the visualLayer's bounds.
  @IBInspectable
  open var contentsGravity: CALayerContentsGravity {
    get {
      return visualLayer.contentsGravity
    }
    set(value) {
      visualLayer.contentsGravity = value
    }
  }
  
  /// A property that accesses the backing layer's background
  @IBInspectable
  open override var backgroundColor: UIColor? {
    didSet {
      layer.backgroundColor = backgroundColor?.cgColor
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
  
  open override func layoutSubviews() {
    super.layoutSubviews()
    layoutShape()
    layoutVisualLayer()
    layoutShadowPath()
  }
  
  /**
   Prepares the view instance when intialized. When subclassing,
   it is recommended to override the prepare method
   to initialize property values and other setup operations.
   The super.prepare method should always be called immediately
   when subclassing.
   */
  open func prepare() {
    contentsGravity = .resizeAspectFill
    contentScaleFactor = Screen.scale
    backgroundColor = .white
    prepareVisualLayer()
  }
}

extension View {
  /// Prepares the visualLayer property.
  fileprivate func prepareVisualLayer() {
    visualLayer.zPosition = 0
    visualLayer.masksToBounds = true
    layer.addSublayer(visualLayer)
  }
}

extension View {
  /// Manages the layout for the visualLayer property.
  fileprivate func layoutVisualLayer() {
    visualLayer.frame = bounds
    visualLayer.cornerRadius = layer.cornerRadius
  }
}
