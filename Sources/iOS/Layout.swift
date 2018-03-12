/*
 * Copyright (C) 2015 - 2017, Daniel Dahan and CosmicMind, Inc. <http://cosmicmind.com>.
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

public class Layout {
  /// Parent UIView context.
  internal weak var parent: UIView?
  
  /// Child UIView context.
  internal weak var child: UIView?
  
  /**
   An initializer that takes in a parent context.
   - Parameter parent: An optional parent UIView.
   */
  public init(parent: UIView?) {
    self.parent = parent
  }
  
  /**
   An initializer that takes in a parent context and child context.
   - Parameter parent: An optional parent UIView.
   - Parameter child: An optional child UIView.
   */
  public init(parent: UIView?, child: UIView?) {
    self.parent = parent
    self.child = child
  }
  
  /**
   Prints a debug message when the parent context is not available.
   - Parameter function: A String representation of the function that
   caused the issue.
   - Returns: The current Layout instance.
   */
  internal func debugParentNotAvailableMessage(function: String = #function) -> Layout {
    debugPrint("[Material Layout Error: Parent view context is not available for \(function).")
    return self
  }
  
  /**
   Prints a debug message when the child context is not available.
   - Parameter function: A String representation of the function that
   caused the issue.
   - Returns: The current Layout instance.
   */
  internal func debugChildNotAvailableMessage(function: String = #function) -> Layout {
    debugPrint("[Material Layout Error: Child view context is not available for \(function).")
    return self
  }
  
  /**
   Sets the width of a view.
   - Parameter child: A child UIView to layout.
   - Parameter width: A CGFloat value.
   - Returns: The current Layout instance.
   */
  @discardableResult
  public func width(_ child: UIView, width: CGFloat) -> Layout {
    guard let v = parent else {
      return debugParentNotAvailableMessage()
    }
    self.child = child
    Layout.width(parent: v, child: child, width: width)
    return self
  }
  
  /**
   Sets the width of a view assuming a child context view.
   - Parameter width: A CGFloat value.
   - Returns: The current Layout instance.
   */
  @discardableResult
  public func width(_ width: CGFloat) -> Layout {
    guard let v = child else {
      return debugChildNotAvailableMessage()
    }
    return self.width(v, width: width)
  }
  
  /**
   Sets the height of a view.
   - Parameter child: A child UIView to layout.
   - Parameter height: A CGFloat value.
   - Returns: The current Layout instance.
   */
  @discardableResult
  public func height(_ child: UIView, height: CGFloat) -> Layout {
    guard let v = parent else {
      return debugParentNotAvailableMessage()
    }
    self.child = child
    Layout.height(parent: v, child: child, height: height)
    return self
  }
  
  /**
   Sets the height of a view assuming a child context view.
   - Parameter height: A CGFloat value.
   - Returns: The current Layout instance.
   */
  @discardableResult
  public func height(_ height: CGFloat) -> Layout {
    guard let v = child else {
      return debugChildNotAvailableMessage()
    }
    return self.height(v, height: height)
  }
  
  /**
   Sets the width and height of a view.
   - Parameter child: A child UIView to layout.
   - Parameter size: A CGSize value.
   - Returns: The current Layout instance.
   */
  @discardableResult
  public func size(_ child: UIView, size: CGSize) -> Layout {
    guard let v = parent else {
      return debugParentNotAvailableMessage()
    }
    self.child = child
    Layout.size(parent: v, child: child, size: size)
    return self
  }
  
  /**
   Sets the width and height of a view assuming a child context view.
   - Parameter size: A CGSize value.
   - Returns: The current Layout instance.
   */
  @discardableResult
  public func size(_ size: CGSize = CGSize.zero) -> Layout {
    guard let v = child else {
      return debugChildNotAvailableMessage()
    }
    return self.size(v, size: size)
  }
  
  /**
   A collection of children views are horizontally stretched with optional left,
   right padding and interim interimSpace.
   - Parameter children: An Array UIView to layout.
   - Parameter left: A CGFloat value for padding the left side.
   - Parameter right: A CGFloat value for padding the right side.
   - Parameter interimSpace: A CGFloat value for interim interimSpace.
   - Returns: The current Layout instance.
   */
  @discardableResult
  public func horizontally(_ children: [UIView], left: CGFloat = 0, right: CGFloat = 0, interimSpace: InterimSpace = 0) -> Layout {
    guard let v = parent else {
      return debugParentNotAvailableMessage()
    }
    Layout.horizontally(parent: v, children: children, left: left, right: right, interimSpace: interimSpace)
    return self
  }
  
  /**
   A collection of children views are vertically stretched with optional top,
   bottom padding and interim interimSpace.
   - Parameter children: An Array UIView to layout.
   - Parameter top: A CGFloat value for padding the top side.
   - Parameter bottom: A CGFloat value for padding the bottom side.
   - Parameter interimSpace: A CGFloat value for interim interimSpace.
   - Returns: The current Layout instance.
   */
  @discardableResult
  public func vertically(_ children: [UIView], top: CGFloat = 0, bottom: CGFloat = 0, interimSpace: InterimSpace = 0) -> Layout {
    guard let v = parent else {
      return debugParentNotAvailableMessage()
    }
    Layout.vertically(parent: v, children: children, top: top, bottom: bottom, interimSpace: interimSpace)
    return self
  }
  
  /**
   A child view is horizontally stretched with optional left and right padding.
   - Parameter child: A child UIView to layout.
   - Parameter left: A CGFloat value for padding the left side.
   - Parameter right: A CGFloat value for padding the right side.
   - Returns: The current Layout instance.
   */
  @discardableResult
  public func horizontally(_ child: UIView, left: CGFloat = 0, right: CGFloat = 0) -> Layout {
    guard let v = parent else {
      return debugParentNotAvailableMessage()
    }
    self.child = child
    Layout.horizontally(parent: v, child: child, left: left, right: right)
    return self
  }
  
  /**
   A child view is horizontally stretched with optional left and right padding.
   - Parameter left: A CGFloat value for padding the left side.
   - Parameter right: A CGFloat value for padding the right side.
   - Returns: The current Layout instance.
   */
  @discardableResult
  public func horizontally(left: CGFloat = 0, right: CGFloat = 0) -> Layout {
    guard let v = child else {
      return debugChildNotAvailableMessage()
    }
    return horizontally(v, left: left, right: right)
  }
  
  /**
   A child view is vertically stretched with optional left and right padding.
   - Parameter child: A child UIView to layout.
   - Parameter top: A CGFloat value for padding the top side.
   - Parameter bottom: A CGFloat value for padding the bottom side.
   - Returns: The current Layout instance.
   */
  @discardableResult
  public func vertically(_ child: UIView, top: CGFloat = 0, bottom: CGFloat = 0) -> Layout {
    guard let v = parent else {
      return debugParentNotAvailableMessage()
    }
    self.child = child
    Layout.vertically(parent: v, child: child, top: top, bottom: bottom)
    return self
  }
  
  /**
   A child view is vertically stretched with optional left and right padding.
   - Parameter top: A CGFloat value for padding the top side.
   - Parameter bottom: A CGFloat value for padding the bottom side.
   - Returns: The current Layout instance.
   */
  @discardableResult
  public func vertically(top: CGFloat = 0, bottom: CGFloat = 0) -> Layout {
    guard let v = child else {
      return debugChildNotAvailableMessage()
    }
    return vertically(v, top: top, bottom: bottom)
  }
  
  /**
   A child view is vertically and horizontally stretched with optional top, left, bottom and right padding.
   - Parameter child: A child UIView to layout.
   - Parameter top: A CGFloat value for padding the top side.
   - Parameter left: A CGFloat value for padding the left side.
   - Parameter bottom: A CGFloat value for padding the bottom side.
   - Parameter right: A CGFloat value for padding the right side.
   - Returns: The current Layout instance.
   */
  @discardableResult
  public func edges(_ child: UIView, top: CGFloat = 0, left: CGFloat = 0, bottom: CGFloat = 0, right: CGFloat = 0) -> Layout {
    guard let v = parent else {
      return debugParentNotAvailableMessage()
    }
    self.child = child
    Layout.edges(parent: v, child: child, top: top, left: left, bottom: bottom, right: right)
    return self
  }
  
  /**
   A child view is vertically and horizontally stretched with optional top, left, bottom and right padding.
   - Parameter child: A child UIView to layout.
   - Parameter top: A CGFloat value for padding the top side.
   - Parameter left: A CGFloat value for padding the left side.
   - Parameter bottom: A CGFloat value for padding the bottom side.
   - Parameter right: A CGFloat value for padding the right side.
   - Returns: The current Layout instance.
   */
  @discardableResult
  public func edges(top: CGFloat = 0, left: CGFloat = 0, bottom: CGFloat = 0, right: CGFloat = 0) -> Layout {
    guard let v = child else {
      return debugChildNotAvailableMessage()
    }
    return edges(v, top: top, left: left, bottom: bottom, right: right)
  }
  
  /**
   A child view is aligned from the top with optional top padding.
   - Parameter child: A child UIView to layout.
   - Parameter top: A CGFloat value for padding the top side.
   - Returns: The current Layout instance.
   */
  @discardableResult
  public func top(_ child: UIView, top: CGFloat = 0) -> Layout {
    guard let v = parent else {
      return debugParentNotAvailableMessage()
    }
    self.child = child
    Layout.top(parent: v, child: child, top: top)
    return self
  }
  
  /**
   A child view is aligned from the top with optional top padding.
   - Parameter top: A CGFloat value for padding the top side.
   - Returns: The current Layout instance.
   */
  @discardableResult
  public func top(_ top: CGFloat = 0) -> Layout {
    guard let v = child else {
      return debugChildNotAvailableMessage()
    }
    return self.top(v, top: top)
  }
  
  /**
   A child view is aligned from the left with optional left padding.
   - Parameter child: A child UIView to layout.
   - Parameter left: A CGFloat value for padding the left side.
   - Returns: The current Layout instance.
   */
  @discardableResult
  public func left(_ child: UIView, left: CGFloat = 0) -> Layout {
    guard let v = parent else {
      return debugParentNotAvailableMessage()
    }
    self.child = child
    Layout.left(parent: v, child: child, left: left)
    return self
  }
  
  /**
   A child view is aligned from the left with optional left padding.
   - Parameter left: A CGFloat value for padding the left side.
   - Returns: The current Layout instance.
   */
  @discardableResult
  public func left(_ left: CGFloat = 0) -> Layout {
    guard let v = child else {
      return debugChildNotAvailableMessage()
    }
    return self.left(v, left: left)
  }
  
  /**
   A child view is aligned from the bottom with optional bottom padding.
   - Parameter child: A child UIView to layout.
   - Parameter bottom: A CGFloat value for padding the bottom side.
   - Returns: The current Layout instance.
   */
  @discardableResult
  public func bottom(_ child: UIView, bottom: CGFloat = 0) -> Layout {
    guard let v = parent else {
      return debugParentNotAvailableMessage()
    }
    self.child = child
    Layout.bottom(parent: v, child: child, bottom: bottom)
    return self
  }
  
  /**
   A child view is aligned from the bottom with optional bottom padding.
   - Parameter bottom: A CGFloat value for padding the bottom side.
   - Returns: The current Layout instance.
   */
  @discardableResult
  public func bottom(_ bottom: CGFloat = 0) -> Layout {
    guard let v = child else {
      return debugChildNotAvailableMessage()
    }
    return self.bottom(v, bottom: bottom)
  }
  
  /**
   A child view is aligned from the right with optional right padding.
   - Parameter child: A child UIView to layout.
   - Parameter right: A CGFloat value for padding the right side.
   - Returns: The current Layout instance.
   */
  @discardableResult
  public func right(_ child: UIView, right: CGFloat = 0) -> Layout {
    guard let v = parent else {
      return debugParentNotAvailableMessage()
    }
    self.child = child
    Layout.right(parent: v, child: child, right: right)
    return self
  }
  
  /**
   A child view is aligned from the right with optional right padding.
   - Parameter right: A CGFloat value for padding the right side.
   - Returns: The current Layout instance.
   */
  @discardableResult
  public func right(_ right: CGFloat = 0) -> Layout {
    guard let v = child else {
      return debugChildNotAvailableMessage()
    }
    return self.right(v, right: right)
  }
  
  /**
   A child view is aligned from the top left with optional top and left padding.
   - Parameter child: A child UIView to layout.
   - Parameter top: A CGFloat value for padding the top side.
   - Parameter left: A CGFloat value for padding the left side.
   - Returns: The current Layout instance.
   */
  @discardableResult
  public func topLeft(_ child: UIView, top: CGFloat = 0, left: CGFloat = 0) -> Layout {
    guard let v = parent else {
      return debugParentNotAvailableMessage()
    }
    self.child = child
    Layout.topLeft(parent: v, child: child, top: top, left: left)
    return self
  }
  
  /**
   A child view is aligned from the top left with optional top and left padding.
   - Parameter top: A CGFloat value for padding the top side.
   - Parameter left: A CGFloat value for padding the left side.
   - Returns: The current Layout instance.
   */
  @discardableResult
  public func topLeft(top: CGFloat = 0, left: CGFloat = 0) -> Layout {
    guard let v = child else {
      return debugChildNotAvailableMessage()
    }
    return topLeft(v, top: top, left: left)
  }
  
  /**
   A child view is aligned from the top right with optional top and right padding.
   - Parameter child: A child UIView to layout.
   - Parameter top: A CGFloat value for padding the top side.
   - Parameter right: A CGFloat value for padding the right side.
   - Returns: The current Layout instance.
   */
  @discardableResult
  public func topRight(_ child: UIView, top: CGFloat = 0, right: CGFloat = 0) -> Layout {
    guard let v = parent else {
      return debugParentNotAvailableMessage()
    }
    self.child = child
    Layout.topRight(parent: v, child: child, top: top, right: right)
    return self
  }
  
  /**
   A child view is aligned from the top right with optional top and right padding.
   - Parameter top: A CGFloat value for padding the top side.
   - Parameter right: A CGFloat value for padding the right side.
   - Returns: The current Layout instance.
   */
  @discardableResult
  public func topRight(top: CGFloat = 0, right: CGFloat = 0) -> Layout {
    guard let v = child else {
      return debugChildNotAvailableMessage()
    }
    return topRight(v, top: top, right: right)
  }
  
  /**
   A child view is aligned from the bottom left with optional bottom and left padding.
   - Parameter child: A child UIView to layout.
   - Parameter bottom: A CGFloat value for padding the bottom side.
   - Parameter left: A CGFloat value for padding the left side.
   - Returns: The current Layout instance.
   */
  @discardableResult
  public func bottomLeft(_ child: UIView, bottom: CGFloat = 0, left: CGFloat = 0) -> Layout {
    guard let v = parent else {
      return debugParentNotAvailableMessage()
    }
    self.child = child
    Layout.bottomLeft(parent: v, child: child, bottom: bottom, left: left)
    return self
  }
  
  /**
   A child view is aligned from the bottom left with optional bottom and left padding.
   - Parameter bottom: A CGFloat value for padding the bottom side.
   - Parameter left: A CGFloat value for padding the left side.
   - Returns: The current Layout instance.
   */
  @discardableResult
  public func bottomLeft(bottom: CGFloat = 0, left: CGFloat = 0) -> Layout {
    guard let v = child else {
      return debugChildNotAvailableMessage()
    }
    return bottomLeft(v, bottom: bottom, left: left)
  }
  
  /**
   A child view is aligned from the bottom right with optional bottom and right padding.
   - Parameter child: A child UIView to layout.
   - Parameter bottom: A CGFloat value for padding the bottom side.
   - Parameter right: A CGFloat value for padding the right side.
   - Returns: The current Layout instance.
   */
  @discardableResult
  public func bottomRight(_ child: UIView, bottom: CGFloat = 0, right: CGFloat = 0) -> Layout {
    guard let v = parent else {
      return debugParentNotAvailableMessage()
    }
    self.child = child
    Layout.bottomRight(parent: v, child: child, bottom: bottom, right: right)
    return self
  }
  
  /**
   A child view is aligned from the bottom right with optional bottom and right padding.
   - Parameter bottom: A CGFloat value for padding the bottom side.
   - Parameter right: A CGFloat value for padding the right side.
   - Returns: The current Layout instance.
   */
  @discardableResult
  public func bottomRight(bottom: CGFloat = 0, right: CGFloat = 0) -> Layout {
    guard let v = child else {
      return debugChildNotAvailableMessage()
    }
    return bottomRight(v, bottom: bottom, right: right)
  }
  
  /**
   A child view is aligned at the center with an optional offsetX and offsetY value.
   - Parameter child: A child UIView to layout.
   - Parameter offsetX: A CGFloat value for the offset along the x axis.
   - Parameter offsetX: A CGFloat value for the offset along the y axis.
   - Returns: The current Layout instance.
   */
  @discardableResult
  public func center(_ child: UIView, offsetX: CGFloat = 0, offsetY: CGFloat = 0) -> Layout {
    guard let v = parent else {
      return debugParentNotAvailableMessage()
    }
    self.child = child
    Layout.center(parent: v, child: child, offsetX: offsetX, offsetY: offsetY)
    return self
  }
  
  /**
   A child view is aligned at the center with an optional offsetX and offsetY value.
   - Parameter offsetX: A CGFloat value for the offset along the x axis.
   - Parameter offsetX: A CGFloat value for the offset along the y axis.
   - Returns: The current Layout instance.
   */
  @discardableResult
  public func center(offsetX: CGFloat = 0, offsetY: CGFloat = 0) -> Layout {
    guard let v = child else {
      return debugChildNotAvailableMessage()
    }
    return center(v, offsetX: offsetX, offsetY: offsetY)
  }
  
  /**
   A child view is aligned at the center horizontally with an optional offset value.
   - Parameter child: A child UIView to layout.
   - Parameter offset: A CGFloat value for the offset along the x axis.
   - Returns: The current Layout instance.
   */
  @discardableResult
  public func centerHorizontally(_ child: UIView, offset: CGFloat = 0) -> Layout {
    guard let v = parent else {
      return debugParentNotAvailableMessage()
    }
    self.child = child
    Layout.centerHorizontally(parent: v, child: child, offset: offset)
    return self
  }
  
  /**
   A child view is aligned at the center horizontally with an optional offset value.
   - Parameter offset: A CGFloat value for the offset along the x axis.
   - Returns: The current Layout instance.
   */
  @discardableResult
  public func centerHorizontally(offset: CGFloat = 0) -> Layout {
    guard let v = child else {
      return debugChildNotAvailableMessage()
    }
    return centerHorizontally(v, offset: offset)
  }
  
  /**
   A child view is aligned at the center vertically with an optional offset value.
   - Parameter child: A child UIView to layout.
   - Parameter offset: A CGFloat value for the offset along the y axis.
   - Returns: The current Layout instance.
   */
  @discardableResult
  public func centerVertically(_ child: UIView, offset: CGFloat = 0) -> Layout {
    guard let v = parent else {
      return debugParentNotAvailableMessage()
    }
    self.child = child
    Layout.centerVertically(parent: v, child: child, offset: offset)
    return self
  }
  
  /**
   A child view is aligned at the center vertically with an optional offset value.
   - Parameter offset: A CGFloat value for the offset along the y axis.
   - Returns: The current Layout instance.
   */
  @discardableResult
  public func centerVertically(offset: CGFloat = 0) -> Layout {
    guard let v = child else {
      return debugChildNotAvailableMessage()
    }
    return centerVertically(v, offset: offset)
  }
}

