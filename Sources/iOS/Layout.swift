/*
 * Copyright (C) 2015 - 2018, Daniel Dahan and CosmicMind, Inc. <http://cosmicmind.com>.
 * All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted provided that the following conditions are met:
 *
 *	*	Redistributions of source code must retain the above copyright notice, this
 *		list of conditions and the following disclaimer.
 *
 *	*	Redistributions in binary form must reproduce the above copyright notice,
 *		this list of conditions and the following disclaimer in the documentation
 *		and/or other materials provided with the distribution.
 *
 *	*	Neither the name of CosmicMind nor the names of its
 *		contributors may be used to endorse or promote products derived from
 *		this software without specific prior written permission.
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
import Motion

/// Layout extension for UIView.
public extension UIView {
  /**
   Used to chain layout constraints on a child context.
   - Parameter child: A child UIView to layout.
   - Returns: A Layout instance.
   */
  func layout(_ child: UIView) -> Layout {
    addSubview(child)
    child.translatesAutoresizingMaskIntoConstraints = false
    return child.layout
  }
  
  /// Layout instance for the view.
  var layout: Layout {
    return Layout(view: self)
  }
}

public struct Layout {
  /// A weak reference to the view.
  weak var view: UIView?
  
  /// Parent view of the view.
  var parent: UIView? {
    return view?.superview
  }
  
  /**
   An initializer taking UIView.
   - Parameter view: A UIView.
   */
  init(view: UIView) {
    self.view = view
  }
}

public extension Layout {
  /**
   Constraints top of the view to its parent's.
   - Parameter _ offset: A CGFloat offset.
   - Returns: A Layout instance to allow chaining.
   */
  @discardableResult
  func top(_ offset: CGFloat = 0) -> Layout {
    return constraint(.top, constant: offset)
  }
  
  /**
   Constraints left of the view to its parent's.
   - Parameter _ offset: A CGFloat offset.
   - Returns: A Layout instance to allow chaining.
   */
  @discardableResult
  func left(_ offset: CGFloat = 0) -> Layout {
    return constraint(.left, constant: offset)
  }
  
  /**
   Constraints right of the view to its parent.
   - Parameter _ offset: A CGFloat offset.
   - Returns: A Layout instance to allow chaining.
   */
  @discardableResult
  func right(_ offset: CGFloat = 0) -> Layout {
    return constraint(.right, constant: -offset)
  }
  
  /**
   Constraints bottom of the view to its parent's.
   - Parameter _ offset: A CGFloat offset.
   - Returns: A Layout instance to allow chaining.
   */
  @discardableResult
  func bottom(_ offset: CGFloat = 0) -> Layout {
    return constraint(.bottom, constant: -offset)
  }
  
  /**
   Constraints top-left of the view to its parent's.
   - Parameter top: A CGFloat offset for top.
   - Parameter left: A CGFloat offset for left.
   - Returns: A Layout instance to allow chaining.
   */
  @discardableResult
  func topLeft(top: CGFloat = 0, left: CGFloat = 0) -> Layout {
    return constraint(.topLeft, constants: top, left)
  }
  
  /**
   Constraints top-right of the view to its parent's.
   - Parameter top: A CGFloat offset for top.
   - Parameter right: A CGFloat offset for right.
   - Returns: A Layout instance to allow chaining.
   */
  @discardableResult
  func topRight(top: CGFloat = 0, right: CGFloat = 0) -> Layout {
    return constraint(.topRight, constants: top, -right)
  }
  
  /**
   Constraints bottom-left of the view to its parent's.
   - Parameter bottom: A CGFloat offset for bottom.
   - Parameter left: A CGFloat offset for left.
   - Returns: A Layout instance to allow chaining.
   */
  @discardableResult
  func bottomLeft(bottom: CGFloat = 0, left: CGFloat = 0) -> Layout {
    return constraint(.bottomLeft, constants: -bottom, left)
  }
  
