//
// Copyright (C) 2015 - 2016 CosmicMind, Inc. <http://cosmicmind.io>. All rights reserved.
//
// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU Affero General Public License as published
// by the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU Affero General Public License for more details.
//
// You should have received a copy of the GNU Affero General Public License
// along with this program located at the root of the software package
// in a file called LICENSE.  If not, see <http://www.gnu.org/licenses/>.
//

import UIKit

internal typealias TextWillProcessEdit = (TextStorage, String, NSRange) -> Void
internal typealias TextDidProcessEdit = (TextStorage, NSTextCheckingResult?, NSMatchingFlags, UnsafeMutablePointer<ObjCBool>) -> Void

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
		let range: NSRange = (string as NSString).paragraphRangeForRange(editedRange)
		
		textWillProcessEdit?(self, string, range)
		
		expression!.enumerateMatchesInString(string, options: [], range: range) { (result: NSTextCheckingResult?, flags: NSMatchingFlags, stop: UnsafeMutablePointer<ObjCBool>) -> Void in
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
	public override func attributesAtIndex(location: Int, effectiveRange range: NSRangePointer) -> [String : AnyObject] {
		return store.attributesAtIndex(location, effectiveRange: range)
	}
	
	/**
	Replaces a range of text with a string value.
	- Parameter range: The character range to replace.
	- Parameter str: The string value that the characters
	will be replaced with.
	*/
	public override func replaceCharactersInRange(range: NSRange, withString str: String) {
		store.replaceCharactersInRange(range, withString: str)
		edited(NSTextStorageEditActions.EditedCharacters, range: range, changeInLength: str.utf16.count - range.length)
	}
	
	/**
	Sets the attributedString attribute values.
	- Parameter attrs: The attributes to set.
	- Parameter range: A range of characters that will have their
	attributes updated.
	*/
	public override func setAttributes(attrs: [String : AnyObject]?, range: NSRange) {
		store.setAttributes(attrs, range: range)
		edited(NSTextStorageEditActions.EditedAttributes, range: range, changeInLength: 0)
	}
}