fileprivate extension Layout {
  /**
   Updates the consraints for a given view.
   - Parameter for view: A UIView.
   */
  class func updateConstraints(for view: UIView) {
    view.setNeedsUpdateConstraints()
    view.updateConstraintsIfNeeded()
    view.setNeedsLayout()
    view.layoutIfNeeded()
  }
  
  /**
   Updates the constraints for a given Array of views.
   - Parameter for [view]: An Array of UIViews.
   */
  class func updateConstraints(for views: [UIView]) {
    for v in views {
      updateConstraints(for: v)
    }
  }
}

/// Layout
extension Layout {
  /**
   Sets the width of a view.
   - Parameter parent: A parent UIView context.
   - Parameter child: A child UIView to layout.
   - Parameter width: A CGFloat value.
   */
  public class func width(parent: UIView, child: UIView, width: CGFloat = 0) {
    prepareForConstraint(parent, child: child)
    parent.addConstraint(NSLayoutConstraint(item: child, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .width, multiplier: 1, constant: width))
    updateConstraints(for: child)
  }
  
  /**
   Sets the height of a view.
   - Parameter parent: A parent UIView context.
   - Parameter child: A child UIView to layout.
   - Parameter height: A CGFloat value.
   */
  public class func height(parent: UIView, child: UIView, height: CGFloat = 0) {
    prepareForConstraint(parent, child: child)
    parent.addConstraint(NSLayoutConstraint(item: child, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1, constant: height))
    updateConstraints(for: child)
  }
  
