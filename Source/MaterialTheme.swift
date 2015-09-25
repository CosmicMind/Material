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

public struct MaterialTheme {
	public struct view {}
	public struct navigation {}
}

// view
public extension MaterialTheme.view {
	// frame
	public static var x: CGFloat = 0
	public static let y: CGFloat = 0
	public static let width: CGFloat = UIScreen.mainScreen().bounds.width
	public static let height: CGFloat = UIScreen.mainScreen().bounds.height
	
	// layer
	public static let shadowColor: UIColor = MaterialColor.blueGrey.darken4
	public static let shadowOffset: CGSize = CGSizeMake(0.2, 0.2)
	public static let shadowOpacity: Float = 0.5
	public static let shadowRadius: CGFloat = 1
	public static let masksToBounds: Bool = false
	
	// color
	public static let backgroudColor: UIColor = MaterialColor.white.color
	
	// interaction
	public static let userInteractionEnabled: Bool = true
	
	// image
	public static let contentsRect: CGRect = CGRectMake(0, 0, 1, 1)
	public static let contentsCenter: CGRect = CGRectMake(0, 0, 1, 1)
	public static let contentsScale: CGFloat = UIScreen.mainScreen().scale
	public static let contentsGravity: MaterialGravity = .ResizeAspectFill
}

// navigation
public extension MaterialTheme.navigation {
	// frame
	public static let x: CGFloat = MaterialTheme.view.x
	public static let y: CGFloat = MaterialTheme.view.y
	public static let width: CGFloat = MaterialTheme.view.width
	public static let height: CGFloat = 70
	
	// layer
	public static let shadowColor: UIColor = MaterialTheme.view.shadowColor
	public static let shadowOffset: CGSize = MaterialTheme.view.shadowOffset
	public static let shadowOpacity: Float = MaterialTheme.view.shadowOpacity
	public static let shadowRadius: CGFloat = MaterialTheme.view.shadowRadius
	public static let masksToBounds: Bool = MaterialTheme.view.masksToBounds
	
	// color
	public static let backgroudColor: UIColor = MaterialColor.blue.accent2
	public static let lightContentStatusBar: Bool = true
	
	// interaction
	public static let userInteractionEnabled: Bool = false
	
	// image
	public static let contentsRect: CGRect = MaterialTheme.view.contentsRect
	public static let contentsCenter: CGRect = MaterialTheme.view.contentsCenter
	public static let contentsScale: CGFloat = MaterialTheme.view.contentsScale
	public static let contentsGravity: MaterialGravity = MaterialTheme.view.contentsGravity
}