  /**
   Constraints bottom-right of the view to its parent's.
   - Parameter bottom: A CGFloat offset for bottom.
   - Parameter right: A CGFloat offset for right.
   - Returns: A Layout instance to allow chaining.
   */
  @discardableResult
  func bottomRight(bottom: CGFloat = 0, right: CGFloat = 0) -> Layout {
    return constraint(.bottomRight, constants: -bottom, -right)
  }
  
  /**
   Constraints left and right of the view to its parent's.
   - Parameter left: A CGFloat offset for left.
   - Parameter right: A CGFloat offset for right.
   - Returns: A Layout instance to allow chaining.
   */
  @discardableResult
  func leftRight(left: CGFloat = 0, right: CGFloat = 0) -> Layout {
    return constraint(.leftRight, constants: left, -right)
  }
  
  /**
   Constraints top and bottom of the view to its parent's.
   - Parameter top: A CGFloat offset for top.
   - Parameter bottom: A CGFloat offset for bottom.
   - Returns: A Layout instance to allow chaining.
   */
  @discardableResult
  func topBottom(top: CGFloat = 0, bottom: CGFloat = 0) -> Layout {
    return constraint(.topBottom, constants: top, -bottom)
  }
  
  /**
   Constraints center of the view to its parent's.
   - Parameter offsetX: A CGFloat offset for horizontal center.
   - Parameter offsetY: A CGFloat offset for vertical center.
   - Returns: A Layout instance to allow chaining.
   */
  @discardableResult
  func center(offsetX: CGFloat = 0, offsetY: CGFloat = 0) -> Layout {
    return constraint(.center, constants: offsetX, offsetY)
  }
  
  /**
   Constraints horizontal center of the view to its parent's.
   - Parameter _ offset: A CGFloat offset.
   - Returns: A Layout instance to allow chaining.
   */
  @discardableResult
  func centerX(_ offset: CGFloat = 0) -> Layout {
    return constraint(.centerX, constant: offset)
  }
  
  /**
   Constraints vertical center of the view to its parent's.
   - Parameter _ offset: A CGFloat offset.
   - Returns: A Layout instance to allow chaining.
   */
  @discardableResult
  func centerY(_ offset: CGFloat = 0) -> Layout {
    return constraint(.centerY, constant: offset)
  }
  
  /**
   Constraints width of the view to its parent's.
   - Parameter offset: A CGFloat offset.
   - Returns: A Layout instance to allow chaining.
   */
  @discardableResult
  func width(offset: CGFloat = 0) -> Layout {
    return constraint(.width, constant: offset)
  }
  
  /**
   Constraints height of the view to its parent's.
   - Parameter offset: A CGFloat offset.
   - Returns: A Layout instance to allow chaining.
   */
  @discardableResult
  func height(offset: CGFloat = 0) -> Layout {
    return constraint(.height, constant: offset)
  }
  
  /**
   Constraints edges of the view to its parent's.
   - Parameter top: A CGFloat offset for top.
   - Parameter left: A CGFloat offset for left.
   - Parameter bottom: A CGFloat offset for bottom.
   - Parameter right: A CGFloat offset for right.
   - Returns: A Layout instance to allow chaining.
   */
  @discardableResult
  func edges(top: CGFloat = 0, left: CGFloat = 0, bottom: CGFloat = 0, right: CGFloat = 0) -> Layout {
    return constraint(.edges, constants: top, left, -bottom, -right)
  }
}

public extension Layout {
  /**
   Constraints width of the view to a constant value.
   - Parameter _ width: A CGFloat value.
   - Returns: A Layout instance to allow chaining.
   */
  @discardableResult
  func width(_ width: CGFloat) -> Layout {
    return constraint(.constantWidth, constants: width)
  }
  
