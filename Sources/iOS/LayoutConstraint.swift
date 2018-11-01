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
