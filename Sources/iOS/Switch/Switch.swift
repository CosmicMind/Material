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

@objc(SwitchState)
public enum SwitchState: Int {
  case on
  case off
}

public enum SwitchSize {
  case small
  case medium
  case large
  case custom(width: CGFloat, height: CGFloat)
}

@objc(SwitchDelegate)
public protocol SwitchDelegate {
  /**
   A Switch delegate method for state changes.
   - Parameter control: Switch control.
   - Parameter state: SwitchState value.
   */
  func switchDidChangeState(control: Switch, state: SwitchState)
}

open class Switch: UIControl, Themeable {
  /// Will layout the view.
  open var willLayout: Bool {
    return 0 < bounds.width && 0 < bounds.height && nil != superview
  }
  
  /// An internal reference to the switchState public property.
  fileprivate var internalSwitchState = SwitchState.off
  
  /// Track thickness.
  open var trackThickness: CGFloat = 0 {
    didSet {
      layoutSubviews()
    }
  }
  
  /// Button diameter.
  open var buttonDiameter: CGFloat = 0 {
    didSet {
      layoutSubviews()
    }
  }
  
  /// Position when in the .on state.
  fileprivate var onPosition: CGFloat = 0
  
  /// Position when in the .off state.
  fileprivate var offPosition: CGFloat = 0
  
  /// The bounce offset when animating.
  fileprivate var bounceOffset: CGFloat = 3
  
  /// An Optional delegation method.
  open weak var delegate: SwitchDelegate?
  
  /// Indicates if the animation should bounce.
  @IBInspectable
  open var isBounceable = true {
    didSet {
      bounceOffset = isBounceable ? 3 : 0
    }
  }
  
  /// Button on color.
  @IBInspectable
  open var buttonOnColor = Color.clear {
    didSet {
      styleForState(state: switchState)
    }
  }
  
  /// Button off color.
  @IBInspectable
  open var buttonOffColor = Color.clear {
    didSet {
      styleForState(state: switchState)
    }
  }
  
  /// Button on image.
  @IBInspectable
  open var buttonOnImage: UIImage? {
    didSet {
      styleForState(state: switchState)
    }
  }
  
  /// Button off image.
  @IBInspectable
  open var buttonOffImage: UIImage? {
    didSet {
      styleForState(state: switchState)
    }
  }
  
  /// Track on color.
  @IBInspectable
  open var trackOnColor = Color.clear {
    didSet {
      styleForState(state: switchState)
    }
  }
  
  /// Track off color.
  @IBInspectable
  open var trackOffColor = Color.clear {
    didSet {
      styleForState(state: switchState)
    }
  }
  
  /// Button on disabled color.
  @IBInspectable
  open var buttonOnDisabledColor = Color.clear {
    didSet {
      styleForState(state: switchState)
    }
  }
  
  /// Track on disabled color.
  @IBInspectable
  open var trackOnDisabledColor = Color.clear {
    didSet {
      styleForState(state: switchState)
    }
  }
  
  /// Button off disabled color.
  @IBInspectable
  open var buttonOffDisabledColor = Color.clear {
    didSet {
      styleForState(state: switchState)
    }
  }
  
  /// Track off disabled color.
  @IBInspectable
  open var trackOffDisabledColor = Color.clear {
    didSet {
      styleForState(state: switchState)
    }
  }
  
  /// Button on disabled image.
  @IBInspectable
  open var buttonOnDisabledImage: UIImage? {
    didSet {
      styleForState(state: switchState)
    }
  }
  
  /// Button off disabled image.
  @IBInspectable
  open var buttonOffDisabledImage: UIImage? {
    didSet {
      styleForState(state: switchState)
    }
  }
  
  
  /// Track view reference.
  open fileprivate(set) var track: UIView {
    didSet {
      prepareTrack()
    }
  }
  
  /// Button view reference.
  open fileprivate(set) var button: FABButton {
    didSet {
      prepareButton()
    }
  }
  
