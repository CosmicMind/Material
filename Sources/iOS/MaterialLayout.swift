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
	public static func width(parent: UIView, child: UIView, width: CGFloat = 0, options: NSLayoutFormatOptions = []) {
		let metrics: Dictionary<String, AnyObject> = ["width" : width]
		let views: Dictionary<String, AnyObject> = ["child" : child]
		parent.addConstraints(constraint("H:[child(width)]", options: options, metrics: metrics, views: views))
	}
	
	/// Height
	public static func height(parent: UIView, child: UIView, height: CGFloat = 0, options: NSLayoutFormatOptions = []) {
		let metrics: Dictionary<String, AnyObject> = ["height" : height]
		let views: Dictionary<String, AnyObject> = ["child" : child]
		parent.addConstraints(constraint("V:[child(height)]", options: options, metrics: metrics, views: views))
	}
	
	/// Size
	public static func size(parent: UIView, child: UIView, width: CGFloat = 0, height: CGFloat = 0, options: NSLayoutFormatOptions = []) {
		MaterialLayout.width(parent, child: child, width: width)
		MaterialLayout.height(parent, child: child, height: height)
	}
	
	/// AlignToParentHorizontally
	public static func alignToParentHorizontally(parent: UIView, children: Array<UIView>, left: CGFloat = 0, right: CGFloat = 0, spacing: CGFloat = 0, options: NSLayoutFormatOptions = []) {
		if 0 < children.count {
			var format: String = "H:|-(left)-"
			var i: Int = 1
			var views: Dictionary<String, UIView> = Dictionary<String, UIView>()
			for v in children {
				let k: String = "view\(i)"
				i += 1
				views[k] = v
				format += i > children.count ? "[\(k)(==view1)]-(right)-|" : "[\(k)(==view1)]-(spacing)-"
			}
			parent.addConstraints(constraint(format, options: options, metrics: ["left" : left, "right": right, "spacing": spacing], views: views))
		}
	}
	
	/// AlignToParentVertically
	public static func alignToParentVertically(parent: UIView, children: Array<UIView>, top: CGFloat = 0, bottom: CGFloat = 0, spacing: CGFloat = 0, options: NSLayoutFormatOptions = []) {
		if 0 < children.count {
			var format: String = "V:|-(top)-"
			var i: Int = 1
			var views: Dictionary<String, UIView> = Dictionary<String, UIView>()
			for v in children {
				let k: String = "view\(i)"
				i += 1
				views[k] = v
				format += i > children.count ? "[\(k)(==view1)]-(bottom)-|" : "[\(k)(==view1)]-(spacing)-"
			}
			parent.addConstraints(constraint(format, options: options, metrics: ["top" : top, "bottom": bottom, "spacing": spacing], views: views))
		}
	}
	
	/// AlignToParentHorizontally
	public static func alignToParentHorizontally(parent: UIView, child: UIView, left: CGFloat = 0, right: CGFloat = 0, options: NSLayoutFormatOptions = []) {
		parent.addConstraints(constraint("H:|-(left)-[child]-(right)-|", options: options, metrics: ["left": left, "right": right], views: ["child" : child]))
	}
	
	/// AlignToParentVertically
	public static func alignToParentVertically(parent: UIView, child: UIView, top: CGFloat = 0, bottom: CGFloat = 0, options: NSLayoutFormatOptions = []) {
		parent.addConstraints(constraint("V:|-(top)-[child]-(bottom)-|", options: options, metrics: ["bottom": bottom, "top": top], views: ["child" : child]))
	}
	
	/// AlignToParent
	public static func alignToParent(parent: UIView, child: UIView, top: CGFloat = 0, left: CGFloat = 0, bottom: CGFloat = 0, right: CGFloat = 0, options: NSLayoutFormatOptions = []) {
		alignToParentHorizontally(parent, child: child, left: left, right: right)
		alignToParentVertically(parent, child: child, top: top, bottom: bottom)
	}
	
	/// AlignFromTopLeft
	public static func alignFromTopLeft(parent: UIView, child: UIView, top: CGFloat = 0, left: CGFloat = 0, options: NSLayoutFormatOptions = []) {
		alignFromTop(parent, child: child, top: top)
		alignFromLeft(parent, child: child, left: left)
	}
	
	/// AlignFromTopRight
	public static func alignFromTopRight(parent: UIView, child: UIView, top: CGFloat = 0, right: CGFloat = 0, options: NSLayoutFormatOptions = []) {
		alignFromTop(parent, child: child, top: top)
		alignFromRight(parent, child: child, right: right)
	}
	
	/// AlignFromBottomLeft
	public static func alignFromBottomLeft(parent: UIView, child: UIView, bottom: CGFloat = 0, left: CGFloat = 0, options: NSLayoutFormatOptions = []) {
		alignFromBottom(parent, child: child, bottom: bottom)
		alignFromLeft(parent, child: child, left: left)
	}
	
	/// AlignFromBottomRight
	public static func alignFromBottomRight(parent: UIView, child: UIView, bottom: CGFloat = 0, right: CGFloat = 0, options: NSLayoutFormatOptions = []) {
		alignFromBottom(parent, child: child, bottom: bottom)
		alignFromRight(parent, child: child, right: right)
	}
	
	/// AlignFromTop
	public static func alignFromTop(parent: UIView, child: UIView, top: CGFloat = 0, options: NSLayoutFormatOptions = []) {
		parent.addConstraints(constraint("V:|-(top)-[child]", options: options, metrics: ["top" : top], views: ["child" : child]))
	}
	
	/// AlignFromLeft
	public static func alignFromLeft(parent: UIView, child: UIView, left: CGFloat = 0, options: NSLayoutFormatOptions = []) {
		parent.addConstraints(constraint("H:|-(left)-[child]", options: options, metrics: ["left" : left], views: ["child" : child]))
	}
	
	/// AlignFromBottom
	public static func alignFromBottom(parent: UIView, child: UIView, bottom: CGFloat = 0, options: NSLayoutFormatOptions = []) {
		parent.addConstraints(constraint("V:[child]-(bottom)-|", options: options, metrics: ["bottom" : bottom], views: ["child" : child]))
	}
	
	/// AlignFromRight
	public static func alignFromRight(parent: UIView, child: UIView, right: CGFloat = 0, options: NSLayoutFormatOptions = []) {
		parent.addConstraints(constraint("H:[child]-(right)-|", options: options, metrics: ["right" : right], views: ["child" : child]))
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