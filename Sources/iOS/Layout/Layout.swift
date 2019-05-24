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
import Motion

/// A protocol that's conformed by UIView and UILayoutGuide.
public protocol Constraintable: class { }

@available(iOS 9.0, *)
extension UILayoutGuide: Constraintable { }
extension UIView: Constraintable { }

/// Layout extension for UIView.
public extension UIView {
  /**
   Used to chain layout constraints on a child context.
   - Parameter child: A child UIView to layout.
   - Returns: A Layout instance.
   */
  func layout(_ child: UIView) -> Layout {
    if self != child.superview {
      addSubview(child)
    }
    
    child.translatesAutoresizingMaskIntoConstraints = false
    return child.layout
  }
  
  /// Layout instance for the view.
  var layout: Layout {
    return Layout(constraintable: self)
  }
  
  /// Anchor instance for the view.
  var anchor: LayoutAnchor {
    return LayoutAnchor(constraintable: self)
  }
  
  /**
   Anchor instance for safeAreaLayoutGuide.
   Below iOS 11, it will be same as view.anchor.
   */
  var safeAnchor: LayoutAnchor {
    if #available(iOS 11.0, *) {
      return LayoutAnchor(constraintable: safeAreaLayoutGuide)
    } else {
      return anchor
    }
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
      && relation == other.relation
  }
}

/// A memory reference to the lastConstraint of UIView.
private var LastConstraintKey: UInt8 = 0

private extension UIView {
  /**
   The last consntraint that's created by Layout system.
   Used to set multiplier/priority on the last constraint.
   */
  var lastConstraint: NSLayoutConstraint? {
    get {
      return AssociatedObject.get(base: self, key: &LastConstraintKey) {
        nil
      }
    }
    set(value) {
      AssociatedObject.set(base: self, key: &LastConstraintKey, value: value)
    }
  }
}

public struct Layout {
  /// A weak reference to the constraintable.
  public weak var constraintable: Constraintable?
  
  /// Parent view of the view.
  var parent: UIView? {
    return (constraintable as? UIView)?.superview
  }
  
  /// Returns the view that is being laied out.
  public var view: UIView? {
    var  v = constraintable as? UIView
    if #available(iOS 9.0, *), v == nil {
      v = (constraintable as? UILayoutGuide)?.owningView
    }
    
    return v
  }
  
  /**
   An initializer taking Constraintable.
   - Parameter view: A Constraintable.
   */
  init(constraintable: Constraintable) {
    self.constraintable = constraintable
  }
}

public extension Layout {
  /**
   Sets multiplier of the last created constraint.
   Not meant for updating the multiplier as it will re-create the constraint.
   - Parameter _ multiplier: A CGFloat multiplier.
   - Returns: A Layout instance to allow chaining.
   */
  @discardableResult
  func multiply(_ multiplier: CGFloat) -> Layout {
    return resetLastConstraint(multiplier: multiplier)
  }
  
  /**
   Sets priority of the last created constraint.
   Not meant for updating the multiplier as it will re-create the constraint.
   - Parameter _ value: A Float priority.
   - Returns: A Layout instance to allow chaining.
   */
  @discardableResult
  func priority(_ value: Float) -> Layout {
    return priority(.init(rawValue: value))
  }
  
  /**
   Sets priority of the last created constraint.
   Not meant for updating the priority as it will re-create the constraint.
   - Parameter _ priority: A UILayoutPriority.
   - Returns: A Layout instance to allow chaining.
   */
  @discardableResult
  func priority(_ priority: UILayoutPriority) -> Layout {
    return resetLastConstraint(priority: priority)
  }
  
  /**
   Removes the last created constraint and creates new one with the new multiplier and/or priority (if provided).
   - Parameter multiplier: An optional CGFloat.
   - Parameter priority: An optional UILayoutPriority.
   - Returns: A Layout instance to allow chaining.
   */
  private func resetLastConstraint(multiplier: CGFloat? = nil, priority: UILayoutPriority? = nil) -> Layout {
    guard let v = view?.lastConstraint, v.isActive else {
      return self
    }
    v.isActive = false
    let newV = NSLayoutConstraint(item: v.firstItem as Any,
                                  attribute: v.firstAttribute,
                                  relatedBy: v.relation,
                                  toItem: v.secondItem,
                                  attribute: v.secondAttribute,
                                  multiplier: multiplier ?? v.multiplier,
                                  constant: v.constant)
    newV.priority = priority ?? v.priority
    newV.isActive = true
    view?.lastConstraint = newV
    return self
  }
}

public extension Layout {
  /**
   Constraints top of the view to its parent's.
   - Parameter _ offset: A CGFloat offset.
   - Parameter _ relationer: A LayoutRelationer.
   - Returns: A Layout instance to allow chaining.
   */
  @discardableResult
  func top(_ offset: CGFloat = 0, _ relationer: LayoutRelationer = LayoutRelationerStruct.equal) -> Layout {
    return constraint(.top, relationer: relationer, constant: offset)
  }
  
  /**
   Constraints left of the view to its parent's.
   - Parameter _ offset: A CGFloat offset.
   - Parameter _ relationer: A LayoutRelationer.
   - Returns: A Layout instance to allow chaining.
   */
  @discardableResult
  func left(_ offset: CGFloat = 0, _ relationer: LayoutRelationer = LayoutRelationerStruct.equal) -> Layout {
    return constraint(.left, relationer: relationer, constant: offset)
  }
  