  @IBInspectable
  open override var isEnabled: Bool {
    didSet {
      styleForState(state: internalSwitchState)
    }
  }
  
  /// A boolean indicating if the switch is on or not.
  @IBInspectable
  public var isOn: Bool {
    get {
      return .on == internalSwitchState
    }
    set(value) {
      updateSwitchState(state: value ? .on : .off, animated: true, isTriggeredByUserInteraction: false)
    }
  }
  
  /// Switch state.
  open var switchState: SwitchState {
    get {
      return internalSwitchState
    }
    set(value) {
      updateSwitchState(state: value, animated: true, isTriggeredByUserInteraction: false)
    }
  }
  
  /// Switch size.
  open var switchSize = SwitchSize.medium {
    didSet {
      switch switchSize {
      case .small:
        trackThickness = 16
        buttonDiameter = 20
      case .medium:
        trackThickness = 20
        buttonDiameter = 24
      case .large:
        trackThickness = 24
        buttonDiameter = 28
      case .custom:
        break
      }
      
      frame.size = intrinsicContentSize
    }
  }
  
  open override var intrinsicContentSize: CGSize {
    switch switchSize {
    case .small:
      return CGSize(width: 34, height: 34)
    case .medium:
      return CGSize(width: 38, height: 38)
    case .large:
      return CGSize(width: 42, height: 42)
    case .custom(let width, let height):
      return CGSize(width: width, height: height)
    }
  }
  
  /**
   An initializer that initializes the object with a NSCoder object.
   - Parameter aDecoder: A NSCoder instance.
   */
  public required init?(coder aDecoder: NSCoder) {
    track = UIView()
    button = FABButton()
    super.init(coder: aDecoder)
    prepare()
  }
  
  /**
   An initializer that initializes the object with a CGRect object.
   If AutoLayout is used, it is better to initilize the instance
   using the init(state:style:size:) initializer, or set the CGRect
   to CGRectNull.
   - Parameter frame: A CGRect instance.
   */
  public override init(frame: CGRect) {
    track = UIView()
    button = FABButton()
    super.init(frame: frame)
    prepare()
  }
  
  /**
   An initializer that sets the state, style, and size of the Switch instance.
   - Parameter state: A SwitchState value.
   - Parameter style: A SwitchStyle value.
   - Parameter size: A SwitchSize value.
   */
  public init(state: SwitchState = .off, size: SwitchSize = .medium) {
    track = UIView()
    button = FABButton()
    super.init(frame: .zero)
    prepare()
    prepareSwitchState(state: state)
    prepareSwitchSize(size: size)
  }
  
  open override func layoutSubviews() {
    super.layoutSubviews()
    guard willLayout else {
      return
    }
    
    reload()
  }
  
  /// Reloads the view.
  open func reload() {
    let w: CGFloat = intrinsicContentSize.width
    let px: CGFloat = (bounds.width - w) / 2
    
    track.frame = CGRect(x: px, y: (bounds.height - trackThickness) / 2, width: w, height: trackThickness)
    track.layer.cornerRadius = min(w, trackThickness) / 2
    
    button.frame = CGRect(x: px, y: (bounds.height - buttonDiameter) / 2, width: buttonDiameter, height: buttonDiameter)
    onPosition = bounds.width - px - buttonDiameter
    offPosition = px
    
    if .on == internalSwitchState {
      button.frame.origin.x = onPosition
    }
  }
  
  open override func willMove(toSuperview newSuperview: UIView?) {
    super.willMove(toSuperview: newSuperview)
    styleForState(state: internalSwitchState)
  }
  
  /**
   Toggle the Switch state, if On will be Off, and if Off will be On.
   - Parameter completion: An Optional completion block.
   */
  open func toggle(completion: ((Switch) -> Void)? = nil) {
    updateSwitchState(state: .on == internalSwitchState ? .off : .on, animated: true, isTriggeredByUserInteraction: false, completion: completion)
  }
  
  open override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    guard track.frame.contains(layer.convert(touches.first!.location(in: self), from: layer)) else {
      return
    }
    
