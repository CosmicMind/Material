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

public enum EditorPlaceholderAnimation {
  case `default`
  case hidden
}

open class Editor: View, Themeable {
  /// Reference to textView.
  public let textView = TextView()
  
  /// A boolean indicating whether the textView is in edit mode.
  open var isEditing: Bool {
    return textView.isEditing
  }
  
  /// A boolean indicating whether the text is empty.
  open var isEmpty: Bool {
    return textView.isEmpty
  }
  
  /// The placeholder UILabel.
  @IBInspectable
  open var placeholderLabel: UILabel {
    return textView.placeholderLabel
  }
  
  /// A Boolean that indicates if the placeholder label is animated.
  @IBInspectable
  open var isPlaceholderAnimated = true
  
  /// Set the placeholder animation value.
  open var placeholderAnimation = EditorPlaceholderAnimation.default {
    didSet {
      updatePlaceholderVisibility()
    }
  }
  
  /// Placeholder normal text color.
  @IBInspectable
  open var placeholderNormalColor = Color.darkText.others {
    didSet {
      updatePlaceholderLabelColor()
    }
  }
  
  /// Placeholder active text color.
  @IBInspectable
  open var placeholderActiveColor = Color.blue.base {
    didSet {
      updatePlaceholderLabelColor()
    }
  }
  
  /// The scale of the active placeholder in relation to the inactive.
  @IBInspectable
  open var placeholderActiveScale: CGFloat = 0.75 {
    didSet {
      layoutPlaceholderLabel()
    }
  }
  
  /// This property adds a padding to placeholder y position animation
  @IBInspectable
  open var placeholderVerticalOffset: CGFloat = 0
  
  /// This property adds a padding to placeholder x position animation
  @IBInspectable
  open var placeholderHorizontalOffset: CGFloat = 0
  
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
  
  /// The detailLabel text color.
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
  
  /// A reference to titleLabel.textAlignment observation.
  private var placeholderLabelTextObserver: NSKeyValueObservation!
  
  /**
   A reference to textView.text observation.
   Only observes programmatic changes.
   */
  private var textViewTextObserver: NSKeyValueObservation!
  
  deinit {
    placeholderLabelTextObserver.invalidate()
    placeholderLabelTextObserver = nil
    
    textViewTextObserver.invalidate()
    textViewTextObserver = nil
  }
  
  open override func prepare() {
    super.prepare()
    backgroundColor = nil
    prepareDivider()
    prepareTextView()
    preparePlaceholderLabel()
    prepareDetailLabel()
    prepareNotificationHandlers()
    
    applyCurrentTheme()
  }
  
  open override func layoutSubviews() {
    super.layoutSubviews()
    layoutPlaceholderLabel()
    layoutDivider()
    layoutBottomLabel(label: detailLabel, verticalOffset: detailVerticalOffset)
  }
  
  /**
   Applies the given theme.
   - Parameter theme: A Theme.
   */
  open func apply(theme: Theme) {
    placeholderActiveColor = theme.secondary
    placeholderNormalColor = theme.onSurface.withAlphaComponent(0.38)
    
    dividerActiveColor = theme.secondary
    dividerNormalColor = theme.onSurface.withAlphaComponent(0.12)
    
    detailColor = theme.onSurface.withAlphaComponent(0.38)
    textView.tintColor = theme.secondary
  }
  
  @discardableResult
  open override func becomeFirstResponder() -> Bool {
    return textView.becomeFirstResponder()
  }
  
  @discardableResult
  open override func resignFirstResponder() -> Bool {
    return textView.resignFirstResponder()
  }
}


private extension Editor {
  /// Prepares the divider.
  func prepareDivider() {
    dividerColor = dividerNormalColor
  }
  
  /// Prepares the textView.
  func prepareTextView() {
    layout(textView).edges()
    textView.isPlaceholderLabelEnabled = false
    
    textViewTextObserver = textView.observe(\.text) { [weak self] _, _ in
      self?.updateEditorState()
    }
  }
  
  /// Prepares the placeholderLabel.
  func preparePlaceholderLabel() {
    addSubview(placeholderLabel)
    placeholderLabelTextObserver = placeholderLabel.observe(\.text) { [weak self] _, _ in
      self?.layoutPlaceholderLabel()
    }
  }
  
  /// Prepares the detailLabel.
  func prepareDetailLabel() {
    detailLabel.font = Theme.font.regular(with: 12)
    detailLabel.numberOfLines = 0
    detailColor = Color.darkText.others
    addSubview(detailLabel)
  }
  
