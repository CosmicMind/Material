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

@objc(FABMenuItemTitleLabelPosition)
public enum FABMenuItemTitleLabelPosition: Int {
  case left
  case right
}

@objc(FABMenuDirection)
public enum FABMenuDirection: Int {
  case up
  case down
  case left
  case right
}

open class FABMenuItem: View {
  /// A reference to the titleLabel.
  public let titleLabel = UILabel()
  
  /// The titleLabel side.
  open var titleLabelPosition = FABMenuItemTitleLabelPosition.left
  
  /// A reference to the fabButton.
  public let fabButton = FABButton()
  
  open override func prepare() {
    super.prepare()
    backgroundColor = nil
    
    prepareFABButton()
    prepareTitleLabel()
  }
  
  /// A reference to the titleLabel text.
  open var title: String? {
    get {
      return titleLabel.text
    }
    set(value) {
      titleLabel.text = value
      layoutSubviews()
    }
  }
  
  open override func layoutSubviews() {
    super.layoutSubviews()
    guard let t = title, 0 < t.utf16.count else {
      titleLabel.removeFromSuperview()
      return
    }
    
    if nil == titleLabel.superview {
      addSubview(titleLabel)
    }
  }
}

extension FABMenuItem {
  /// Shows the titleLabel.
  open func showTitleLabel() {
    let interimSpace = InterimSpacePresetToValue(preset: .interimSpace6)
    
    titleLabel.sizeToFit()
    titleLabel.frame.size.width += 1.5 * interimSpace
    titleLabel.frame.size.height += interimSpace / 2
    titleLabel.frame.origin.y = (bounds.height - titleLabel.bounds.height) / 2
    
    switch titleLabelPosition {
    case .left:
      titleLabel.frame.origin.x = -titleLabel.bounds.width - interimSpace
    case .right:
      titleLabel.frame.origin.x = frame.bounds.width + interimSpace
    }
    
    titleLabel.alpha = 0
    titleLabel.isHidden = false
    
    UIView.animate(withDuration: 0.25, animations: { [weak self] in
      guard let `self` = self else {
        return
      }
      
      `self`.titleLabel.alpha = 1
    })
  }
  
  /// Hides the titleLabel.
  open func hideTitleLabel() {
    titleLabel.isHidden = true
  }
}

extension FABMenuItem {
  /// Prepares the fabButton.
  fileprivate func prepareFABButton() {
    layout(fabButton).edges()
  }
  
  /// Prepares the titleLabel.
  fileprivate func prepareTitleLabel() {
    titleLabel.font = Theme.font.regular(with: 14)
    titleLabel.textAlignment = .center
    titleLabel.backgroundColor = .white
    titleLabel.depthPreset = fabButton.depthPreset
    titleLabel.cornerRadiusPreset = .cornerRadius1
  }
}

@objc(FABMenuDelegate)
public protocol FABMenuDelegate {
  /**
   A delegation method that is executed to determine whether fabMenu should open.
   - Parameter fabMenu: A FABMenu.
   */
  @objc
  optional func fabMenuShouldOpen(fabMenu: FABMenu) -> Bool
  
  /**
   A delegation method that is execited when the fabMenu will open.
   - Parameter fabMenu: A FABMenu.
   */
  @objc
  optional func fabMenuWillOpen(fabMenu: FABMenu)
  
  /**
   A delegation method that is execited when the fabMenu did open.
   - Parameter fabMenu: A FABMenu.
   */
  @objc
  optional func fabMenuDidOpen(fabMenu: FABMenu)
  
  /**
   A delegation method that is executed to determine whether fabMenu should close.
   - Parameter fabMenu: A FABMenu.
   */
  @objc
  optional func fabMenuShouldClose(fabMenu: FABMenu) -> Bool
  
  /**
   A delegation method that is execited when the fabMenu will close.
   - Parameter fabMenu: A FABMenu.
   */
  @objc
  optional func fabMenuWillClose(fabMenu: FABMenu)
  
  /**
   A delegation method that is execited when the fabMenu did close.
   - Parameter fabMenu: A FABMenu.
   */
  @objc
  optional func fabMenuDidClose(fabMenu: FABMenu)
  
  /**
   A delegation method that is executed when the user taps while
   the menu is opened.
   - Parameter fabMenu: A FABMenu.
   - Parameter tappedAt point: A CGPoint.
   - Parameter isOutside: A boolean indicating whether the tap
   was outside the menu button area.
   */
  @objc
  optional func fabMenu(fabMenu: FABMenu, tappedAt point: CGPoint, isOutside: Bool)
}

@objc(FABMenu)
open class FABMenu: View {
  /// A flag to avoid the double tap.
  fileprivate var shouldAvoidHitTest = false
  
  
  /// A reference to the SpringAnimation object.
  let spring = SpringAnimation()
  
