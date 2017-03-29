/*
 * Copyright (C) 2015 - 2017, Daniel Dahan and CosmicMind, Inc. <http://cosmicmind.com>.
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

public protocol FontType {}

public struct Font {
	/// Size of font.
	public static let pointSize: CGFloat = 16
	
	/** 
     Retrieves the system font with a specified size.
     - Parameter ofSize size: A CGFloat.
     */
    public static func systemFont(ofSize size: CGFloat) -> UIFont {
		return UIFont.systemFont(ofSize: size)
	}
	
	/**
     Retrieves the bold system font with a specified size..
     - Parameter ofSize size: A CGFloat.
     */
    public static func boldSystemFont(ofSize size: CGFloat) -> UIFont {
		return UIFont.boldSystemFont(ofSize: size)
	}
	
	/**
     Retrieves the italic system font with a specified size.
     - Parameter ofSize size: A CGFloat.
     */
    public static func italicSystemFont(ofSize size: CGFloat) -> UIFont {
		return UIFont.italicSystemFont(ofSize: size)
	}
    
	/**
     Loads a given font if needed.
     - Parameter name: A String font name.
     */
    public static func loadFontIfNeeded(name: String) {
        FontLoader.loadFontIfNeeded(name: name)
    }
}

/// Loads fonts packaged with Material.
private class FontLoader {
    /// A Dictionary of the fonts already loaded.
    static var loadedFonts: Dictionary<String, String> = Dictionary<String, String>()
	
    /**
     Loads a given font if needed.
     - Parameter fontName: A String font name.
     */
    static func loadFontIfNeeded(name: String) {
		let loadedFont: String? = FontLoader.loadedFonts[name]
		
        if nil == loadedFont && nil == UIFont(name: name, size: 1) {
			FontLoader.loadedFonts[name] = name
			
			let bundle = Bundle(for: FontLoader.self)
			let identifier = bundle.bundleIdentifier
            let fontURL = true == identifier?.hasPrefix("org.cocoapods") ? bundle.url(forResource: name, withExtension: "ttf", subdirectory: "com.cosmicmind.material.fonts.bundle") : bundle.url(forResource: name, withExtension: "ttf")
			
			if let v = fontURL {
				let data = NSData(contentsOf: v as URL)!
                let provider = CGDataProvider(data: data)!
				let font = CGFont(provider)
                
                var error: Unmanaged<CFError>?
                if !CTFontManagerRegisterGraphicsFont(font, &error) {
                    let errorDescription = CFErrorCopyDescription(error!.takeUnretainedValue())
					let nsError = error!.takeUnretainedValue() as Any as! Error
                    NSException(name: .internalInconsistencyException, reason: errorDescription as String?, userInfo: [NSUnderlyingErrorKey: nsError as Any]).raise()
                }
            }
        }
    }
}