    updateSwitchState(state: .on == internalSwitchState ? .on : .off, animated: true, isTriggeredByUserInteraction: true)
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
    prepareTrack()
    prepareButton()
    prepareSwitchState()
    prepareSwitchSize()
    applyCurrentTheme()
  }
  
  /**
   Applies the given theme.
   - Parameter theme: A Theme.
   */
  open func apply(theme: Theme) {
    buttonOnColor = theme.secondary
    trackOnColor = theme.secondary.withAlphaComponent(0.60)
    buttonOffColor = theme.surface.blend(with: theme.onSurface.withAlphaComponent(0.15).blend(with: theme.secondary.withAlphaComponent(0.06)))
    trackOffColor = theme.onSurface.withAlphaComponent(0.12)
    
    buttonOnDisabledColor = theme.surface.blend(with: theme.onSurface.withAlphaComponent(0.15))
    trackOnDisabledColor = theme.onSurface.withAlphaComponent(0.15)
    buttonOffDisabledColor = buttonOnDisabledColor
    trackOffDisabledColor = trackOnDisabledColor
  }
}

extension Switch {
  /**
   Set the switchState property with an option to animate.
   - Parameter state: The SwitchState to set.
   - Parameter animated: A Boolean indicating to set the animation or not.
   - Parameter completion: An Optional completion block.
   */
  open func setSwitchState(state: SwitchState, animated: Bool = true, completion: ((Switch) -> Void)? = nil) {
    updateSwitchState(state: state, animated: animated, isTriggeredByUserInteraction: false, completion: completion)
  }
}

fileprivate extension Switch {
  /**
   Set the switchState property with an option to animate.
   - Parameter state: The SwitchState to set.
   - Parameter animated: A Boolean indicating to set the animation or not.
   - Parameter isTriggeredByUserInteraction: A boolean indicating whether the
   state was changed by a user interaction, true if yes, false otherwise.
   - Parameter completion: An Optional completion block.
   */
  func updateSwitchState(state: SwitchState, animated: Bool, isTriggeredByUserInteraction: Bool, completion: ((Switch) -> Void)? = nil) {
    guard isEnabled && internalSwitchState != state else {
      return
    }
    
    internalSwitchState = state
    
    if animated {
      animateToState(state: state) { [weak self, isTriggeredByUserInteraction = isTriggeredByUserInteraction] _ in
        guard let s = self else {
          return
        }
        
        guard isTriggeredByUserInteraction else {
          completion?(s)
          return
        }
        
        s.sendActions(for: .valueChanged)
        completion?(s)
        s.delegate?.switchDidChangeState(control: s, state: s.internalSwitchState)
      }
    } else {
      button.frame.origin.x = .on == state ? self.onPosition : self.offPosition
      styleForState(state: state)
      
      guard isTriggeredByUserInteraction else {
        completion?(self)
        return
      }
      
      sendActions(for: .valueChanged)
      completion?(self)
      delegate?.switchDidChangeState(control: self, state: internalSwitchState)
    }
  }
  
  /**
   Updates the coloring for the enabled state.
   - Parameter state: SwitchState.
   */
  func updateColorForState(state: SwitchState) {
    if .on == state {
      button.backgroundColor = buttonOnColor
      track.backgroundColor = trackOnColor
      button.image = buttonOnImage
    } else {
      button.backgroundColor = buttonOffColor
      track.backgroundColor = trackOffColor
      button.image = buttonOffImage
    }
  }
  
  /**
   Updates the coloring for the disabled state.
   - Parameter state: SwitchState.
   */
  func updateColorForDisabledState(state: SwitchState) {
    if .on == state {
      button.backgroundColor = buttonOnDisabledColor
      track.backgroundColor = trackOnDisabledColor
      button.image = buttonOnDisabledImage
    } else {
      button.backgroundColor = buttonOffDisabledColor
      track.backgroundColor = trackOffDisabledColor
      button.image = buttonOffDisabledImage
    }
  }
  
  /**
   Updates the style based on the state.
   - Parameter state: The SwitchState to set the style to.
   */
  func styleForState(state: SwitchState) {
    if isEnabled {
      updateColorForState(state: state)
      
    } else {
      updateColorForDisabledState(state: state)
    }
  }
}

