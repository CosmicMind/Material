/*
 * Copyright (C) 2015 - 2018, Daniel Dahan and CosmicMind, Inc. <http://cosmicmind.com>.
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions are met:
 *
 *  * Redistributions of source code must retain the above copyright notice, this
 *    list of conditions and the following disclaimer.
 *
 *  * Redistributions in binary form must reproduce the above copyright notice,
 *    this list of conditions and the following disclaimer in the documentation
 *    and/or other materials provided with the distribution.
 *
 *  * Neither the name of CosmicMind nor the names of its
 *    contributors may be used to endorse or promote products derived from
 *    this software without specific prior written permission.
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

/// A typealias for NSLayoutConstraint.Attribute
internal typealias LayoutAttribute = NSLayoutConstraint.Attribute

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
