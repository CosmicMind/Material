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

@objc(TextFieldPlaceholderAnimation)
public enum TextFieldPlaceholderAnimation: Int {
  case `default`
  case hidden
}

@objc(TextFieldDelegate)
public protocol TextFieldDelegate: UITextFieldDelegate {
  /**
   A delegation method that is executed when the textField changed.
   - Parameter textField: A TextField.
   - Parameter didChange text: An optional String.
   */
  @objc
  optional func textField(textField: TextField, didChange text: String?)
  
  /**
   A delegation method that is executed when the textField will clear.
   - Parameter textField: A TextField.
   - Parameter willClear text: An optional String.
   */
  @objc
  optional func textField(textField: TextField, willClear text: String?)
  
  /**
   A delegation method that is executed when the textField is cleared.
   - Parameter textField: A TextField.
   - Parameter didClear text: An optional String.
   */
  @objc
  optional func textField(textField: TextField, didClear text: String?)
}

open class TextField: UITextField {
  /// Default size when using AutoLayout.
  open override var intrinsicContentSize: CGSize {
    return CGSize(width: bounds.width, height: 32)
  }
  
  /// A Boolean that indicates if the placeholder label is animated.
  @IBInspectable
  open var isPlaceholderAnimated = true
  
  /// Set the placeholder animation value.
  open var placeholderAnimation = TextFieldPlaceholderAnimation.default {
    didSet {
      guard isEditing else {
        placeholderLabel.isHidden = !isEmpty && .hidden == placeholderAnimation
        return
      }
      
      placeholderLabel.isHidden = .hidden == placeholderAnimation
    }
  }
  
  /// A boolean indicating whether the text is empty.
  open var isEmpty: Bool {
    return 0 == text?.utf16.count
  }
  
  open override var text: String? {
    didSet {
      placeholderAnimation = { placeholderAnimation }()
    }
  }
  
  open override var leftView: UIView? {
    didSet {
      prepareLeftView()
      layoutSubviews()
    }
  }
  
  /// The leftView width value.
  open var leftViewWidth: CGFloat {
    guard nil != leftView else {
      return 0
    }
    
    return leftViewOffset + bounds.height
  }
  
  /// The leftView offset value.
  open var leftViewOffset: CGFloat = 16
  
  /// Placeholder normal text
  @IBInspectable
  open var leftViewNormalColor = Color.darkText.others {
    didSet {
      updateLeftViewColor()
    }
  }
  
  /// Placeholder active text
  @IBInspectable
  open var leftViewActiveColor = Color.blue.base {
    didSet {
      updateLeftViewColor()
    }
  }
  
  /// Divider normal height.
  @IBInspectable
  open var dividerNormalHeight: CGFloat = 1 {
    didSet {
      guard !isEditing else {
        return
      }
      
      dividerThickness = dividerNormalHeight
    }
  }
  
  
  /// Divider active height.
  @IBInspectable
  open var dividerActiveHeight: CGFloat = 2 {
    didSet {
      guard isEditing else {
        return
      }
      
      dividerThickness = dividerActiveHeight
    }
  }
  
  /// Divider normal color.
  @IBInspectable
  open var dividerNormalColor = Color.grey.lighten2 {
    didSet {
      guard !isEditing else {
        return
      }
      
      dividerColor = dividerNormalColor
    }
  }
  
  /// Divider active color.
  @IBInspectable
  open var dividerActiveColor = Color.blue.base {
    didSet {
      guard isEditing else {
        return
      }
      
      dividerColor = dividerActiveColor
    }
  }
  
  /// The placeholderLabel font value.
  @IBInspectable
  open override var font: UIFont? {
    didSet {
      placeholderLabel.font = font
    }
  }
  
  /// The placeholderLabel text value.
  @IBInspectable
  open override var placeholder: String? {
    get {
      return placeholderLabel.text
    }
    set(value) {
      if isEditing && isPlaceholderUppercasedWhenEditing {
        placeholderLabel.text = value?.uppercased()
      } else {
        placeholderLabel.text = value
      }
      layoutSubviews()
    }
  }
  
  open override var isSecureTextEntry: Bool {
    didSet {
      updateVisibilityIcon()
      fixCursorPosition()
    }
  }
  
  /// The placeholder UILabel.
  @IBInspectable
  open let placeholderLabel = UILabel()
  