  /**
   Constraints right of the view to its parent.
   - Parameter _ offset: A CGFloat offset.
   - Parameter _ relationer: A LayoutRelationer.
   - Returns: A Layout instance to allow chaining.
   */
  @discardableResult
  func right(_ offset: CGFloat = 0, _ relationer: LayoutRelationer = LayoutRelationerStruct.equal) -> Layout {
    return constraint(.right, relationer: relationer, constant: -offset)
  }
  
  /**
   Constraints leading of the view to its parent's.
   - Parameter _ offset: A CGFloat offset.
   - Parameter _ relationer: A LayoutRelationer.
   - Returns: A Layout instance to allow chaining.
   */
  @discardableResult
  func leading(_ offset: CGFloat = 0, _ relationer: LayoutRelationer = LayoutRelationerStruct.equal) -> Layout {
    return constraint(.leading, relationer: relationer, constant: offset)
  }
  
  /**
   Constraints trailing of the view to its parent.
   - Parameter _ offset: A CGFloat offset.
   - Parameter _ relationer: A LayoutRelationer.
   - Returns: A Layout instance to allow chaining.
   */
  @discardableResult
  func trailing(_ offset: CGFloat = 0, _ relationer: LayoutRelationer = LayoutRelationerStruct.equal) -> Layout {
    return constraint(.trailing, relationer: relationer, constant: -offset)
  }
  
