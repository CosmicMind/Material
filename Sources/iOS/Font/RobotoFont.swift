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

public struct RobotoFont: FontType {
  /// Size of font.
  public static var pointSize: CGFloat {
    return Font.pointSize
  }
  
  /// Thin font.
  public static var thin: UIFont {
    return thin(with: Font.pointSize)
  }
  
  /// Light font.
  public static var light: UIFont {
    return light(with: Font.pointSize)
  }
  
  /// Regular font.
  public static var regular: UIFont {
    return regular(with: Font.pointSize)
  }
  
  /// Medium font.
  public static var medium: UIFont {
    return medium(with: Font.pointSize)
  }
  
  /// Bold font.
  public static var bold: UIFont {
    return bold(with: Font.pointSize)
  }
  
  /**
   Thin with size font.
   - Parameter with size: A CGFLoat for the font size.
   - Returns: A UIFont.
   */
  public static func thin(with size: CGFloat) -> UIFont {
    Font.loadFontIfNeeded(name: "Roboto-Thin")
    
    if let f = UIFont(name: "Roboto-Thin", size: size) {
      return f
    }
    
    return Font.systemFont(ofSize: size)
  }
  
  /**
   Light with size font.
   - Parameter with size: A CGFLoat for the font size.
   - Returns: A UIFont.
   */
  public static func light(with size: CGFloat) -> UIFont {
    Font.loadFontIfNeeded(name: "Roboto-Light")
    
    if let f = UIFont(name: "Roboto-Light", size: size) {
      return f
    }
    
    return Font.systemFont(ofSize: size)
  }
  
  /**
   Regular with size font.
   - Parameter with size: A CGFLoat for the font size.
   - Returns: A UIFont.
   */
  public static func regular(with size: CGFloat) -> UIFont {
    Font.loadFontIfNeeded(name: "Roboto-Regular")
    
    if let f = UIFont(name: "Roboto-Regular", size: size) {
      return f
    }
    
    return Font.systemFont(ofSize: size)
  }
  
  /**
   Medium with size font.
   - Parameter with size: A CGFLoat for the font size.
   - Returns: A UIFont.
   */
  public static func medium(with size: CGFloat) -> UIFont {
    Font.loadFontIfNeeded(name: "Roboto-Medium")
    
    if let f = UIFont(name: "Roboto-Medium", size: size) {
      return f
    }
    
    return Font.boldSystemFont(ofSize: size)
  }
  
  /**
   Bold with size font.
   - Parameter with size: A CGFLoat for the font size.
   - Returns: A UIFont.
   */
  public static func bold(with size: CGFloat) -> UIFont {
    Font.loadFontIfNeeded(name: "Roboto-Bold")
    
    if let f = UIFont(name: "Roboto-Bold", size: size) {
      return f
    }
    
    return Font.boldSystemFont(ofSize: size)
  }
}