  /// Prepares the Notification handlers.
  func prepareNotificationHandlers() {
    let center = NotificationCenter.default
    center.addObserver(self, selector: #selector(handleTextViewTextDidBegin), name: UITextView.textDidBeginEditingNotification, object: textView)
    center.addObserver(self, selector: #selector(handleTextViewTextDidChange), name: UITextView.textDidChangeNotification, object: textView)
    center.addObserver(self, selector: #selector(handleTextViewTextDidEnd), name: UITextView.textDidEndEditingNotification, object: textView)
  }
}

private extension Editor {
  /// Updates the placeholderLabel text color.
  func updatePlaceholderLabelColor() {
    tintColor = placeholderActiveColor
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
  
  /// Updates the detailLabel text color.
  func updateDetailLabelColor() {
    detailLabel.textColor = detailColor
  }
}

private extension Editor {
  /// Layout the placeholderLabel.
  func layoutPlaceholderLabel() {
    let inset = textView.textContainerInsets
    let leftPadding = inset.left + textView.textContainer.lineFragmentPadding
    let rightPadding = inset.right + textView.textContainer.lineFragmentPadding
    let w = bounds.width - leftPadding - rightPadding
    var h = placeholderLabel.sizeThatFits(CGSize(width: w, height: .greatestFiniteMagnitude)).height
    h = max(h, textView.minimumTextHeight)
    h = min(h, bounds.height - inset.top - inset.bottom)
    
    placeholderLabel.bounds.size = CGSize(width: w, height: h)
    
    guard isEditing || !isEmpty || !isPlaceholderAnimated else {
      placeholderLabel.transform = CGAffineTransform.identity
      placeholderLabel.frame.origin = CGPoint(x: leftPadding, y: inset.top)
      return
    }
    
    placeholderLabel.transform = CGAffineTransform(scaleX: placeholderActiveScale, y: placeholderActiveScale)
    placeholderLabel.frame.origin.y = -placeholderLabel.frame.height + placeholderVerticalOffset
    
    switch placeholderLabel.textAlignment {
    case .left, .natural:
      placeholderLabel.frame.origin.x = leftPadding + placeholderHorizontalOffset
    case .right:
      let scaledWidth = w * placeholderActiveScale
      placeholderLabel.frame.origin.x = bounds.width - scaledWidth - rightPadding + placeholderHorizontalOffset
    default:break
    }
  }
  
  /// Layout given label at the bottom with the vertical offset provided.
  func layoutBottomLabel(label: UILabel, verticalOffset: CGFloat) {
    let c = dividerContentEdgeInsets
    label.frame.origin.x = c.left
    label.frame.origin.y = bounds.height + verticalOffset
    label.frame.size.width = bounds.width - c.left - c.right
    label.frame.size.height = label.sizeThatFits(CGSize(width: label.bounds.width, height: .greatestFiniteMagnitude)).height
  }
}

private extension Editor {
  /// Notification handler for when text editing began.
  @objc
  func handleTextViewTextDidBegin() {
    updateEditorState(isAnimated: true)
  }
  
  /// Notification handler for when text changed.
  @objc
  func handleTextViewTextDidChange() {
    updateEditorState()
  }
  
  /// Notification handler for when text editing ended.
  @objc
  func handleTextViewTextDidEnd() {
    updateEditorState(isAnimated: true)
  }
  
  /// Updates editor.
  func updateEditorState(isAnimated: Bool = false) {
    updatePlaceholderVisibility()
    updatePlaceholderLabelColor()
    updateDividerHeight()
    updateDividerColor()
    
    guard isAnimated && isPlaceholderAnimated else {
      layoutPlaceholderLabel()
      return
    }
    
    UIView.animate(withDuration: 0.15, animations: layoutPlaceholderLabel)
  }
}

public extension Editor {
  /// A reference to the textView text.
  var text: String! {
    get {
      return textView.text
    }
    set(value) {
      textView.text = value
    }
  }
  
  /// A reference to the textView font.
  var font: UIFont? {
    get {
      return textView.font
    }
    set(value) {
      textView.font = value
    }
  }
  
  /// A reference to the textView placeholder.
  var placeholder: String? {
    get {
      return textView.placeholder
    }
    set(value) {
      textView.placeholder = value
    }
  }
  
  /// A reference to the textView textAlignment.
  var textAlignment: NSTextAlignment {
    get {
      return textView.textAlignment
    }
    set(value) {
      textView.textAlignment = value
      detailLabel.textAlignment = value
    }
  }
}