  /**
   Sets the width and height of a view.
   - Parameter parent: A parent UIView context.
   - Parameter child: A child UIView to layout.
   - Parameter size: A CGSize value.
   */
  public class func size(parent: UIView, child: UIView, size: CGSize = CGSize.zero) {
    Layout.width(parent: parent, child: child, width: size.width)
    Layout.height(parent: parent, child: child, height: size.height)
  }
  
  /**
   A collection of children views are horizontally stretched with optional left,
   right padding and interim interimSpace.
   - Parameter parent: A parent UIView context.
   - Parameter children: An Array UIView to layout.
   - Parameter left: A CGFloat value for padding the left side.
   - Parameter right: A CGFloat value for padding the right side.
   - Parameter interimSpace: A CGFloat value for interim interimSpace.
   */
  public class func horizontally(parent: UIView, children: [UIView], left: CGFloat = 0, right: CGFloat = 0, interimSpace: InterimSpace = 0) {
    prepareForConstraint(parent, children: children)
    
    if 0 < children.count {
      parent.addConstraint(NSLayoutConstraint(item: children[0], attribute: .left, relatedBy: .equal, toItem: parent, attribute: .left, multiplier: 1, constant: left))
      for i in 1..<children.count {
        parent.addConstraint(NSLayoutConstraint(item: children[i], attribute: .left, relatedBy: .equal, toItem: children[i - 1], attribute: .right, multiplier: 1, constant: interimSpace))
        parent.addConstraint(NSLayoutConstraint(item: children[i], attribute: .width, relatedBy: .equal, toItem: children[0], attribute: .width, multiplier: 1, constant: 0))
      }
      parent.addConstraint(NSLayoutConstraint(item: children[children.count - 1], attribute: .right, relatedBy: .equal, toItem: parent, attribute: .right, multiplier: 1, constant: -right))
    }
    
