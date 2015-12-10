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

public struct RobotoFont : MaterialFontType {
	/**
	:name:	pointSize
	*/
	public static var pointSize: CGFloat {
		return MaterialFont.pointSize
	}

	/**
	:name:	thin
	*/
	public static var thin: UIFont {
		return thinWithSize(MaterialFont.pointSize)
	}
	
	/**
	:name:	thinWithSize
	*/
	public static func thinWithSize(size: CGFloat) -> UIFont {
		if let f = UIFont(name: "Roboto-Thin", size: size) {
			return f
		}
		return MaterialFont.systemFontWithSize(size)
	}
	
	/**
	:name:	light
	*/
	public static var light: UIFont {
		return lightWithSize(MaterialFont.pointSize)
	}
	
	/**
	:name:	lightWithSize
	*/
	public static func lightWithSize(size: CGFloat) -> UIFont {
		if let f = UIFont(name: "Roboto-Light", size: size) {
			return f
		}
		return MaterialFont.systemFontWithSize(size)
	}
	
	/**
	:name:	regular
	*/
	public static var regular: UIFont {
		return regularWithSize(MaterialFont.pointSize)
	}
	
	/**
	:name:	regularWithSize
	*/
	public static func regularWithSize(size: CGFloat) -> UIFont {
		if let f = UIFont(name: "Roboto-Regular", size: size) {
			return f
		}
		return MaterialFont.systemFontWithSize(size)
	}
	
	/**
	:name:	mediumWithSize
	*/
	public static func mediumWithSize(size: CGFloat) -> UIFont {
		if let f = UIFont(name: "Roboto-Medium", size: size) {
			return f
		}
		return MaterialFont.boldSystemFontWithSize(size)
	}
	
	/**
	:name:	medium
	*/
	public static var medium: UIFont {
		return mediumWithSize(MaterialFont.pointSize)
	}
	
	/**
	:name:	bold
	*/
	public static var bold: UIFont {
		return boldWithSize(MaterialFont.pointSize)
	}
	
	/**
	:name:	boldWithSize
	*/
	public static func boldWithSize(size: CGFloat) -> UIFont {
		if let f = UIFont(name: "Roboto-Bold", size: size) {
			return f
		}
		return MaterialFont.boldSystemFontWithSize(size)
	}
}