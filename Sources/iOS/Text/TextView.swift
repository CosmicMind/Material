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

@objc(TextViewDelegate)
public protocol TextViewDelegate : UITextViewDelegate {
  /**
   A delegation method that is executed when the keyboard will open.
   - Parameter textView: A TextView.
   - Parameter willShowKeyboard value: A NSValue.
   */
  @objc
  optional func textView(textView: TextView, willShowKeyboard value: NSValue)
  
  /**
   A delegation method that is executed when the keyboard will close.
   - Parameter textView: A TextView.
   - Parameter willHideKeyboard value: A NSValue.
   */
  @objc
  optional func textView(textView: TextView, willHideKeyboard value: NSValue)
  
  /**
   A delegation method that is executed when the keyboard did open.
   - Parameter textView: A TextView.
   - Parameter didShowKeyboard value: A NSValue.
   */
  @objc
  optional func textView(textView: TextView, didShowKeyboard value: NSValue)
  
  /**
   A delegation method that is executed when the keyboard did close.
   - Parameter textView: A TextView.
   - Parameter didHideKeyboard value: A NSValue.
   */
  @objc
  optional func textView(textView: TextView, didHideKeyboard value: NSValue)
  
  /**
   A delegation method that is executed when text will be
   processed during editing.
   - Parameter textView: A TextView.
   - Parameter willProcessEditing textStorage: A TextStorage.
   - Parameter text: A String.
   - Parameter range: A NSRange.
   */
  @objc
  optional func textView(textView: TextView, willProcessEditing textStorage: TextStorage, text: String, range: NSRange)
  
  /**
   A delegation method that is executed when text has been
   processed after editing.
   - Parameter textView: A TextView.
   - Parameter didProcessEditing textStorage: A TextStorage.
   - Parameter text: A String.
   - Parameter range: A NSRange.
   */
  @objc
  optional func textView(textView: TextView, didProcessEditing textStorage: TextStorage, text: String, range: NSRange)
}

open class TextView: UITextView, Themeable {
  /// A boolean indicating whether the text is empty.
  open var isEmpty: Bool {
    return 0 == text?.utf16.count
  }
  
  /// A boolean indicating whether the text is in edit mode.
  open fileprivate(set) var isEditing = false
  
  /// Is the keyboard hidden.
  open fileprivate(set) var isKeyboardHidden = true
  
  /// A property that accesses the backing layer's background
  @IBInspectable
  open override var backgroundColor: UIColor? {
    didSet {
      layer.backgroundColor = backgroundColor?.cgColor
    }
  }
  
  /// Holds default font.
  private var _font: UIFont?
  
  /// The placeholderLabel font value.
  @IBInspectable
  open override var font: UIFont? {
    didSet {
      _font = font
      placeholderLabel.font = font
    }
  }
  
  /// The placeholderLabel text value.
  @IBInspectable
  open var placeholder: String? {
    get {
      return placeholderLabel.text
    }
    set(value) {
      placeholderLabel.text = value
    }
  }
  
  /// The placeholder UILabel.
  @IBInspectable
  public let placeholderLabel = UILabel()
  
  /// A property to enable/disable operations on the placeholderLabel
  internal var isPlaceholderLabelEnabled = true
  
  /// Placeholder normal text
  @IBInspectable
  open var placeholderColor = Color.darkText.others {
    didSet {
      updatePlaceholderLabelColor()
    }
  }
  
  /// NSTextContainer EdgeInsets preset property.
  open var textContainerInsetsPreset = EdgeInsetsPreset.none {
    didSet {
      textContainerInsets = EdgeInsetsPresetToValue(preset: textContainerInsetsPreset)
    }
  }
  
  /// NSTextContainer EdgeInsets property.
  open var textContainerInsets: EdgeInsets {
    get {
      return textContainerInset
    }
    set(value) {
      textContainerInset = value
    }
  }
  