  /**
   Constraints bottom of the view to its parent's.
   - Parameter _ offset: A CGFloat offset.
   - Parameter _ relationer: A LayoutRelationer.
   - Returns: A Layout instance to allow chaining.
   */
  @discardableResult
  func bottom(_ offset: CGFloat = 0, _ relationer: LayoutRelationer = LayoutRelationerStruct.equal) -> Layout {
    return constraint(.bottom, relationer: relationer, constant: -offset)
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
   Constraints top-leading of the view to its parent's.
   - Parameter top: A CGFloat offset for top.
   - Parameter leading: A CGFloat offset for leading.
   - Returns: A Layout instance to allow chaining.
   */
  @discardableResult
  func topLeading(top: CGFloat = 0, leading: CGFloat = 0) -> Layout {
    return constraint(.topLeading, constants: top, leading)
  }
  
  /**
   Constraints top-trailing of the view to its parent's.
   - Parameter top: A CGFloat offset for top.
   - Parameter trailing: A CGFloat offset for trailing.
   - Returns: A Layout instance to allow chaining.
   */
  @discardableResult
  func topTrailing(top: CGFloat = 0, trailing: CGFloat = 0) -> Layout {
    return constraint(.topTrailing, constants: top, -trailing)
  }
  
  /**
   Constraints bottom-leading of the view to its parent's.
   - Parameter bottom: A CGFloat offset for bottom.
   - Parameter leading: A CGFloat offset for leading.
   - Returns: A Layout instance to allow chaining.
   */
  @discardableResult
  func bottomLeading(bottom: CGFloat = 0, leading: CGFloat = 0) -> Layout {
    return constraint(.bottomLeading, constants: -bottom, leading)
  }
  
  /**
   Constraints bottom-trailing of the view to its parent's.
   - Parameter bottom: A CGFloat offset for bottom.
   - Parameter trailing: A CGFloat offset for trailing.
   - Returns: A Layout instance to allow chaining.
   */
  @discardableResult
  func bottomTrailing(bottom: CGFloat = 0, trailing: CGFloat = 0) -> Layout {
    return constraint(.bottomTrailing, constants: -bottom, -trailing)
  }
  
  /**
   Constraints leading and trailing of the view to its parent's.
   - Parameter leading: A CGFloat offset for leading.
   - Parameter trailing: A CGFloat offset for trailing.
   - Returns: A Layout instance to allow chaining.
   */
  @discardableResult
  func leadingTrailing(leading: CGFloat = 0, trailing: CGFloat = 0) -> Layout {
    return constraint(.leadingTrailing, constants: leading, -trailing)
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
   - Parameter _ relationer: A LayoutRelationer.
   - Returns: A Layout instance to allow chaining.
   */
  @discardableResult
  func centerX(_ offset: CGFloat = 0, _ relationer: LayoutRelationer = LayoutRelationerStruct.equal) -> Layout {
    return constraint(.centerX, relationer: relationer, constant: offset)
  }
  
  /**
   Constraints vertical center of the view to its parent's.
   - Parameter _ offset: A CGFloat offset.
   - Parameter _ relationer: A LayoutRelationer.
   - Returns: A Layout instance to allow chaining.
   */
  @discardableResult
  func centerY(_ offset: CGFloat = 0, _ relationer: LayoutRelationer = LayoutRelationerStruct.equal) -> Layout {
    return constraint(.centerY, relationer: relationer, constant: offset)
  }
  
  /**
   Constraints width of the view to its parent's.
   - Parameter offset: A CGFloat offset.
   - Parameter _ relationer: A LayoutRelationer.
   - Returns: A Layout instance to allow chaining.
   */
  @discardableResult
  func width(offset: CGFloat = 0, _ relationer: LayoutRelationer = LayoutRelationerStruct.equal) -> Layout {
    return constraint(.width, relationer: relationer, constant: offset)
  }
  
  /**
   Constraints height of the view to its parent's.
   - Parameter offset: A CGFloat offset.
   - Parameter _ relationer: A LayoutRelationer.
   - Returns: A Layout instance to allow chaining.
   */
  @discardableResult
  func height(offset: CGFloat = 0, _ relationer: LayoutRelationer = LayoutRelationerStruct.equal) -> Layout {
    return constraint(.height, relationer: relationer, constant: offset)
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
   Constraints top of the view to its parent's safeArea.
   - Parameter _ offset: A CGFloat offset.
   - Parameter _ relationer: A LayoutRelationer.
   - Returns: A Layout instance to allow chaining.
   */
  @discardableResult
  func topSafe(_ offset: CGFloat = 0, _ relationer: LayoutRelationer = LayoutRelationerStruct.equal) -> Layout {
    return constraint(.top, relationer: relationer, constant: offset, useSafeArea: true)
  }
  
  /**
   Constraints left of the view to its parent's safeArea.
   - Parameter _ offset: A CGFloat offset.
   - Parameter _ relationer: A LayoutRelationer.
   - Returns: A Layout instance to allow chaining.
   */
  @discardableResult
  func leftSafe(_ offset: CGFloat = 0, _ relationer: LayoutRelationer = LayoutRelationerStruct.equal) -> Layout {
    return constraint(.left, relationer: relationer, constant: offset, useSafeArea: true)
  }
  
  /**
   Constraints right of the view to its parent.
   - Parameter _ offset: A CGFloat offset.
   - Parameter _ relationer: A LayoutRelationer.
   - Returns: A Layout instance to allow chaining.
   */
  @discardableResult
  func rightSafe(_ offset: CGFloat = 0, _ relationer: LayoutRelationer = LayoutRelationerStruct.equal) -> Layout {
    return constraint(.right, relationer: relationer, constant: -offset, useSafeArea: true)
  }
  
  /**
   Constraints leading of the view to its parent's safeArea.
   - Parameter _ offset: A CGFloat offset.
   - Parameter _ relationer: A LayoutRelationer.
   - Returns: A Layout instance to allow chaining.
   */
  @discardableResult
  func leadingSafe(_ offset: CGFloat = 0, _ relationer: LayoutRelationer = LayoutRelationerStruct.equal) -> Layout {
    return constraint(.leading, relationer: relationer, constant: offset, useSafeArea: true)
  }
  
  /**
   Constraints trailing of the view to its parent.
   - Parameter _ offset: A CGFloat offset.
   - Parameter _ relationer: A LayoutRelationer.
   - Returns: A Layout instance to allow chaining.
   */
  @discardableResult
  func trailingSafe(_ offset: CGFloat = 0, _ relationer: LayoutRelationer = LayoutRelationerStruct.equal) -> Layout {
    return constraint(.trailing, relationer: relationer, constant: -offset, useSafeArea: true)
  }
  
  /**
   Constraints bottom of the view to its parent's safeArea.
   - Parameter _ offset: A CGFloat offset.
   - Parameter _ relationer: A LayoutRelationer.
   - Returns: A Layout instance to allow chaining.
   */
  @discardableResult
  func bottomSafe(_ offset: CGFloat = 0, _ relationer: LayoutRelationer = LayoutRelationerStruct.equal) -> Layout {
    return constraint(.bottom, relationer: relationer, constant: -offset, useSafeArea: true)
  }
  
  /**
   Constraints top-left of the view to its parent's safeArea.
   - Parameter top: A CGFloat offset for top.
   - Parameter left: A CGFloat offset for left.
   - Returns: A Layout instance to allow chaining.
   */
  @discardableResult
  func topLeftSafe(top: CGFloat = 0, left: CGFloat = 0) -> Layout {
    return constraint(.topLeft, constants: top, left, useSafeArea: true)
  }
  
  /**
   Constraints top-right of the view to its parent's safeArea.
   - Parameter top: A CGFloat offset for top.
   - Parameter right: A CGFloat offset for right.
   - Returns: A Layout instance to allow chaining.
   */
  @discardableResult
  func topRightSafe(top: CGFloat = 0, right: CGFloat = 0) -> Layout {
    return constraint(.topRight, constants: top, -right, useSafeArea: true)
  }
  
  /**
   Constraints bottom-left of the view to its parent's safeArea.
   - Parameter bottom: A CGFloat offset for bottom.
   - Parameter left: A CGFloat offset for left.
   - Returns: A Layout instance to allow chaining.
   */
  @discardableResult
  func bottomLeftSafe(bottom: CGFloat = 0, left: CGFloat = 0) -> Layout {
    return constraint(.bottomLeft, constants: -bottom, left, useSafeArea: true)
  }
  
  /**
   Constraints bottom-right of the view to its parent's safeArea.
   - Parameter bottom: A CGFloat offset for bottom.
   - Parameter right: A CGFloat offset for right.
   - Returns: A Layout instance to allow chaining.
   */
  @discardableResult
  func bottomRightSafe(bottom: CGFloat = 0, right: CGFloat = 0) -> Layout {
    return constraint(.bottomRight, constants: -bottom, -right, useSafeArea: true)
  }
  
  /**
   Constraints left and right of the view to its parent's safeArea.
   - Parameter left: A CGFloat offset for left.
   - Parameter right: A CGFloat offset for right.
   - Returns: A Layout instance to allow chaining.
   */
  @discardableResult
  func leftRightSafe(left: CGFloat = 0, right: CGFloat = 0) -> Layout {
    return constraint(.leftRight, constants: left, -right, useSafeArea: true)
  }
  
  /**
   Constraints top-leading of the view to its parent's safeArea.
   - Parameter top: A CGFloat offset for top.
   - Parameter leading: A CGFloat offset for leading.
   - Returns: A Layout instance to allow chaining.
   */
  @discardableResult
  func topLeadingSafe(top: CGFloat = 0, leading: CGFloat = 0) -> Layout {
    return constraint(.topLeading, constants: top, leading, useSafeArea: true)
  }
  
  /**
   Constraints top-trailing of the view to its parent's safeArea.
   - Parameter top: A CGFloat offset for top.
   - Parameter trailing: A CGFloat offset for trailing.
   - Returns: A Layout instance to allow chaining.
   */
  @discardableResult
  func topTrailingSafe(top: CGFloat = 0, trailing: CGFloat = 0) -> Layout {
    return constraint(.topTrailing, constants: top, -trailing, useSafeArea: true)
  }
  
  /**
   Constraints bottom-leading of the view to its parent's safeArea.
   - Parameter bottom: A CGFloat offset for bottom.
   - Parameter leading: A CGFloat offset for leading.
   - Returns: A Layout instance to allow chaining.
   */
  @discardableResult
  func bottomLeadingSafe(bottom: CGFloat = 0, leading: CGFloat = 0) -> Layout {
    return constraint(.bottomLeading, constants: -bottom, leading, useSafeArea: true)
  }
  
  /**
   Constraints bottom-trailing of the view to its parent's safeArea.
   - Parameter bottom: A CGFloat offset for bottom.
   - Parameter trailing: A CGFloat offset for trailing.
   - Returns: A Layout instance to allow chaining.
   */
  @discardableResult
  func bottomTrailingSafe(bottom: CGFloat = 0, trailing: CGFloat = 0) -> Layout {
    return constraint(.bottomTrailing, constants: -bottom, -trailing, useSafeArea: true)
  }
  
  /**
   Constraints leading and trailing of the view to its parent's safeArea.
   - Parameter leading: A CGFloat offset for leading.
   - Parameter trailing: A CGFloat offset for trailing.
   - Returns: A Layout instance to allow chaining.
   */
  @discardableResult
  func leadingTrailingSafe(leading: CGFloat = 0, trailing: CGFloat = 0) -> Layout {
    return constraint(.leadingTrailing, constants: leading, -trailing, useSafeArea: true)
  }
  
  /**
   Constraints top and bottom of the view to its parent's safeArea.
   - Parameter top: A CGFloat offset for top.
   - Parameter bottom: A CGFloat offset for bottom.
   - Returns: A Layout instance to allow chaining.
   */
  @discardableResult
  func topBottomSafe(top: CGFloat = 0, bottom: CGFloat = 0) -> Layout {
    return constraint(.topBottom, constants: top, -bottom, useSafeArea: true)
  }
  
  /**
   Constraints center of the view to its parent's safeArea.
   - Parameter offsetX: A CGFloat offset for horizontal center.
   - Parameter offsetY: A CGFloat offset for vertical center.
   - Returns: A Layout instance to allow chaining.
   */
  @discardableResult
  func centerSafe(offsetX: CGFloat = 0, offsetY: CGFloat = 0) -> Layout {
    return constraint(.center, constants: offsetX, offsetY, useSafeArea: true)
  }
  
  /**
   Constraints horizontal center of the view to its parent's safeArea.
   - Parameter _ offset: A CGFloat offset.
   - Parameter _ relationer: A LayoutRelationer.
   - Returns: A Layout instance to allow chaining.
   */
  @discardableResult
  func centerXSafe(_ offset: CGFloat = 0, _ relationer: LayoutRelationer = LayoutRelationerStruct.equal) -> Layout {
    return constraint(.centerX, relationer: relationer, constant: offset, useSafeArea: true)
  }
  
  /**
   Constraints vertical center of the view to its parent's safeArea.
   - Parameter _ offset: A CGFloat offset.
   - Parameter _ relationer: A LayoutRelationer.
   - Returns: A Layout instance to allow chaining.
   */
  @discardableResult
  func centerYSafe(_ offset: CGFloat = 0, _ relationer: LayoutRelationer = LayoutRelationerStruct.equal) -> Layout {
    return constraint(.centerY, relationer: relationer, constant: offset, useSafeArea: true)
  }
  
  /**
   Constraints width of the view to its parent's safeArea.
   - Parameter offset: A CGFloat offset.
   - Parameter _ relationer: A LayoutRelationer.
   - Returns: A Layout instance to allow chaining.
   */
  @discardableResult
  func widthSafe(offset: CGFloat = 0, _ relationer: LayoutRelationer = LayoutRelationerStruct.equal) -> Layout {
    return constraint(.width, relationer: relationer, constant: offset, useSafeArea: true)
  }
  
  /**
   Constraints height of the view to its parent's safeArea.
   - Parameter offset: A CGFloat offset.
   - Parameter _ relationer: A LayoutRelationer.
   - Returns: A Layout instance to allow chaining.
   */
  @discardableResult
  func heightSafe(offset: CGFloat = 0, _ relationer: LayoutRelationer = LayoutRelationerStruct.equal) -> Layout {
    return constraint(.height, relationer: relationer, constant: offset, useSafeArea: true)
  }
  
  /**
   Constraints edges of the view to its parent's safeArea.
   - Parameter top: A CGFloat offset for top.
   - Parameter left: A CGFloat offset for left.
   - Parameter bottom: A CGFloat offset for bottom.
   - Parameter right: A CGFloat offset for right.
   - Returns: A Layout instance to allow chaining.
   */
  @discardableResult
  func edgesSafe(top: CGFloat = 0, left: CGFloat = 0, bottom: CGFloat = 0, right: CGFloat = 0) -> Layout {
    return constraint(.edges, constants: top, left, -bottom, -right, useSafeArea: true)
  }
}

public extension Layout {
  /**
   Constraints width of the view to a constant value.
   - Parameter _ width: A CGFloat value.
   - Parameter _ relationer: A LayoutRelationer.
   - Returns: A Layout instance to allow chaining.
   */
  @discardableResult
  func width(_ width: CGFloat, _ relationer: LayoutRelationer = LayoutRelationerStruct.equal) -> Layout {
    return constraint(.constantWidth, relationer: relationer, constants: width)
  }
  
  /**
   Constraints height of the view to a constant value.
   - Parameter _ height: A CGFloat value.
   - Parameter _ relationer: A LayoutRelationer.
   - Returns: A Layout instance to allow chaining.
   */
  @discardableResult
  func height(_ height: CGFloat, _ relationer: LayoutRelationer = LayoutRelationerStruct.equal) -> Layout {
    return constraint(.constantHeight, relationer: relationer, constants: height)
  }
  
  /**
   The width and height of the view to its parent's.
   - Parameter _ size: A CGSize offset.
   - Returns: A Layout instance to allow chaining.
   */
  @discardableResult
  func size(_ size: CGSize) -> Layout {
    return width(size.width).height(size.height)
  }
}

public extension Layout {
  /**
   Constraints top of the view to the given anchor.
   - Parameter _ anchor: A LayoutAnchorable.
   - Parameter _ offset: A CGFloat offset.
   - Parameter _ relationer: A LayoutRelationer.
   - Returns: A Layout instance to allow chaining.
   */
  @discardableResult
  func top(_ anchor: LayoutAnchorable, _ offset: CGFloat = 0, _ relationer: LayoutRelationer = LayoutRelationerStruct.equal) -> Layout {
    return constraint(.top, to: anchor, relationer: relationer, constant: offset)
  }
  
  /**
   Constraints left of the view to the given anchor.
   - Parameter _ anchor: A LayoutAnchorable.
   - Parameter _ offset: A CGFloat offset.
   - Parameter _ relationer: A LayoutRelationer.
   - Returns: A Layout instance to allow chaining.
   */
  @discardableResult
  func left(_ anchor: LayoutAnchorable, _ offset: CGFloat = 0, _ relationer: LayoutRelationer = LayoutRelationerStruct.equal) -> Layout {
    return constraint(.left, to: anchor, relationer: relationer, constant: offset)
  }
  
  /**
   Constraints right of the view to the given anchor.
   - Parameter _ anchor: A LayoutAnchorable.
   - Parameter _ offset: A CGFloat offset.
   - Parameter _ relationer: A LayoutRelationer.
   - Returns: A Layout instance to allow chaining.
   */
  @discardableResult
  func right(_ anchor: LayoutAnchorable, _ offset: CGFloat = 0, _ relationer: LayoutRelationer = LayoutRelationerStruct.equal) -> Layout {
    return constraint(.right, to: anchor, relationer: relationer, constant: -offset)
  }
  
  /**
   Constraints leading of the view to the given anchor.
   - Parameter _ anchor: A LayoutAnchorable.
   - Parameter _ offset: A CGFloat offset.
   - Parameter _ relationer: A LayoutRelationer.
   - Returns: A Layout instance to allow chaining.
   */
  @discardableResult
  func leading(_ anchor: LayoutAnchorable, _ offset: CGFloat = 0, _ relationer: LayoutRelationer = LayoutRelationerStruct.equal) -> Layout {
    return constraint(.leading, to: anchor, relationer: relationer, constant: offset)
  }
  
  /**
   Constraints trailing of the view to the given anchor.
   - Parameter _ anchor: A LayoutAnchorable.
   - Parameter _ offset: A CGFloat offset.
   - Parameter _ relationer: A LayoutRelationer.
   - Returns: A Layout instance to allow chaining.
   */
  @discardableResult
  func trailing(_ anchor: LayoutAnchorable, _ offset: CGFloat = 0, _ relationer: LayoutRelationer = LayoutRelationerStruct.equal) -> Layout {
    return constraint(.trailing, to: anchor, relationer: relationer, constant: -offset)
  }
  
  /**
   Constraints bottom of the view to the given anchor.
   - Parameter _ anchor: A LayoutAnchorable.
   - Parameter _ offset: A CGFloat offset.
   - Parameter _ relationer: A LayoutRelationer.
   - Returns: A Layout instance to allow chaining.
   */
  @discardableResult
  func bottom(_ anchor: LayoutAnchorable, _ offset: CGFloat = 0, _ relationer: LayoutRelationer = LayoutRelationerStruct.equal) -> Layout {
    return constraint(.bottom, to: anchor, relationer: relationer, constant: -offset)
  }
  
  /**
   Constraints top-leading of the view to the given anchor.
   - Parameter _ anchor: A LayoutAnchorable.
   - Parameter top: A CGFloat offset for top.
   - Parameter leading: A CGFloat offset for leading.
   - Returns: A Layout instance to allow chaining.
   */
  @discardableResult
  func topLeading(_ anchor: LayoutAnchorable, top: CGFloat = 0, leading: CGFloat = 0) -> Layout {
    return constraint(.topLeading, to: anchor, constants: top, leading)
  }
  
  /**
   Constraints top-trailing of the view to the given anchor.
   - Parameter _ anchor: A LayoutAnchorable.
   - Parameter top: A CGFloat offset for top.
   - Parameter trailing: A CGFloat offset for trailing.
   - Returns: A Layout instance to allow chaining.
   */
  @discardableResult
  func topTrailing(_ anchor: LayoutAnchorable, top: CGFloat = 0, trailing: CGFloat = 0) -> Layout {
    return constraint(.topTrailing, to: anchor, constants: top, -trailing)
  }
  
  /**
   Constraints bottom-leading of the view to the given anchor.
   - Parameter _ anchor: A LayoutAnchorable.
   - Parameter bottom: A CGFloat offset for bottom.
   - Parameter leading: A CGFloat offset for leading.
   - Returns: A Layout instance to allow chaining.
   */
  @discardableResult
  func bottomLeading(_ anchor: LayoutAnchorable, bottom: CGFloat = 0, leading: CGFloat = 0) -> Layout {
    return constraint(.bottomLeading, to: anchor, constants: -bottom, leading)
  }
  
  /**
   Constraints bottom-trailing of the view to the given anchor.
   - Parameter _ anchor: A LayoutAnchorable.
   - Parameter bottom: A CGFloat offset for bottom.
   - Parameter trailing: A CGFloat offset for trailing.
   - Returns: A Layout instance to allow chaining.
   */
  @discardableResult
  func bottomTrailing(_ anchor: LayoutAnchorable, bottom: CGFloat = 0, trailing: CGFloat = 0) -> Layout {
    return constraint(.bottomTrailing, to: anchor, constants: -bottom, -trailing)
  }
  
  /**
   Constraints leading and trailing of the view to the given anchor.
   - Parameter _ anchor: A LayoutAnchorable.
   - Parameter leading: A CGFloat offset for leading.
   - Parameter trailing: A CGFloat offset for trailing.
   - Returns: A Layout instance to allow chaining.
   */
  @discardableResult
  func leadingTrailing(_ anchor: LayoutAnchorable, leading: CGFloat = 0, trailing: CGFloat = 0) -> Layout {
    return constraint(.leadingTrailing, to: anchor, constants: leading, -trailing)
  }
  
  /**
   Constraints top-left of the view to the given anchor.
   - Parameter _ anchor: A LayoutAnchorable.
   - Parameter top: A CGFloat offset for top.
   - Parameter left: A CGFloat offset for left.
   - Returns: A Layout instance to allow chaining.
   */
  @discardableResult
  func topLeft(_ anchor: LayoutAnchorable, top: CGFloat = 0, left: CGFloat = 0) -> Layout {
    return constraint(.topLeft, to: anchor, constants: top, left)
  }
  
  /**
   Constraints top-right of the view to the given anchor.
   - Parameter _ anchor: A LayoutAnchorable.
   - Parameter top: A CGFloat offset for top.
   - Parameter right: A CGFloat offset for right.
   - Returns: A Layout instance to allow chaining.
   */
  @discardableResult
  func topRight(_ anchor: LayoutAnchorable, top: CGFloat = 0, right: CGFloat = 0) -> Layout {
    return constraint(.topRight, to: anchor, constants: top, -right)
  }
  
  /**
   Constraints bottom-left of the view to the given anchor.
   - Parameter _ anchor: A LayoutAnchorable.
   - Parameter bottom: A CGFloat offset for bottom.
   - Parameter left: A CGFloat offset for left.
   - Returns: A Layout instance to allow chaining.
   */
  @discardableResult
  func bottomLeft(_ anchor: LayoutAnchorable, bottom: CGFloat = 0, left: CGFloat = 0) -> Layout {
    return constraint(.bottomLeft, to: anchor, constants: -bottom, left)
  }
  
  /**
   Constraints bottom-right of the view to the given anchor.
   - Parameter _ anchor: A LayoutAnchorable.
   - Parameter bottom: A CGFloat offset for bottom.
   - Parameter right: A CGFloat offset for right.
   - Returns: A Layout instance to allow chaining.
   */
  @discardableResult
  func bottomRight(_ anchor: LayoutAnchorable, bottom: CGFloat = 0, right: CGFloat = 0) -> Layout {
    return constraint(.bottomRight, to: anchor, constants: -bottom, -right)
  }
  
  /**
   Constraints left and right of the view to the given anchor.
   - Parameter _ anchor: A LayoutAnchorable.
   - Parameter left: A CGFloat offset for left.
   - Parameter right: A CGFloat offset for right.
   - Returns: A Layout instance to allow chaining.
   */
  @discardableResult
  func leftRight(_ anchor: LayoutAnchorable, left: CGFloat = 0, right: CGFloat = 0) -> Layout {
    return constraint(.leftRight, to: anchor, constants: left, -right)
  }
  
  /**
   Constraints top and bottom of the view to the given anchor.
   - Parameter _ anchor: A LayoutAnchorable.
   - Parameter top: A CGFloat offset for top.
   - Parameter bottom: A CGFloat offset for bottom.
   - Returns: A Layout instance to allow chaining.
   */
  @discardableResult
  func topBottom(_ anchor: LayoutAnchorable, top: CGFloat = 0, bottom: CGFloat = 0) -> Layout {
    return constraint(.topBottom, to: anchor, constants: top, -bottom)
  }
  
  /**
   Constraints center of the view to the given anchor.
   - Parameter _ anchor: A LayoutAnchorable.
   - Parameter offsetX: A CGFloat offset for horizontal center.
   - Parameter offsetY: A CGFloat offset for vertical center.
   - Returns: A Layout instance to allow chaining.
   */
  @discardableResult
  func center(_ anchor: LayoutAnchorable, offsetX: CGFloat = 0, offsetY: CGFloat = 0) -> Layout {
    return constraint(.center, to: anchor, constants: offsetX, offsetY)
  }
  
  /**
   Constraints horizontal center of the view to the given anchor.
   - Parameter _ anchor: A LayoutAnchorable.
   - Parameter _ offset: A CGFloat offset.
   - Parameter _ relationer: A LayoutRelationer.
   - Returns: A Layout instance to allow chaining.
   */
  @discardableResult
  func centerX(_ anchor: LayoutAnchorable, _ offset: CGFloat = 0, _ relationer: LayoutRelationer = LayoutRelationerStruct.equal) -> Layout {
    return constraint(.centerX, to: anchor, relationer: relationer, constant: offset)
  }
  
  /**
   Constraints vertical center of the view to the given anchor.
   - Parameter _ anchor: A LayoutAnchorable.
   - Parameter _ offset: A CGFloat offset.
   - Parameter _ relationer: A LayoutRelationer.
   - Returns: A Layout instance to allow chaining.
   */
  @discardableResult
  func centerY(_ anchor: LayoutAnchorable, _ offset: CGFloat = 0, _ relationer: LayoutRelationer = LayoutRelationerStruct.equal) -> Layout {
    return constraint(.centerY, to: anchor, relationer: relationer, constant: offset)
  }
  
  /**
   Constraints width of the view to the given anchor.
   - Parameter _ anchor: A LayoutAnchorable.
   - Parameter _ offset: A CGFloat offset.
   - Parameter _ relationer: A LayoutRelationer.
   - Returns: A Layout instance to allow chaining.
   */
  @discardableResult
  func width(_ anchor: LayoutAnchorable, _ offset: CGFloat = 0, _ relationer: LayoutRelationer = LayoutRelationerStruct.equal) -> Layout {
    return constraint(.width, to: anchor, relationer: relationer, constant: offset)
  }
  
  /**
   Constraints height of the view to the given anchor.
   - Parameter _ anchor: A LayoutAnchorable.
   - Parameter _ offset: A CGFloat offset.
   - Parameter _ relationer: A LayoutRelationer.
   - Returns: A Layout instance to allow chaining.
   */
  @discardableResult
  func height(_ anchor: LayoutAnchorable, _ offset: CGFloat = 0, _ relationer: LayoutRelationer = LayoutRelationerStruct.equal) -> Layout {
    return constraint(.height, to: anchor, relationer: relationer, constant: offset)
  }
  
  /**
   Constraints edges of the view to the given anchor.
   - Parameter _ anchor: A LayoutAnchorable.
   - Parameter top: A CGFloat offset for top.
   - Parameter left: A CGFloat offset for left.
   - Parameter bottom: A CGFloat offset for bottom.
   - Parameter right: A CGFloat offset for right.
   - Returns: A Layout instance to allow chaining.
   */
  @discardableResult
  func edges(_ anchor: LayoutAnchorable, top: CGFloat = 0, left: CGFloat = 0, bottom: CGFloat = 0, right: CGFloat = 0) -> Layout {
    return constraint(.edges, to: anchor, constants: top, left, -bottom, -right)
  }
}

public extension Layout {
  /**
   Constraints the object and sets it's anchor to `bottom`.
   - Parameter _ view: A UIView.
   - Parameter offset: A CGFloat offset for top.
   - Returns: A Layout instance to allow chaining.
   */
  @discardableResult
  func below(_ view: UIView, _ offset: CGFloat = 0) -> Layout {
    return top(view.anchor.bottom, offset)
  }
  
  /**
   Constraints the object and sets it's anchor to `top`.
   - Parameter _ view: A UIView.
   - Parameter offset: A CGFloat offset for bottom.
   - Returns: A Layout instance to allow chaining.
   */
  @discardableResult
  func above(_ view: UIView, _ offset: CGFloat = 0) -> Layout {
    return bottom(view.anchor.top, offset)
  }
  
  /**
   Constraints the object and sets it's anchor to `before/left`.
   - Parameter _ view: A UIView.
   - Parameter offset: A CGFloat offset for right.
   - Returns: A Layout instance to allow chaining.
   */
  @discardableResult
  func before(_ view: UIView, _ offset: CGFloat = 0) -> Layout {
    return right(view.anchor.left, offset)
  }
  
  /**
   Constraints the object and sets it's anchor to `after/right`.
   - Parameter _ view: A UIView.
   - Parameter offset: A CGFloat offset for left.
   - Returns: A Layout instance to allow chaining.
   */
  @discardableResult
  func after(_ view: UIView, _ offset: CGFloat = 0) -> Layout {
    return left(view.anchor.right, offset)
  }
  
  /**
   Constraints the object and sets it's aspect.
   - Parameter ratio: A CGFloat ratio multiplier.
   - Returns: A Layout instance to allow chaining.
   */
  @discardableResult
  func aspect(_ ratio: CGFloat = 1) -> Layout {
    return height(view!.anchor.width).multiply(ratio)
  }
}

private extension Layout {
  /**
   Constraints the view to its parent according to the provided attribute.
   If the constraint already exists, will update its constant.
   - Parameter _ attribute: A LayoutAttribute.
   - Parameter _ relationer: A LayoutRelationer.
   - Parameter constant: A CGFloat.
   - Returns: A Layout instance to allow chaining.
   */
  func constraint(_ attribute: LayoutAttribute, relationer: LayoutRelationer = LayoutRelationerStruct.equal, constant: CGFloat, useSafeArea: Bool = false) -> Layout {
    return constraint([attribute], relationer: relationer, constants: constant, useSafeArea: useSafeArea)
  }
  
  /**
   Constraints the view to its parent according to the provided attributes.
   If any of the constraints already exists, will update its constant.
   - Parameter _ attributes: An array of LayoutAttribute.
   - Parameter _ relationer: A LayoutRelationer.
   - Parameter constants: A list of CGFloat.
   - Returns: A Layout instance to allow chaining.
   */
  func constraint(_ attributes: [LayoutAttribute], relationer: LayoutRelationer = LayoutRelationerStruct.equal, constants: CGFloat..., useSafeArea: Bool = false) -> Layout {
    var attributes = attributes
    var anchor: LayoutAnchor!
    
    if attributes == .constantHeight || attributes == .constantWidth {
      attributes.removeLast()
      anchor = LayoutAnchor(constraintable: nil, attributes: [.notAnAttribute])
    } else {
      
      guard parent != nil else {
        fatalError("[Material Error: Constraint requires view to have parent.")
      }
      
      anchor = LayoutAnchor(constraintable: useSafeArea ? parent?.safeAnchor.constraintable : parent, attributes: attributes)
    }
    return constraint(attributes, to: anchor, relationer: relationer, constants: constants)
  }
  
  /**
   Constraints the view to the given anchor according to the provided attribute.
   If the constraint already exists, will update its constant.
   - Parameter _ attribute: A LayoutAttribute.
   - Parameter to anchor: A LayoutAnchorable.
   - Parameter relation: A LayoutRelation between anchors.
   - Parameter constant: A CGFloat.
   - Returns: A Layout instance to allow chaining.
   */
  func constraint(_ attribute: LayoutAttribute, to anchor: LayoutAnchorable, relationer: LayoutRelationer = LayoutRelationerStruct.equal, constant: CGFloat) -> Layout {
    return constraint([attribute], to: anchor, relationer: relationer, constants: constant)
  }
  
  /**
   Constraints the view to the given anchor according to the provided attributes.
   If any of the constraints already exists, will update its constant.
   - Parameter _ attributes: An array of LayoutAttribute.
   - Parameter to anchor: A LayoutAnchorable.
   - Parameter relation: A LayoutRelation between anchors.
   - Parameter constants: A list of CGFloat.
   - Returns: A Layout instance to allow chaining.
   */
  func constraint(_ attributes: [LayoutAttribute], to anchor: LayoutAnchorable, relationer: LayoutRelationer = LayoutRelationerStruct.equal, constants: CGFloat...) -> Layout {
    return constraint(attributes, to: anchor, relationer: relationer, constants: constants)
  }
  
  /**
   Constraints the view to the given anchor according to the provided attributes.
   If any of the constraints already exists, will update its constant.
   - Parameter _ attributes: An array of LayoutAttribute.
   - Parameter to anchor: A LayoutAnchorable.
   - Parameter relation: A LayoutRelation between anchors.
   - Parameter constants: An array of CGFloat.
   - Returns: A Layout instance to allow chaining.
   */
  func constraint(_ attributes: [LayoutAttribute], to anchor: LayoutAnchorable, relationer: LayoutRelationer, constants: [CGFloat]) -> Layout {
    let from = LayoutAnchor(constraintable: constraintable, attributes: attributes)
    var to = anchor as? LayoutAnchor
    if to?.attributes.isEmpty ?? true {
      let v = (anchor as? UIView) ?? (anchor as? LayoutAnchor)?.constraintable
      to = LayoutAnchor(constraintable: v, attributes: attributes)
    }
    let constraint = LayoutConstraint(fromAnchor: from, toAnchor: to!, relation: relationer(.nil, .nil), constants: constants)
    
    
    let constraints = (view?.constraints ?? []) + (view?.superview?.constraints ?? [])
    let newConstraints = constraint.constraints
    for newConstraint in newConstraints {
      guard let activeConstraint = constraints.first(where: { $0.equalTo(newConstraint) }) else {
        newConstraint.isActive = true
        view?.lastConstraint = newConstraint
        continue
      }
      
      activeConstraint.constant = newConstraint.constant
    }
    
    return self
  }
}

/// A closure typealias for relation operators.
public typealias LayoutRelationer = (LayoutRelationerStruct, LayoutRelationerStruct) -> LayoutRelation

/// A dummy struct used in creating relation operators (==, >=, <=).
public struct LayoutRelationerStruct {
  /// Passed as an unused argument to the LayoutRelationer closures.
  static let `nil` = LayoutRelationerStruct()
  
  /**
   A method used as a default parameter for LayoutRelationer closures.
   Swift does not allow using == operator directly, so we had to create this.
   */
  public static func equal(left: LayoutRelationerStruct, right: LayoutRelationerStruct) -> LayoutRelation {
    return .equal
  }
}

/// A method returning `LayoutRelation.equal`
public func ==(left: LayoutRelationerStruct, right: LayoutRelationerStruct) -> LayoutRelation {
  return .equal
}

/// A method returning `LayoutRelation.greaterThanOrEqual`
public func >=(left: LayoutRelationerStruct, right: LayoutRelationerStruct) -> LayoutRelation {
  return .greaterThanOrEqual
}

/// A method returning `LayoutRelation.lessThanOrEqual`
public func <=(left: LayoutRelationerStruct, right: LayoutRelationerStruct) -> LayoutRelation {
  return .lessThanOrEqual
}