  /// Placeholder normal text
  @IBInspectable
  open var placeholderNormalColor = Color.darkText.others {
    didSet {
      updatePlaceholderLabelColor()
    }
  }
  
  /// Placeholder active text
  @IBInspectable
  open var placeholderActiveColor = Color.blue.base {
    didSet {
      updatePlaceholderLabelColor()
    }
  }
  
  /// This property adds a padding to placeholder y position animation
  @IBInspectable
  open var placeholderVerticalOffset: CGFloat = 0
  
  /// This property adds a padding to placeholder y position animation
  @IBInspectable
  open var placeholderHorizontalOffset: CGFloat = 0
  
  /// The scale of the active placeholder in relation to the inactive
  @IBInspectable
  open var placeholderActiveScale: CGFloat = 0.75 {
    didSet {
      layoutPlaceholderLabel()
    }
  }
  
  /// The detailLabel UILabel that is displayed.
  @IBInspectable
  open let detailLabel = UILabel()
  
  /// The detailLabel text value.
  @IBInspectable
  open var detail: String? {
    get {
      return detailLabel.text
    }
    set(value) {
      detailLabel.text = value
      layoutSubviews()
    }
  }
  
  /// Detail text
  @IBInspectable
  open var detailColor = Color.darkText.others {
    didSet {
      updateDetailLabelColor()
    }
  }
  
  /// Vertical distance for the detailLabel from the divider.
  @IBInspectable
  open var detailVerticalOffset: CGFloat = 8 {
    didSet {
      layoutSubviews()
    }
  }
  
  /// Handles the textAlignment of the placeholderLabel.
  open override var textAlignment: NSTextAlignment {
    get {
      return super.textAlignment
    }
    set(value) {
      super.textAlignment = value
      placeholderLabel.textAlignment = value
      detailLabel.textAlignment = value
    }
  }
  
  /// A reference to the clearIconButton.
  open fileprivate(set) var clearIconButton: IconButton?
  