  /**
   Constraints height of the view to a constant value.
   - Parameter _ height: A CGFloat value.
   - Returns: A Layout instance to allow chaining.
   */
  @discardableResult
  func height(_ height: CGFloat) -> Layout {
    return constraint(.constantHeight, constants: height)
  }
}

public extension Layout {
  /**
   Constraints top of the view to the given anchor.
   - Parameter _ acnhor: A LayoutAnchor.
   - Parameter _ offset: A CGFloat offset.
   - Returns: A Layout instance to allow chaining.
   */
  @discardableResult
  func top(_ anchor: LayoutAnchor, _ offset: CGFloat = 0) -> Layout {
    return constraint(.top, to: anchor, constant: offset)
  }
  
  /**
   Constraints left of the view to the given anchor.
   - Parameter _ acnhor: A LayoutAnchor.
   - Parameter _ offset: A CGFloat offset.
   - Returns: A Layout instance to allow chaining.
   */
  @discardableResult
  func left(_ anchor: LayoutAnchor, _ offset: CGFloat = 0) -> Layout {
    return constraint(.left, to: anchor, constant: offset)
  }
  
  /**
   Constraints right of the view to the given anchor.
   - Parameter _ acnhor: A LayoutAnchor.
   - Parameter _ offset: A CGFloat offset.
   - Returns: A Layout instance to allow chaining.
   */
  @discardableResult
  func right(_ anchor: LayoutAnchor, _ offset: CGFloat = 0) -> Layout {
    return constraint(.right, to: anchor, constant: -offset)
  }
  
  /**
   Constraints bottom of the view to the given anchor.
   - Parameter _ acnhor: A LayoutAnchor.
   - Parameter _ offset: A CGFloat offset.
   - Returns: A Layout instance to allow chaining.
   */
  @discardableResult
  func bottom(_ anchor: LayoutAnchor, _ offset: CGFloat = 0) -> Layout {
    return constraint(.bottom, to: anchor, constant: -offset)
  }
  
  /**
   Constraints top-left of the view to the given anchor.
   - Parameter _ acnhor: A LayoutAnchor.
   - Parameter top: A CGFloat offset for top.
   - Parameter left: A CGFloat offset for left.
   - Returns: A Layout instance to allow chaining.
   */
  @discardableResult
  func topLeft(_ anchor: LayoutAnchor, top: CGFloat = 0, left: CGFloat = 0) -> Layout {
    return constraint(.topLeft, to: anchor, constants: top, left)
  }
  
  /**
   Constraints top-right of the view to the given anchor.
   - Parameter _ acnhor: A LayoutAnchor.
   - Parameter top: A CGFloat offset for top.
   - Parameter right: A CGFloat offset for right.
   - Returns: A Layout instance to allow chaining.
   */
  @discardableResult
  func topRight(_ anchor: LayoutAnchor, top: CGFloat = 0, right: CGFloat = 0) -> Layout {
    return constraint(.topRight, to: anchor, constants: top, -right)
  }
  
  /**
   Constraints bottom-left of the view to the given anchor.
   - Parameter _ acnhor: A LayoutAnchor.
   - Parameter bottom: A CGFloat offset for bottom.
   - Parameter left: A CGFloat offset for left.
   - Returns: A Layout instance to allow chaining.
   */
  @discardableResult
  func bottomLeft(_ anchor: LayoutAnchor, bottom: CGFloat = 0, left: CGFloat = 0) -> Layout {
    return constraint(.bottomLeft, to: anchor, constants: -bottom, left)
  }
  
  /**
   Constraints bottom-right of the view to the given anchor.
   - Parameter _ acnhor: A LayoutAnchor.
   - Parameter bottom: A CGFloat offset for bottom.
   - Parameter right: A CGFloat offset for right.
   - Returns: A Layout instance to allow chaining.
   */
  @discardableResult
  func bottomRight(_ anchor: LayoutAnchor, bottom: CGFloat = 0, right: CGFloat = 0) -> Layout {
    return constraint(.bottomRight, to: anchor, constants: -bottom, -right)
  }
  
