/*
 * Copyright (C) 2015 - 2016, Daniel Dahan and CosmicMind, Inc. <http://cosmicmind.com>.
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

@objc(EditorDelegate)
public protocol EditorDelegate {
    /**
     A delegation method that is executed when text will be
     processed during editing.
     - Parameter editor: An Editor.
     - Parameter willProcessEditing textStorage: A TextStorage.
     - Parameter text: A String.
     - Parameter range: A NSRange.
     */
    @objc
    optional func editor(editor: Editor, willProcessEditing textStorage: TextStorage, text: String, range: NSRange)
    
    /**
     A delegation method that is executed when text has been
     processed after editing.
     - Parameter editor: An Editor.
     - Parameter didProcessEditing textStorage: A TextStorage.
     - Parameter text: A String.
     - Parameter range: A NSRange.
     */
    @objc
    optional func editor(editor: Editor, didProcessEditing textStorage: TextStorage, text: String, range: NSRange)
    
    /**
     A delegation method that is executed when the textView should begin editing.
     - Parameter editor: An Editor.
     - Parameter shouldBeginEditing textView: A UITextView.
     - Returns: A boolean indicating if the textView should begin editing, true if
     yes, false otherwise.
     */
    @objc
    optional func editor(editor: Editor, shouldBeginEditing textView: UITextView) -> Bool
    
    /**
     A delegation method that is executed when the textView should end editing.
     - Parameter editor: An Editor.
     - Parameter shouldEndEditing textView: A UITextView.
     - Returns: A boolean indicating if the textView should end editing, true if
     yes, false otherwise.
     */
    @objc
    optional func editor(editor: Editor, shouldEndEditing textView: UITextView) -> Bool
    
    /**
     A delegation method that is executed when the textView did begin editing.
     - Parameter editor: An Editor.
     - Parameter didBeginEditing textView: A UITextView.
     */
    @objc
    optional func editor(editor: Editor, didBeginEditing textView: UITextView)
    
    /**
     A delegation method that is executed when the textView did begin editing.
     - Parameter editor: An Editor.
     - Parameter didBeginEditing textView: A UITextView.
     */
    @objc
    optional func editor(editor: Editor, didEndEditing textView: UITextView)
    
    /**
     A delegation method that is executed when the textView should change text in
     a given range with replacement text.
     - Parameter editor: An Editor.
     - Parameter textView: A UITextView.
     - Parameter shouldChangeTextIn range: A NSRange.
     - Parameter replacementText text: A String.
     - Returns: A boolean indicating if the textView should change text in a given
     range with the given replacement text, true if yes, false otherwise.
     */
    @objc
    optional func editor(editor: Editor, textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool
    
    /**
     A delegation method that is executed when the textView did change.
     - Parameter editor: An Editor.
     - Parameter didChange textView: A UITextView.
     */
    @objc
    optional func editor(editor: Editor, didChange textView: UITextView)
    
    /**
     A delegation method that is executed when the textView did change a selection.
     - Parameter editor: An Editor.
     - Parameter didChangeSelection textView: A UITextView.
     */
    @objc
    optional func editor(editor: Editor, didChangeSelection textView: UITextView)
    
    /**
     A delegation method that is executed when the textView should interact with
     a URL in a given character range.
     - Parameter editor: An Editor.
     - Parameter textView: A UITextView.
     - Parameter shouldInteractWith URL: A URL.
     - Parameter in characterRange: A Range.
     - Returns: A boolean indicating if the textView should interact with a URL in
     a given character range, true if yes, false otherwise.
 
    @available(iOS, introduced: 8.0, deprecated: 10.0)
    @objc
    optional func editor(editor: Editor, textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange) -> Bool
    
     A delegation method that is executed when the textView should interact with
     a text attachment in a given character range.
     - Parameter editor: An Editor.
     - Parameter textView: A UITextView.
     - Parameter shouldInteractWith textAttachment: A NSTextAttachment.
     - Parameter in characterRange: A Range.
     - Returns: A boolean indicating if the textView should interact with a 
     NSTextAttachment in a given character range, true if yes, false otherwise.
    @available(iOS, introduced: 8.0, deprecated: 10.0)
    @objc
    optional func editor(editor: Editor, textView: UITextView, shouldInteractWith textAttachment: NSTextAttachment, in characterRange: NSRange) -> Bool
    
     A delegation method that is executed when the textView should interact with
     a URL in a given character range.
     - Parameter editor: An Editor.
     - Parameter textView: A UITextView.
     - Parameter shouldInteractWith URL: A URL.
     - Parameter in characterRange: A Range.
     - Parameter interaction: A UITextItemInteraction.
     - Returns: A boolean indicating if the textView should interact with a URL in
     a given character range, true if yes, false otherwise.
    @available(iOS 10.0, *)
    @objc
    optional func editor(editor: Editor, textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool
    
     A delegation method that is executed when the textView should interact with
     a text attachment in a given character range.
     - Parameter editor: An Editor.
     - Parameter textView: A UITextView.
     - Parameter shouldInteractWith textAttachment: A NSTextAttachment.
     - Parameter in characterRange: A Range.
     - Parameter interaction: A UITextItemInteraction.
     - Returns: A boolean indicating if the textView should interact with a
     NSTextAttachment in a given character range, true if yes, false otherwise.
    @available(iOS 10.0, *)
    @objc
    optional func editor(editor: Editor, textView: UITextView, shouldInteractWith textAttachment: NSTextAttachment, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool
    */
}

