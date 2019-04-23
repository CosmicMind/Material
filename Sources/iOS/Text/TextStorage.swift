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

@objc(TextStorageDelegate)
public protocol TextStorageDelegate: NSTextStorageDelegate {
  /**
   A delegation method that is executed when text will be 
   processed during editing.
   - Parameter textStorage: A TextStorage.
   - Parameter willProcessEditing text: A String.
   - Parameter range: A NSRange.
   */
  @objc
  optional func textStorage(textStorage: TextStorage, willProcessEditing text: String, range: NSRange)
  
  /**
   A delegation method that is executed when text has been
   processed after editing.
   - Parameter textStorage: A TextStorage.
   - Parameter didProcessEditing text: A String.
   - Parameter result: An optional NSTextCheckingResult.
   - Parameter flags: NSRegularExpression.MatchingFlags.
   - Parameter top: An UnsafeMutablePointer<ObjCBool>.
   */
  @objc
  optional func textStorage(textStorage: TextStorage, didProcessEditing text: String, result: NSTextCheckingResult?, flags: NSRegularExpression.MatchingFlags, stop: UnsafeMutablePointer<ObjCBool>)
}

open class TextStorage: NSTextStorage {
  /// A storage facility for attributed text.
  public let storage = NSMutableAttributedString()
  
  /// The regular expression to match text fragments against.
  open var expression: NSRegularExpression?
  
  /// Initializer.
  public required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }
  
  /// Initializer.
  public override init() {
    super.init()
  }
}

extension TextStorage {
  /// A String value of the attirbutedString property.
  open override var string: String {
    return storage.string
  }
  
  /// Processes the text when editing.
  open override func processEditing() {
    let range = (string as NSString).paragraphRange(for: editedRange)
    
    (delegate as? TextStorageDelegate)?.textStorage?(textStorage: self, willProcessEditing: string, range: range)
    
    expression?.enumerateMatches(in: string, options: [], range: range) { [unowned self] (result: NSTextCheckingResult?, flags: NSRegularExpression.MatchingFlags, stop: UnsafeMutablePointer<ObjCBool>) -> Void in
      (self.delegate as? TextStorageDelegate)?.textStorage?(textStorage: self, didProcessEditing: self.string, result: result, flags: flags, stop: stop)
    }
    
    storage.fixAttributes(in: range)
    
    super.processEditing()
  }
  
  /**
   Returns the attributes for the character at a given index.
   - Parameter location: An Int
   - Parameter effectiveRange range: Upon return, the range over which the
   attributes and values are the same as those at index. This range
   isn’t necessarily the maximum range covered, and its extent is
   implementation-dependent. If you need the maximum range, use
   attributesAtIndex:longestEffectiveRange:inRange:.
   If you don't need this value, pass NULL.
   - Returns: The attributes for the character at index.
   */
  open override func attributes(at location: Int, effectiveRange range: NSRangePointer?) -> [NSAttributedString.Key: Any] {
    return storage.attributes(at: location, effectiveRange: range)
  }
  
  /**
   Replaces a range of text with a string value.
   - Parameter range: The character range to replace.
   - Parameter str: The string value that the characters
   will be replaced with.
   */
  open override func replaceCharacters(in range: NSRange, with str: String) {
    storage.replaceCharacters(in: range, with: str)
    edited(.editedCharacters, range: range, changeInLength: str.utf16.count - range.length)
  }
  
  /**
   Sets the attributedString attribute values.
   - Parameter attrs: The attributes to set.
   - Parameter range: A range of characters that will have their
   attributes updated.
   */
  open override func setAttributes(_ attrs: [NSAttributedString.Key : Any]?, range: NSRange) {
    storage.setAttributes(attrs, range: range)
    edited(.editedAttributes, range: range, changeInLength: 0)
  }
  
  /**
   Adds an individual attribute.
   - Parameter _ name: Attribute name.
   - Parameter value: An Any type.
   - Parameter range: A range of characters that will have their
   attributes added.
   */
  open override func addAttribute(_ name: NSAttributedString.Key, value: Any, range: NSRange) {
    storage.addAttribute(name, value: value, range: range)
    edited(.editedAttributes, range: range, changeInLength: 0)
  }
  
  /**
   Removes an individual attribute.
   - Parameter _ name: Attribute name.
   - Parameter range: A range of characters that will have their
   attributes removed.
   */
  open override func removeAttribute(_ name: NSAttributedString.Key, range: NSRange) {
    storage.removeAttribute(name, range: range)
    edited(.editedAttributes, range: range, changeInLength: 0)
  }
}