  /**
   Constraints left and right of the view to the given anchor.
   - Parameter _ acnhor: A LayoutAnchor.
   - Parameter left: A CGFloat offset for left.
   - Parameter right: A CGFloat offset for right.
   - Returns: A Layout instance to allow chaining.
   */
  @discardableResult
  func leftRight(_ anchor: LayoutAnchor, left: CGFloat = 0, right: CGFloat = 0) -> Layout {
    return constraint(.leftRight, to: anchor, constants: left, -right)
  }
  
  /**
   Constraints top and bottom of the view to the given anchor.
   - Parameter _ acnhor: A LayoutAnchor.
   - Parameter top: A CGFloat offset for top.
   - Parameter bottom: A CGFloat offset for bottom.
   - Returns: A Layout instance to allow chaining.
   */
  @discardableResult
  func topBottom(_ anchor: LayoutAnchor, top: CGFloat = 0, bottom: CGFloat = 0) -> Layout {
    return constraint(.topBottom, to: anchor, constants: top, -bottom)
  }
  
  /**
   Constraints center of the view to the given anchor.
   - Parameter _ acnhor: A LayoutAnchor.
   - Parameter offsetX: A CGFloat offset for horizontal center.
   - Parameter offsetY: A CGFloat offset for vertical center.
   - Returns: A Layout instance to allow chaining.
   */
  @discardableResult
  func center(_ anchor: LayoutAnchor, offsetX: CGFloat = 0, offsetY: CGFloat = 0) -> Layout {
    return constraint(.center, to: anchor, constants: offsetX, offsetY)
  }
  
  /**
   Constraints horizontal center of the view to the given anchor.
   - Parameter _ acnhor: A LayoutAnchor.
   - Parameter _ offset: A CGFloat offset.
   - Returns: A Layout instance to allow chaining.
   */
  @discardableResult
  func centerX(_ anchor: LayoutAnchor, _ offset: CGFloat = 0) -> Layout {
    return constraint(.centerX, to: anchor, constant: offset)
  }
  
  /**
   Constraints vertical center of the view to the given anchor.
   - Parameter _ acnhor: A LayoutAnchor.
   - Parameter _ offset: A CGFloat offset.
   - Returns: A Layout instance to allow chaining.
   */
  @discardableResult
  func centerY(_ anchor: LayoutAnchor, _ offset: CGFloat = 0) -> Layout {
    return constraint(.centerY, to: anchor, constant: offset)
  }
  
  /**
   Constraints height of the view to the given anchor.
   - Parameter _ acnhor: A LayoutAnchor.
   - Parameter offset: A CGFloat offset.
   - Returns: A Layout instance to allow chaining.
   */
  @discardableResult
  func width(_ anchor: LayoutAnchor, _ offset: CGFloat = 0) -> Layout {
    return constraint(.width, to: anchor, constant: offset)
  }
  
  /**
   Constraints height of the view to the given anchor.
   - Parameter _ acnhor: A LayoutAnchor.
   - Parameter offset: A CGFloat offset.
   - Returns: A Layout instance to allow chaining.
   */
  @discardableResult
  func height(_ anchor: LayoutAnchor, _ offset: CGFloat = 0) -> Layout {
    return constraint(.height, to: anchor, constant: offset)
  }
  
  /**
   Constraints edges of the view to the given anchor.
   - Parameter _ acnhor: A LayoutAnchor.
   - Parameter top: A CGFloat offset for top.
   - Parameter left: A CGFloat offset for left.
   - Parameter bottom: A CGFloat offset for bottom.
   - Parameter right: A CGFloat offset for right.
   - Returns: A Layout instance to allow chaining.
   */
  @discardableResult
  func edges(_ anchor: LayoutAnchor, top: CGFloat = 0, left: CGFloat = 0, bottom: CGFloat = 0, right: CGFloat = 0) -> Layout {
    return constraint(.edges, to: anchor, constants: top, left, -bottom, -right)
  }
}