    updateConstraints(for: children)
  }
  
  /**
   A collection of children views are vertically stretched with optional top,
   bottom padding and interim interimSpace.
   - Parameter parent: A parent UIView context.
   - Parameter children: An Array UIView to layout.
   - Parameter top: A CGFloat value for padding the top side.
   - Parameter bottom: A CGFloat value for padding the bottom side.
   - Parameter interimSpace: A CGFloat value for interim interimSpace.
   */
  public class func vertically(parent: UIView, children: [UIView], top: CGFloat = 0, bottom: CGFloat = 0, interimSpace: InterimSpace = 0) {
    prepareForConstraint(parent, children: children)
    
    if 0 < children.count {
      parent.addConstraint(NSLayoutConstraint(item: children[0], attribute: .top, relatedBy: .equal, toItem: parent, attribute: .top, multiplier: 1, constant: top))
      for i in 1..<children.count {
        parent.addConstraint(NSLayoutConstraint(item: children[i], attribute: .top, relatedBy: .equal, toItem: children[i - 1], attribute: .bottom, multiplier: 1, constant: interimSpace))
        parent.addConstraint(NSLayoutConstraint(item: children[i], attribute: .height, relatedBy: .equal, toItem: children[0], attribute: .height, multiplier: 1, constant: 0))
      }
      parent.addConstraint(NSLayoutConstraint(item: children[children.count - 1], attribute: .bottom, relatedBy: .equal, toItem: parent, attribute: .bottom, multiplier: 1, constant: -bottom))
    }
    
