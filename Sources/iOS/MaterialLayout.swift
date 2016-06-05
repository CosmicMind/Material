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

public struct MaterialLayout {
	/// Width
	public static func width(parent: UIView, child: UIView, width: CGFloat = 0) {
        prepareForConstraint([child])
        parent.addConstraint(NSLayoutConstraint(item: child, attribute: .Width, relatedBy: .Equal, toItem: nil, attribute: .Width, multiplier: 1.0, constant: width))
	}
	
	/// Height
	public static func height(parent: UIView, child: UIView, height: CGFloat = 0) {
        prepareForConstraint([child])
		parent.addConstraint(NSLayoutConstraint(item: child, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .Height, multiplier: 1.0, constant: height))
	}
	
	/// Size
	public static func size(parent: UIView, child: UIView, width: CGFloat = 0, height: CGFloat = 0) {
		MaterialLayout.width(parent, child: child, width: width)
		MaterialLayout.height(parent, child: child, height: height)
	}
	
	/// AlignToParentHorizontally
	public static func alignToParentHorizontally(parent: UIView, children: Array<UIView>, left: CGFloat = 0, right: CGFloat = 0, spacing: CGFloat = 0) {
        prepareForConstraint(children)
        if 0 < children.count {
            parent.addConstraint(NSLayoutConstraint(item: children[0], attribute: .Left, relatedBy: .Equal, toItem: parent, attribute: .Left, multiplier: 1.0, constant: left))
            if 1 < children.count {
                for i in 1 ... (children.count - 1) {
                 parent.addConstraint(NSLayoutConstraint(item: children[i], attribute: .Left, relatedBy: .Equal, toItem: children[i-1], attribute: .Right, multiplier: 1.0, constant: spacing))
                 parent.addConstraint(NSLayoutConstraint(item: children[i], attribute: .Width, relatedBy: .Equal, toItem: children[0], attribute: .Width, multiplier: 1.0, constant: 0.0))
                }
            }
            parent.addConstraint(NSLayoutConstraint(item: children[children.count-1], attribute: .Right, relatedBy: .Equal, toItem: parent, attribute: .Right, multiplier: 1.0, constant: -right))
		}
	}
	
	/// AlignToParentVertically
	public static func alignToParentVertically(parent: UIView, children: Array<UIView>, top: CGFloat = 0, bottom: CGFloat = 0, spacing: CGFloat = 0) {
        prepareForConstraint(children)
        if 0 < children.count {
            parent.addConstraint(NSLayoutConstraint(item: children[0], attribute: .Top, relatedBy: .Equal, toItem: parent, attribute: .Top, multiplier: 1.0, constant: top))
            if 1 < children.count {
                for i in 1 ... (children.count - 1) {
                    parent.addConstraint(NSLayoutConstraint(item: children[i], attribute: .Top, relatedBy: .Equal, toItem: children[i-1], attribute: .Bottom, multiplier: 1.0, constant: spacing))
                    parent.addConstraint(NSLayoutConstraint(item: children[i], attribute: .Height, relatedBy: .Equal, toItem: children[0], attribute: .Height, multiplier: 1.0, constant: 0.0))
                }
            }
            parent.addConstraint(NSLayoutConstraint(item: children[children.count-1], attribute: .Bottom, relatedBy: .Equal, toItem: parent, attribute: .Bottom, multiplier: 1.0, constant: -bottom))
        }
	}
	
	/// AlignToParentHorizontally
	public static func alignToParentHorizontally(parent: UIView, child: UIView, left: CGFloat = 0, right: CGFloat = 0) {
        prepareForConstraint([child])
        parent.addConstraint(NSLayoutConstraint(item: child, attribute: .Left, relatedBy: .Equal, toItem: parent, attribute: .Left, multiplier: 1.0, constant: left))
        parent.addConstraint(NSLayoutConstraint(item: child, attribute: .Right, relatedBy: .Equal, toItem: parent, attribute: .Right, multiplier: 1.0, constant: -right))
	}
	
	/// AlignToParentVertically
	public static func alignToParentVertically(parent: UIView, child: UIView, top: CGFloat = 0, bottom: CGFloat = 0) {
        prepareForConstraint([child])
        parent.addConstraint(NSLayoutConstraint(item: child, attribute: .Top, relatedBy: .Equal, toItem: parent, attribute: .Top, multiplier: 1.0, constant: top))
        parent.addConstraint(NSLayoutConstraint(item: child, attribute: .Bottom, relatedBy: .Equal, toItem: parent, attribute: .Bottom, multiplier: 1.0, constant: -bottom))
	}
	
