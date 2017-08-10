/*
 * Copyright (C) 2015 - 2017, Daniel Dahan and CosmicMind, Inc. <http://cosmicmind.com>.
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

open class TextView: UITextView {
    /// A boolean indicating whether the text is empty.
    open var isEmpty: Bool {
        return 0 == text?.utf16.count
    }
    
    
    /// This property adds a padding to placeholder y position animation
    @IBInspectable
    open var placeholderVerticalOffset: CGFloat = 0
    
    /// EdgeInsets for text.
    open var textInset: CGFloat = 0
    
    @IBInspectable
    open var isPlaceholderAnimated = true
    /// A boolean indicating whether the text is in edit mode.
    open fileprivate(set) var isEditing = false
    
    /// Is the keyboard hidden.
    open fileprivate(set) var isKeyboardHidden = true
    
    //Height of the label, even as the multiline textview expands
    open fileprivate(set) var placeholderHeight: CGFloat = 32
    //Height of the textview when it initially lays out (before it has expanded)
    open fileprivate(set) var baseHeight: CGFloat = 32
    
    /// A property that accesses the backing layer's background
    @IBInspectable
    open override var backgroundColor: UIColor? {
        didSet {
            layer.backgroundColor = backgroundColor?.cgColor
        }
    }
    
    @IBInspectable
    open var dividerNormalColor = Color.darkText.dividers {
        didSet {
            guard !isEditing else {
                return
            }
            
            dividerColor = dividerNormalColor
        }
    }
    
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
    
    /// The detailLabel UILabel that is displayed.
    @IBInspectable
    open let detailLabel = UILabel()
    
    @IBInspectable
    open var detailColor = Color.darkText.others {
        didSet {
            updateDetailLabelColor()
        }
    }
    
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
    public init() {
        let textContainer = NSTextContainer(size: .zero)
        
        let layoutManager = NSLayoutManager()
        layoutManager.addTextContainer(textContainer)
        
        let textStorage = TextStorage()
        textStorage.addLayoutManager(layoutManager)
        
        super.init(frame: .zero, textContainer: textContainer)
        
        textContainer.size = bounds.size
        textStorage.delegate = self
        prepare()
    }
    
    /// Denitializer.
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        height = max(baseHeight, height) //This makes the magic happen --> Basically gives this view a min height of 32, then lets it expand
        layoutShape()
        layoutShadowPath()
        layoutPlaceholderLabel()
        layoutDivider()
        layoutDetailLabel()
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
        contentScaleFactor = Screen.scale
        textContainerInset = .zero
        backgroundColor = nil
        isScrollEnabled = false //Ensures the field expands to fit the text
        font = RobotoFont.regular(with: 16)
        textColor = Color.darkText.primary
        prepareNotificationHandlers()
        prepareRegularExpression()
        preparePlaceholderLabel()
        prepareDivider()
        prepareDetailLabel()
    }
}

extension TextView {
    /// Prepares the Notification handlers.
    fileprivate func prepareNotificationHandlers() {
        let defaultCenter = NotificationCenter.default
        defaultCenter.addObserver(self, selector: #selector(handleKeyboardWillShow(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        defaultCenter.addObserver(self, selector: #selector(handleKeyboardWillHide(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        defaultCenter.addObserver(self, selector: #selector(handleKeyboardDidShow(notification:)), name: NSNotification.Name.UIKeyboardDidShow, object: nil)
        defaultCenter.addObserver(self, selector: #selector(handleKeyboardDidHide(notification:)), name: NSNotification.Name.UIKeyboardDidHide, object: nil)
        defaultCenter.addObserver(self, selector: #selector(handleTextViewTextDidBegin), name: NSNotification.Name.UITextViewTextDidBeginEditing, object: self)
        defaultCenter.addObserver(self, selector: #selector(handleTextViewTextDidChange), name: NSNotification.Name.UITextViewTextDidChange, object: self)
        defaultCenter.addObserver(self, selector: #selector(handleTextViewTextDidEnd), name: NSNotification.Name.UITextViewTextDidEndEditing, object: self)
    }
    
    /// Prepares the regular expression for matching.
    fileprivate func prepareRegularExpression() {
        (textStorage as? TextStorage)?.expression = try? NSRegularExpression(pattern: pattern, options: [])
    }
    
    /// prepares the placeholderLabel property.
    fileprivate func preparePlaceholderLabel() {
        placeholderLabel.textColor = Color.darkText.others
        placeholderLabel.textAlignment = textAlignment
        placeholderLabel.numberOfLines = 0
        placeholderLabel.backgroundColor = .clear
        addSubview(placeholderLabel)
    }
    
    fileprivate func prepareDivider() {
        dividerColor = dividerNormalColor
    }
    
    fileprivate func prepareDetailLabel() {
        detailLabel.font = RobotoFont.regular(with: 12)
        detailLabel.numberOfLines = 0
        detailColor = Color.darkText.others
        addSubview(detailLabel)
    }
}

extension TextView {
    /// Updates the placeholderLabel text color.
    fileprivate func updatePlaceholderLabelColor() {
        tintColor = placeholderActiveColor
        placeholderLabel.textColor = isEditing ? placeholderActiveColor : placeholderNormalColor
    }
    /// Updates the detailLabel text color.
    fileprivate func updateDetailLabelColor() {
        detailLabel.textColor = detailColor
    }
}

extension TextView {
    /// Laysout the placeholder UILabel.
    fileprivate func layoutPlaceholderLabel() {
        let w = textInset
        let h: CGFloat = placeholderHeight
        
        placeholderLabel.transform = CGAffineTransform.identity
        
        guard isEditing || !isEmpty || !isPlaceholderAnimated else {
            placeholderLabel.frame = CGRect(x: w, y: 0, width: width - 2 * textInset, height: h)
            return
        }
        
        placeholderLabel.frame = CGRect(x: w, y: 0, width: width - 2 * textInset, height: h)
        placeholderLabel.transform = CGAffineTransform(scaleX: 0.75, y: 0.75)
        
        switch textAlignment {
        case .left, .natural:
            placeholderLabel.x = w
        case .right:
            placeholderLabel.x = width - placeholderLabel.width - textInset
        default:break
        }
        
        placeholderLabel.y = -placeholderLabel.height + placeholderVerticalOffset
    }
    
    /// Layout the detailLabel.
    fileprivate func layoutDetailLabel() {
        let c = dividerContentEdgeInsets
        detailLabel.height = detailLabel.sizeThatFits(CGSize(width: width, height: .greatestFiniteMagnitude)).height
        detailLabel.x = c.left
        detailLabel.y = height
        detailLabel.width = width - c.left - c.right
    }
}

extension TextView {
    /// The animation for the divider when editing begins.
    fileprivate func dividerEditingDidBeginAnimation() {
        dividerColor = dividerActiveColor
    }
    
    /// The animation for the divider when editing ends.
    fileprivate func dividerEditingDidEndAnimation() {
        dividerColor = dividerNormalColor
    }
    
    fileprivate func placeholderEditingDidBeginAnimation() {
        
        updatePlaceholderLabelColor()
        
        guard isPlaceholderAnimated else {
            return
        }
        
        guard isEmpty else {
            return
        }
        
        UIView.animate(withDuration: 0.15, animations: { [weak self] in
            guard let s = self else {
                return
            }
            
            s.placeholderLabel.transform = CGAffineTransform(scaleX: 0.75, y: 0.75)
            
            switch s.textAlignment {
            case .left, .natural:
                s.placeholderLabel.x = s.textInset
            case .right:
                s.placeholderLabel.x = s.width - s.placeholderLabel.width - s.textInset
            default:break
            }
            
            s.placeholderLabel.y = -s.placeholderLabel.height + s.placeholderVerticalOffset
        })
    }
    
    fileprivate func placeholderEditingDidEndAnimation() {
        
        updatePlaceholderLabelColor()
        
        guard isPlaceholderAnimated else {
            return
        }
        
        guard isEmpty else {
            return
        }
        
        UIView.animate(withDuration: 0.15, animations: { [weak self] in
            guard let s = self else {
                return
            }
            
            s.placeholderLabel.transform = CGAffineTransform.identity
            s.placeholderLabel.x = s.textInset
            s.placeholderLabel.y = 0
        })
    }
}

extension TextView {
    /**
     Handler for when the keyboard will open.
     - Parameter notification: A Notification.
     */
    @objc
    fileprivate func handleKeyboardWillShow(notification: Notification) {
        guard isKeyboardHidden else {
            return
        }
        
        guard let v = notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue else {
            return
        }
        
        (delegate as? TextViewDelegate)?.textView?(textView: self, willShowKeyboard: v)
    }
    
    /**
     Handler for when the keyboard did open.
     - Parameter notification: A Notification.
     */
    @objc
    fileprivate func handleKeyboardDidShow(notification: Notification) {
        guard isKeyboardHidden else {
            return
        }
        
        isKeyboardHidden = false
        
        guard let v = notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue else {
            return
        }
        
        (delegate as? TextViewDelegate)?.textView?(textView: self, didShowKeyboard: v)
    }
    
    /**
     Handler for when the keyboard will close.
     - Parameter notification: A Notification.
     */
    @objc
    fileprivate func handleKeyboardWillHide(notification: Notification) {
        guard !isKeyboardHidden else {
            return
        }
        
        guard let v = notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue else {
            return
        }
        
        (delegate as? TextViewDelegate)?.textView?(textView: self, willHideKeyboard: v)
    }
    
    /**
     Handler for when the keyboard did close.
     - Parameter notification: A Notification.
     */
    @objc
    fileprivate func handleKeyboardDidHide(notification: Notification) {
        guard !isKeyboardHidden else {
            return
        }
        
        isKeyboardHidden = true
        
        guard let v = notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue else {
            return
        }
        
        (delegate as? TextViewDelegate)?.textView?(textView: self, didHideKeyboard: v)
    }
    
    /// Notification handler for when text editing began.
    @objc
    fileprivate func handleTextViewTextDidBegin() {
        isEditing = true
        dividerEditingDidBeginAnimation()
        placeholderEditingDidBeginAnimation()
    }
    
    /// Notification handler for when text changed.
    @objc
    fileprivate func handleTextViewTextDidChange() {
    }
    
    /// Notification handler for when text editing ended.
    @objc
    fileprivate func handleTextViewTextDidEnd() {
        isEditing = false
        placeholderEditingDidEndAnimation()
        dividerEditingDidEndAnimation()
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