    updateConstraints(for: children)
  }
  
  /**
   A child view is horizontally stretched with optional left and right padding.
   - Parameter parent: A parent UIView context.
   - Parameter child: A child UIView to layout.
   - Parameter left: A CGFloat value for padding the left side.
   - Parameter right: A CGFloat value for padding the right side.
   */
  public class func horizontally(parent: UIView, child: UIView, left: CGFloat = 0, right: CGFloat = 0) {
    prepareForConstraint(parent, child: child)
    parent.addConstraint(NSLayoutConstraint(item: child, attribute: .left, relatedBy: .equal, toItem: parent, attribute: .left, multiplier: 1, constant: left))
    parent.addConstraint(NSLayoutConstraint(item: child, attribute: .right, relatedBy: .equal, toItem: parent, attribute: .right, multiplier: 1, constant: -right))
    updateConstraints(for: child)
  }
  
  /**
   A child view is vertically stretched with optional left and right padding.
   - Parameter parent: A parent UIView context.
   - Parameter child: A child UIView to layout.
   - Parameter top: A CGFloat value for padding the top side.
   - Parameter bottom: A CGFloat value for padding the bottom side.
   */
  public class func vertically(parent: UIView, child: UIView, top: CGFloat = 0, bottom: CGFloat = 0) {
    prepareForConstraint(parent, child: child)
    parent.addConstraint(NSLayoutConstraint(item: child, attribute: .top, relatedBy: .equal, toItem: parent, attribute: .top, multiplier: 1, constant: top))
    parent.addConstraint(NSLayoutConstraint(item: child, attribute: .bottom, relatedBy: .equal, toItem: parent, attribute: .bottom, multiplier: 1, constant: -bottom))
    updateConstraints(for: child)
  }
  
