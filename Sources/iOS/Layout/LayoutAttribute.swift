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

/// A typealias for NSLayoutConstraint.Attribute
public typealias LayoutAttribute = NSLayoutConstraint.Attribute

internal extension Array where Element == LayoutAttribute {
  /// A LayoutAttribute array containing top and left.
  static var topLeft: [LayoutAttribute] {
    return [.top, .left]
  }
  
  /// A LayoutAttribute array containing top and right.
  static var topRight: [LayoutAttribute] {
    return [.top, .right]
  }
  
  /// A LayoutAttribute array containing bottom and left.
  static var bottomLeft: [LayoutAttribute] {
    return [.bottom, .left]
  }
  
  /// A LayoutAttribute array containing bottom and right.
  static var bottomRight: [LayoutAttribute] {
    return [.bottom, .right]
  }
  
  /// A LayoutAttribute array containing left and right.
  static var leftRight: [LayoutAttribute] {
    return [.left, .right]
  }
  
  /// A LayoutAttribute array containing top and leading.
  static var topLeading: [LayoutAttribute] {
    return [.top, .leading]
  }
  
  /// A LayoutAttribute array containing top and trailing.
  static var topTrailing: [LayoutAttribute] {
    return [.top, .trailing]
  }
  
  /// A LayoutAttribute array containing bottom and leading.
  static var bottomLeading: [LayoutAttribute] {
    return [.bottom, .leading]
  }
  
  /// A LayoutAttribute array containing bottom and trailing.
  static var bottomTrailing: [LayoutAttribute] {
    return [.bottom, .trailing]
  }
  
  /// A LayoutAttribute array containing left and trailing.
  static var leadingTrailing: [LayoutAttribute] {
    return [.leading, .trailing]
  }
  
  /// A LayoutAttribute array containing top and bottom.
  static var topBottom: [LayoutAttribute] {
    return [.top, .bottom]
  }
  
  /// A LayoutAttribute array containing centerX and centerY.
  static var center: [LayoutAttribute] {
    return [.centerX, .centerY]
  }
  
  /// A LayoutAttribute array containing top, left, bottom and right.
  static var edges: [LayoutAttribute] {
    return [.top, .left, .bottom, .right]
  }
  
  /// A LayoutAttribute array for constant height.
  static var constantHeight: [LayoutAttribute] {
    return [.height, .notAnAttribute]
  }
  
  /// A LayoutAttribute array for constant width.
  static var constantWidth: [LayoutAttribute] {
    return [.width, .notAnAttribute]
  }
}
