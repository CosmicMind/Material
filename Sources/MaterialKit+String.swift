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

public extension String {
	/**
	:name:	lines
	*/
	public var lines: Array<String> {
		return componentsSeparatedByCharactersInSet(NSCharacterSet.newlineCharacterSet())
	}
	
	/**
	:name:	firstLine
	*/
	public var firstLine: String? {
		return lines.first?.trim()
	}
	
	/**
	:name:	lastLine
	*/
	public var lastLine: String? {
		return lines.last?.trim()
	}
	
	/**
	:name:	replaceNewLineCharater
	*/
	public func replaceNewLineCharater(replace: String = " ") -> String {
		return componentsSeparatedByCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet()).joinWithSeparator(replace).trim()
	}
	
	/**
	:name:	replacePunctuationCharacters
	*/
	public func replacePunctuationCharacters(replace: String = "") -> String {
		return componentsSeparatedByCharactersInSet(NSCharacterSet.punctuationCharacterSet()).joinWithSeparator(replace).trim()
	}
	
	/**
	:name:	trim
	*/
	public func trim() -> String {
		return stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
	}
}
