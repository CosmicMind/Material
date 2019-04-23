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

@objc(CollectionReusableView)
open class CollectionReusableView: UICollectionReusableView, Pulseable, PulseableLayer {
  /**
   A CAShapeLayer used to manage elements that would be affected by
   the clipToBounds property of the backing layer. For example, this
   allows the dropshadow effect on the backing layer, while clipping
   the image to a desired shape within the visualLayer.
   */
  public let visualLayer = CAShapeLayer()
  
  /// A Pulse reference.
  internal var pulse: Pulse!
  
  /// A reference to the pulse layer.
  internal var pulseLayer: CALayer? {
    return pulse.pulseLayer
  }
  
  /// PulseAnimation value.
  open var pulseAnimation: PulseAnimation {
    get {
      return pulse.animation
    }
    set(value) {
      pulse.animation = value
    }
  }
  
  /// PulseAnimation color.
  @IBInspectable
  open var pulseColor: UIColor {
    get {
      return pulse.color
    }
    set(value) {
      pulse.color = value
    }
  }
  
  /// Pulse opacity.
  @IBInspectable
  open var pulseOpacity: CGFloat {
    get {
      return pulse.opacity
    }
    set(value) {
      pulse.opacity = value
    }
  }
  
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
  
  /// A preset wrapper around contentEdgeInsets.
  open var contentEdgeInsetsPreset: EdgeInsetsPreset {
    get {
      return grid.contentEdgeInsetsPreset
    }
    set(value) {
      grid.contentEdgeInsetsPreset = value
    }
  }
  
  /// A reference to EdgeInsets.
  @IBInspectable
  open var contentEdgeInsets: UIEdgeInsets {
    get {
      return grid.contentEdgeInsets
    }
    set(value) {
      grid.contentEdgeInsets = value
    }
  }
  
  /// A preset wrapper around interimSpace.
  open var interimSpacePreset: InterimSpacePreset {
    get {
      return grid.interimSpacePreset
    }
    set(value) {
      grid.interimSpacePreset = value
    }
  }
  
  /// A wrapper around grid.interimSpace.
  @IBInspectable
  open var interimSpace: InterimSpace {
    get {
      return grid.interimSpace
    }
    set(value) {
      grid.interimSpace = value
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
   Triggers the pulse animation.
   - Parameter point: A Optional point to pulse from, otherwise pulses
   from the center.
   */
  open func pulse(point: CGPoint? = nil) {
    pulse.expand(point: point ?? center)
    Motion.delay(0.35) { [weak self] in
      self?.pulse.contract()
    }
  }
  
  /**
   A delegation method that is executed when the view has began a
   touch event.
   - Parameter touches: A set of UITouch objects.
   - Parameter event: A UIEvent object.
   */
  open override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    super.touchesBegan(touches, with: event)
    pulse.expand(point: layer.convert(touches.first!.location(in: self), from: layer))
  }
  
  /**
   A delegation method that is executed when the view touch event has
   ended.
   - Parameter touches: A set of UITouch objects.
   - Parameter event: A UIEvent object.
   */
  open override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
    super.touchesEnded(touches, with: event)
    pulse.contract()
  }
  
  /**
   A delegation method that is executed when the view touch event has
   been cancelled.
   - Parameter touches: A set of UITouch objects.
   - Parameter event: A UIEvent object.
   */
  open override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
    super.touchesCancelled(touches, with: event)
    pulse.contract()
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
    prepareVisualLayer()
    preparePulse()
  }
}

extension CollectionReusableView {
  /// Prepares the pulse motion.
  fileprivate func preparePulse() {
    pulse = Pulse(pulseView: self, pulseLayer: visualLayer)
    pulseAnimation = .none
  }
  
  /// Prepares the visualLayer property.
  fileprivate func prepareVisualLayer() {
    visualLayer.zPosition = 0
    visualLayer.masksToBounds = true
    layer.addSublayer(visualLayer)
  }
}

extension CollectionReusableView {
  /// Manages the layout for the visualLayer property.
  fileprivate func layoutVisualLayer() {
    visualLayer.frame = bounds
    visualLayer.cornerRadius = layer.cornerRadius
  }
}
