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
	public struct basicCardView {}
	public struct navigationBarView {}
	public struct label {}
	public struct flatButton {}
	public struct raisedButton {}
	public struct fabButton {}
}

// view
public extension MaterialTheme.view {
	// shadow
	public static var shadowDepth: MaterialDepth = .Depth0
	public static var shadowColor: UIColor = MaterialColor.black
	
	// shape
	public static var masksToBounds: Bool = true
	public static var cornerRadius: MaterialRadius = .Radius0
	
	// border
	public static var borderWidth: MaterialBorder = .Border0
	public static var bordercolor: UIColor = MaterialColor.black
	
	// color
	public static var backgroudColor: UIColor = MaterialColor.white
	
	// interaction
	public static var userInteractionEnabled: Bool = true
	
	// image
	public static var contentsRect: CGRect = CGRectMake(0, 0, 1, 1)
	public static var contentsCenter: CGRect = CGRectMake(0, 0, 1, 1)
	public static var contentsScale: CGFloat = UIScreen.mainScreen().scale
	public static var contentsGravity: MaterialGravity = .ResizeAspectFill
	
	// position
	public static var zPosition: CGFloat = 0
}

// pulseView
public extension MaterialTheme.pulseView {
	// shadow
	public static var shadowDepth: MaterialDepth = MaterialTheme.view.shadowDepth
	public static var shadowColor: UIColor = MaterialTheme.view.shadowColor
	
	// shape
	public static var masksToBounds: Bool = true
	public static var cornerRadius: MaterialRadius = MaterialTheme.view.cornerRadius
	
	// border
	public static var borderWidth: MaterialBorder = MaterialTheme.view.borderWidth
	public static var bordercolor: UIColor = MaterialTheme.view.bordercolor
	
	// color
	public static var backgroudColor: UIColor = MaterialColor.clear
	public static var pulseColor: UIColor = MaterialColor.white
	public static var pulseColorOpacity: CGFloat = 0.25
	
	// interaction
	public static var userInteractionEnabled: Bool = MaterialTheme.view.userInteractionEnabled
	
	// image
	public static var contentsRect: CGRect = MaterialTheme.view.contentsRect
	public static var contentsCenter: CGRect = MaterialTheme.view.contentsCenter
	public static var contentsScale: CGFloat = MaterialTheme.view.contentsScale
	public static var contentsGravity: MaterialGravity = MaterialTheme.view.contentsGravity
	
	// position
	public static var zPosition: CGFloat = MaterialTheme.view.zPosition
}

// basicCardView
public extension MaterialTheme.basicCardView {
	// shadow
	public static var shadowDepth: MaterialDepth = .Depth2
	public static var shadowColor: UIColor = MaterialTheme.view.shadowColor
	
	// shape
	public static var masksToBounds: Bool = true
	public static var cornerRadius: MaterialRadius = .Radius1
	public static var contentInsetsRef: MaterialInsetsType = MaterialInsetsToValue(.Square2)
	public static var titleLabelInsetsRef: MaterialInsetsType = MaterialInsetsToValue(.Square2)
	public static var detailLabelInsetsRef: MaterialInsetsType = MaterialInsetsToValue(.Square2)
	public static var leftButtonsInsetsRef: MaterialInsetsType = MaterialInsetsToValue(.Square2)
	public static var rightButtonsInsetsRef: MaterialInsetsType = MaterialInsetsToValue(.Square2)
	
	// border
	public static var borderWidth: MaterialBorder = MaterialTheme.view.borderWidth
	public static var bordercolor: UIColor = MaterialTheme.view.bordercolor
	
	// color
	public static var backgroudColor: UIColor = MaterialColor.blueGrey.darken1
	public static var pulseColor: UIColor = MaterialColor.white
	public static var pulseColorOpacity: CGFloat = 0.25
	
	// interaction
	public static var userInteractionEnabled: Bool = MaterialTheme.view.userInteractionEnabled
	
	// image
	public static var contentsRect: CGRect = MaterialTheme.view.contentsRect
	public static var contentsCenter: CGRect = MaterialTheme.view.contentsCenter
	public static var contentsScale: CGFloat = MaterialTheme.view.contentsScale
	public static var contentsGravity: MaterialGravity = MaterialTheme.view.contentsGravity
	
	// position
	public static var zPosition: CGFloat = MaterialTheme.view.zPosition
}

// navigationBarView
public extension MaterialTheme.navigationBarView {
	// frame
	public static var x: CGFloat = 0
	public static var y: CGFloat = 0
	public static var width: CGFloat = UIScreen.mainScreen().bounds.width
	public static var height: CGFloat = 70
	
	// shadow
	public static var shadowDepth: MaterialDepth = .Depth2
	public static var shadowColor: UIColor = MaterialTheme.view.shadowColor
	