private extension Layout {
  /**
   Constraints the view to its parent according to the provided attribute.
   If the constraint already exists, will update its constant.
   - Parameter _ attribute: A LayoutAttribute.
   - Parameter constant: A CGFloat.
   - Returns: A Layout instance to allow chaining.
   */
  func constraint(_ attribute: LayoutAttribute, constant: CGFloat) -> Layout {
    return constraint([attribute], constants: constant)
  }
  
  /**
   Constraints the view to its parent according to the provided attributes.
   If any of the constraints already exists, will update its constant.
   - Parameter _ attributes: An array of LayoutAttribute.
   - Parameter constants: A list of CGFloat.
   - Returns: A Layout instance to allow chaining.
   */
  func constraint(_ attributes: [LayoutAttribute], constants: CGFloat...) -> Layout {
    var attributes = attributes
    var anchor: LayoutAnchor!
    
    if attributes == .constantHeight || attributes == .constantWidth {
      attributes.removeLast()
      anchor = LayoutAnchor(view: nil, attributes: [.notAnAttribute])
    } else {
      anchor = LayoutAnchor(view: parent, attributes: attributes)
    }
    return constraint(attributes, to: anchor, constants: constants)
  }
  
  /**
   Constraints the view to the given anchor according to the provided attribute.
   If the constraint already exists, will update its constant.
   - Parameter _ attribute: A LayoutAttribute.
   - Parameter to anchor: A LayoutAnchor.
   - Parameter constant: A CGFloat.
   - Returns: A Layout instance to allow chaining.
   */
  func constraint(_ attribute: LayoutAttribute, to anchor: LayoutAnchor, constant: CGFloat) -> Layout {
    return constraint([attribute], to: anchor, constants: constant)
  }
  
  /**
   Constraints the view to the given anchor according to the provided attributes.
   If any of the constraints already exists, will update its constant.
   - Parameter _ attributes: An array of LayoutAttribute.
   - Parameter to anchor: A LayoutAnchor.
   - Parameter constants: A list of CGFloat.
   - Returns: A Layout instance to allow chaining.
   */
  func constraint(_ attributes: [LayoutAttribute], to anchor: LayoutAnchor, constants: CGFloat...) -> Layout {
    return constraint(attributes, to: anchor, constants: constants)
  }
  
  /**
   Constraints the view to the given anchor according to the provided attributes.
   If any of the constraints already exists, will update its constant.
   - Parameter _ attributes: An array of LayoutAttribute.
   - Parameter to anchor: A LayoutAnchor.
   - Parameter constants: An array of CGFloat.
   - Returns: A Layout instance to allow chaining.
   */
  func constraint(_ attributes: [LayoutAttribute], to anchor: LayoutAnchor, constants: [CGFloat]) -> Layout {
    let from = LayoutAnchor(view: view, attributes: attributes)
    let constraint = LayoutConstraint(fromAnchor: from, toAnchor: anchor, constants: constants)
    
    let constraints = (view?.constraints ?? []) + (parent?.constraints ?? [])
    let newConstraints = constraint.constraints
    for newConstraint in newConstraints {
      guard let activeConstraint = constraints.first(where: { $0.equalTo(newConstraint) }) else {
        newConstraint.isActive = true
        continue
      }
      
      activeConstraint.constant = newConstraint.constant
    }
    
    return self
  }
}

private extension NSLayoutConstraint {
  /**
   Checks if the constraint is equal to given constraint.
   - Parameter _ other: An NSLayoutConstraint.
   - Returns: A Bool indicating whether constraints are equal.
   */
  func equalTo(_ other: NSLayoutConstraint) -> Bool {
    return firstItem === other.firstItem
      && secondItem === other.secondItem
      && firstAttribute == other.firstAttribute
      && secondAttribute == other.secondAttribute
  }
}
