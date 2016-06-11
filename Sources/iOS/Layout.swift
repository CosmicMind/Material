/*
* Copyright (C) 2015 - 2016, Daniel Dahan and CosmicMind, Inc. <http://cosmicmind.io>.
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
*	*	Neither the name of Material nor the names of its
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

public class Layout {
	/// Reference to Align.
	
	/// UIView context.
	internal weak var context: UIView?
    
    /// Child UIView context.
    internal weak var childContext: UIView?
	
	init(context: UIView?) {
		self.context = context
	}

    init(context: UIView?, childContext: UIView?) {
        self.context = context
        self.childContext = childContext
    }

	/// Width
    /// - returns: layout instance
	public func width(child: UIView, width: CGFloat) -> Layout {
		if let v: UIView = context {
			Layout.width(v, child: child, width: width)
        } else {
            debugPrint("Parent context not available.")
        }
        
        return self
	}
    
    /// Width (Assuming a child context)
    /// - returns: current layout instance
    public func width(width: CGFloat) -> Layout {
        if let c: UIView = childContext {
            self.width(c, width: width)
        } else {
            debugPrint("Child view context not available.")
        }
        
        return self
    }
	
	/// Height
    /// - returns: current layout instance
	public func height(child: UIView, height: CGFloat) -> Layout {
		if let v: UIView = context {
			Layout.height(v, child: child, height: height)
        } else {
            debugPrint("Parent context not available.")
        }
        
        return self
	}
	
    /// Height (Assuming a child context)
    /// - returns: current layout instance
    public func height(height: CGFloat) -> Layout {
        if let c: UIView = childContext {
            self.height(c, height: height)
        } else {
            debugPrint("Child view context not available.")
        }
        
        return self
    }
    
	/// Size
    /// - returns: current layout instance
	public func size(child: UIView, width: CGFloat, height: CGFloat) -> Layout {
		if let v: UIView = context {
			Layout.size(v, child: child, width: width, height: height)
        } else {
            debugPrint("Parent context not available.")
        }
        
        return self
	}
    
    /// Size (Assuming a child context)
    /// - returns: current layout instance
    public func size(width width: CGFloat, height: CGFloat) -> Layout {
        if let c: UIView = childContext {
            size(c, width: width, height: height)
        } else {
            debugPrint("Child view context not available.")
        }
        
        return self
    }
	
	/// Array of UIViews horizontally aligned.
    /// - returns: current layout instance
	public func horizontally(children: Array<UIView>, left: CGFloat = 0, right: CGFloat = 0, spacing: CGFloat = 0) -> Layout {
		if let v: UIView = context {
			Layout.alignToParentHorizontally(v, children: children, left: left, right: right, spacing: spacing)
        } else {
            debugPrint("Parent context not available.")
        }
        
        return self
	}
	
	/// Array of UIViews vertically aligned.
    /// - returns: current layout instance
	public func vertically(children: Array<UIView>, top: CGFloat = 0, bottom: CGFloat = 0, spacing: CGFloat = 0) -> Layout {
		if let v: UIView = context {
			Layout.alignToParentVertically(v, children: children, top: top, bottom: bottom, spacing: spacing)
        } else {
            debugPrint("Parent context not available.")
        }
        
        return self
	}
	
	/// Horizontally aligned.
    /// - returns: current layout instance
	public func horizontally(child: UIView, left: CGFloat = 0, right: CGFloat = 0) -> Layout {
		if let v: UIView = context {
			Layout.alignToParentHorizontally(v, child: child, left: left, right: right)
        } else {
            debugPrint("Parent context not available.")
        }
        
        return self
	}
    
    /// Horizontally aligned (Assuming a child context)
    /// - returns: current layout instance
    public func horizontally(left left: CGFloat = 0, right: CGFloat = 0) -> Layout {
        if let c: UIView = childContext {
            horizontally(c, left: left, right: right)
        } else {
            debugPrint("Child view context not available.")
        }
        
        return self
    }
	
	/// Vertically aligned.
    /// - returns: current layout instance
	public func vertically(child: UIView, top: CGFloat = 0, bottom: CGFloat = 0) -> Layout {
		if let v: UIView = context {
			Layout.alignToParentVertically(v, child: child, top: top, bottom: bottom)
        } else {
            debugPrint("Parent context not available.")
        }
        
        return self
	}
    
    /// Vertically aligned (Assuming a child context)
    /// - returns: current layout instance
    public func vertically(top top: CGFloat = 0, bottom: CGFloat = 0) -> Layout {
        if let c: UIView = childContext {
            vertically(c, top: top, bottom: bottom)
        } else {
            debugPrint("Child view context not available.")
        }
        
        return self
    }
	
	/// Center
    /// - returns: current layout instance
	public func center(child: UIView, constantX: CGFloat = 0, constantY: CGFloat = 0) -> Layout {
		if let v: UIView = context {
			Layout.center(v, child: child, constantX: constantX, constantY: constantY)
        } else {
            debugPrint("Parent context not available.")
        }
        
        return self
	}
    
    /// Center (Assuming a child context)
    /// - returns: current layout instance
    public func center(constantX constantX: CGFloat = 0, constantY: CGFloat = 0) -> Layout {
        if let c: UIView = childContext {
            center(c, constantX: constantX, constantY: constantY)
        } else {
            debugPrint("Child view context not available.")
        }
        
        return self
    }
	
	/// Center Horizontally
    /// - returns: current layout instance
	public func centerHorizontally(child: UIView, constant: CGFloat = 0) -> Layout {
		if let v: UIView = context {
			Layout.centerHorizontally(v, child: child, constant: constant)
        } else {
            debugPrint("Parent context not available.")
        }
        
        return self
	}
    
    /// Center Horizontally (Assuming a child context)
    /// - returns: current layout instance
    public func centerHorizontally(constant: CGFloat = 0) -> Layout {
        if let c: UIView = childContext {
            centerHorizontally(c, constant: constant)
        } else {
            debugPrint("Child view context not available.")
        }
        
        return self
    }
	
	/// Center Vertically
    /// - returns: current layout instance
	public func centerVertically(child: UIView, constant: CGFloat = 0) -> Layout {
		if let v: UIView = context {
			Layout.centerVertically(v, child: child, constant: constant)
        } else {
            debugPrint("Parent context not available.")
        }
        
        return self
	}
    
    /// Center Vertically (Assuming a child context)
    /// - returns: current layout instance
    public func centerVertically(constant: CGFloat = 0) -> Layout {
        if let c: UIView = childContext {
            centerVertically(c, constant: constant)
        }  else {
            debugPrint("Child view context not available.")
        }
        
        return self
    }
    
    /// Align Edges
    /// - returns: current layout instance
    public func edges(child: UIView, top: CGFloat = 0, left: CGFloat = 0, bottom: CGFloat = 0, right: CGFloat = 0) -> Layout {
        if let v: UIView = context {
            Layout.alignToParent(v, child: child, top: top, left: left, bottom: bottom, right: right)
        } else {
            debugPrint("Parent context not available.")
        }
        
        return self
    }
    
    /// Align Edges (Assuming a child context)
    /// - returns: current layout instance
    public func edges(top top: CGFloat = 0, left: CGFloat = 0, bottom: CGFloat = 0, right: CGFloat = 0) -> Layout {
        if let c: UIView = childContext {
            edges(c, top: top, left: left, bottom: bottom, right: right)
        } else {
            debugPrint("Child view context not available.")
        }
        
        return self
    }
    
    /// Align to TopLeft
    /// - returns: current layout instance
    public func topLeft(child: UIView, top: CGFloat = 0, left: CGFloat = 0) -> Layout {
        if let v: UIView = context {
            Layout.alignFromTopLeft(v, child: child, top: top, left: left)
        } else {
            debugPrint("Parent context not available.")
        }
        
        return self
    }
    
    /// Align to TopLeft (Assuming a child context)
    /// - returns: current layout instance
    public func topLeft(top top: CGFloat = 0, left: CGFloat = 0) -> Layout {
        if let c: UIView = childContext {
            topLeft(c, top: top, left: left)
        } else {
            debugPrint("Child view context not available.")
        }
        
        return self
    }
    
    /// Align to TopRight
    /// - returns: current layout instance
    public func topRight(child: UIView, top: CGFloat = 0, right: CGFloat = 0) -> Layout {
        if let v: UIView = context {
            Layout.alignFromTopRight(v, child: child, top: top, right: right)
        } else {
            debugPrint("Parent context not available.")
        }
        
        return self
    }
    
    /// Align to TopRight (Assuming a child context)
    /// - returns: current layout instance
    public func topRight(top top: CGFloat = 0, right: CGFloat = 0) -> Layout {
        if let c: UIView = childContext {
            topRight(c, top: top, right: right)
        } else {
            debugPrint("Child view context not available.")
        }
        
        return self
    }
    
    /// Align to BottomLeft
    /// - returns: current layout instance
    public func bottomLeft(child: UIView, bottom: CGFloat = 0, left: CGFloat = 0) -> Layout {
        if let v: UIView = context {
            Layout.alignFromBottomLeft(v, child: child, bottom: bottom, left: left)
        } else {
            debugPrint("Parent context not available.")
        }
        
        return self
    }
    
    /// Align to BottomLeft (Assuming a child context)
    /// - returns: current layout instance
    public func bottomLeft(bottom bottom: CGFloat = 0, left: CGFloat = 0) -> Layout {
        if let c: UIView = childContext {
            bottomLeft(c, bottom: bottom, left: left)
        } else {
            debugPrint("Child view context not available.")
        }
        
        return self
    }
    
    /// Align to BottomRight
    /// - returns: current layout instance
    public func bottomRight(child: UIView, bottom: CGFloat = 0, right: CGFloat = 0) -> Layout {
        if let v: UIView = context {
            Layout.alignFromBottomRight(v, child: child, bottom: bottom, right: right)
        } else {
            debugPrint("Parent context not available.")
        }
        
        return self
    }
    
    /// Align to BottomRight (Assuming a child context)
    /// - returns: current layout instance
    public func bottomRight(bottom bottom: CGFloat = 0, right: CGFloat = 0) -> Layout {
        if let c: UIView = childContext {
            bottomRight(c, bottom: bottom, right: right)
        } else {
            debugPrint("Child view context not available.")
        }
        
        return self
    }
    
    /// Align to Top
    /// - returns: current layout instance
    public func top(child: UIView, top: CGFloat = 0) -> Layout {
        if let v: UIView = context {
            Layout.alignFromTop(v, child: child, top: top)
        } else {
            debugPrint("Parent context not available.")
        }
        
        return self
    }
    
    /// Align to Top (Assuming a child context)
    /// - returns: current layout instance
    public func top(top: CGFloat = 0) -> Layout {
        if let c: UIView = childContext {
            self.top(c, top: top)
        }  else {
            debugPrint("Child view context not available.")
        }
        
        return self
    }
    
    /// Align to Left
    /// - returns: current layout instance
    public func left(child: UIView, left: CGFloat = 0) -> Layout {
        if let v: UIView = context {
            Layout.alignFromLeft(v, child: child, left: left)
        } else {
            debugPrint("Parent context not available.")
        }
        
        return self
    }
    
    /// Align to Left (Assuming a child context)
    /// - returns: current layout instance
    public func left(left: CGFloat = 0) -> Layout {
        if let c: UIView = childContext {
            self.left(c, left: left)
        } else {
            debugPrint("Child view context not available.")
        }
        
        return self
    }
    
    /// Align to Bottom
    /// - returns: current layout instance
    public func bottom(child: UIView, bottom: CGFloat = 0) -> Layout {
        if let v: UIView = context {
            Layout.alignFromBottom(v, child: child, bottom: bottom)
        } else {
            debugPrint("Parent context not available.")
        }
        
        return self
    }
    
    /// Align to Bottom (Assuming a child context)
    /// - returns: current layout instance
    public func bottom(bottom: CGFloat = 0) -> Layout {
        if let c: UIView = childContext {
            self.bottom(c, bottom: bottom)
        } else {
            debugPrint("Child view context not available.")
        }
        
        return self
    }
    
    
    /// Align to Right
    /// - returns: current layout instance
    public func right(child: UIView, right: CGFloat = 0) -> Layout {
        if let v: UIView = context {
            Layout.alignFromRight(v, child: child, right: right)
        } else {
            debugPrint("Parent context not available.")
        }
        
        return self
    }
    
    /// Align to Right (Assuming a child context)
    /// - returns: current layout instance
    public func right(right: CGFloat = 0) -> Layout {
        if let c: UIView = childContext {
            self.right(c, right: right)
        } else {
            debugPrint("Child view context not available.")
        }
        
        return self
    }
}

/// Layout
public extension Layout {
	/// Width
	public class func width(parent: UIView, child: UIView, width: CGFloat = 0) {
		prepareForConstraint(parent, child: child)
		parent.addConstraint(NSLayoutConstraint(item: child, attribute: .Width, relatedBy: .Equal, toItem: nil, attribute: .Width, multiplier: 1, constant: width))
	}
	
	/// Height
	public class func height(parent: UIView, child: UIView, height: CGFloat = 0) {
		prepareForConstraint(parent, child: child)
		parent.addConstraint(NSLayoutConstraint(item: child, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .Height, multiplier: 1, constant: height))
	}
	
	/// Size
	public class func size(parent: UIView, child: UIView, width: CGFloat = 0, height: CGFloat = 0) {
		Layout.width(parent, child: child, width: width)
		Layout.height(parent, child: child, height: height)
	}
	
	/// AlignToParentHorizontally
	public class func alignToParentHorizontally(parent: UIView, children: Array<UIView>, left: CGFloat = 0, right: CGFloat = 0, spacing: CGFloat = 0) {
		prepareForConstraint(parent, children: children)
		if 0 < children.count {
			parent.addConstraint(NSLayoutConstraint(item: children[0], attribute: .Left, relatedBy: .Equal, toItem: parent, attribute: .Left, multiplier: 1, constant: left))
			for i in 1..<children.count {
				parent.addConstraint(NSLayoutConstraint(item: children[i], attribute: .Left, relatedBy: .Equal, toItem: children[i - 1], attribute: .Right, multiplier: 1, constant: spacing))
				parent.addConstraint(NSLayoutConstraint(item: children[i], attribute: .Width, relatedBy: .Equal, toItem: children[0], attribute: .Width, multiplier: 1, constant: 0))
			}
			parent.addConstraint(NSLayoutConstraint(item: children[children.count - 1], attribute: .Right, relatedBy: .Equal, toItem: parent, attribute: .Right, multiplier: 1, constant: -right))
		}
	}
	
	/// AlignToParentVertically
	public class func alignToParentVertically(parent: UIView, children: Array<UIView>, top: CGFloat = 0, bottom: CGFloat = 0, spacing: CGFloat = 0) {
		prepareForConstraint(parent, children: children)
		if 0 < children.count {
			parent.addConstraint(NSLayoutConstraint(item: children[0], attribute: .Top, relatedBy: .Equal, toItem: parent, attribute: .Top, multiplier: 1, constant: top))
			for i in 1..<children.count {
				parent.addConstraint(NSLayoutConstraint(item: children[i], attribute: .Top, relatedBy: .Equal, toItem: children[i - 1], attribute: .Bottom, multiplier: 1, constant: spacing))
				parent.addConstraint(NSLayoutConstraint(item: children[i], attribute: .Height, relatedBy: .Equal, toItem: children[0], attribute: .Height, multiplier: 1, constant: 0))
			}
			parent.addConstraint(NSLayoutConstraint(item: children[children.count - 1], attribute: .Bottom, relatedBy: .Equal, toItem: parent, attribute: .Bottom, multiplier: 1, constant: -bottom))
		}
	}
	
	/// AlignToParentHorizontally
	public class func alignToParentHorizontally(parent: UIView, child: UIView, left: CGFloat = 0, right: CGFloat = 0) {
		prepareForConstraint(parent, child: child)
		parent.addConstraint(NSLayoutConstraint(item: child, attribute: .Left, relatedBy: .Equal, toItem: parent, attribute: .Left, multiplier: 1, constant: left))
		parent.addConstraint(NSLayoutConstraint(item: child, attribute: .Right, relatedBy: .Equal, toItem: parent, attribute: .Right, multiplier: 1, constant: -right))
	}
	
	/// AlignToParentVertically
	public class func alignToParentVertically(parent: UIView, child: UIView, top: CGFloat = 0, bottom: CGFloat = 0) {
		prepareForConstraint(parent, child: child)
		parent.addConstraint(NSLayoutConstraint(item: child, attribute: .Top, relatedBy: .Equal, toItem: parent, attribute: .Top, multiplier: 1, constant: top))
		parent.addConstraint(NSLayoutConstraint(item: child, attribute: .Bottom, relatedBy: .Equal, toItem: parent, attribute: .Bottom, multiplier: 1, constant: -bottom))
	}
	
	/// AlignToParent
	public class func alignToParent(parent: UIView, child: UIView, top: CGFloat = 0, left: CGFloat = 0, bottom: CGFloat = 0, right: CGFloat = 0) {
		alignToParentHorizontally(parent, child: child, left: left, right: right)
		alignToParentVertically(parent, child: child, top: top, bottom: bottom)
	}
	
	/// AlignFromTopLeft
	public class func alignFromTopLeft(parent: UIView, child: UIView, top: CGFloat = 0, left: CGFloat = 0) {
		alignFromTop(parent, child: child, top: top)
		alignFromLeft(parent, child: child, left: left)
	}
	
	/// AlignFromTopRight
	public class func alignFromTopRight(parent: UIView, child: UIView, top: CGFloat = 0, right: CGFloat = 0) {
		alignFromTop(parent, child: child, top: top)
		alignFromRight(parent, child: child, right: right)
	}
	
	/// AlignFromBottomLeft
	public class func alignFromBottomLeft(parent: UIView, child: UIView, bottom: CGFloat = 0, left: CGFloat = 0) {
		alignFromBottom(parent, child: child, bottom: bottom)
		alignFromLeft(parent, child: child, left: left)
	}
	
	/// AlignFromBottomRight
	public class func alignFromBottomRight(parent: UIView, child: UIView, bottom: CGFloat = 0, right: CGFloat = 0) {
		alignFromBottom(parent, child: child, bottom: bottom)
		alignFromRight(parent, child: child, right: right)
	}
	
	/// AlignFromTop
	public class func alignFromTop(parent: UIView, child: UIView, top: CGFloat = 0) {
		prepareForConstraint(parent, child: child)
		parent.addConstraint(NSLayoutConstraint(item: child, attribute: .Top, relatedBy: .Equal, toItem: parent, attribute: .Top, multiplier: 1, constant: top))
	}
	
	/// AlignFromLeft
	public class func alignFromLeft(parent: UIView, child: UIView, left: CGFloat = 0) {
		prepareForConstraint(parent, child: child)
		parent.addConstraint(NSLayoutConstraint(item: child, attribute: .Left, relatedBy: .Equal, toItem: parent, attribute: .Left, multiplier: 1, constant: left))
	}
	
	/// AlignFromBottom
	public class func alignFromBottom(parent: UIView, child: UIView, bottom: CGFloat = 0) {
		prepareForConstraint(parent, child: child)
		parent.addConstraint(NSLayoutConstraint(item: child, attribute: .Bottom, relatedBy: .Equal, toItem: parent, attribute: .Bottom, multiplier: 1, constant: -bottom))
	}
	
	/// AlignFromRight
	public class func alignFromRight(parent: UIView, child: UIView, right: CGFloat = 0) {
		prepareForConstraint(parent, child: child)
		parent.addConstraint(NSLayoutConstraint(item: child, attribute: .Right, relatedBy: .Equal, toItem: parent, attribute: .Right, multiplier: 1, constant: -right))
	}
	
	/// Center
	public class func center(parent: UIView, child: UIView, constantX: CGFloat = 0, constantY: CGFloat = 0) {
		centerHorizontally(parent, child: child, constant: constantX)
		centerVertically(parent, child: child, constant: constantY)
	}
	
	/// CenterHorizontally
	public class func centerHorizontally(parent: UIView, child: UIView, constant: CGFloat = 0) {
		prepareForConstraint(parent, child: child)
		parent.addConstraint(NSLayoutConstraint(item: child, attribute: .CenterX, relatedBy: .Equal, toItem: parent, attribute: .CenterX, multiplier: 1, constant: constant))
	}
	
	/// CenterVertically
	public class func centerVertically(parent: UIView, child: UIView, constant: CGFloat = 0) {
		prepareForConstraint(parent, child: child)
		parent.addConstraint(NSLayoutConstraint(item: child, attribute: .CenterY, relatedBy: .Equal, toItem: parent, attribute: .CenterY, multiplier: 1, constant: constant))
	}
	
	/// Constraint
	public class func constraint(format: String, options: NSLayoutFormatOptions, metrics: Dictionary<String, AnyObject>?, views: Dictionary<String, AnyObject>) -> Array<NSLayoutConstraint> {
		for (_, a) in views {
			if let v: UIView = a as? UIView {
				v.translatesAutoresizingMaskIntoConstraints = false
			}
		}
		return NSLayoutConstraint.constraintsWithVisualFormat(
			format,
			options: options,
			metrics: metrics,
			views: views
		)
	}
	
	/// prepareForConstraint
	private class func prepareForConstraint(parent: UIView, child: UIView) {
		if parent != child.superview {
			parent.addSubview(child)
		}
		child.translatesAutoresizingMaskIntoConstraints = false
	}
	
	/// prepareForConstraint
	private class func prepareForConstraint(parent: UIView, children: [UIView]) {
		for v in children {
			prepareForConstraint(parent, child: v)
		}
	}
}

/// A memory reference to the LayoutKey instance for UIView extensions.
private var LayoutKey: UInt8 = 0

/// Layout extension for UIView.
public extension UIView {
	/// Layout reference.
	public private(set) var layout: Layout {
		get {
			return MaterialAssociatedObject(self, key: &LayoutKey) {
				return Layout(context: self)
			}
		}
		set(value) {
			MaterialAssociateObject(self, key: &LayoutKey, value: value)
		}
	}
    
    /// Layout reference with a child context.
    public func layout(child: UIView) -> Layout {
        return Layout(context: self, childContext: child)
    }
    
}
