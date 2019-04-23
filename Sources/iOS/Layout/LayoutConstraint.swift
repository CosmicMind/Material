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

internal struct LayoutConstraint {
  /// `From` anchor for the constraint.
  private let fromAnchor: LayoutAnchor
  
  /// `To` anchor for the constraint.
  private let toAnchor: LayoutAnchor
  
  /// An array of constants for the constraint.
  private var constants: [CGFloat]
  
  /**
   An initializer taking `from` and `to` anchors and constants for the constraint.
   - Parameter fromAnchor: A LayoutAnchor.
   - Parameter toAnchor: A LayoutAnchor.
   - Parameter constants: An array of CGFloat.
   */
  init(fromAnchor: LayoutAnchor, toAnchor: LayoutAnchor, constants: [CGFloat]) {
    self.fromAnchor = fromAnchor
    self.toAnchor = toAnchor
    self.constants = constants
  }
}

internal extension LayoutConstraint {
  /// Creates an array of NSLayoutConstraint from a LayoutConstraint.
  var constraints: [NSLayoutConstraint] {
    guard fromAnchor.attributes.count == toAnchor.attributes.count else {
      fatalError("[Material Error: The number of attributes of anchors does not match.]")
    }
    
    guard fromAnchor.attributes.count == constants.count else {
      fatalError("[Material Error: The number of constants does not match the number of constraints.]")
    }
    
    var v: [NSLayoutConstraint] = []
    
    zip(zip(fromAnchor.attributes, toAnchor.attributes), constants).forEach {
      v.append(NSLayoutConstraint(item: fromAnchor.constraintable as Any,
                                  attribute: $0.0,
                                  relatedBy: .equal,
                                  toItem: toAnchor.constraintable,
                                  attribute: $0.1,
                                  multiplier: 1,
                                  constant: $1))
    }
    
    
    return v
  }
}
