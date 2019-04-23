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

public extension UIColor {
  /**
   A convenience initializer that creates color from
   argb(alpha red green blue) hexadecimal representation.
   - Parameter argb: An unsigned 32 bit integer. E.g 0xFFAA44CC.
   */
  convenience init(argb: UInt32) {
    let a = argb >> 24
    let r = argb >> 16
    let g = argb >> 8
    let b = argb >> 0
    
    func f(_ v: UInt32) -> CGFloat {
      return CGFloat(v & 0xff) / 255
    }
    
    self.init(red: f(r), green: f(g), blue: f(b), alpha: f(a))
  }
  
  
  /**
   A convenience initializer that creates color from
   rgb(red green blue) hexadecimal representation with alpha value 1.
   - Parameter rgb: An unsigned 32 bit integer. E.g 0xAA44CC.
   */
  convenience init(rgb: UInt32) {
    self.init(argb: (0xff000000 as UInt32) | rgb)
  }
}

internal extension UIColor {
  /// A tuple of the rgba components.
  var components: (r: CGFloat, g: CGFloat, b: CGFloat, a: CGFloat) {
    var r: CGFloat = 0
    var g: CGFloat = 0
    var b: CGFloat = 0
    var a: CGFloat = 0
    
    getRed(&r, green: &g, blue: &b, alpha: &a)
    
    return (r, g, b, a)
  }
  
  /**
   Blends given coverColor over this color.
   - Parameter with coverColor: A UIColor.
   - Returns: Resultant color of blending.
   */
  func blend(with coverColor: UIColor) -> UIColor {
    
    /// Blends channels according to https://en.wikipedia.org/wiki/Alpha_compositing (see `over` operator).
    func blendChannel(value: CGFloat, bValue: CGFloat, alpha: CGFloat, bAlpha: CGFloat) -> CGFloat {
      return ((1 - alpha) * bValue * bAlpha + alpha * value) / (alpha + bAlpha * (1 - alpha))
    }
    
    let (r, g, b, a) = coverColor.components
    let (bR, bG, bB, bA) = components
    
    let newR = blendChannel(value: r, bValue: bR, alpha: a, bAlpha: bA)
    let newG = blendChannel(value: g, bValue: bG, alpha: a, bAlpha: bA)
    let newB = blendChannel(value: b, bValue: bB, alpha: a, bAlpha: bA)
    let newA = a + bA * (1 - a)
    
    return UIColor(red: newR, green: newG, blue: newB, alpha: newA)
  }
  
  /**
   Adjusts brightness of the color by given value.
   - Parameter by value: A CGFloat value.
   - Returns: Adjusted color.
   */
  func adjustingBrightness(by value: CGFloat) -> UIColor {
    var h: CGFloat = 0
    var s: CGFloat = 0
    var b: CGFloat = 0
    var a: CGFloat = 0
    
    getHue(&h, saturation: &s, brightness: &b, alpha: &a)
    
    return UIColor(hue: h, saturation: s, brightness: (b + value).clamp(0, 1), alpha: 1)
  }
  
  /// A lighter version of the color.
  var lighter: UIColor {
    return adjustingBrightness(by: 0.1)
  }
  
  /// A darker version of the color.
  var darker: UIColor {
    return adjustingBrightness(by: -0.1)
  }
}
