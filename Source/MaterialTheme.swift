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
	public struct button {
		public struct fab {}
		public struct flat {}
		public struct raised {}
	}
}

// view
public extension MaterialTheme.view {
	// frame
	public static var x: CGFloat = 0
	public static let y: CGFloat = 0
	public static let width: CGFloat = UIScreen.mainScreen().bounds.width
	public static let height: CGFloat = UIScreen.mainScreen().bounds.height
	
	// shadow
	public static let shadow: MaterialShadow = .Depth0
	public static let shadowColor: UIColor = MaterialColor.blueGrey.darken4
	
	// shape
	public static let masksToBounds: Bool = false
	public static let cornerRadius: MaterialRadius = .Square
	
	// border
	public static let borderWidth: MaterialBorder = .None
	public static let bordercolor: UIColor = MaterialColor.black
	
	// color
	public static let backgroudColor: UIColor = MaterialColor.white
	
	// interaction
	public static let userInteractionEnabled: Bool = true
	
	// image
	public static let contentsRect: CGRect = CGRectMake(0, 0, 1, 1)
	public static let contentsCenter: CGRect = CGRectMake(0, 0, 1, 1)
	public static let contentsScale: CGFloat = UIScreen.mainScreen().scale
	public static let contentsGravity: MaterialGravity = .ResizeAspectFill
	
	// position
	public static let zPosition: CGFloat = 0
}

// navigation
public extension MaterialTheme.navigation {
	// frame
	public static let x: CGFloat = MaterialTheme.view.x
	public static let y: CGFloat = MaterialTheme.view.y
	public static let width: CGFloat = MaterialTheme.view.width
	public static let height: CGFloat = 70
	
	// shadow
	public static let shadow: MaterialShadow = .Depth1
	public static let shadowColor: UIColor = MaterialTheme.view.shadowColor
	
	// shape
	public static let masksToBounds: Bool = MaterialTheme.view.masksToBounds
	public static let cornerRadius: MaterialRadius = MaterialTheme.view.cornerRadius
	
	// border
	public static let borderWidth: MaterialBorder = MaterialTheme.view.borderWidth
	public static let bordercolor: UIColor = MaterialTheme.view.bordercolor
	
	// color
	public static let backgroudColor: UIColor = MaterialColor.blue.accent3
	public static let lightContentStatusBar: Bool = true
	
	// interaction
	public static let userInteractionEnabled: Bool = false
	
	// image
	public static let contentsRect: CGRect = MaterialTheme.view.contentsRect
	public static let contentsCenter: CGRect = MaterialTheme.view.contentsCenter
	public static let contentsScale: CGFloat = MaterialTheme.view.contentsScale
	public static let contentsGravity: MaterialGravity = MaterialTheme.view.contentsGravity
	
	// position
	public static let zPosition: CGFloat = 100
}

// button
public extension MaterialTheme.button {
	// shadow
	public static let shadow: MaterialShadow = .Depth0
	public static let shadowColor: UIColor = MaterialTheme.view.shadowColor
	
	// shape
	public static let masksToBounds: Bool = MaterialTheme.view.masksToBounds
	public static let cornerRadius: MaterialRadius = .Light
	public static let contentInsets: MaterialInsets = .Inset2
	
	// border
	public static let borderWidth: MaterialBorder = MaterialTheme.view.borderWidth
	public static let bordercolor: UIColor = MaterialTheme.view.bordercolor
	
	// color
	public static let backgroudColor: UIColor = MaterialColor.clear
	public static let titleLabelColorForNormalState: UIColor = MaterialColor.blueGrey.darken4
	
	// interaction
	public static let userInteractionEnabled: Bool = true
	
	// position
	public static let zPosition: CGFloat = 200
	
	// font
	public static let titleLabelFont: UIFont = RobotoFont.regular
}

// button.flat
public extension MaterialTheme.button.flat {
	// shadow
	public static let shadow: MaterialShadow = MaterialTheme.button.shadow
	public static let shadowColor: UIColor = MaterialTheme.button.shadowColor
	
	// shape
	public static let masksToBounds: Bool = MaterialTheme.button.masksToBounds
	public static let cornerRadius: MaterialRadius = MaterialTheme.button.cornerRadius
	public static let contentInsets: MaterialInsets = MaterialTheme.button.contentInsets
	
	// border
	public static let borderWidth: MaterialBorder = MaterialTheme.button.borderWidth
	public static let bordercolor: UIColor = MaterialTheme.button.bordercolor
	
	// color
	public static let backgroudColor: UIColor = MaterialTheme.button.backgroudColor
	public static let titleLabelColorForNormalState: UIColor = MaterialTheme.button.titleLabelColorForNormalState
	
	// interaction
	public static let userInteractionEnabled: Bool = MaterialTheme.button.userInteractionEnabled
	
	// position
	public static let zPosition: CGFloat = MaterialTheme.button.zPosition
	
	// font
	public static let titleLabelFont: UIFont = RobotoFont.regular
}

// button.fab
public extension MaterialTheme.button.fab {
	
}

// button.raised
public extension MaterialTheme.button.raised {
	
}