open class Editor: View {
    /// Will layout the view.
    open var willLayout: Bool {
        return 0 < width && 0 < height && nil != superview
    }
    
    /// TextStorage instance that is observed while editing.
    open fileprivate(set) var textStorage: TextStorage!
    
    /// A reference to the NSTextContainer.
    open fileprivate(set) var textContainer: NSTextContainer!
    
    /// A reference to the NSLayoutManager.
    open fileprivate(set) var layoutManager: NSLayoutManager!
    
    /// A preset wrapper around textViewEdgeInsets.
    open var textViewEdgeInsetsPreset = EdgeInsetsPreset.none {
        didSet {
            textViewEdgeInsets = EdgeInsetsPresetToValue(preset: textViewEdgeInsetsPreset)
        }
    }
    
    /// A reference to textViewEdgeInsets.
    @IBInspectable
    open var textViewEdgeInsets = EdgeInsets.zero {
        didSet {
            layoutSubviews()
        }
    }
    
    /// Reference to the TextView.
    open fileprivate(set) var textView: UITextView!
    
    /// A reference to an EditorDelegate.
    open weak var delegate: EditorDelegate?
    
    /// The string pattern to match within the textStorage.
    open var pattern = "(^|\\s)#[\\d\\w_\u{203C}\u{2049}\u{20E3}\u{2122}\u{2139}\u{2194}-\u{2199}\u{21A9}-\u{21AA}\u{231A}-\u{231B}\u{23E9}-\u{23EC}\u{23F0}\u{23F3}\u{24C2}\u{25AA}-\u{25AB}\u{25B6}\u{25C0}\u{25FB}-\u{25FE}\u{2600}-\u{2601}\u{260E}\u{2611}\u{2614}-\u{2615}\u{261D}\u{263A}\u{2648}-\u{2653}\u{2660}\u{2663}\u{2665}-\u{2666}\u{2668}\u{267B}\u{267F}\u{2693}\u{26A0}-\u{26A1}\u{26AA}-\u{26AB}\u{26BD}-\u{26BE}\u{26C4}-\u{26C5}\u{26CE}\u{26D4}\u{26EA}\u{26F2}-\u{26F3}\u{26F5}\u{26FA}\u{26FD}\u{2702}\u{2705}\u{2708}-\u{270C}\u{270F}\u{2712}\u{2714}\u{2716}\u{2728}\u{2733}-\u{2734}\u{2744}\u{2747}\u{274C}\u{274E}\u{2753}-\u{2755}\u{2757}\u{2764}\u{2795}-\u{2797}\u{27A1}\u{27B0}\u{2934}-\u{2935}\u{2B05}-\u{2B07}\u{2B1B}-\u{2B1C}\u{2B50}\u{2B55}\u{3030}\u{303D}\u{3297}\u{3299}\u{1F004}\u{1F0CF}\u{1F170}-\u{1F171}\u{1F17E}-\u{1F17F}\u{1F18E}\u{1F191}-\u{1F19A}\u{1F1E7}-\u{1F1EC}\u{1F1EE}-\u{1F1F0}\u{1F1F3}\u{1F1F5}\u{1F1F7}-\u{1F1FA}\u{1F201}-\u{1F202}\u{1F21A}\u{1F22F}\u{1F232}-\u{1F23A}\u{1F250}-\u{1F251}\u{1F300}-\u{1F320}\u{1F330}-\u{1F335}\u{1F337}-\u{1F37C}\u{1F380}-\u{1F393}\u{1F3A0}-\u{1F3C4}\u{1F3C6}-\u{1F3CA}\u{1F3E0}-\u{1F3F0}\u{1F400}-\u{1F43E}\u{1F440}\u{1F442}-\u{1F4F7}\u{1F4F9}-\u{1F4FC}\u{1F500}-\u{1F507}\u{1F509}-\u{1F53D}\u{1F550}-\u{1F567}\u{1F5FB}-\u{1F640}\u{1F645}-\u{1F64F}\u{1F680}-\u{1F68A}]+" {
        didSet {
            prepareRegularExpression()
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
        return textStorage.expression!.matches(in: string, options: [], range: NSMakeRange(0, string.utf16.count)).map { [unowned self] in
            (self.string as NSString).substring(with: $0.range).trimmed
        }
    }
    
    /**
     An Array of unique matches that match the pattern
     expression.
     */
    public var uniqueMatches: [String] {
        var seen = [String: Bool]()
        return matches.filter { nil == seen.updateValue(true, forKey: $0) }
    }
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        guard willLayout else {
            return
        }
        
        textView.frame = CGRect(x: textViewEdgeInsets.left, y: textViewEdgeInsets.top, width: width - textViewEdgeInsets.left - textViewEdgeInsets.right, height: height - textViewEdgeInsets.top - textViewEdgeInsets.bottom)
    }
    