	// shape
	public static var masksToBounds: Bool = MaterialTheme.view.masksToBounds
	public static var cornerRadius: MaterialRadius = MaterialTheme.view.cornerRadius
	public static var contentInsetsRef: MaterialInsetsType = MaterialInsetsToValue(.Square2)
	public static var titleLabelInsetsRef: MaterialInsetsType = MaterialInsetsToValue(.Square2)
	public static var leftButtonsInsetsRef: MaterialInsetsType = MaterialInsetsToValue(.Square2)
	public static var rightButtonsInsetsRef: MaterialInsetsType = MaterialInsetsToValue(.Square2)
	
	// border
	public static var borderWidth: MaterialBorder = MaterialTheme.view.borderWidth
	public static var bordercolor: UIColor = MaterialTheme.view.bordercolor
	
	// color
	public static var backgroudColor: UIColor = MaterialColor.blue.accent3
	public static var statusBarStyle: MaterialStatusBarStyle = .LightContent
	
	// interaction
	public static var userInteractionEnabled: Bool = true
	
	// image
	public static var contentsRect: CGRect = MaterialTheme.view.contentsRect
	public static var contentsCenter: CGRect = MaterialTheme.view.contentsCenter
	public static var contentsScale: CGFloat = MaterialTheme.view.contentsScale
	public static var contentsGravity: MaterialGravity = MaterialTheme.view.contentsGravity
	
	// position
	public static var zPosition: CGFloat = 100
}

// label
public extension MaterialTheme.label {
	// scale
	public static var contentsScale: CGFloat = UIScreen.mainScreen().scale
	
	// alignment
	public static var wrapped: Bool = true
	public static var textAlignment: NSTextAlignment = .Left
	
	// font
	public static var font: UIFont = RobotoFont.regularWithSize(20)
}

// flatButton
public extension MaterialTheme.flatButton {
	// shadow
	public static var shadowDepth: MaterialDepth = .Depth0
	public static var shadowColor: UIColor = MaterialTheme.view.shadowColor
	
	// shape
	public static var masksToBounds: Bool = true
	public static var cornerRadius: MaterialRadius = .Radius1
	public static var contentInsets: MaterialInsets = .Rectangle2
	public static var shape: MaterialShape? = nil
	
	// border
	public static var borderWidth: MaterialBorder = MaterialTheme.view.borderWidth
	public static var bordercolor: UIColor = MaterialTheme.view.bordercolor
	
	// color
	public static var backgroudColor: UIColor = MaterialColor.clear
	public static var pulseColor: UIColor = MaterialColor.blue.accent3
	public static var pulseColorOpacity: CGFloat = MaterialTheme.pulseView.pulseColorOpacity
	public static var titleLabelColorForNormalState: UIColor = MaterialColor.blue.accent3
	
	// interaction
	public static var userInteractionEnabled: Bool = true
	
	// position
	public static var zPosition: CGFloat = 200
	
	// font
	public static var titleLabelFont: UIFont = RobotoFont.regular
}

// raisedButton
public extension MaterialTheme.raisedButton {
	// shadow
	public static var shadowDepth: MaterialDepth = .Depth2
	public static var shadowColor: UIColor = MaterialTheme.view.shadowColor
	
	// shape
	public static var masksToBounds: Bool = true
	public static var cornerRadius: MaterialRadius = .Radius1
	public static var contentInsets: MaterialInsets = .Rectangle2
	public static var shape: MaterialShape? = nil
	
	// border
	public static var borderWidth: MaterialBorder = MaterialTheme.view.borderWidth
	public static var bordercolor: UIColor = MaterialTheme.view.bordercolor
	
	// color
	public static var backgroudColor: UIColor = MaterialColor.blue.accent3
	public static var pulseColor: UIColor = MaterialColor.white
	public static var pulseColorOpacity: CGFloat = MaterialTheme.pulseView.pulseColorOpacity
	public static var titleLabelColorForNormalState: UIColor = MaterialColor.white
	
	// interaction
	public static var userInteractionEnabled: Bool = true
	
	// position
	public static var zPosition: CGFloat = 200
	
	// font
	public static var titleLabelFont: UIFont = RobotoFont.regular
}


// fabButton
public extension MaterialTheme.fabButton {
	// shadow
	public static var shadowDepth: MaterialDepth = .Depth2
	public static var shadowColor: UIColor = MaterialTheme.view.shadowColor
	
	// shape
	public static var masksToBounds: Bool = true
	public static var cornerRadius: MaterialRadius = .Radius0
	public static var contentInsets: MaterialInsets = .Rectangle0
	public static var shape: MaterialShape? = .Circle
	
	// border
	public static var borderWidth: MaterialBorder = MaterialTheme.view.borderWidth
	public static var bordercolor: UIColor = MaterialTheme.view.bordercolor
	
	// color
	public static var backgroudColor: UIColor = MaterialColor.red.darken1
	public static var pulseColor: UIColor = MaterialColor.white
	public static var pulseColorOpacity: CGFloat = MaterialTheme.pulseView.pulseColorOpacity
	public static var titleLabelColorForNormalState: UIColor = MaterialColor.white
	
	// interaction
	public static var userInteractionEnabled: Bool = true
	
	// position
	public static var zPosition: CGFloat = 200
	
	// font
	public static var titleLabelFont: UIFont = RobotoFont.regular
}
