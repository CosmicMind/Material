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
	public static func width(parent: UIView, child: UIView, width: CGFloat) {
		let metrics: Dictionary<String, AnyObject> = ["width" : width]
		let views: Dictionary<String, AnyObject> = ["child" : child]
		constraint(parent, constraint: "H:[child(width)]", metrics: metrics, views: views)
	}
	
	public static func height(parent: UIView, child: UIView, height: CGFloat) {
		let metrics: Dictionary<String, AnyObject> = ["height" : height]
		let views: Dictionary<String, AnyObject> = ["child" : child]
		constraint(parent, constraint: "V:[child(height)]", metrics: metrics, views: views)
	}
	
	public static func size(parent: UIView, child: UIView, width: CGFloat, height: CGFloat) {
		Layout.width(parent, child: child, width: width)
		Layout.height(parent, child: child, height: height)
	}
	
	public static func alignFromTopLeft(parent: UIView, child: UIView, top: CGFloat, left: CGFloat) {
		let metrics: Dictionary<String, AnyObject> = ["top" : top, "left" : left]
		let views: Dictionary<String, AnyObject> = ["child" : child]
		constraint(parent, constraint: "H:|-(left)-[child]", metrics: metrics, views: views)
		constraint(parent, constraint: "V:|-(top)-[child]", metrics: metrics, views: views)
	}
	
	public static func alignFromTopRight(parent: UIView, child: UIView, top: CGFloat, right: CGFloat) {
		let metrics: Dictionary<String, AnyObject> = ["top" : top, "right" : right]
		let views: Dictionary<String, AnyObject> = ["child" : child]
		constraint(parent, constraint: "H:[child]-(right)-|", metrics: metrics, views: views)
		constraint(parent, constraint: "V:|-(top)-[child]", metrics: metrics, views: views)
	}
	
	public static func alignFromBottomLeft(parent: UIView, child: UIView, bottom: CGFloat, left: CGFloat) {
		let metrics: Dictionary<String, AnyObject> = ["bottom" : bottom, "left" : left]
		let views: Dictionary<String, AnyObject> = ["child" : child]
		constraint(parent, constraint: "H:|-(left)-[child]", metrics: metrics, views: views)
		constraint(parent, constraint: "V:[child]-(bottom)-|", metrics: metrics, views: views)
	}
	
	public static func alignFromBottomRight(parent: UIView, child: UIView, bottom: CGFloat, right: CGFloat) {
		let metrics: Dictionary<String, AnyObject> = ["bottom" : bottom, "right" : right]
		let views: Dictionary<String, AnyObject> = ["child" : child]
		constraint(parent, constraint: "H:[child]-(right)-|", metrics: metrics, views: views)
		constraint(parent, constraint: "V:[child]-(bottom)-|", metrics: metrics, views: views)
	}
	
	private static func constraint(parent: UIView, constraint: String, metrics: Dictionary<String, AnyObject>, views: Dictionary<String, AnyObject>) {
		parent.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(
			constraint,
			options: nil,
			metrics: metrics,
			views: views
			)
		)
	}
}