    /**
     Prepares the view instance when intialized. When subclassing,
     it is recommended to override the prepare method
     to initialize property values and other setup operations.
     The super.prepare method should always be called immediately
     when subclassing.
     */
    open override func prepare() {
        super.prepare()
        prepareTextContainer()
        prepareLayoutManager()
        prepareTextStorage()
        prepareRegularExpression()
        prepareTextView()
    }
}

extension Editor {
    /// Prepares the textContainer.
    fileprivate func prepareTextContainer() {
        textContainer = NSTextContainer(size: bounds.size)
    }
    
    /// Prepares the layoutManager.
    fileprivate func prepareLayoutManager() {
        layoutManager = NSLayoutManager()
        layoutManager.addTextContainer(textContainer)
    }
    
    /// Prepares the textStorage.
    fileprivate func prepareTextStorage() {
        textStorage = TextStorage()
        textStorage.addLayoutManager(layoutManager)
        textStorage.delegate = self
    }
    
    /// Prepares the textView.
    fileprivate func prepareTextView() {
        textView = UITextView(frame: .zero, textContainer: textContainer)
        textView.delegate = self
        addSubview(textView)
    }
    
    /// Prepares the regular expression for matching.
    fileprivate func prepareRegularExpression() {
        textStorage.expression = try? NSRegularExpression(pattern: pattern, options: [])
    }
}

extension Editor: TextStorageDelegate {
    open func textStorage(textStorage: TextStorage, willProcessEditing text: String, range: NSRange) {
        delegate?.editor?(editor: self, willProcessEditing: textStorage, text: string, range: range)
    }
    
    open func textStorage(textStorage: TextStorage, didProcessEditing text: String, result: NSTextCheckingResult?, flags: NSRegularExpression.MatchingFlags, stop: UnsafeMutablePointer<ObjCBool>) {
        guard let range = result?.range else {
            return
        }
        
        delegate?.editor?(editor: self, didProcessEditing: textStorage, text: string, range: range)
    }
}

extension Editor: UITextViewDelegate {
    open func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        return delegate?.editor?(editor: self, shouldBeginEditing: textView) ?? true
    }
    
    open func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
        return delegate?.editor?(editor: self, shouldEndEditing: textView) ?? true
    }
    
    open func textViewDidBeginEditing(_ textView: UITextView) {
        delegate?.editor?(editor: self, didBeginEditing: textView)
    }
    
    open func textViewDidEndEditing(_ textView: UITextView) {
        delegate?.editor?(editor: self, didEndEditing: textView)
    }
    
    open func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        return delegate?.editor?(editor: self, textView: textView, shouldChangeTextIn: range, replacementText: text) ?? true
    }
    
    open func textViewDidChange(_ textView: UITextView) {
        delegate?.editor?(editor: self, didChange: textView)
    }
    
    open func textViewDidChangeSelection(_ textView: UITextView) {
        delegate?.editor?(editor: self, didChangeSelection: textView)
    }
}

/*
@available(iOS, introduced: 8.0, deprecated: : 10.0)
extension Editor {
    open func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange) -> Bool {
        return delegate?.editor?(editor: self, textView: textView, shouldInteractWith: URL, in: characterRange) ?? true
    }
    
    open func textView(_ textView: UITextView, shouldInteractWith textAttachment: NSTextAttachment, in characterRange: NSRange) -> Bool {
        return delegate?.editor?(editor: self, textView: textView, shouldInteractWith: textAttachment, in: characterRange) ?? true
    }
}

@available(iOS 10.0, *)
extension Editor {
    open func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        return delegate?.editor?(editor: self, textView: textView, shouldInteractWith: URL, in: characterRange, interaction: interaction) ?? true
    }
    
    open func textView(_ textView: UITextView, shouldInteractWith textAttachment: NSTextAttachment, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        return delegate?.editor?(editor: self, textView: textView, shouldInteractWith: textAttachment, in: characterRange, interaction: interaction) ?? true
    }
}
*/
