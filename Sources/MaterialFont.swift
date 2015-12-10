//
// Copyright (C) 2015 CosmicMind, Inc. <http://cosmicmind.io> and other CosmicMind contributors
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

public protocol MaterialFontType {}

public struct MaterialFont : MaterialFontType {
	/**
	:name:	pointSize
	*/
	public static let pointSize: CGFloat = 16
	
	/**
	:name:	systemFontWithSize
	*/
	public static func systemFontWithSize(size: CGFloat) -> UIFont {
		return UIFont.systemFontOfSize(size)
	}
	
	/**
	:name:	boldSystemFontWithSize
	*/
	public static func boldSystemFontWithSize(size: CGFloat) -> UIFont {
		return UIFont.boldSystemFontOfSize(size)
	}
	
	/**
	:name:	italicSystemFontWithSize
	*/
	public static func italicSystemFontWithSize(size: CGFloat) -> UIFont {
		return UIFont.italicSystemFontOfSize(size)
	}
}