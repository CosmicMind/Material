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

open class TextField: UITextField, Themeable {
  
  /// Minimum TextField text height.
  private let minimumTextHeight: CGFloat = 32
  
  /// Default size when using AutoLayout.
  open override var intrinsicContentSize: CGSize {
    let h = textInsets.top + textInsets.bottom + minimumTextHeight
    return CGSize(width: bounds.width, height: max(h, super.intrinsicContentSize.height))
  }
  
  /// A Boolean that indicates if the placeholder label is animated.
  @IBInspectable
  open var isPlaceholderAnimated = true
  
  /// Set the placeholder animation value.
  open var placeholderAnimation = TextFieldPlaceholderAnimation.default {
    didSet {
      updatePlaceholderVisibility()
    }
  }
  
  /// A boolean indicating whether the text is empty.
  open var isEmpty: Bool {
    return 0 == text?.utf16.count
  }
  
  open override var text: String? {
    didSet {
      updatePlaceholderVisibility()
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
      updateDividerHeight()
    }
  }
  
  /// Divider active height.
  @IBInspectable
  open var dividerActiveHeight: CGFloat = 2 {
    didSet {
      updateDividerHeight()
    }
  }
  
  /// Divider normal color.
  @IBInspectable
  open var dividerNormalColor = Color.grey.lighten2 {
    didSet {
      updateDividerColor()
    }
  }
  
  /// Divider active color.
  @IBInspectable
  open var dividerActiveColor = Color.blue.base {
    didSet {
      updateDividerColor()
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
  public let placeholderLabel = UILabel()
  
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
      /// Keep tintColor update here. See #1229
      tintColor = placeholderActiveColor
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
  public let detailLabel = UILabel()
  
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
    didSet {
      placeholderLabel.textAlignment = textAlignment
      detailLabel.textAlignment = textAlignment
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

    /// Fire didSet here to update tintColor
    placeholderActiveColor = { placeholderActiveColor }()
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
  open var textInsets: EdgeInsets = .zero
  
  /// EdgeInsets preset property for text.
  open var textInsetsPreset = EdgeInsetsPreset.none {
    didSet {
      textInsets = EdgeInsetsPresetToValue(preset: textInsetsPreset)
    }
  }
  
  open override func textRect(forBounds bounds: CGRect) -> CGRect {
    return super.textRect(forBounds: bounds).inset(by: textInsets)
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
    font = Theme.font.regular(with: 16)
    textColor = Color.darkText.primary
    
    prepareDivider()
    preparePlaceholderLabel()
    prepareDetailLabel()
    prepareTargetHandlers()
    prepareTextAlignment()
    prepareRightView()
    applyCurrentTheme()
  }
  
  /**
   Applies the given theme.
   - Parameter theme: A Theme.
   */
  open func apply(theme: Theme) {
    placeholderActiveColor = theme.secondary
    placeholderNormalColor = theme.onSurface.withAlphaComponent(0.38)
    
    leftViewActiveColor = theme.secondary
    leftViewNormalColor = theme.onSurface.withAlphaComponent(0.38)
    
    dividerActiveColor = theme.secondary
    dividerNormalColor = theme.onSurface.withAlphaComponent(0.12)
    
    detailColor = theme.onSurface.withAlphaComponent(0.38)
    textColor = theme.onSurface.withAlphaComponent(0.87)
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
    detailLabel.font = Theme.font.regular(with: 12)
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
    placeholderLabel.textColor = isEditing ? placeholderActiveColor : placeholderNormalColor
  }
  
  /// Updates the placeholder visibility.
  func updatePlaceholderVisibility() {
    guard isEditing else {
      placeholderLabel.isHidden = !isEmpty && .hidden == placeholderAnimation
      return
    }
    
    placeholderLabel.isHidden = .hidden == placeholderAnimation
  }
  
  /// Updates the dividerColor.
  func updateDividerColor() {
    dividerColor = isEditing ? dividerActiveColor : dividerNormalColor
  }
  
  /// Updates the dividerThickness.
  func updateDividerHeight() {
    dividerThickness = isEditing ? dividerActiveHeight : dividerNormalHeight
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
    let leftPadding = leftViewWidth + textInsets.left
    let w = bounds.width - leftPadding - textInsets.right
    var h = placeholderLabel.sizeThatFits(CGSize(width: w, height: .greatestFiniteMagnitude)).height
    h = min(h, bounds.height - textInsets.top - textInsets.bottom)
    h = max(h, minimumTextHeight)
    
    placeholderLabel.bounds.size = CGSize(width: w, height: h)
    
    guard isEditing || !isEmpty || !isPlaceholderAnimated else {
      placeholderLabel.transform = CGAffineTransform.identity
      placeholderLabel.frame.origin = CGPoint(x: leftPadding, y: textInsets.top)
      return
    }
    
    placeholderLabel.transform = CGAffineTransform(scaleX: placeholderActiveScale, y: placeholderActiveScale)
    placeholderLabel.frame.origin.y = -placeholderLabel.frame.height + placeholderVerticalOffset
    
    switch placeholderLabel.textAlignment {
    case .left, .natural:
      placeholderLabel.frame.origin.x = leftPadding + placeholderHorizontalOffset
    case .right:
      let scaledWidth = w * placeholderActiveScale
      placeholderLabel.frame.origin.x = bounds.width - scaledWidth - textInsets.right + placeholderHorizontalOffset
    default:break
    }
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
    guard let v = rightView else {
      return
    }
    
    let w = CGFloat(v.grid.views.count) * bounds.height
    v.frame = CGRect(x: bounds.width - w, y: 0, width: w, height: bounds.height)
    v.grid.reload()
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

private extension TextField {
  /// The animation for leftView when editing begins.
  func leftViewEditingBeginAnimation() {
    updateLeftViewColor()
  }
  
  /// The animation for leftView when editing ends.
  func leftViewEditingEndAnimation() {
    updateLeftViewColor()
  }
  
  /// The animation for the divider when editing begins.
  func dividerEditingDidBeginAnimation() {
    updateDividerHeight()
    updateDividerColor()
  }
  
  /// The animation for the divider when editing ends.
  func dividerEditingDidEndAnimation() {
    updateDividerHeight()
    updateDividerColor()
  }
  
  /// The animation for the placeholder when editing begins.
  func placeholderEditingDidBeginAnimation() {
    updatePlaceholderVisibility()
    updatePlaceholderLabelColor()
    
    guard isPlaceholderAnimated else {
      return
    }
    
    updatePlaceholderTextToActiveState()
    UIView.animate(withDuration: 0.15, animations: layoutPlaceholderLabel)
  }
  
  /// The animation for the placeholder when editing ends.
  func placeholderEditingDidEndAnimation() {
    updatePlaceholderVisibility()
    updatePlaceholderLabelColor()
    
    guard isPlaceholderAnimated else {
      return
    }
    
    updatePlaceholderTextToNormalState()
    UIView.animate(withDuration: 0.15, animations: layoutPlaceholderLabel)
  }
}

private extension TextField {
  /// Updates visibilityIconButton image based on isSecureTextEntry value.
  func updateVisibilityIcon() {
    visibilityIconButton?.image = isSecureTextEntry ? visibilityIconOff : visibilityIconOn
  }
  
  /// Remove view from rightView.
  func removeFromRightView(view: UIView?) {
    guard let v = view, let i = rightView?.grid.views.firstIndex(of: v) else {
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