  open var fabMenuDirection: FABMenuDirection {
    get {
      switch spring.springDirection {
      case .up:
        return .up
      case .down:
        return .down
      case .left:
        return .left
      case .right:
        return .right
      }
    }
    set(value) {
      switch value {
      case .up:
        spring.springDirection = .up
      case .down:
        spring.springDirection = .down
      case .left:
        spring.springDirection = .left
      case .right:
        spring.springDirection = .right
      }
      
      layoutSubviews()
    }
  }
  
  /// A reference to the base FABButton.
  open var fabButton: FABButton? {
    didSet {
      oldValue?.removeFromSuperview()
      
      guard let v = fabButton else {
        return
      }
      
      addSubview(v)
      
      v.addTarget(self, action: #selector(handleFABButton(button:)), for: .touchUpInside)
    }
  }
  
  /// An open handler for the FABButton.
  open var handleFABButtonCallback: ((UIButton) -> Void)?
  
  /// An internal handler for the open function.
  internal var handleOpenCallback: (() -> Void)?
  
  /// An internal handler for the close function.
  internal var handleCloseCallback: (() -> Void)?
  
  /// An internal handler for the completion function.
  internal var handleCompletionCallback: ((UIView) -> Void)?
  
  /// Size of FABMenuItems.
  open var fabMenuItemSize: CGSize {
    get {
      return spring.itemSize
    }
    set(value) {
      spring.itemSize = value
    }
  }
  
  /// A preset wrapper around interimSpace.
  open var interimSpacePreset: InterimSpacePreset {
    get {
      return spring.interimSpacePreset
    }
    set(value) {
      spring.interimSpacePreset = value
    }
  }
  
  /// The space between views.
  open var interimSpace: InterimSpace {
    get {
      return spring.interimSpace
    }
    set(value) {
      spring.interimSpace = value
    }
  }
  
  /// A boolean indicating if the menu is open or not.
  open var isOpened: Bool {
    get {
      return spring.isOpened
    }
    set(value) {
      spring.isOpened = value
    }
  }
  
  /// A boolean indicating if the menu is enabled.
  open var isEnabled: Bool {
    get {
      return spring.isEnabled
    }
    set(value) {
      spring.isEnabled = value
    }
  }
  
  /// An optional delegation handler.
  open weak var delegate: FABMenuDelegate?
  
  /// A reference to the FABMenuItems
  open var fabMenuItems: [FABMenuItem] {
    get {
      return spring.views as! [FABMenuItem]
    }
    set(value) {
      for v in spring.views {
        v.removeFromSuperview()
      }
      
      for v in value {
        addSubview(v)
      }
      
      spring.views = value
    }
  }
  
  open override func layoutSubviews() {
    super.layoutSubviews()
    fabButton?.frame = bounds
    fabButton?.setNeedsLayout()
    fabButton?.layoutIfNeeded()
    spring.baseSize = bounds.size
  }
  
  open override func prepare() {
    super.prepare()
    backgroundColor = nil
    interimSpacePreset = .interimSpace6
  }
}

extension FABMenu {
  /**
   Open the Menu component with animation options.
   - Parameter duration: The time for each view's animation.
   - Parameter delay: A delay time for each view's animation.
   - Parameter usingSpringWithDamping: A damping ratio for the animation.
   - Parameter initialSpringVelocity: The initial velocity for the animation.
   - Parameter options: Options to pass to the animation.
   - Parameter animations: An animation block to execute on each view's animation.
   - Parameter completion: A completion block to execute on each view's animation.
   */
  open func open(duration: TimeInterval = 0.15, delay: TimeInterval = 0, usingSpringWithDamping: CGFloat = 0.5, initialSpringVelocity: CGFloat = 0, options: UIView.AnimationOptions = [], animations: ((UIView) -> Void)? = nil, completion: ((UIView) -> Void)? = nil) {
    open(isTriggeredByUserInteraction: false, duration: duration, delay: delay, usingSpringWithDamping: usingSpringWithDamping, initialSpringVelocity: initialSpringVelocity, options: options, animations: animations, completion: completion)
  }
  
  /**
   Open the Menu component with animation options.
   - Parameter isTriggeredByUserInteraction: A boolean indicating whether the
   state was changed by a user interaction, true if yes, false otherwise.
   - Parameter duration: The time for each view's animation.
   - Parameter delay: A delay time for each view's animation.
   - Parameter usingSpringWithDamping: A damping ratio for the animation.
   - Parameter initialSpringVelocity: The initial velocity for the animation.
   - Parameter options: Options to pass to the animation.
   - Parameter animations: An animation block to execute on each view's animation.
   - Parameter completion: A completion block to execute on each view's animation.
   */
  open func open(isTriggeredByUserInteraction: Bool, duration: TimeInterval = 0.15, delay: TimeInterval = 0, usingSpringWithDamping: CGFloat = 0.5, initialSpringVelocity: CGFloat = 0, options: UIView.AnimationOptions = [], animations: ((UIView) -> Void)? = nil, completion: ((UIView) -> Void)? = nil) {
    
    if isTriggeredByUserInteraction && false == delegate?.fabMenuShouldOpen?(fabMenu: self) {
      return
    }
    
    handleOpenCallback?()
    
    if isTriggeredByUserInteraction {
      delegate?.fabMenuWillOpen?(fabMenu: self)
    }
    
    spring.expand(duration: duration, delay: delay, usingSpringWithDamping: usingSpringWithDamping, initialSpringVelocity: initialSpringVelocity, options: options, animations: animations) { [weak self, isTriggeredByUserInteraction = isTriggeredByUserInteraction, completion = completion] (view) in
      guard let `self` = self else {
        return
      }
      
      (view as? FABMenuItem)?.showTitleLabel()
      
      if isTriggeredByUserInteraction && view == self.fabMenuItems.last {
        self.delegate?.fabMenuDidOpen?(fabMenu: self)
      }
      
      completion?(view)
      self.handleCompletionCallback?(view)
    }
  }
  
