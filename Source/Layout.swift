//
// Copyright (C) 2015 GraphKit, Inc. <http://graphkit.io> and other GraphKit contributors.
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

public struct Layout {
	/**
		:name:	width
	*/
	public static func width(parent: UIView, child: UIView, width: CGFloat) {
		let metrics: Dictionary<String, AnyObject> = ["width" : width]
		let views: Dictionary<String, AnyObject> = ["child" : child]
		parent.addConstraints(constraint("H:[child(width)]", options: nil, metrics: metrics, views: views))
	}
	
	/**
		:name:	height
	*/
	public static func height(parent: UIView, child: UIView, height: CGFloat) {
		let metrics: Dictionary<String, AnyObject> = ["height" : height]
		let views: Dictionary<String, AnyObject> = ["child" : child]
		parent.addConstraints(constraint("V:[child(height)]", options: nil, metrics: metrics, views: views))
	}
	
	/**
		:name:	size
	*/
	public static func size(parent: UIView, child: UIView, width: CGFloat, height: CGFloat) {
		Layout.width(parent, child: child, width: width)
		Layout.height(parent, child: child, height: height)
	}
	
	/**
		:name:	expandToParent
	*/
	public static func expandToParent(parent: UIView, child: UIView) {
		let views: Dictionary<String, AnyObject> = ["child" : child]
		parent.addConstraints(constraint("H:|[child]|", options: nil, metrics: nil, views: views))
		parent.addConstraints(constraint("V:|[child]|", options: nil, metrics: nil, views: views))
	}
	
	/**
		:name:	expandToParentHorizontallyWithPad
	*/
	public static func expandToParentHorizontallyWithPad(parent: UIView, child: UIView, left: CGFloat, right: CGFloat) {
		parent.addConstraints(constraint("H:|-(left)-[child]-(right)-|", options: nil, metrics: ["left": left, "right": right], views: ["child" : child]))
	}
	
	/**
		:name:	expandToParentVerticallyWithPad
	*/
	public static func expandToParentVerticallyWithPad(parent: UIView, child: UIView, top: CGFloat, bottom: CGFloat) {
		parent.addConstraints(constraint("V:|-(top)-[child]-(bottom)-|", options: nil, metrics: ["bottom": bottom, "top": top], views: ["child" : child]))
	}
	
	/**
		:name:	expandToParentWithPad
	*/
	public static func expandToParentWithPad(parent: UIView, child: UIView, left: CGFloat, bottom: CGFloat, right: CGFloat, top: CGFloat) {
		let views: Dictionary<String, AnyObject> = ["child" : child]
		parent.addConstraints(constraint("H:|-(left)-[child]-(right)-|", options: nil, metrics: ["left": left, "right": right], views: views))
		parent.addConstraints(constraint("V:|-(top)-[child]-(bottom)-|", options: nil, metrics: ["bottom": bottom, "top": top], views: views))
	}
	
	/**
		:name:	alignFromTopLeft
	*/
	public static func alignFromTopLeft(parent: UIView, child: UIView, top: CGFloat, left: CGFloat) {
		let metrics: Dictionary<String, AnyObject> = ["top" : top, "left" : left]
		let views: Dictionary<String, AnyObject> = ["child" : child]
		parent.addConstraints(constraint("H:|-(left)-[child]", options: nil, metrics: metrics, views: views))
		parent.addConstraints(constraint("V:|-(top)-[child]", options: nil, metrics: metrics, views: views))
	}
	
	/**
		:name:	alignFromTopRight
	*/
	public static func alignFromTopRight(parent: UIView, child: UIView, top: CGFloat, right: CGFloat) {
		let metrics: Dictionary<String, AnyObject> = ["top" : top, "right" : right]
		let views: Dictionary<String, AnyObject> = ["child" : child]
		parent.addConstraints(constraint("H:[child]-(right)-|", options: nil, metrics: metrics, views: views))
		parent.addConstraints(constraint("V:|-(top)-[child]", options: nil, metrics: metrics, views: views))
	}
	
	/**
		:name:	alignFromBottomLeft
	*/
	public static func alignFromBottomLeft(parent: UIView, child: UIView, bottom: CGFloat, left: CGFloat) {
		let metrics: Dictionary<String, AnyObject> = ["bottom" : bottom, "left" : left]
		let views: Dictionary<String, AnyObject> = ["child" : child]
		parent.addConstraints(constraint("H:|-(left)-[child]", options: nil, metrics: metrics, views: views))
		parent.addConstraints(constraint("V:[child]-(bottom)-|", options: nil, metrics: metrics, views: views))
	}
	
	/**
		:name:	alignFromBottomRight
	*/
	public static func alignFromBottomRight(parent: UIView, child: UIView, bottom: CGFloat, right: CGFloat) {
		let metrics: Dictionary<String, AnyObject> = ["bottom" : bottom, "right" : right]
		let views: Dictionary<String, AnyObject> = ["child" : child]
		parent.addConstraints(constraint("H:[child]-(right)-|", options: nil, metrics: metrics, views: views))
		parent.addConstraints(constraint("V:[child]-(bottom)-|", options: nil, metrics: metrics, views: views))
	}
    
    /**
    :name:	alignAllSides
    */
    public static func alignAllSides(parent: UIView, child: UIView) {
        let views: Dictionary<String, AnyObject> = ["child" : child]
        parent.addConstraints(constraint("H:|[child]|", options: nil, metrics: nil, views: views))
        parent.addConstraints(constraint("V:|[child]|", options: nil, metrics: nil, views: views))
    }
    
	/**
		:name:	constraint
	*/
	public static func constraint(format: String, options: NSLayoutFormatOptions, metrics: Dictionary<String, AnyObject>?, views: Dictionary<String, AnyObject>) -> Array<NSLayoutConstraint> {
		for (_, v) in views {
			v.setTranslatesAutoresizingMaskIntoConstraints(false)
		}
		return NSLayoutConstraint.constraintsWithVisualFormat(
			format,
			options: options,
			metrics: metrics,
			views: views
		) as! Array<NSLayoutConstraint>
	}
}
