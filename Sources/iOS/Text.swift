/*
* Copyright (C) 2015 - 2016, Daniel Dahan and CosmicMind, Inc. <http://cosmicmind.io>.
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
*	*	Neither the name of Material nor the names of its
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

@objc(TextDelegate)
public protocol TextDelegate {
	/**
	An optional delegation method that is executed when
	text will be processed during editing.
	- Parameter text: The Text instance assodicated with the
	delegation object.
	- Parameter  textStorage: The TextStorage instance
	associated with the delegation object.
	- Parameter string: The string value that is currently 
	being edited.
	- Parameter range: The range of characters that are being
	edited.
	*/
	optional func textWillProcessEdit(text: Text, textStorage: TextStorage, string: String, range: NSRange)
	
	/**
	An optional delegation method that is executed after
	the edit processing has completed.
	- Parameter text: The Text instance assodicated with the
	delegation object.
	- Parameter  textStorage: The TextStorage instance
	associated with the delegation object.
	- Parameter string: The string value that was edited.
	- Parameter result: A NSTextCheckingResult associated
	with the processing result.
	- Parameter flags: Matching flags.
	- Parameter stop: Halts a service which is either 
	publishing or resolving.
	*/
	optional func textDidProcessEdit(text: Text, textStorage: TextStorage, string: String, result: NSTextCheckingResult?, flags: NSMatchingFlags, stop: UnsafeMutablePointer<ObjCBool>)
}

@objc(Text)
public class Text : NSObject {
	/// The string pattern to match within the textStorage.
	public var pattern: String = "(^|\\s)#[\\d\\w_\u{203C}\u{2049}\u{20E3}\u{2122}\u{2139}\u{2194}-\u{2199}\u{21A9}-\u{21AA}\u{231A}-\u{231B}\u{23E9}-\u{23EC}\u{23F0}\u{23F3}\u{24C2}\u{25AA}-\u{25AB}\u{25B6}\u{25C0}\u{25FB}-\u{25FE}\u{2600}-\u{2601}\u{260E}\u{2611}\u{2614}-\u{2615}\u{261D}\u{263A}\u{2648}-\u{2653}\u{2660}\u{2663}\u{2665}-\u{2666}\u{2668}\u{267B}\u{267F}\u{2693}\u{26A0}-\u{26A1}\u{26AA}-\u{26AB}\u{26BD}-\u{26BE}\u{26C4}-\u{26C5}\u{26CE}\u{26D4}\u{26EA}\u{26F2}-\u{26F3}\u{26F5}\u{26FA}\u{26FD}\u{2702}\u{2705}\u{2708}-\u{270C}\u{270F}\u{2712}\u{2714}\u{2716}\u{2728}\u{2733}-\u{2734}\u{2744}\u{2747}\u{274C}\u{274E}\u{2753}-\u{2755}\u{2757}\u{2764}\u{2795}-\u{2797}\u{27A1}\u{27B0}\u{2934}-\u{2935}\u{2B05}-\u{2B07}\u{2B1B}-\u{2B1C}\u{2B50}\u{2B55}\u{3030}\u{303D}\u{3297}\u{3299}\u{1F004}\u{1F0CF}\u{1F170}-\u{1F171}\u{1F17E}-\u{1F17F}\u{1F18E}\u{1F191}-\u{1F19A}\u{1F1E7}-\u{1F1EC}\u{1F1EE}-\u{1F1F0}\u{1F1F3}\u{1F1F5}\u{1F1F7}-\u{1F1FA}\u{1F201}-\u{1F202}\u{1F21A}\u{1F22F}\u{1F232}-\u{1F23A}\u{1F250}-\u{1F251}\u{1F300}-\u{1F320}\u{1F330}-\u{1F335}\u{1F337}-\u{1F37C}\u{1F380}-\u{1F393}\u{1F3A0}-\u{1F3C4}\u{1F3C6}-\u{1F3CA}\u{1F3E0}-\u{1F3F0}\u{1F400}-\u{1F43E}\u{1F440}\u{1F442}-\u{1F4F7}\u{1F4F9}-\u{1F4FC}\u{1F500}-\u{1F507}\u{1F509}-\u{1F53D}\u{1F550}-\u{1F567}\u{1F5FB}-\u{1F640}\u{1F645}-\u{1F64F}\u{1F680}-\u{1F68A}]+" {
		didSet {
			prepareTextStorageExpression()
		}
	}
	
	/// TextStorage instance that is observed while editing.
	public private(set) var textStorage: TextStorage = TextStorage()
	
	/// Delegation object for pre and post text processing.
	public weak var delegate: TextDelegate?
	
	/// Initializer.
	public override init() {
		super.init()
		prepareTextStorageExpression()
		prepareTextStorageProcessingCallbacks()
	}
	
	/**
	A convenience property that accesses the textStorage
	string.
	*/
	public var string: String {
		return textStorage.string
	}
	
	/// An Array of matches that match the pattern expression.
	public var matches: Array<String> {
		return textStorage.expression!.matchesInString(string, options: [], range: NSMakeRange(0, string.utf16.count)).map {
			(self.string as NSString).substringWithRange($0.range).trim()
		}
	}
	
	/**
	An Array of unique matches that match the pattern
	expression.
	*/
	public var uniqueMatches: Array<String> {
		var seen: [String: Bool] = [:]
		return matches.filter { nil == seen.updateValue(true, forKey: $0) }
	}
	
	/// Prepares the TextStorage regular expression for matching.
	private func prepareTextStorageExpression() {
		textStorage.expression = try? NSRegularExpression(pattern: pattern, options: [])
	}
	
	/// Prepares the pre and post processing callbacks.
	private func prepareTextStorageProcessingCallbacks() {
		textStorage.textWillProcessEdit = { [weak self] (textStorage: TextStorage, string: String, range: NSRange) -> Void in
			if let s: Text = self {
				s.delegate?.textWillProcessEdit?(s, textStorage: textStorage, string: string, range: range)
			}
		}
		textStorage.textDidProcessEdit = { [weak self] (textStorage: TextStorage, result: NSTextCheckingResult?, flags: NSMatchingFlags, stop: UnsafeMutablePointer<ObjCBool>) -> Void in
			if let s: Text = self {
				s.delegate?.textDidProcessEdit?(s, textStorage: textStorage, string: textStorage.string, result: result, flags: flags, stop: stop)
			}
		}
	}
}