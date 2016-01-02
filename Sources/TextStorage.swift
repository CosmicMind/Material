//
// Copyright (C) 2015 CosmicMind, Inc. <http://cosmicmind.io>
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
	/**
		:name:	store
	*/
	private lazy var store: NSMutableAttributedString = NSMutableAttributedString()
	
	/**
		:name:	expression
	*/
	internal var expression: NSRegularExpression?
	
	/**
		:name:	textWillProcessEdit
	*/
	internal var textWillProcessEdit: TextWillProcessEdit?
	
	/**
		:name:	textDidProcessEdit
	*/
	internal var textDidProcessEdit: TextDidProcessEdit?
	
	/**
		:name:	init
	*/
	public required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}
	
	/**
		:name:	init
	*/
	public override init() {
		super.init()
	}
	
	/**
		:name:	string
	*/
	override public var string: String {
		get {
			return store.string
		}
	}
	
	/**
		:name:	processEditing
	*/
	public override func processEditing() {
		let range: NSRange = (string as NSString).paragraphRangeForRange(editedRange)
		textWillProcessEdit?(self, string, range)
		expression!.enumerateMatchesInString(string, options: [], range: range) { (result: NSTextCheckingResult?, flags: NSMatchingFlags, stop: UnsafeMutablePointer<ObjCBool>) -> Void in
			self.textDidProcessEdit?(self, result, flags, stop)
		}
		super.processEditing()
	}
	
	/**
		:name:	attributesAtIndex
	*/
	public override func attributesAtIndex(location: Int, effectiveRange range: NSRangePointer) -> [String : AnyObject] {
		return store.attributesAtIndex(location, effectiveRange: range)
	}
	
	/**
		:name:	replaceCharactersInRange
	*/
	public override func replaceCharactersInRange(range: NSRange, withString str: String) {
		store.replaceCharactersInRange(range, withString: str)
		edited(NSTextStorageEditActions.EditedCharacters, range: range, changeInLength: str.utf16.count - range.length)
	}
	
	/**
		:name:	setAttributes
	*/
	public override func setAttributes(attrs: [String : AnyObject]?, range: NSRange) {
		store.setAttributes(attrs, range: range)
		edited(NSTextStorageEditActions.EditedAttributes, range: range, changeInLength: 0)
	}
}