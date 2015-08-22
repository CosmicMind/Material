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
	public static func topRight(parent: UIView, child: UIView, width: CGFloat, height: CGFloat, top: CGFloat, right: CGFloat) {
		parent.addSubview(child)
		var metrics = ["width" : width, "height" : height, "top" : top, "right" : right]
		var views = ["view" : child]
		var viewBindingsDict: NSMutableDictionary = NSMutableDictionary()
		viewBindingsDict.setValue(child, forKey: "child")
		parent.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:[child(width)]-(right)-|", options: nil, metrics: metrics, views: viewBindingsDict as [NSObject : AnyObject]))
		parent.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-(top)-[child(height)]", options: nil, metrics: metrics, views: viewBindingsDict as [NSObject : AnyObject]))
	}
	
	public static func topLeft(parent: UIView, child: UIView, width: CGFloat, height: CGFloat, top: CGFloat, left: CGFloat) {
		parent.addSubview(child)
		var metrics = ["width" : width, "height" : height, "top" : top, "left" : left]
		var views = ["view" : child]
		var viewBindingsDict: NSMutableDictionary = NSMutableDictionary()
		viewBindingsDict.setValue(child, forKey: "child")
		parent.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-(left)-[child(width)]", options: nil, metrics: metrics, views: viewBindingsDict as [NSObject : AnyObject]))
		parent.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-(top)-[child(height)]", options: nil, metrics: metrics, views: viewBindingsDict as [NSObject : AnyObject]))
	}
	
	public static func bottomRight(parent: UIView, child: UIView, width: CGFloat, height: CGFloat, bottom: CGFloat, right: CGFloat) {
		parent.addSubview(child)
		var metrics = ["width" : width, "height" : height, "bottom" : bottom, "right" : right]
		var views = ["view" : child]
		var viewBindingsDict: NSMutableDictionary = NSMutableDictionary()
		viewBindingsDict.setValue(child, forKey: "child")
		parent.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:[child(width)]-(right)-|", options: nil, metrics: metrics, views: viewBindingsDict as [NSObject : AnyObject]))
		parent.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:[child(height)]-(bottom)-|", options: nil, metrics: metrics, views: viewBindingsDict as [NSObject : AnyObject]))
	}
	
	public static func bottomLeft(parent: UIView, child: UIView, width: CGFloat, height: CGFloat, bottom: CGFloat, left: CGFloat) {
		parent.addSubview(child)
		var metrics = ["width" : width, "height" : height, "bottom" : bottom, "left" : left]
		var views = ["view" : child]
		var viewBindingsDict: NSMutableDictionary = NSMutableDictionary()
		viewBindingsDict.setValue(child, forKey: "child")
		parent.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-(left)-[child(width)]", options: nil, metrics: metrics, views: viewBindingsDict as [NSObject : AnyObject]))
		parent.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:[child(height)]-(bottom)-|", options: nil, metrics: metrics, views: viewBindingsDict as [NSObject : AnyObject]))
	}
}