	/// AlignToParent
	public static func alignToParent(parent: UIView, child: UIView, top: CGFloat = 0, left: CGFloat = 0, bottom: CGFloat = 0, right: CGFloat = 0) {
		alignToParentHorizontally(parent, child: child, left: left, right: right)
		alignToParentVertically(parent, child: child, top: top, bottom: bottom)
	}
	
	/// AlignFromTopLeft
	public static func alignFromTopLeft(parent: UIView, child: UIView, top: CGFloat = 0, left: CGFloat = 0) {
		alignFromTop(parent, child: child, top: top)
		alignFromLeft(parent, child: child, left: left)
	}
	
	/// AlignFromTopRight
	public static func alignFromTopRight(parent: UIView, child: UIView, top: CGFloat = 0, right: CGFloat = 0) {
		alignFromTop(parent, child: child, top: top)
		alignFromRight(parent, child: child, right: right)
	}
	
	/// AlignFromBottomLeft
	public static func alignFromBottomLeft(parent: UIView, child: UIView, bottom: CGFloat = 0, left: CGFloat = 0) {
		alignFromBottom(parent, child: child, bottom: bottom)
		alignFromLeft(parent, child: child, left: left)
	}
	
	/// AlignFromBottomRight
	public static func alignFromBottomRight(parent: UIView, child: UIView, bottom: CGFloat = 0, right: CGFloat = 0) {
		alignFromBottom(parent, child: child, bottom: bottom)
		alignFromRight(parent, child: child, right: right)
	}
	
	/// AlignFromTop
	public static func alignFromTop(parent: UIView, child: UIView, top: CGFloat = 0) {
        prepareForConstraint([child])
        parent.addConstraint(NSLayoutConstraint(item: child, attribute: .Top, relatedBy: .Equal, toItem: parent, attribute: .Top, multiplier: 1.0, constant: top))
	}
	
	/// AlignFromLeft
	public static func alignFromLeft(parent: UIView, child: UIView, left: CGFloat = 0) {
        prepareForConstraint([child])
		parent.addConstraint(NSLayoutConstraint(item: child, attribute: .Left, relatedBy: .Equal, toItem: parent, attribute: .Left, multiplier: 1.0, constant: left))
	}
	
	/// AlignFromBottom
	public static func alignFromBottom(parent: UIView, child: UIView, bottom: CGFloat = 0) {
        prepareForConstraint([child])
		parent.addConstraint(NSLayoutConstraint(item: child, attribute: .Bottom, relatedBy: .Equal, toItem: parent, attribute: .Bottom, multiplier: 1.0, constant: -bottom))
	}
	
	/// AlignFromRight
	public static func alignFromRight(parent: UIView, child: UIView, right: CGFloat = 0) {
        prepareForConstraint([child])
		parent.addConstraint(NSLayoutConstraint(item: child, attribute: .Right, relatedBy: .Equal, toItem: parent, attribute: .Right, multiplier: 1.0, constant: -right))
	}
	
    /// CenterHorizontally
    public static func centerHorizontally(parent: UIView, child: UIView, constant: CGFloat = 0) {
        prepareForConstraint([child])
        parent.addConstraint(NSLayoutConstraint(item: child, attribute: .CenterX, relatedBy: .Equal, toItem: parent, attribute: .CenterX, multiplier: 1.0, constant: constant))
    }
	
    /// CenterVertically
    public static func centerVertically(parent: UIView, child: UIView, constant: CGFloat = 0) {
        prepareForConstraint([child])
        parent.addConstraint(NSLayoutConstraint(item: child, attribute: .CenterY, relatedBy: .Equal, toItem: parent, attribute: .CenterY, multiplier: 1.0, constant: constant))
    }
    
    /// Center
    public static func center(parent: UIView, child: UIView, constantX: CGFloat = 0, constantY: CGFloat = 0) {
        centerHorizontally(parent, child: child, constant: constantX)
        centerVertically(parent, child: child, constant: constantY)
    }
    
    /// prepareForConstraint
    private static func prepareForConstraint(views: [UIView]) {
        for v in views {
            v.translatesAutoresizingMaskIntoConstraints = false
        }
    }
    
    /// Constraint
	public static func constraint(format: String, options: NSLayoutFormatOptions, metrics: Dictionary<String, AnyObject>?, views: Dictionary<String, AnyObject>) -> Array<NSLayoutConstraint> {
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
}