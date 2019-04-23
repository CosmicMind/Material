/*
 * The MIT License (MIT)
 *
 * Copyright (C) 2019, CosmicMind, Inc. <http://cosmicmind.com>.
 * All rights reserved.
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

import UIKit

public protocol FontType {
  /**
   Regular with size font.
   - Parameter with size: A CGFLoat for the font size.
   - Returns: A UIFont.
   */
  static func regular(with size: CGFloat) -> UIFont
  
  /**
   Medium with size font.
   - Parameter with size: A CGFLoat for the font size.
   - Returns: A UIFont.
   */
  static func medium(with size: CGFloat) -> UIFont
  
  /**
   Bold with size font.
   - Parameter with size: A CGFLoat for the font size.
   - Returns: A UIFont.
   */
  static func bold(with size: CGFloat) -> UIFont
}

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
        if !CTFontManagerRegisterGraphicsFont(font!, &error) {
          let errorDescription = CFErrorCopyDescription(error!.takeUnretainedValue())
          let nsError = error!.takeUnretainedValue() as Any as! Error
          NSException(name: .internalInconsistencyException, reason: errorDescription as String?, userInfo: [NSUnderlyingErrorKey: nsError as Any]).raise()
        }
      }
    }
  }
}
