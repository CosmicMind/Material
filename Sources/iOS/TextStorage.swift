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

internal typealias TextWillProcessEdit = (TextStorage, String, NSRange) -> Void
internal typealias TextDidProcessEdit = (TextStorage, NSTextCheckingResult?, NSRegularExpression.MatchingFlags, UnsafeMutablePointer<ObjCBool>) -> Void

public class TextStorage: NSTextStorage {
	/// A callback that is executed when a process edit will happen.
	internal var textWillProcessEdit: TextWillProcessEdit?
	
	/// A callback that is executed when a process edit did happen.
	internal var textDidProcessEdit: TextDidProcessEdit?
	
	/// A storage facility for attributed text.
	public lazy var store: NSMutableAttributedString = NSMutableAttributedString()
	
	/// The regular expression to match text fragments against.
	public var expression: NSRegularExpression?
	
	/// Initializer.
	public required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}
	
	/// Initializer.
	public override init() {
		super.init()
	}
	
	/// A String value of the attirbutedString property.
	public override var string: String {
		return store.string
	}
	
	/// Processes the text when editing.
	public override func processEditing() {
		let range: NSRange = (string as NSString).paragraphRange(for: editedRange)
		
		textWillProcessEdit?(self, string, range)
		
		expression!.enumerateMatches(in: string, options: [], range: range) { (result: NSTextCheckingResult?, flags: NSRegularExpression.MatchingFlags, stop: UnsafeMutablePointer<ObjCBool>) -> Void in
			self.textDidProcessEdit?(self, result, flags, stop)
		}
		super.processEditing()
	}
	
	/**
	Returns the attributes for the character at a given index.
	- Parameter location: The index for which to return attributes. 
	This value must lie within the bounds of the receiver.
	- Parameter range: Upon return, the range over which the 
	attributes and values are the same as those at index. This range 
	isn’t necessarily the maximum range covered, and its extent is 
	implementation-dependent. If you need the maximum range, use 
	attributesAtIndex:longestEffectiveRange:inRange:. 
	If you don't need this value, pass NULL.
	- Returns: The attributes for the character at index.
	*/
	public override func attributes(at location: Int, effectiveRange range: NSRangePointer?) -> [String : Any] {
		return store.attributes(at: location, effectiveRange: range)
	}
	
	/**
	Replaces a range of text with a string value.
	- Parameter range: The character range to replace.
	- Parameter str: The string value that the characters
	will be replaced with.
	*/
	public override func replaceCharacters(in range: NSRange, with str: String) {
		store.replaceCharacters(in: range, with: str)
		edited(NSTextStorageEditActions.editedCharacters, range: range, changeInLength: str.utf16.count - range.length)
	}
	
	/**
	Sets the attributedString attribute values.
	- Parameter attrs: The attributes to set.
	- Parameter range: A range of characters that will have their
	attributes updated.
	*/
	public override func setAttributes(_ attrs: [String : Any]?, range: NSRange) {
		store.setAttributes(attrs, range: range)
		edited(NSTextStorageEditActions.editedAttributes, range: range, changeInLength: 0)
	}
}
