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

public struct RobotoFont: FontType {
	/// Size of font.
	public static var pointSize: CGFloat {
		return Font.pointSize
	}

	/// Thin font.
	public static var thin: UIFont {
		return thinWithSize(size: Font.pointSize)
	}
	
    /// Light font.
    public static var light: UIFont {
        return lightWithSize(size: Font.pointSize)
    }
    
    /// Regular font.
    public static var regular: UIFont {
        return regularWithSize(size: Font.pointSize)
    }
    
    /// Medium font.
    public static var medium: UIFont {
        return mediumWithSize(size: Font.pointSize)
    }
    
    /// Bold font.
    public static var bold: UIFont {
        return boldWithSize(size: Font.pointSize)
    }
    
	/**
     Thin with size font.
     - Parameter size: A CGFLoat for the font size.
     - Returns: A UIFont.
     */
    public static func thinWithSize(size: CGFloat) -> UIFont {
        Font.loadFontIfNeeded(name: "Roboto-Thin")
		if let f = UIFont(name: "Roboto-Thin", size: size) {
			return f
		}
		return Font.systemFontWithSize(size: size)
	}
	
    /**
     Light with size font.
     - Parameter size: A CGFLoat for the font size.
     - Returns: A UIFont.
     */
    public static func lightWithSize(size: CGFloat) -> UIFont {
        Font.loadFontIfNeeded(name: "Roboto-Light")
		if let f = UIFont(name: "Roboto-Light", size: size) {
			return f
		}
		return Font.systemFontWithSize(size: size)
	}
	
    /**
     Regular with size font.
     - Parameter size: A CGFLoat for the font size.
     - Returns: A UIFont.
     */
    public static func regularWithSize(size: CGFloat) -> UIFont {
        Font.loadFontIfNeeded(name: "Roboto-Regular")
		if let f = UIFont(name: "Roboto-Regular", size: size) {
			return f
		}
		return Font.systemFontWithSize(size: size)
	}
	
    /**
     Medium with size font.
     - Parameter size: A CGFLoat for the font size.
     - Returns: A UIFont.
     */
    public static func mediumWithSize(size: CGFloat) -> UIFont {
		Font.loadFontIfNeeded(name: "Roboto-Medium")
		if let f = UIFont(name: "Roboto-Medium", size: size) {
			return f
		}
		return Font.boldSystemFontWithSize(size: size)
	}
	
    /**
     Bold with size font.
     - Parameter size: A CGFLoat for the font size.
     - Returns: A UIFont.
     */
    public static func boldWithSize(size: CGFloat) -> UIFont {
        Font.loadFontIfNeeded(name: "Roboto-Bold")
		if let f = UIFont(name: "Roboto-Bold", size: size) {
			return f
		}
		return Font.boldSystemFontWithSize(size: size)
	}
}