  /// Handles the textAlignment of the placeholderLabel and textView itself.
  open override var textAlignment: NSTextAlignment {
    didSet {
      placeholderLabel.textAlignment = textAlignment
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
  
  /// The string pattern to match within the textStorage.
  open var pattern = "(^|\\s)#[\\d\\w_\u{203C}\u{2049}\u{20E3}\u{2122}\u{2139}\u{2194}-\u{2199}\u{21A9}-\u{21AA}\u{231A}-\u{231B}\u{23E9}-\u{23EC}\u{23F0}\u{23F3}\u{24C2}\u{25AA}-\u{25AB}\u{25B6}\u{25C0}\u{25FB}-\u{25FE}\u{2600}-\u{2601}\u{260E}\u{2611}\u{2614}-\u{2615}\u{261D}\u{263A}\u{2648}-\u{2653}\u{2660}\u{2663}\u{2665}-\u{2666}\u{2668}\u{267B}\u{267F}\u{2693}\u{26A0}-\u{26A1}\u{26AA}-\u{26AB}\u{26BD}-\u{26BE}\u{26C4}-\u{26C5}\u{26CE}\u{26D4}\u{26EA}\u{26F2}-\u{26F3}\u{26F5}\u{26FA}\u{26FD}\u{2702}\u{2705}\u{2708}-\u{270C}\u{270F}\u{2712}\u{2714}\u{2716}\u{2728}\u{2733}-\u{2734}\u{2744}\u{2747}\u{274C}\u{274E}\u{2753}-\u{2755}\u{2757}\u{2764}\u{2795}-\u{2797}\u{27A1}\u{27B0}\u{2934}-\u{2935}\u{2B05}-\u{2B07}\u{2B1B}-\u{2B1C}\u{2B50}\u{2B55}\u{3030}\u{303D}\u{3297}\u{3299}\u{1F004}\u{1F0CF}\u{1F170}-\u{1F171}\u{1F17E}-\u{1F17F}\u{1F18E}\u{1F191}-\u{1F19A}\u{1F1E7}-\u{1F1EC}\u{1F1EE}-\u{1F1F0}\u{1F1F3}\u{1F1F5}\u{1F1F7}-\u{1F1FA}\u{1F201}-\u{1F202}\u{1F21A}\u{1F22F}\u{1F232}-\u{1F23A}\u{1F250}-\u{1F251}\u{1F300}-\u{1F320}\u{1F330}-\u{1F335}\u{1F337}-\u{1F37C}\u{1F380}-\u{1F393}\u{1F3A0}-\u{1F3C4}\u{1F3C6}-\u{1F3CA}\u{1F3E0}-\u{1F3F0}\u{1F400}-\u{1F43E}\u{1F440}\u{1F442}-\u{1F4F7}\u{1F4F9}-\u{1F4FC}\u{1F500}-\u{1F507}\u{1F509}-\u{1F53D}\u{1F550}-\u{1F567}\u{1F5FB}-\u{1F640}\u{1F645}-\u{1F64F}\u{1F680}-\u{1F68A}]+" {
    didSet {
      prepareRegularExpression()
    }
  }
  
  /// A reference to the textView text.
  open override var text: String! {
    didSet {
      setContentOffset(.zero, animated: true)
      updatePlaceholderVisibility()
    }
  }
  
  /**
   A convenience property that accesses the textStorage
   string.
   */
  open var string: String {
    return textStorage.string
  }
  
  /// An Array of matches that match the pattern expression.
  open var matches: [String] {
    guard let v = (textStorage as? TextStorage)?.expression else {
      return []
    }
    
    return v.matches(in: string, options: [], range: NSMakeRange(0, string.utf16.count)).map { [unowned self] in
      (self.string as NSString).substring(with: $0.range).trimmed
    }
  }
  
  /**
   An Array of unique matches that match the pattern
   expression.
   */
  open var uniqueMatches: [String] {
    var set = Set<String>()
    for x in matches {
      set.insert(x)
    }
    return Array<String>(set)
  }
  
  /**
   An initializer that initializes the object with a CGRect object.
   If AutoLayout is used, it is better to initilize the instance
   using the init() initializer.
   - Parameter frame: A CGRect instance.
   - Parameter textContainer: A NSTextContainer instance.
   */
  public override init(frame: CGRect, textContainer: NSTextContainer?) {
    super.init(frame: frame, textContainer: textContainer)
    prepare()
  }
  
  /**
   A convenience initializer that is mostly used with AutoLayout.
   - Parameter textContainer: A NSTextContainer instance.
   */
  public convenience init(textContainer: NSTextContainer?) {
    self.init(frame: .zero, textContainer: textContainer)
  }
  
  /// A convenience initializer that constructs all aspects of the textView.
  public convenience init() {
    let textContainer = NSTextContainer(size: .zero)
    
    let layoutManager = NSLayoutManager()
    layoutManager.addTextContainer(textContainer)
    
    let textStorage = TextStorage()
    textStorage.addLayoutManager(layoutManager)
    
    self.init(textContainer: textContainer)
    
    textContainer.size = bounds.size
    textStorage.delegate = self
  }
  
  /// Denitializer.
  deinit {
    NotificationCenter.default.removeObserver(self)
  }
  
  open override func layoutSubviews() {
    super.layoutSubviews()
    layoutShape()
    layoutShadowPath()
    layoutPlaceholderLabel()
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
    textContainerInset = .zero
    backgroundColor = nil
    font = Theme.font.regular(with: 16)
    textColor = Color.darkText.primary
    
    prepareNotificationHandlers()
    prepareRegularExpression()
    preparePlaceholderLabel()
    applyCurrentTheme()
  }
  
  open override var contentSize: CGSize {
    didSet {
      guard isGrowEnabled else {
        return
      }
      invalidateIntrinsicContentSize()
      
      guard isEditing && isHeightChangeAnimated else {
        superview?.layoutIfNeeded()
        return
      }
      
      UIView.animate(withDuration: 0.15) {
        let v = self.superview as? Editor ?? self
        v.superview?.layoutIfNeeded()
      }
    }
  }
  
  /// A Boolean that indicates if the height change during growing is animated.
  open var isHeightChangeAnimated = true
  
  /// Maximum preffered layout height before scrolling.
  open var preferredMaxLayoutHeight: CGFloat = 0 {
    didSet {
      invalidateIntrinsicContentSize()
      superview?.layoutIfNeeded()
    }
  }
  
  /// A property indicating if textView allowed to grow.
  private var isGrowEnabled: Bool {
    return preferredMaxLayoutHeight > 0 && isScrollEnabled
  }
  
  /// Minimum TextView text height.
  internal let minimumTextHeight: CGFloat = 32
  
  open override var intrinsicContentSize: CGSize {
    guard isGrowEnabled else {
      return super.intrinsicContentSize
    }
    
    let insets = textContainerInsets
    
    let w = bounds.width - insets.left - insets.right - 2 * textContainer.lineFragmentPadding
    let placeholderH = placeholderLabel.sizeThatFits(CGSize(width: w, height: .greatestFiniteMagnitude)).height
    var h = max(minimumTextHeight, placeholderH) + insets.top + insets.bottom
    h = max(h, contentSize.height)
    return CGSize(width: UIView.noIntrinsicMetric, height: min(h, preferredMaxLayoutHeight))
  }
  
  open override func insertText(_ text: String) {
    fixTypingFont()
    super.insertText(text)
    fixTypingFont()
  }
  
  open override func paste(_ sender: Any?) {
    fixTypingFont()
    super.paste(sender)
    fixTypingFont()
  }
  
  /**
   Applies the given theme.
   - Parameter theme: A Theme.
   */
  open func apply(theme: Theme) {
    textColor = theme.onSurface.withAlphaComponent(0.87)
    placeholderColor = theme.onSurface.withAlphaComponent(0.38)
  }
}

fileprivate extension TextView {
  /// Prepares the Notification handlers.
  func prepareNotificationHandlers() {
    let defaultCenter = NotificationCenter.default
    defaultCenter.addObserver(self, selector: #selector(handleKeyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
    defaultCenter.addObserver(self, selector: #selector(handleKeyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    defaultCenter.addObserver(self, selector: #selector(handleKeyboardDidShow(notification:)), name: UIResponder.keyboardDidShowNotification, object: nil)
    defaultCenter.addObserver(self, selector: #selector(handleKeyboardDidHide(notification:)), name: UIResponder.keyboardDidHideNotification, object: nil)
    defaultCenter.addObserver(self, selector: #selector(handleTextViewTextDidBegin), name: UITextView.textDidBeginEditingNotification, object: self)
    defaultCenter.addObserver(self, selector: #selector(handleTextViewTextDidChange), name: UITextView.textDidChangeNotification, object: self)
    defaultCenter.addObserver(self, selector: #selector(handleTextViewTextDidEnd), name: UITextView.textDidEndEditingNotification, object: self)
  }
  
  /// Prepares the regular expression for matching.
  func prepareRegularExpression() {
    (textStorage as? TextStorage)?.expression = try? NSRegularExpression(pattern: pattern, options: [])
  }
  
  /// prepares the placeholderLabel property.
  func preparePlaceholderLabel() {
    placeholderLabel.textColor = Color.darkText.others
    placeholderLabel.textAlignment = textAlignment
    placeholderLabel.numberOfLines = 0
    placeholderLabel.backgroundColor = .clear
    addSubview(placeholderLabel)
  }
}

fileprivate extension TextView {
  /// Updates the placeholderLabel text color.
  func updatePlaceholderLabelColor() {
    guard isPlaceholderLabelEnabled else {
      return
    }
    
    tintColor = placeholderColor
    placeholderLabel.textColor = placeholderColor
  }
  
  /// Updates the placeholderLabel visibility.
  func updatePlaceholderVisibility() {
    guard isPlaceholderLabelEnabled else {
      return
    }
    
    placeholderLabel.isHidden = !isEmpty
  }
}

fileprivate extension TextView {
  /// Laysout the placeholder UILabel.
  func layoutPlaceholderLabel() {
    guard isPlaceholderLabelEnabled else {
      return
    }
    
    let insets = textContainerInsets
    let leftPadding = insets.left + textContainer.lineFragmentPadding
    let rightPadding = insets.right + textContainer.lineFragmentPadding
    let w = bounds.width - leftPadding - rightPadding
    var h = placeholderLabel.sizeThatFits(CGSize(width: w, height: .greatestFiniteMagnitude)).height
    h = max(h, minimumTextHeight)
    h = min(h, bounds.height - insets.top - insets.bottom)
    
    placeholderLabel.frame = CGRect(x: leftPadding, y: insets.top, width: w, height: h)
  }
}

fileprivate extension TextView {
  /**
   Handler for when the keyboard will open.
   - Parameter notification: A Notification.
   */
  @objc
  func handleKeyboardWillShow(notification: Notification) {
    guard isKeyboardHidden else {
      return
    }
    
    guard let v = notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue else {
      return
    }
    
    (delegate as? TextViewDelegate)?.textView?(textView: self, willShowKeyboard: v)
  }
  
  /**
   Handler for when the keyboard did open.
   - Parameter notification: A Notification.
   */
  @objc
  func handleKeyboardDidShow(notification: Notification) {
    guard isKeyboardHidden else {
      return
    }
    
    isKeyboardHidden = false
    
    guard let v = notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue else {
      return
    }
    
    (delegate as? TextViewDelegate)?.textView?(textView: self, didShowKeyboard: v)
  }
  
  /**
   Handler for when the keyboard will close.
   - Parameter notification: A Notification.
   */
  @objc
  func handleKeyboardWillHide(notification: Notification) {
    guard !isKeyboardHidden else {
      return
    }
    
    guard let v = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else {
      return
    }
    
    (delegate as? TextViewDelegate)?.textView?(textView: self, willHideKeyboard: v)
  }
  
  /**
   Handler for when the keyboard did close.
   - Parameter notification: A Notification.
   */
  @objc
  func handleKeyboardDidHide(notification: Notification) {
    guard !isKeyboardHidden else {
      return
    }
    
    isKeyboardHidden = true
    
    guard let v = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else {
      return
    }
    
    (delegate as? TextViewDelegate)?.textView?(textView: self, didHideKeyboard: v)
  }
  
  /// Notification handler for when text editing began.
  @objc
  func handleTextViewTextDidBegin() {
    isEditing = true
  }
  
  /// Notification handler for when text changed.
  @objc
  func handleTextViewTextDidChange() {
    updatePlaceholderVisibility()
  }
  
  /// Notification handler for when text editing ended.
  @objc
  func handleTextViewTextDidEnd() {
    isEditing = false
    updatePlaceholderVisibility()
  }
}

extension TextView: TextStorageDelegate {
  @objc
  open func textStorage(textStorage: TextStorage, willProcessEditing text: String, range: NSRange) {
    (delegate as? TextViewDelegate)?.textView?(textView: self, willProcessEditing: textStorage, text: string, range: range)
  }
  
  @objc
  open func textStorage(textStorage: TextStorage, didProcessEditing text: String, result: NSTextCheckingResult?, flags: NSRegularExpression.MatchingFlags, stop: UnsafeMutablePointer<ObjCBool>) {
    guard let range = result?.range else {
      return
    }
    
    (delegate as? TextViewDelegate)?.textView?(textView: self, didProcessEditing: textStorage, text: string, range: range)
  }
}

private extension TextView {
  /// issue-838 and pr-1117
  ///
  /// Inserting (typing or pasting) an emoji character or placing cursor after some
  /// emoji characters (e.g ☺️) was causing typing font to change to "AppleColorEmoji"
  /// and which was eventually falling back to "Courier New" when a non-emoji
  /// character is inserted. This only happens only if `NSTextStorage` subclass is
  /// used, otherwise typing font never changed to "AppleColorEmoji". So, we fix it
  /// by resetting typing font from AppleColorEmoji to the default font set by the
  /// developer. The fix is applied before and after inserting text. The former fixes
  /// typing font change due to cursor placed after an emoji character, and the
  /// latter fixes the typing font change due to the insertion of an emoji character
  /// (typing font changes somehow are reflected in `UITextView.font` parameter).
  func fixTypingFont() {
    let fontAttribute = NSAttributedString.Key.font
    
    guard (typingAttributes[fontAttribute] as? UIFont)?.fontName == "AppleColorEmoji" else {
      return
    }
    
    typingAttributes[fontAttribute] = _font
  }
}