  /**
   A child view is vertically and horizontally stretched with optional top, left, bottom and right padding.
   - Parameter parent: A parent UIView context.
   - Parameter child: A child UIView to layout.
   - Parameter top: A CGFloat value for padding the top side.
   - Parameter left: A CGFloat value for padding the left side.
   - Parameter bottom: A CGFloat value for padding the bottom side.
   - Parameter right: A CGFloat value for padding the right side.
   */
  public class func edges(parent: UIView, child: UIView, top: CGFloat = 0, left: CGFloat = 0, bottom: CGFloat = 0, right: CGFloat = 0) {
    horizontally(parent: parent, child: child, left: left, right: right)
    vertically(parent: parent, child: child, top: top, bottom: bottom)
  }
  
  /**
   A child view is aligned from the top with optional top padding.
   - Parameter parent: A parent UIView context.
   - Parameter child: A child UIView to layout.
   - Parameter top: A CGFloat value for padding the top side.
   - Returns: The current Layout instance.
   */
  public class func top(parent: UIView, child: UIView, top: CGFloat = 0) {
    prepareForConstraint(parent, child: child)
    parent.addConstraint(NSLayoutConstraint(item: child, attribute: .top, relatedBy: .equal, toItem: parent, attribute: .top, multiplier: 1, constant: top))
    updateConstraints(for: child)
  }
  
