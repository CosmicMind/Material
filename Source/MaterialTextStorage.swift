//
// Copyright (C) 2015 GraphKit, Inc. <http://graphkit.io> and other GraphKit contributors.
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

internal typealias MaterialTextStorageWillProcessEdit = (MaterialTextStorage, String, NSRange) -> Void
internal typealias MaterialTextStorageDidProcessEdit = (MaterialTextStorage, NSTextCheckingResult, NSMatchingFlags, UnsafeMutablePointer<ObjCBool>) -> Void

public class MaterialTextStorage: NSTextStorage {
	/**
		:name:	store
		:description:	Acts as the model, storing the string value.
	*/
	private lazy var store: NSMutableAttributedString = NSMutableAttributedString()
	
	/**
		:name:	searchExpression
		:description:	Matches text within the TextStorage string property.
	*/
	internal var searchExpression: NSRegularExpression?
	
	/**
		:name:	textStorageWillProcessEdit
		:description:	If set, this block callback executes when there is a change in the TextStorage
		string value.
	*/
	internal var textStorageWillProcessEdit: MaterialTextStorageWillProcessEdit?
	
	/**
		:name:	textStorageDidProcessEdit
		:description:	If set, this block callback executes when a match is detected after a change in
		the TextStorage string value.
	*/
	internal var textStorageDidProcessEdit: MaterialTextStorageDidProcessEdit?
	
	required public init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}
	
	override public init() {
		super.init()
	}
	
	/**
		:name:	string
		:description:	Managed string value.
	*/
	override public var string: String {
		get {
			return store.string
		}
	}
	
	override public func processEditing() {
		let range: NSRange = (string as NSString).paragraphRangeForRange(editedRange)
		textStorageWillProcessEdit?(self, string, range)
		searchExpression!.enumerateMatchesInString(string, options: [], range: range) { (result: NSTextCheckingResult!, flags: NSMatchingFlags, stop: UnsafeMutablePointer<ObjCBool>) in
			self.textStorageDidProcessEdit?(self, result, flags, stop)
		}
		super.processEditing()
	}
	
	override public func attributesAtIndex(location: Int, effectiveRange range: NSRangePointer) -> [String : AnyObject] {
		return store.attributesAtIndex(location, effectiveRange: range)
	}
	
	override public func replaceCharactersInRange(range: NSRange, withString str: String) {
		store.replaceCharactersInRange(range, withString: str)
		edited(NSTextStorageEditActions.EditedCharacters, range: range, changeInLength: str.utf16.count - range.length)
	}
	
	override public func setAttributes(attrs: [String : AnyObject]?, range: NSRange) {
		store.setAttributes(attrs, range: range)
		edited(NSTextStorageEditActions.EditedAttributes, range: range, changeInLength: 0)
	}
}