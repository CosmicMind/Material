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

open class Button: UIButton, Pulseable, PulseableLayer, Themeable {
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
  
  /// A property that accesses the backing layer's background
  @IBInspectable
  open override var backgroundColor: UIColor? {
    didSet {
      layer.backgroundColor = backgroundColor?.cgColor
    }
  }
  
  /// A preset property for updated contentEdgeInsets.
  open var contentEdgeInsetsPreset = EdgeInsetsPreset.none {
    didSet {
      contentEdgeInsets = EdgeInsetsPresetToValue(preset: contentEdgeInsetsPreset)
    }
  }
  
  /// Sets the normal and highlighted image for the button.
  @IBInspectable
  open var image: UIImage? {
    didSet {
      setImage(image, for: .normal)
      setImage(image, for: .selected)
      setImage(image, for: .highlighted)
      setImage(image, for: .disabled)
      
      if #available(iOS 9, *) {
        setImage(image, for: .application)
        setImage(image, for: .focused)
        setImage(image, for: .reserved)
      }
    }
  }
  
  /// Sets the normal and highlighted title for the button.
  @IBInspectable
  open var title: String? {
    didSet {
      setTitle(title, for: .normal)
      setTitle(title, for: .selected)
      setTitle(title, for: .highlighted)
      setTitle(title, for: .disabled)
      
      if #available(iOS 9, *) {
        setTitle(title, for: .application)
        setTitle(title, for: .focused)
        setTitle(title, for: .reserved)
      }
      
      guard nil != title else {
        return
      }
      
      guard nil == titleColor else {
        return
      }
      
      titleColor = Color.blue.base
    }
  }
  
  /// Sets the normal and highlighted titleColor for the button.
  @IBInspectable
  open var titleColor: UIColor? {
    didSet {
      setTitleColor(titleColor, for: .normal)
      setTitleColor(titleColor, for: .highlighted)
      setTitleColor(titleColor, for: .disabled)
      
      if nil == selectedTitleColor {
        setTitleColor(titleColor, for: .selected)
      }
      
      if #available(iOS 9, *) {
        setTitleColor(titleColor, for: .application)
        setTitleColor(titleColor, for: .focused)
        setTitleColor(titleColor, for: .reserved)
      }
    }
  }
  
  /// Sets the selected titleColor for the button.
  @IBInspectable
  open var selectedTitleColor: UIColor? {
    didSet {
      setTitleColor(selectedTitleColor, for: .selected)
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
    /// Set these here to avoid overriding storyboard values
    tintColor = Color.blue.base
    titleLabel?.font = Theme.font.regular(with: fontSize)
    prepare()
  }
  
  /**
   A convenience initializer that acceps an image and tint
   - Parameter image: A UIImage.
   - Parameter tintColor: A UIColor.
   */
  public init(image: UIImage?, tintColor: UIColor? = nil) {
    super.init(frame: .zero)
    prepare()
    prepare(with: image, tintColor: tintColor)
  }
  
  /**
   A convenience initializer that acceps a title and title
   - Parameter title: A String.
   - Parameter titleColor: A UIColor.
   */
  public init(title: String?, titleColor: UIColor? = nil) {
    super.init(frame: .zero)
    prepare()
    prepare(with: title, titleColor: titleColor)
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
  
  open func bringImageViewToFront() {
    guard let v = imageView else {
      return
    }
    
    bringSubviewToFront(v)
  }
  
  /**
   Prepares the view instance when intialized. When subclassing,
   it is recommended to override the prepare method
   to initialize property values and other setup operations.
   The super.prepare method should always be called immediately
   when subclassing.
   */
  open func prepare() {
    contentScaleFactor = Screen.scale
    prepareVisualLayer()
    preparePulse()
    applyCurrentTheme()
  }
  
  /**
   Applies the given theme.
   - Parameter theme: A Theme.
   */
  open func apply(theme: Theme) { }
}

extension Button {
  /// Prepares the visualLayer property.
  fileprivate func prepareVisualLayer() {
    visualLayer.zPosition = 0
    visualLayer.masksToBounds = true
    layer.addSublayer(visualLayer)
  }
  
  /// Prepares the pulse motion.
  fileprivate func preparePulse() {
    pulse = Pulse(pulseView: self, pulseLayer: visualLayer)
  }
  
  /**
   Prepares the Button with an image and tint
   - Parameter image: A UIImage.
   - Parameter tintColor: A UI
   */
  fileprivate func prepare(with image: UIImage?, tintColor: UIColor?) {
    self.image = image
    self.tintColor = tintColor ?? self.tintColor
  }
  
  /**
   Prepares the Button with a title and title
   - Parameter title: A String.
   - Parameter titleColor: A UI
   */
  fileprivate func prepare(with title: String?, titleColor: UIColor?) {
    self.title = title
    self.titleColor = titleColor ?? self.titleColor
  }
}

extension Button {
  /// Manages the layout for the visualLayer property.
  fileprivate func layoutVisualLayer() {
    visualLayer.frame = bounds
    visualLayer.cornerRadius = layer.cornerRadius
  }
}
