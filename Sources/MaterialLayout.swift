//
// Copyright (C) 2015 CosmicMind, Inc. <http://cosmicmind.io> and other CosmicMind contributors
//
// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU Affero General Public License as published
// by the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU Affero General Public License for more details.
//
// You should have received a copy of the GNU Affero General Public License
// along with this program located at the root of the software package
// in a file called LICENSE.  If not, see <http://www.gnu.org/licenses/>.
//

import UIKit

public struct MaterialLayout {
	/**
	:name:	width
	*/
	public static func width(parent: UIView, child: UIView, width: CGFloat = 0, options: NSLayoutFormatOptions = []) {
		let metrics: Dictionary<String, AnyObject> = ["width" : width]
		let views: Dictionary<String, AnyObject> = ["child" : child]
		parent.addConstraints(constraint("H:[child(width)]", options: options, metrics: metrics, views: views))
	}
	
	/**
	:name:	height
	*/
	public static func height(parent: UIView, child: UIView, height: CGFloat = 0, options: NSLayoutFormatOptions = []) {
		let metrics: Dictionary<String, AnyObject> = ["height" : height]
		let views: Dictionary<String, AnyObject> = ["child" : child]
		parent.addConstraints(constraint("V:[child(height)]", options: options, metrics: metrics, views: views))
	}
	
	/**
	:name:	size
	*/
	public static func size(parent: UIView, child: UIView, width: CGFloat = 0, height: CGFloat = 0, options: NSLayoutFormatOptions = []) {
		MaterialLayout.width(parent, child: child, width: width)
		MaterialLayout.height(parent, child: child, height: height)
	}
	
	/**
	:name:	alignToParentHorizontally
	*/
	public static func alignToParentHorizontally(parent: UIView, children: Array<UIView>, left: CGFloat = 0, right: CGFloat = 0, spacing: CGFloat = 0, options: NSLayoutFormatOptions = []) {
		if 0 < children.count {
			var format: String = "H:|-(left)-"
			var i: Int = 1
			var views: Dictionary<String, UIView> = Dictionary<String, UIView>()
			for v in children {
				let k: String = "view\(i++)"
				views[k] = v
				format += i > children.count ? "[\(k)(==view1)]-(right)-|" : "[\(k)(==view1)]-(spacing)-"
			}
			parent.addConstraints(constraint(format, options: options, metrics: ["left" : left, "right": right, "spacing": spacing], views: views))
		}
	}
	
	/**
	:name:	alignToParentVertically
	*/
	public static func alignToParentVertically(parent: UIView, children: Array<UIView>, top: CGFloat = 0, bottom: CGFloat = 0, spacing: CGFloat = 0, options: NSLayoutFormatOptions = []) {
		if 0 < children.count {
			var format: String = "V:|-(top)-"
			var i: Int = 1
			var views: Dictionary<String, UIView> = Dictionary<String, UIView>()
			for v in children {
				let k: String = "view\(i++)"
				views[k] = v
				format += i > children.count ? "[\(k)(==view1)]-(bottom)-|" : "[\(k)(==view1)]-(spacing)-"
			}
			parent.addConstraints(constraint(format, options: options, metrics: ["top" : top, "bottom": bottom, "spacing": spacing], views: views))
		}
	}
	
	/**
	:name:	alignToParentHorizontally
	*/
	public static func alignToParentHorizontally(parent: UIView, child: UIView, left: CGFloat = 0, right: CGFloat = 0, options: NSLayoutFormatOptions = []) {
		parent.addConstraints(constraint("H:|-(left)-[child]-(right)-|", options: options, metrics: ["left": left, "right": right], views: ["child" : child]))
	}
	
	/**
	:name:	alignToParentVertically
	*/
	public static func alignToParentVertically(parent: UIView, child: UIView, top: CGFloat = 0, bottom: CGFloat = 0, options: NSLayoutFormatOptions = []) {
		parent.addConstraints(constraint("V:|-(top)-[child]-(bottom)-|", options: options, metrics: ["bottom": bottom, "top": top], views: ["child" : child]))
	}
	
	/**
	:name:	alignToParent
	*/
	public static func alignToParent(parent: UIView, child: UIView, top: CGFloat = 0, left: CGFloat = 0, bottom: CGFloat = 0, right: CGFloat = 0, options: NSLayoutFormatOptions = []) {
		alignToParentHorizontally(parent, child: child, left: left, right: right)
		alignToParentVertically(parent, child: child, top: top, bottom: bottom)
	}
	
	/**
	:name:	alignFromTopLeft
	*/
	public static func alignFromTopLeft(parent: UIView, child: UIView, top: CGFloat = 0, left: CGFloat = 0, options: NSLayoutFormatOptions = []) {
		alignFromTop(parent, child: child, top: top)
		alignFromLeft(parent, child: child, left: left)
	}
	
	/**
	:name:	alignFromTopRight
	*/
	public static func alignFromTopRight(parent: UIView, child: UIView, top: CGFloat = 0, right: CGFloat = 0, options: NSLayoutFormatOptions = []) {
		alignFromTop(parent, child: child, top: top)
		alignFromRight(parent, child: child, right: right)
	}
	
	/**
	:name:	alignFromBottomLeft
	*/
	public static func alignFromBottomLeft(parent: UIView, child: UIView, bottom: CGFloat = 0, left: CGFloat = 0, options: NSLayoutFormatOptions = []) {
		alignFromBottom(parent, child: child, bottom: bottom)
		alignFromLeft(parent, child: child, left: left)
	}
	
	/**
	:name:	alignFromBottomRight
	*/
	public static func alignFromBottomRight(parent: UIView, child: UIView, bottom: CGFloat = 0, right: CGFloat = 0, options: NSLayoutFormatOptions = []) {
		alignFromBottom(parent, child: child, bottom: bottom)
		alignFromRight(parent, child: child, right: right)
	}
	
	/**
	:name:	alignFromTop
	*/
	public static func alignFromTop(parent: UIView, child: UIView, top: CGFloat = 0, options: NSLayoutFormatOptions = []) {
		parent.addConstraints(constraint("V:|-(top)-[child]", options: options, metrics: ["top" : top], views: ["child" : child]))
	}
	
	/**
	:name:	alignFromLeft
	*/
	public static func alignFromLeft(parent: UIView, child: UIView, left: CGFloat = 0, options: NSLayoutFormatOptions = []) {
		parent.addConstraints(constraint("H:|-(left)-[child]", options: options, metrics: ["left" : left], views: ["child" : child]))
	}
	
	/**
	:name:	alignFromBottom
	*/
	public static func alignFromBottom(parent: UIView, child: UIView, bottom: CGFloat = 0, options: NSLayoutFormatOptions = []) {
		parent.addConstraints(constraint("V:[child]-(bottom)-|", options: options, metrics: ["bottom" : bottom], views: ["child" : child]))
	}
	
	/**
	:name:	alignFromRight
	*/
	public static func alignFromRight(parent: UIView, child: UIView, right: CGFloat = 0, options: NSLayoutFormatOptions = []) {
		parent.addConstraints(constraint("H:[child]-(right)-|", options: options, metrics: ["right" : right], views: ["child" : child]))
	}
	
	/**
	:name:	constraint
	*/
	public static func constraint(format: String, options: NSLayoutFormatOptions, metrics: Dictionary<String, AnyObject>?, views: Dictionary<String, AnyObject>) -> Array<NSLayoutConstraint> {
		return NSLayoutConstraint.constraintsWithVisualFormat(
			format,
			options: options,
			metrics: metrics,
			views: views
		)
	}
}