  /**
   Close the Menu component with animation options.
   - Parameter duration: The time for each view's animation.
   - Parameter delay: A delay time for each view's animation.
   - Parameter usingSpringWithDamping: A damping ratio for the animation.
   - Parameter initialSpringVelocity: The initial velocity for the animation.
   - Parameter options: Options to pass to the animation.
   - Parameter animations: An animation block to execute on each view's animation.
   - Parameter completion: A completion block to execute on each view's animation.
   */
  open func close(duration: TimeInterval = 0.15, delay: TimeInterval = 0, usingSpringWithDamping: CGFloat = 0.5, initialSpringVelocity: CGFloat = 0, options: UIView.AnimationOptions = [], animations: ((UIView) -> Void)? = nil, completion: ((UIView) -> Void)? = nil) {
    close(isTriggeredByUserInteraction: false, duration: duration, delay: delay, usingSpringWithDamping: usingSpringWithDamping, initialSpringVelocity: initialSpringVelocity, options: options, animations: animations, completion: completion)
  }
  
  /**
   Close the Menu component with animation options.
   - Parameter isTriggeredByUserInteraction: A boolean indicating whether the
   state was changed by a user interaction, true if yes, false otherwise.
   - Parameter duration: The time for each view's animation.
   - Parameter delay: A delay time for each view's animation.
   - Parameter usingSpringWithDamping: A damping ratio for the animation.
   - Parameter initialSpringVelocity: The initial velocity for the animation.
   - Parameter options: Options to pass to the animation.
   - Parameter animations: An animation block to execute on each view's animation.
   - Parameter completion: A completion block to execute on each view's animation.
   */
  open func close(isTriggeredByUserInteraction: Bool, duration: TimeInterval = 0.15, delay: TimeInterval = 0, usingSpringWithDamping: CGFloat = 0.5, initialSpringVelocity: CGFloat = 0, options: UIView.AnimationOptions = [], animations: ((UIView) -> Void)? = nil, completion: ((UIView) -> Void)? = nil) {
    
    if isTriggeredByUserInteraction && false == delegate?.fabMenuShouldClose?(fabMenu: self) {
      return
    }
    
    handleCloseCallback?()
    
    if isTriggeredByUserInteraction {
      delegate?.fabMenuWillClose?(fabMenu: self)
    }
    
    spring.contract(duration: duration, delay: delay, usingSpringWithDamping: usingSpringWithDamping, initialSpringVelocity: initialSpringVelocity, options: options, animations: animations) { [weak self, isTriggeredByUserInteraction = isTriggeredByUserInteraction, completion = completion] (view) in
      guard let `self` = self else {
        return
      }
      
      (view as? FABMenuItem)?.hideTitleLabel()
      
      if isTriggeredByUserInteraction && view == self.fabMenuItems.last {
        self.delegate?.fabMenuDidClose?(fabMenu: self)
      }
      
      completion?(view)
      self.handleCompletionCallback?(view)
    }
  }
}

extension FABMenu {
  /**
   Handles the hit test for the Menu and views outside of the Menu bounds.
   - Parameter _ point: A CGPoint.
   - Parameter with event: An optional UIEvent.
   - Returns: An optional UIView.
   */
  open override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
    guard isOpened, isEnabled else {
      return super.hitTest(point, with: event)
    }
    
    for v in subviews {
      let p = v.convert(point, from: self)
      if v.bounds.contains(p) {
        if !shouldAvoidHitTest {
          delegate?.fabMenu?(fabMenu: self, tappedAt: point, isOutside: false)
        }
        shouldAvoidHitTest = !shouldAvoidHitTest
        return v.hitTest(p, with: event)
      }
    }
    
    delegate?.fabMenu?(fabMenu: self, tappedAt: point, isOutside: true)
    
    close(isTriggeredByUserInteraction: true)
    
    return super.hitTest(point, with: event)
  }
}

extension FABMenu {
  /**
   Handler to toggle the FABMenu opened or closed. 
   - Parameter button: A UIButton.
   */
  @objc
  fileprivate func handleFABButton(button: UIButton) {
    guard nil == handleFABButtonCallback else {
      handleFABButtonCallback?(button)
      return
    }
    
    guard isOpened else {
      open(isTriggeredByUserInteraction: true)
      return
    }
    
    close(isTriggeredByUserInteraction: true)
  }
}
