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

/// A protocol that's conformed by UIView, LayoutAnchor, and Layout.
public protocol LayoutAnchorable { }

extension UIView: LayoutAnchorable { }
extension Layout: LayoutAnchorable { }
extension LayoutAnchor: LayoutAnchorable { }

public struct LayoutAnchor {
  /// A weak reference to the constraintable.
  public weak var constraintable: Constraintable?
  
  /// An array of LayoutAttribute for the view.
  public let attributes: [LayoutAttribute]
  
  /**
   An initializer taking constraintable and anchor attributes.
   - Parameter view: A Constraintable.
   - Parameter attributes: An array of LayoutAtrribute.
   */
  public init(constraintable: Constraintable?, attributes: [LayoutAttribute] = []) {
    self.constraintable = constraintable
    self.attributes = attributes
  }
}

public extension LayoutAnchor {
  /// A layout anchor representing top of the view.
  var top: LayoutAnchor {
    return anchor(.top)
  }
  
  /// A layout anchor representing bottom of the view.
  var bottom: LayoutAnchor {
    return anchor(.bottom)
  }
  
  /// A layout anchor representing left of the view.
  var left: LayoutAnchor {
    return anchor(.left)
  }
  
  /// A layout anchor representing right of the view.
  var right: LayoutAnchor {
    return anchor(.right)
  }
  
  /// A layout anchor representing leading of the view.
  var leading: LayoutAnchor {
    return anchor(.leading)
  }
  
  /// A layout anchor representing trailing of the view.
  var trailing: LayoutAnchor {
    return anchor(.trailing)
  }
  
  /// A layout anchor representing top-left of the view.
  var topLeft: LayoutAnchor {
    return acnhor(.topLeft)
  }
  
  /// A layout anchor representing top-right of the view.
  var topRight: LayoutAnchor {
    return acnhor(.topRight)
  }
  
  /// A layout anchor representing bottom-left of the view.
  var bottomLeft: LayoutAnchor {
    return acnhor(.bottomLeft)
  }
  
  /// A layout anchor representing bottom-right of the view.
  var bottomRight: LayoutAnchor {
    return acnhor(.bottomRight)
  }
  
  /// A layout anchor representing top-leading of the view.
  var topLeading: LayoutAnchor {
    return acnhor(.topLeading)
  }
  
  /// A layout anchor representing top-trailing of the view.
  var topTrailing: LayoutAnchor {
    return acnhor(.topTrailing)
  }
  
  /// A layout anchor representing bottom-leading of the view.
  var bottomLeading: LayoutAnchor {
    return acnhor(.bottomLeading)
  }
  
  /// A layout anchor representing bottom-trailing of the view.
  var bottomTrailing: LayoutAnchor {
    return acnhor(.bottomTrailing)
  }
  
  /// A layout anchor representing top and bottom of the view.
  var topBottom: LayoutAnchor {
    return acnhor(.topBottom)
  }
  
  /// A layout anchor representing left and right of the view.
  var leftRight: LayoutAnchor {
    return acnhor(.leftRight)
  }
  
  /// A layout anchor representing leading and trailing of the view.
  var leadingTrailing: LayoutAnchor {
    return acnhor(.leadingTrailing)
  }
  
  /// A layout anchor representing center of the view.
  var center: LayoutAnchor {
    return acnhor(.center)
  }
  
  /// A layout anchor representing horizontal center of the view.
  var centerX: LayoutAnchor {
    return anchor(.centerX)
  }
  
  /// A layout anchor representing vertical center of the view.
  var centerY: LayoutAnchor {
    return anchor(.centerY)
  }
  
  /// A layout anchor representing top, left, bottom and right of the view.
  var edges: LayoutAnchor {
    return acnhor(.edges)
  }
  
  /// A layout anchor representing width of the view.
  var width: LayoutAnchor {
    return anchor(.width)
  }
  /// A layout anchor representing height of the view.
  var height: LayoutAnchor {
    return anchor(.height)
  }
}

private extension LayoutAnchor {
  /**
   Creates LayoutAnchor with the given attribute.
   - Parameter attribute: A LayoutAttribute.
   - Returns: A LayoutAnchor.
   */
  func anchor(_ attribute: LayoutAttribute) -> LayoutAnchor {
    return LayoutAnchor(constraintable: constraintable, attributes: [attribute])
  }
  
  /**
   Creates LayoutAnchor with the given attributes.
   - Parameter attributes: An array of LayoutAttribute.
   - Returns: A LayoutAnchor.
   */
  func acnhor(_ attributes: [LayoutAttribute]) -> LayoutAnchor {
    return LayoutAnchor(constraintable: constraintable, attributes: attributes)
  }
}