  /// Enables the clearIconButton.
  @IBInspectable
  open var isClearIconButtonEnabled: Bool {
    get {
      return nil != clearIconButton
    }
    set(value) {
      guard value else {
        clearIconButton?.removeTarget(self, action: #selector(handleClearIconButton), for: .touchUpInside)
        removeFromRightView(view: clearIconButton)
        clearIconButton = nil
        return
      }
      
      guard nil == clearIconButton else {
        return
      }
      
      clearIconButton = IconButton(image: Icon.cm.clear, tintColor: placeholderNormalColor)
      clearIconButton!.contentEdgeInsetsPreset = .none
      clearIconButton!.pulseAnimation = .none

      rightView?.grid.views.insert(clearIconButton!, at: 0)
      isClearIconButtonAutoHandled = { isClearIconButtonAutoHandled }()
      
      layoutSubviews()
    }
  }
  
  /// Enables the automatic handling of the clearIconButton.
  @IBInspectable
  open var isClearIconButtonAutoHandled = true {
    didSet {
      clearIconButton?.removeTarget(self, action: #selector(handleClearIconButton), for: .touchUpInside)
      
      guard isClearIconButtonAutoHandled else {
        return
      }
      
      clearIconButton?.addTarget(self, action: #selector(handleClearIconButton), for: .touchUpInside)
    }
  }
  
  /// A reference to the visibilityIconButton.
  open fileprivate(set) var visibilityIconButton: IconButton?
  
  /// Icon for visibilityIconButton when in the on state.
  open var visibilityIconOn = Icon.visibility {
    didSet {
      updateVisibilityIcon()
    }
  }
  
  /// Icon for visibilityIconButton when in the off state.
  open var visibilityIconOff = Icon.visibilityOff {
    didSet {
      updateVisibilityIcon()
    }
  }
  
  /// Enables the visibilityIconButton.
  @IBInspectable
  open var isVisibilityIconButtonEnabled: Bool {
    get {
      return nil != visibilityIconButton
    }
    set(value) {
      guard value else {
        visibilityIconButton?.removeTarget(self, action: #selector(handleVisibilityIconButton), for: .touchUpInside)
        removeFromRightView(view: visibilityIconButton)
        visibilityIconButton = nil
        return
      }
      
      guard nil == visibilityIconButton else {
        return
      }
      
      isSecureTextEntry = true
      visibilityIconButton = IconButton(image: nil, tintColor: placeholderNormalColor.withAlphaComponent(0.54))
      updateVisibilityIcon()
      visibilityIconButton!.contentEdgeInsetsPreset = .none
      visibilityIconButton!.pulseAnimation = .centerRadialBeyondBounds
      
      rightView?.grid.views.append(visibilityIconButton!)
      isVisibilityIconButtonAutoHandled = { isVisibilityIconButtonAutoHandled }()
      
      layoutSubviews()
    }
  }
  
  /// Enables the automatic handling of the visibilityIconButton.
  @IBInspectable
  open var isVisibilityIconButtonAutoHandled = true {
    didSet {
      visibilityIconButton?.removeTarget(self, action: #selector(handleVisibilityIconButton), for: .touchUpInside)
      guard isVisibilityIconButtonAutoHandled else {
        return
      }
      
      visibilityIconButton?.addTarget(self, action: #selector(handleVisibilityIconButton), for: .touchUpInside)
    }
  }
  
  @IBInspectable
  open var isPlaceholderUppercasedWhenEditing = false {
    didSet {
      updatePlaceholderTextToActiveState()
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
    layoutPlaceholderLabel()
    layoutBottomLabel(label: detailLabel, verticalOffset: detailVerticalOffset)
    layoutDivider()
    layoutLeftView()
    layoutRightView()
  }
  
  open override func becomeFirstResponder() -> Bool {
    layoutSubviews()
    return super.becomeFirstResponder()
  }
  
  /// EdgeInsets for text.
  @objc
  open var textInset: CGFloat = 0
  
  open override func textRect(forBounds bounds: CGRect) -> CGRect {
    var b = super.textRect(forBounds: bounds)
    b.origin.x += textInset
    b.size.width -= textInset
    return b
  }
  
  open override func editingRect(forBounds bounds: CGRect) -> CGRect {
    return textRect(forBounds: bounds)
  }
  
  /**
   Prepares the view instance when intialized. When subclassing,
   it is recommended to override the prepare method
   to initialize property values and other setup operations.
   The super.prepare method should always be called immediately
   when subclassing.
   */
  open func prepare() {
    clipsToBounds = false
    borderStyle = .none
    backgroundColor = nil
    contentScaleFactor = Screen.scale
    font = RobotoFont.regular(with: 16)
    textColor = Color.darkText.primary
    
    prepareDivider()
    preparePlaceholderLabel()
    prepareDetailLabel()
    prepareTargetHandlers()
    prepareTextAlignment()
    prepareRightView()
  }
}

fileprivate extension TextField {
  /// Prepares the divider.
  func prepareDivider() {
    dividerColor = dividerNormalColor
  }
  
  /// Prepares the placeholderLabel.
  func preparePlaceholderLabel() {
    placeholderNormalColor = Color.darkText.others
    placeholderLabel.backgroundColor = .clear
    addSubview(placeholderLabel)
  }
  
  /// Prepares the detailLabel.
  func prepareDetailLabel() {
    detailLabel.font = RobotoFont.regular(with: 12)
    detailLabel.numberOfLines = 0
    detailColor = Color.darkText.others
    addSubview(detailLabel)
  }
  
  /// Prepares the leftView.
  func prepareLeftView() {
    leftView?.contentMode = .left
    leftViewMode = .always
    updateLeftViewColor()
  }
  
  /// Prepares the target handlers.
  func prepareTargetHandlers() {
    addTarget(self, action: #selector(handleEditingDidBegin), for: .editingDidBegin)
    addTarget(self, action: #selector(handleEditingChanged), for: .editingChanged)
    addTarget(self, action: #selector(handleEditingDidEnd), for: .editingDidEnd)
  }
  
  /// Prepares the textAlignment.
  func prepareTextAlignment() {
    textAlignment = .rightToLeft == Application.userInterfaceLayoutDirection ? .right : .left
  }
  
  /// Prepares the rightView.
  func prepareRightView() {
    rightView = UIView()
    rightView?.grid.columns = 2
    rightViewMode = .whileEditing
    clearButtonMode = .never
  }
}

fileprivate extension TextField {
  /// Updates the leftView tint color.
  func updateLeftViewColor() {
    leftView?.tintColor = isEditing ? leftViewActiveColor : leftViewNormalColor
  }
  
  /// Updates the placeholderLabel text color.
  func updatePlaceholderLabelColor() {
    tintColor = placeholderActiveColor
    placeholderLabel.textColor = isEditing ? placeholderActiveColor : placeholderNormalColor
  }
  
  /// Update the placeholder text to the active state.
  func updatePlaceholderTextToActiveState() {
    guard isPlaceholderUppercasedWhenEditing else {
      return
    }
    
    guard isEditing || !isEmpty else {
      return
    }
    
    placeholderLabel.text = placeholderLabel.text?.uppercased()
  }
  
  /// Update the placeholder text to the normal state.
  func updatePlaceholderTextToNormalState() {
    guard isPlaceholderUppercasedWhenEditing else {
      return
    }
    
    guard isEmpty else {
      return
    }
    
    placeholderLabel.text = placeholderLabel.text?.capitalized
  }
  
  /// Updates the detailLabel text color.
  func updateDetailLabelColor() {
    detailLabel.textColor = detailColor
  }
}

fileprivate extension TextField {
  /// Layout the placeholderLabel.
  func layoutPlaceholderLabel() {
    let w = leftViewWidth + textInset
    let h = 0 == bounds.height ? intrinsicContentSize.height : bounds.height
    
    placeholderLabel.transform = CGAffineTransform.identity
    
    guard isEditing || !isEmpty || !isPlaceholderAnimated else {
      placeholderLabel.frame = CGRect(x: w, y: 0, width: bounds.width - leftViewWidth - 2 * textInset, height: h)
      return
    }
    
    placeholderLabel.frame = CGRect(x: w, y: 0, width: bounds.width - leftViewWidth - 2 * textInset, height: h)
    placeholderLabel.transform = CGAffineTransform(scaleX: placeholderActiveScale, y: placeholderActiveScale)
    
    switch textAlignment {
    case .left, .natural:
      placeholderLabel.frame.origin.x = w + placeholderHorizontalOffset
    case .right:
      placeholderLabel.frame.origin.x = (bounds.width * (1.0 - placeholderActiveScale)) - textInset + placeholderHorizontalOffset
    default:break
    }
    
    placeholderLabel.frame.origin.y = -placeholderLabel.frame.height + placeholderVerticalOffset
  }
  
  /// Layout the leftView.
  func layoutLeftView() {
    guard let v = leftView else {
      return
    }
    
    let w = leftViewWidth
    v.frame = CGRect(x: 0, y: 0, width: w, height: bounds.height)
    dividerContentEdgeInsets.left = w
  }
  /// Layout the rightView.
  func layoutRightView() {
    guard let rightView = rightView else {
      return
    }
    
    let w = CGFloat(rightView.grid.views.count) * bounds.height
    rightView.frame = CGRect(x: bounds.width - w, y: 0, width: w, height: bounds.height)
    rightView.grid.reload()
  }
}

internal extension TextField {
  /// Layout given label at the bottom with the vertical offset provided.
  func layoutBottomLabel(label: UILabel, verticalOffset: CGFloat) {
    let c = dividerContentEdgeInsets
    label.frame.origin.x = c.left
    label.frame.origin.y = bounds.height + verticalOffset
    label.frame.size.width = bounds.width - c.left - c.right
    label.frame.size.height = label.sizeThatFits(CGSize(width: label.bounds.width, height: .greatestFiniteMagnitude)).height
  }
}

fileprivate extension TextField {
  /// Handles the text editing did begin state.
  @objc
  func handleEditingDidBegin() {
    leftViewEditingBeginAnimation()
    placeholderEditingDidBeginAnimation()
    dividerEditingDidBeginAnimation()
  }
  
  // Live updates the textField text.
  @objc
  func handleEditingChanged(textField: UITextField) {
    (delegate as? TextFieldDelegate)?.textField?(textField: self, didChange: textField.text)
  }
  
  /// Handles the text editing did end state.
  @objc
  func handleEditingDidEnd() {
    leftViewEditingEndAnimation()
    placeholderEditingDidEndAnimation()
    dividerEditingDidEndAnimation()
  }
  
  /// Handles the clearIconButton TouchUpInside event.
  @objc
  func handleClearIconButton() {
    guard nil == delegate?.textFieldShouldClear || true == delegate?.textFieldShouldClear?(self) else {
      return
    }
    
    let t = text
    
    (delegate as? TextFieldDelegate)?.textField?(textField: self, willClear: t)
    
    text = nil
    
    (delegate as? TextFieldDelegate)?.textField?(textField: self, didClear: t)
  }
  
  /// Handles the visibilityIconButton TouchUpInside event.
  @objc
  func handleVisibilityIconButton() {
    UIView.transition(
      with: (visibilityIconButton?.imageView)!,
      duration: 0.3,
      options: .transitionCrossDissolve,
      animations: { [weak self] in
        guard let `self` = self else {
          return
        }
        
        self.isSecureTextEntry = !self.isSecureTextEntry
    })
  }
}

extension TextField {
  /// The animation for leftView when editing begins.
  fileprivate func leftViewEditingBeginAnimation() {
    updateLeftViewColor()
  }
  
  /// The animation for leftView when editing ends.
  fileprivate func leftViewEditingEndAnimation() {
    updateLeftViewColor()
  }
  
  /// The animation for the divider when editing begins.
  fileprivate func dividerEditingDidBeginAnimation() {
    dividerThickness = dividerActiveHeight
    dividerColor = dividerActiveColor
  }
  
  /// The animation for the divider when editing ends.
  fileprivate func dividerEditingDidEndAnimation() {
    dividerThickness = dividerNormalHeight
    dividerColor = dividerNormalColor
  }
  
  /// The animation for the placeholder when editing begins.
  fileprivate func placeholderEditingDidBeginAnimation() {
    guard .default == placeholderAnimation else {
      placeholderLabel.isHidden = true
      return
    }
    
    updatePlaceholderLabelColor()
    
    guard isPlaceholderAnimated else {
      updatePlaceholderTextToActiveState()
      return
    }
    
    guard isEmpty else {
      updatePlaceholderTextToActiveState()
      return
    }
    
    UIView.animate(withDuration: 0.15, animations: { [weak self] in
      guard let `self` = self else {
        return
      }
      
      self.placeholderLabel.transform = CGAffineTransform(scaleX: self.placeholderActiveScale, y: self.placeholderActiveScale)
      
      self.updatePlaceholderTextToActiveState()
      
      switch self.textAlignment {
      case .left, .natural:
        self.placeholderLabel.frame.origin.x = self.leftViewWidth + self.textInset + self.placeholderHorizontalOffset
      case .right:
        self.placeholderLabel.frame.origin.x = (self.bounds.width * (1.0 - self.placeholderActiveScale)) - self.textInset + self.placeholderHorizontalOffset
      default:break
      }
      
      self.placeholderLabel.frame.origin.y = -self.placeholderLabel.bounds.height + self.placeholderVerticalOffset
    })
  }
  
  /// The animation for the placeholder when editing ends.
  fileprivate func placeholderEditingDidEndAnimation() {
    guard .default == placeholderAnimation else {
      placeholderLabel.isHidden = !isEmpty
      return
    }
    
    updatePlaceholderLabelColor()
    updatePlaceholderTextToNormalState()
    
    guard isPlaceholderAnimated else {
      return
    }
    
    guard isEmpty else {
      return
    }
    
    UIView.animate(withDuration: 0.15, animations: { [weak self] in
      guard let `self` = self else {
        return
      }
      
      self.placeholderLabel.transform = CGAffineTransform.identity
      self.placeholderLabel.frame.origin.x = self.leftViewWidth + self.textInset
      self.placeholderLabel.frame.origin.y = 0
    })
  }
}

private extension TextField {
  /// Updates visibilityIconButton image based on isSecureTextEntry value.
  func updateVisibilityIcon() {
    visibilityIconButton?.image = isSecureTextEntry ? visibilityIconOff : visibilityIconOn
  }
  
  /// Remove view from rightView.
  func removeFromRightView(view: UIView?) {
    guard let v = view, let i = rightView?.grid.views.index(of: v) else {
      return
    }
    
    rightView?.grid.views.remove(at: i)
  }
  
  /**
   Reassign text to reset cursor position.
   Fixes issue-1119. Previously issue-1030, and issue-1023.
   */
  func fixCursorPosition() {
    let t = text
    text = nil
    text = t
  }
}
