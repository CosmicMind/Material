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

public enum RobotoFont: String, FontType {
    /// Thin font.
    case thin = "Roboto-Thin"
  
    /// Light font.
    case light = "Roboto-Light"
  
    /// Regular font.
    case regular = "Roboto-Regular"
  
    /// Medium font.
    case medium = "Roboto-Medium"
  
    /// Bold font.
    case bold = "Roboto-Bold"
  
    /**
    Thin with size font.
    - Parameter with size: A CGFLoat for the font size.
    - Returns: A UIFont.
    */
    public func size(_ value: CGFloat) -> UIFont {
        Font.loadFontIfNeeded(name: self.rawValue)
        if let f = UIFont(name: self.rawValue, size: value) {
            return f
        }

        return Font.systemFont(ofSize: value)
    }
    
    /// Size of font.
    public static var pointSize: CGFloat {
        return Font.pointSize
    }
}

extension RobotoFont: FontThemeable {
    public class Theme: FontTheme {
        public static func regular(with size: CGFloat) -> UIFont {
            return RobotoFont.regular.size(size)
        }
        
        public static func bold(with size: CGFloat) -> UIFont {
            return RobotoFont.bold.size(size)
        }
        
        public static func medium(with size: CGFloat) -> UIFont {
            return RobotoFont.medium.size(size)
        }
    }
}