  /**
   A child view is aligned from the left with optional left padding.
   - Parameter parent: A parent UIView context.
   - Parameter child: A child UIView to layout.
   - Parameter left: A CGFloat value for padding the left side.
   - Returns: The current Layout instance.
   */
  public class func left(parent: UIView, child: UIView, left: CGFloat = 0) {
    prepareForConstraint(parent, child: child)
    parent.addConstraint(NSLayoutConstraint(item: child, attribute: .left, relatedBy: .equal, toItem: parent, attribute: .left, multiplier: 1, constant: left))
    updateConstraints(for: child)
  }
  
  /**
   A child view is aligned from the bottom with optional bottom padding.
   - Parameter parent: A parent UIView context.
   - Parameter child: A child UIView to layout.
   - Parameter bottom: A CGFloat value for padding the bottom side.
   - Returns: The current Layout instance.
   */
  public class func bottom(parent: UIView, child: UIView, bottom: CGFloat = 0) {
    prepareForConstraint(parent, child: child)
    parent.addConstraint(NSLayoutConstraint(item: child, attribute: .bottom, relatedBy: .equal, toItem: parent, attribute: .bottom, multiplier: 1, constant: -bottom))
    updateConstraints(for: child)
  }
  
  /**
   A child view is aligned from the right with optional right padding.
   - Parameter parent: A parent UIView context.
   - Parameter child: A child UIView to layout.
   - Parameter right: A CGFloat value for padding the right side.
   - Returns: The current Layout instance.
   */
  public class func right(parent: UIView, child: UIView, right: CGFloat = 0) {
    prepareForConstraint(parent, child: child)
    parent.addConstraint(NSLayoutConstraint(item: child, attribute: .right, relatedBy: .equal, toItem: parent, attribute: .right, multiplier: 1, constant: -right))
    updateConstraints(for: child)
  }
  
  /**
   A child view is aligned from the top left with optional top and left padding.
   - Parameter parent: A parent UIView context.
   - Parameter child: A child UIView to layout.
   - Parameter top: A CGFloat value for padding the top side.
   - Parameter left: A CGFloat value for padding the left side.
   - Returns: The current Layout instance.
   */
  public class func topLeft(parent: UIView, child: UIView, top t: CGFloat = 0, left l: CGFloat = 0) {
    top(parent: parent, child: child, top: t)
    left(parent: parent, child: child, left: l)
  }
  
  /**
   A child view is aligned from the top right with optional top and right padding.
   - Parameter parent: A parent UIView context.
   - Parameter child: A child UIView to layout.
   - Parameter top: A CGFloat value for padding the top side.
   - Parameter right: A CGFloat value for padding the right side.
   - Returns: The current Layout instance.
   */
  public class func topRight(parent: UIView, child: UIView, top t: CGFloat = 0, right r: CGFloat = 0) {
    top(parent: parent, child: child, top: t)
    right(parent: parent, child: child, right: r)
  }
  
  /**
   A child view is aligned from the bottom left with optional bottom and left padding.
   - Parameter parent: A parent UIView context.
   - Parameter child: A child UIView to layout.
   - Parameter bottom: A CGFloat value for padding the bottom side.
   - Parameter left: A CGFloat value for padding the left side.
   - Returns: The current Layout instance.
   */
  public class func bottomLeft(parent: UIView, child: UIView, bottom b: CGFloat = 0, left l: CGFloat = 0) {
    bottom(parent: parent, child: child, bottom: b)
    left(parent: parent, child: child, left: l)
  }
  
  /**
   A child view is aligned from the bottom right with optional bottom and right padding.
   - Parameter parent: A parent UIView context.
   - Parameter child: A child UIView to layout.
   - Parameter bottom: A CGFloat value for padding the bottom side.
   - Parameter right: A CGFloat value for padding the right side.
   - Returns: The current Layout instance.
   */
  public class func bottomRight(parent: UIView, child: UIView, bottom b: CGFloat = 0, right r: CGFloat = 0) {
    bottom(parent: parent, child: child, bottom: b)
    right(parent: parent, child: child, right: r)
  }
  