fileprivate extension Switch {
  /**
   Set the switchState property with an animate.
   - Parameter state: The SwitchState to set.
   - Parameter completion: An Optional completion block.
   */
  func animateToState(state: SwitchState, completion: ((Switch) -> Void)? = nil) {
    isUserInteractionEnabled = false
    UIView.animate(withDuration: 0.15,
                   delay: 0.05,
                   options: [.curveEaseIn, .curveEaseOut],
                   animations: { [weak self] in
                    guard let s = self else {
                      return
                    }
                    
                    s.button.frame.origin.x = .on == state ? s.onPosition + s.bounceOffset : s.offPosition - s.bounceOffset
                    s.styleForState(state: state)
    }) { [weak self] _ in
      UIView.animate(withDuration: 0.15,
                     animations: { [weak self] in
                      guard let s = self else {
                        return
                      }
                      
                      s.button.frame.origin.x = .on == state ? s.onPosition : s.offPosition
      }) { [weak self] _ in
        guard let s = self else {
          return
        }
        
        s.isUserInteractionEnabled = true
        completion?(s)
      }
    }
  }
}

fileprivate extension Switch {
  /**
   Handle the TouchUpOutside and TouchCancel moments.
   - Parameter sender: A UIButton.
   - Parameter event: A UIEvent.
   */
  @objc
  func handleTouchUpOutsideOrCanceled(sender: FABButton, event: UIEvent) {
    guard let v = event.touches(for: sender)?.first else {
      return
    }
    
    let q: CGFloat = sender.frame.origin.x + v.location(in: sender).x - v.previousLocation(in: sender).x
    updateSwitchState(state: q > (bounds.width - button.bounds.width) / 2 ? .on : .off, animated: true, isTriggeredByUserInteraction: true)
  }
  
  /// Handles the TouchUpInside event.
  @objc
  func handleTouchUpInside() {
    updateSwitchState(state: isOn ? .off : .on, animated: true, isTriggeredByUserInteraction: true)
  }
  
  /**
   Handle the TouchDragInside event.
   - Parameter sender: A UIButton.
   - Parameter event: A UIEvent.
   */
  @objc
  func handleTouchDragInside(sender: FABButton, event: UIEvent) {
    guard let v = event.touches(for: sender)?.first else {
      return
    }
    
    let q: CGFloat = max(min(sender.frame.origin.x + v.location(in: sender).x - v.previousLocation(in: sender).x, onPosition), offPosition)
    
    guard q != sender.frame.origin.x else {
      return
    }
    
    sender.frame.origin.x = q
  }
}

fileprivate extension Switch {
  /// Prepares the track.
  func prepareTrack() {
    addSubview(track)
  }
  
  /// Prepares the button.
  func prepareButton() {
    button.addTarget(self, action: #selector(handleTouchUpInside), for: .touchUpInside)
    button.addTarget(self, action: #selector(handleTouchDragInside), for: .touchDragInside)
    button.addTarget(self, action: #selector(handleTouchUpOutsideOrCanceled), for: .touchCancel)
    button.addTarget(self, action: #selector(handleTouchUpOutsideOrCanceled), for: .touchUpOutside)
    addSubview(button)
  }
  
  /**
   Prepares the switchState property. This is used mainly to allow
   init to set the state value and have an effect.
   - Parameter state: The SwitchState to set.
   */
  func prepareSwitchState(state: SwitchState = .off) {
    updateSwitchState(state: state, animated: false, isTriggeredByUserInteraction: false)
  }
  
  /**
   Prepares the switchSize property. This is used mainly to allow
   init to set the size value and have an effect.
   - Parameter size: The SwitchSize to set.
   */
  func prepareSwitchSize(size: SwitchSize = .medium) {
    switchSize = size
  }
}
