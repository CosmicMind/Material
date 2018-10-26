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

public struct LayoutAnchor {
  /// A weak reference to the view.
  weak var view: UIView?
  
  /// An array of LayoutAttribute for the view.
  let attributes: [LayoutAttribute]
  
  /**
   An initializer taking view and anchor attributes.
   - Parameter view: A UIView.
   - Parameter attributes: An array of LayoutAtrribute.
  */
  init(view: UIView?, attributes: [LayoutAttribute]) {
    self.view = view
    self.attributes = attributes
  }
}

public extension Layout {
  /// A layout anchor representing top of the view.
  var top: LayoutAnchor {
    return attribute(.top)
  }
  
  /// A layout anchor representing bottom of the view.
  var bottom: LayoutAnchor {
    return attribute(.bottom)
  }
  
  /// A layout anchor representing left of the view.
  var left: LayoutAnchor {
    return attribute(.left)
  }
  
  /// A layout anchor representing right of the view.
  var right: LayoutAnchor {
    return attribute(.right)
  }
  
  /// A layout anchor representing top-left of the view.
  var topLeft: LayoutAnchor {
    return attribute(.topLeft)
  }
  
  /// A layout anchor representing top-right of the view.
  var topRight: LayoutAnchor {
    return attribute(.topRight)
  }
  
  /// A layout anchor representing bottom-left of the view.
  var bottomLeft: LayoutAnchor {
    return attribute(.bottomLeft)
  }
  
  /// A layout anchor representing bottom-right of the view.
  var bottomRight: LayoutAnchor {
    return attribute(.bottomRight)
  }
  
  /// A layout anchor representing top and bottom of the view.
  var topBottom: LayoutAnchor {
    return attribute(.topBottom)
  }
  
  /// A layout anchor representing left and right of the view.
  var leftRight: LayoutAnchor {
    return attribute(.leftRight)
  }
  
  /// A layout anchor representing center of the view.
  var center: LayoutAnchor {
    return attribute(.center)
  }
  
  /// A layout anchor representing horizontal center of the view.
  var centerX: LayoutAnchor {
    return attribute(.centerX)
  }
  
  /// A layout anchor representing vertical center of the view.
  var centerY: LayoutAnchor {
    return attribute(.centerY)
  }
  
  /// A layout anchor representing top, left, bottom and right of the view.
  var edges: LayoutAnchor {
    return attribute(.edges)
  }
  
  /// A layout anchor representing width of the view.
  var width: LayoutAnchor {
    return attribute(.width)
  }
  /// A layout anchor representing height of the view.
  var height: LayoutAnchor {
    return attribute(.height)
  }
}

private extension Layout {
  /**
   Creates LayoutAnchor with the given attribute.
   - Parameter attribute: A LayoutAttribute.
   - Returns: A LayoutAnchor.
   */
  func attribute(_ attribute: LayoutAttribute) -> LayoutAnchor {
    return LayoutAnchor(view: view, attributes: [attribute])
  }
  
  /**
   Creates LayoutAnchor with the given attributes.
   - Parameter attributes: An array of LayoutAttribute.
   - Returns: A LayoutAnchor.
   */
  func attribute(_ attributes: [LayoutAttribute]) -> LayoutAnchor {
    return LayoutAnchor(view: view, attributes: attributes)
  }
}