  /**
   A child view is aligned at the center with an optional offsetX and offsetY value.
   - Parameter parent: A parent UIView context.
   - Parameter child: A child UIView to layout.
   - Parameter offsetX: A CGFloat value for the offset along the x axis.
   - Parameter offsetX: A CGFloat value for the offset along the y axis.
   - Returns: The current Layout instance.
   */
  public class func center(parent: UIView, child: UIView, offsetX: CGFloat = 0, offsetY: CGFloat = 0) {
    centerHorizontally(parent: parent, child: child, offset: offsetX)
    centerVertically(parent: parent, child: child, offset: offsetY)
  }
  
  /**
   A child view is aligned at the center horizontally with an optional offset value.
   - Parameter parent: A parent UIView context.
   - Parameter child: A child UIView to layout.
   - Parameter offset: A CGFloat value for the offset along the y axis.
   - Returns: The current Layout instance.
   */
  public class func centerHorizontally(parent: UIView, child: UIView, offset: CGFloat = 0) {
    prepareForConstraint(parent, child: child)
    parent.addConstraint(NSLayoutConstraint(item: child, attribute: .centerX, relatedBy: .equal, toItem: parent, attribute: .centerX, multiplier: 1, constant: offset))
    updateConstraints(for: child)
  }
  
  /**
   A child view is aligned at the center vertically with an optional offset value.
   - Parameter parent: A parent UIView context.
   - Parameter child: A child UIView to layout.
   - Parameter offset: A CGFloat value for the offset along the y axis.
   - Returns: The current Layout instance.
   */
  public class func centerVertically(parent: UIView, child: UIView, offset: CGFloat = 0) {
    prepareForConstraint(parent, child: child)
    parent.addConstraint(NSLayoutConstraint(item: child, attribute: .centerY, relatedBy: .equal, toItem: parent, attribute: .centerY, multiplier: 1, constant: offset))
    updateConstraints(for: child)
  }
  
  /**
   Creats an Array with a NSLayoutConstraint value.
   - Parameter format: The VFL format string.
   - Parameter options: Additional NSLayoutFormatOptions.
   - Parameter metrics: An optional Dictionary<String, Any> of metric key / value pairs.
   - Parameter views: A Dictionary<String, Any> of view key / value pairs.
   - Returns: The Array<NSLayoutConstraint> instance.
   */
  public class func constraint(format: String, options: NSLayoutFormatOptions, metrics: [String: Any]?, views: [String: Any]) -> [NSLayoutConstraint] {
    for (_, a) in views {
      if let v = a as? UIView {
        v.translatesAutoresizingMaskIntoConstraints = false
      }
    }
    return NSLayoutConstraint.constraints(
      withVisualFormat: format,
      options: options,
      metrics: metrics,
      views: views
    )
  }
  
  /**
   Prepares the relationship between the parent view context and child view
   to layout. If the child is not already added to the view hierarchy as the
   parent's child, then it is added.
   - Parameter parent: A parent UIView context.
   - Parameter child: A child UIView to layout.
   */
  private class func prepareForConstraint(_ parent: UIView, child: UIView) {
    if parent != child.superview {
      child.removeFromSuperview()
      parent.addSubview(child)
    }
    child.translatesAutoresizingMaskIntoConstraints = false
  }
  
  /**
   Prepares the relationship between the parent view context and an Array of
   child UIViews.
   - Parameter parent: A parent UIView context.
   - Parameter children: An Array of UIViews.
   */
  private class func prepareForConstraint(_ parent: UIView, children: [UIView]) {
    for v in children {
      prepareForConstraint(parent, child: v)
    }
  }
}

/// A memory reference to the LayoutKey instance for UIView extensions.
fileprivate var LayoutKey: UInt8 = 0

/// Layout extension for UIView.
extension UIView {
  /// Layout reference.
  public private(set) var layout: Layout {
    get {
      return AssociatedObject.get(base: self, key: &LayoutKey) {
        return Layout(parent: self)
      }
    }
    set(value) {
      AssociatedObject.set(base: self, key: &LayoutKey, value: value)
    }
  }
  
  /**
   Used to chain layout constraints on a child context.
   - Parameter child: A child UIView to layout.
   - Returns: The current Layout instance.
   */
  public func layout(_ child: UIView) -> Layout {
    return Layout(parent: self, child: child)
  }
}
