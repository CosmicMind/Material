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

public protocol MaterialFontType {}

public struct MaterialFont : MaterialFontType {
	/// Size of font.
	public static let pointSize: CGFloat = 16
	
	/// Retrieves the system font with a specified size.
	public static func systemFontWithSize(size: CGFloat) -> UIFont {
		return UIFont.systemFontOfSize(size)
	}
	
	/// Retrieves the bold system font with a specified size.
	public static func boldSystemFontWithSize(size: CGFloat) -> UIFont {
		return UIFont.boldSystemFontOfSize(size)
	}
	
	/// Retrieves the italic system font with a specified size.
	public static func italicSystemFontWithSize(size: CGFloat) -> UIFont {
		return UIFont.italicSystemFontOfSize(size)
	}
    
	/// Loads a font if it is needed.
	public static func loadFontIfNeeded(fontName: String) {
        MaterialFontLoader.loadFontIfNeeded(fontName)
    }
}

/// Loads fonts packaged with Material.
private class MaterialFontLoader {
    /// A Dictionary of the fonts already loaded.
    static var loadedFonts: Dictionary<String, String> = Dictionary<String, String>()
	
	/// Loads a font specified if needed.
    static func loadFontIfNeeded(fontName: String) {
		let loadedFont: String? = MaterialFontLoader.loadedFonts[fontName]
		
        if nil == loadedFont && nil == UIFont(name: fontName, size: 1) {
			MaterialFontLoader.loadedFonts[fontName] = fontName
			
			let bundle: NSBundle = NSBundle(forClass: MaterialFontLoader.self)
			let identifier: String? = bundle.bundleIdentifier
			let fontURL: NSURL? = true == identifier?.hasPrefix("org.cocoapods") ? bundle.URLForResource(fontName, withExtension: "ttf", subdirectory: "io.cosmicmind.material.fonts.bundle") : bundle.URLForResource(fontName, withExtension: "ttf")
			
			if let v: NSURL = fontURL {
				let data: NSData = NSData(contentsOfURL: v)!
                let provider: CGDataProvider = CGDataProviderCreateWithCFData(data)!
				let font: CGFont = CGFontCreateWithDataProvider(provider)!
                
                var error: Unmanaged<CFError>?
                if !CTFontManagerRegisterGraphicsFont(font, &error) {
                    let errorDescription: CFStringRef = CFErrorCopyDescription(error!.takeUnretainedValue())
					let nsError: NSError = error!.takeUnretainedValue() as AnyObject as! NSError
                    NSException(name: NSInternalInconsistencyException, reason: errorDescription as String, userInfo: [NSUnderlyingErrorKey: nsError]).raise()
                }
            }
        }
    }
}