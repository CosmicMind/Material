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
	public struct pulseView {}
	public struct navigation {}
	public struct button {
		public struct flat {}
		public struct raised {}
		public struct fab {}
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
	public static let shadowDepth: MaterialDepth = .Depth0
	public static let shadowColor: UIColor = MaterialColor.black
	
	// shape
	public static let masksToBounds: Bool = true
	public static let cornerRadius: MaterialRadius = .Radius0
	
	// border
	public static let borderWidth: MaterialBorder = .Border0
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

// pulseView
public extension MaterialTheme.pulseView {
	// frame
	public static let x: CGFloat = MaterialTheme.view.x
	public static let y: CGFloat = MaterialTheme.view.y
	public static let width: CGFloat = MaterialTheme.view.width
	public static let height: CGFloat = MaterialTheme.view.height
	
	// shadow
	public static let shadowDepth: MaterialDepth = MaterialTheme.view.shadowDepth
	public static let shadowColor: UIColor = MaterialTheme.view.shadowColor
	
	// shape
	public static let masksToBounds: Bool = true
	public static let cornerRadius: MaterialRadius = MaterialTheme.view.cornerRadius
	
	// border
	public static let borderWidth: MaterialBorder = MaterialTheme.view.borderWidth
	public static let bordercolor: UIColor = MaterialTheme.view.bordercolor
	
	// color
	public static let backgroudColor: UIColor = MaterialColor.clear
	public static let pulseColor: UIColor = MaterialColor.white
	
	// interaction
	public static let userInteractionEnabled: Bool = MaterialTheme.view.userInteractionEnabled
	
	// image
	public static let contentsRect: CGRect = MaterialTheme.view.contentsRect
	public static let contentsCenter: CGRect = MaterialTheme.view.contentsCenter
	public static let contentsScale: CGFloat = MaterialTheme.view.contentsScale
	public static let contentsGravity: MaterialGravity = MaterialTheme.view.contentsGravity
	
	// position
	public static let zPosition: CGFloat = MaterialTheme.view.zPosition
}

// navigation
public extension MaterialTheme.navigation {
	// frame
	public static let x: CGFloat = MaterialTheme.view.x
	public static let y: CGFloat = MaterialTheme.view.y
	public static let width: CGFloat = MaterialTheme.view.width
	public static let height: CGFloat = 70
	
	// shadow
	public static let shadowDepth: MaterialDepth = .Depth1
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

// button.flat
public extension MaterialTheme.button.flat {
	// shadow
	public static let shadowDepth: MaterialDepth = .Depth0
	public static let shadowColor: UIColor = MaterialTheme.view.shadowColor
	
	// shape
	public static let masksToBounds: Bool = true
	public static let cornerRadius: MaterialRadius = .Radius1
	public static let contentInsets: MaterialInsets = .Inset2
	public static let shape: MaterialShape? = nil
	
	// border
	public static let borderWidth: MaterialBorder = MaterialTheme.view.borderWidth
	public static let bordercolor: UIColor = MaterialTheme.view.bordercolor
	
	// color
	public static let backgroudColor: UIColor = MaterialColor.clear
	public static let pulseColor: UIColor = MaterialColor.blue.accent3
	public static let titleLabelColorForNormalState: UIColor = MaterialColor.blue.accent3
	
	// interaction
	public static let userInteractionEnabled: Bool = true
	
	// position
	public static let zPosition: CGFloat = 200
	
	// font
	public static let titleLabelFont: UIFont = RobotoFont.regular
}

// button.raised
public extension MaterialTheme.button.raised {
	// shadow
	public static let shadowDepth: MaterialDepth = .Depth2
	public static let shadowColor: UIColor = MaterialTheme.view.shadowColor
	
	// shape
	public static let masksToBounds: Bool = true
	public static let cornerRadius: MaterialRadius = .Radius1
	public static let contentInsets: MaterialInsets = .Inset2
	public static let shape: MaterialShape? = nil
	
	// border
	public static let borderWidth: MaterialBorder = MaterialTheme.view.borderWidth
	public static let bordercolor: UIColor = MaterialTheme.view.bordercolor
	
	// color
	public static let backgroudColor: UIColor = MaterialColor.blue.accent3
	public static let pulseColor: UIColor = MaterialColor.white
	public static let titleLabelColorForNormalState: UIColor = MaterialColor.white
	
	// interaction
	public static let userInteractionEnabled: Bool = true
	
	// position
	public static let zPosition: CGFloat = 200
	
	// font
	public static let titleLabelFont: UIFont = RobotoFont.regular
}


// button.fab
public extension MaterialTheme.button.fab {
	// shadow
	public static let shadowDepth: MaterialDepth = .Depth2
	public static let shadowColor: UIColor = MaterialTheme.view.shadowColor
	
	// shape
	public static let masksToBounds: Bool = true
	public static let cornerRadius: MaterialRadius = .Radius0
	public static let contentInsets: MaterialInsets = .Inset0
	public static let shape: MaterialShape? = .Circle
	
	// border
	public static let borderWidth: MaterialBorder = MaterialTheme.view.borderWidth
	public static let bordercolor: UIColor = MaterialTheme.view.bordercolor
	
	// color
	public static let backgroudColor: UIColor = MaterialColor.red.darken1
	public static let pulseColor: UIColor = MaterialColor.white
	public static let titleLabelColorForNormalState: UIColor = MaterialColor.white
	
	// interaction
	public static let userInteractionEnabled: Bool = true
	
	// position
	public static let zPosition: CGFloat = 200
	
	// font
	public static let titleLabelFont: UIFont = RobotoFont.regular
}
