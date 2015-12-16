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

public struct MaterialTheme {
	public struct view {}
	public struct pulseView {}
	public struct basicCardView {}
	public struct imageCardView {}
	public struct navigationBarView {}
	public struct captureView {}
	public struct textLayer {}
	public struct label {}
	public struct flatButton {}
	public struct raisedButton {}
	public struct fabButton {}
}

// view
public extension MaterialTheme.view {
	// shadow
	public static var shadowDepth: MaterialDepth = .None
	public static var shadowColor: UIColor = MaterialColor.black
	
	// border
	public static var borderWidth: MaterialBorder = .None
	public static var bordercolor: UIColor = MaterialColor.black
	
	// color
	public static var backgroundColor: UIColor = MaterialColor.white
	
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
	public static var shadowDepth: MaterialDepth = .None
	public static var shadowColor: UIColor = MaterialColor.black
	
	// border
	public static var borderWidth: MaterialBorder = .None
	public static var bordercolor: UIColor = MaterialColor.black
	
	// color
	public static var backgroundColor: UIColor = MaterialColor.clear
	public static var pulseColor: UIColor = MaterialColor.white
	public static var pulseColorOpacity: CGFloat = 0.25
	
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

// basicCardView
public extension MaterialTheme.basicCardView {
	// shadow
	public static var shadowDepth: MaterialDepth = .Depth2
	public static var shadowColor: UIColor = MaterialColor.black
	
	// shape
	public static var contentInsetsRef: UIEdgeInsets = MaterialEdgeInsetsToValue(.Square2)
	public static var titleLabelInsetsRef: UIEdgeInsets = MaterialEdgeInsetsToValue(.Square2)
	public static var detailLabelInsetsRef: UIEdgeInsets = MaterialEdgeInsetsToValue(.Square2)
	public static var leftButtonsInsetsRef: UIEdgeInsets = MaterialEdgeInsetsToValue(.None)
	public static var rightButtonsInsetsRef: UIEdgeInsets = MaterialEdgeInsetsToValue(.None)
	public static var dividerInsetsRef: UIEdgeInsets = UIEdgeInsets(top: 8, left: 0, bottom: 8, right: 0)
	
	// border
	public static var borderWidth: MaterialBorder = .None
	public static var bordercolor: UIColor = MaterialColor.black
	
	// color
	public static var backgroundColor: UIColor = MaterialColor.white
	public static var pulseColor: UIColor = MaterialColor.blueGrey.lighten4
	public static var pulseColorOpacity: CGFloat = 0.25
	
	// interaction
	public static var userInteractionEnabled: Bool = true
	
	// image
	public static var contentsRect: CGRect = CGRectMake(0, 0, 1, 1)
	public static var contentsCenter: CGRect = CGRectMake(0, 0, 1, 1)
	public static var contentsScale: CGFloat = UIScreen.mainScreen().scale
	public static var contentsGravity: MaterialGravity = .ResizeAspectFill
	
	// position
	public static var zPosition: CGFloat = 0
	
	// divider
	public static var divider: Bool = true
	public static var dividerColor: UIColor = MaterialColor.blueGrey.lighten5
}

// imageCardView
public extension MaterialTheme.imageCardView {
	// shadow
	public static var shadowDepth: MaterialDepth = .Depth2
	public static var shadowColor: UIColor = MaterialColor.black
	
	// shape
	public static var contentInsetsRef: UIEdgeInsets = MaterialEdgeInsetsToValue(.Square2)
	public static var titleLabelInsetsRef: UIEdgeInsets = MaterialEdgeInsetsToValue(.Square2)
	public static var detailLabelInsetsRef: UIEdgeInsets = MaterialEdgeInsetsToValue(.Square2)
	public static var leftButtonsInsetsRef: UIEdgeInsets = MaterialEdgeInsetsToValue(.None)
	public static var rightButtonsInsetsRef: UIEdgeInsets = MaterialEdgeInsetsToValue(.None)
	public static var dividerInsetsRef: UIEdgeInsets = UIEdgeInsets(top: 8, left: 0, bottom: 8, right: 0)
	
	// border
	public static var borderWidth: MaterialBorder = .None
	public static var bordercolor: UIColor = MaterialColor.black
	
	// color
	public static var backgroundColor: UIColor = MaterialColor.white
	public static var pulseColor: UIColor = MaterialColor.blueGrey.lighten4
	public static var pulseColorOpacity: CGFloat = 0.25
	
	// interaction
	public static var userInteractionEnabled: Bool = true
	
	// image
	public static var contentsRect: CGRect = CGRectMake(0, 0, 1, 1)
	public static var contentsCenter: CGRect = CGRectMake(0, 0, 1, 1)
	public static var contentsScale: CGFloat = UIScreen.mainScreen().scale
	public static var contentsGravity: MaterialGravity = .ResizeAspectFill
	
	// position
	public static var zPosition: CGFloat = 0
	
	// divider
	public static var divider: Bool = true
	public static var dividerColor: UIColor = MaterialColor.blueGrey.lighten5
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
	public static var shadowColor: UIColor = MaterialColor.black
	
	// shape
	public static var contentInsetsRef: UIEdgeInsets = MaterialEdgeInsetsToValue(.Square2)
	public static var titleLabelInsetsRef: UIEdgeInsets = UIEdgeInsets(top: 8, left: 0, bottom: 0, right: 0)
	public static var detailLabelInsetsRef: UIEdgeInsets = MaterialEdgeInsetsToValue(.None)
	public static var leftButtonsInsetsRef: UIEdgeInsets = UIEdgeInsets(top: 8, left: 0, bottom: 0, right: 0)
	public static var rightButtonsInsetsRef: UIEdgeInsets = UIEdgeInsets(top: 8, left: 0, bottom: 0, right: 0)
	
	// border
	public static var borderWidth: MaterialBorder = .None
	public static var bordercolor: UIColor = MaterialColor.black
	
	// color
	public static var backgroundColor: UIColor = MaterialColor.white
	
	// interaction
	public static var userInteractionEnabled: Bool = true
	
	// image
	public static var contentsRect: CGRect = CGRectMake(0, 0, 1, 1)
	public static var contentsCenter: CGRect = CGRectMake(0, 0, 1, 1)
	public static var contentsScale: CGFloat = UIScreen.mainScreen().scale
	public static var contentsGravity: MaterialGravity = .ResizeAspectFill
	
	// position
	public static var zPosition: CGFloat = 100
}

// captureView
public extension MaterialTheme.captureView {
	// shadow
	public static var shadowDepth: MaterialDepth = .None
	public static var shadowColor: UIColor = MaterialColor.black
	
	// shape
	public static var contentInsetsRef: UIEdgeInsets = MaterialEdgeInsetsToValue(.Square4)
	
	// border
	public static var borderWidth: MaterialBorder = .None
	public static var bordercolor: UIColor = MaterialColor.black
	
	// color
	public static var backgroundColor: UIColor = MaterialColor.black
	
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

// textLayer
public extension MaterialTheme.textLayer {
	// scale
	public static var contentsScale: CGFloat = UIScreen.mainScreen().scale
	
	// alignment
	public static var wrapped: Bool = true
	public static var textAlignment: NSTextAlignment = .Left
	public static var lineBreakMode: NSLineBreakMode = .ByWordWrapping
	
	// font
	public static var font: UIFont = RobotoFont.regular
	
	// color
	public static var textColor: UIColor = MaterialColor.black
}

// label
public extension MaterialTheme.label {
	// scale
	public static var contentsScale: CGFloat = UIScreen.mainScreen().scale
	
	// alignment
	public static var wrapped: Bool = true
	public static var textAlignment: NSTextAlignment = .Left
	
	// font
	public static var font: UIFont = RobotoFont.regular
}

// flatButton
public extension MaterialTheme.flatButton {
	// shadow
	public static var shadowDepth: MaterialDepth = .None
	public static var shadowColor: UIColor = MaterialColor.black
	
	// shape
	public static var cornerRadius: MaterialRadius = .Radius1
	public static var contentInsets: MaterialEdgeInsets = .WideRectangle3
	public static var shape: MaterialShape = .None
	
	// border
	public static var borderWidth: MaterialBorder = .None
	public static var bordercolor: UIColor = MaterialColor.black
	
	// color
	public static var backgroundColor: UIColor = MaterialColor.clear
	public static var pulseColor: UIColor = MaterialColor.blue.accent3
	public static var pulseColorOpacity: CGFloat = 0.25
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
	public static var shadowColor: UIColor = MaterialColor.black
	
	// shape
	public static var cornerRadius: MaterialRadius = .Radius1
	public static var contentInsets: MaterialEdgeInsets = .WideRectangle2
	public static var shape: MaterialShape = .None
	
	// border
	public static var borderWidth: MaterialBorder = .None
	public static var bordercolor: UIColor = MaterialColor.black
	
	// color
	public static var backgroundColor: UIColor = MaterialColor.blue.accent3
	public static var pulseColor: UIColor = MaterialColor.white
	public static var pulseColorOpacity: CGFloat = 0.25
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
	public static var shadowColor: UIColor = MaterialColor.black
	
	// shape
	public static var contentInsets: MaterialEdgeInsets = .None
	public static var shape: MaterialShape = .Circle
	
	// border
	public static var borderWidth: MaterialBorder = .None
	public static var bordercolor: UIColor = MaterialColor.black
	
	// color
	public static var backgroundColor: UIColor = MaterialColor.red.darken1
	public static var pulseColor: UIColor = MaterialColor.white
	public static var pulseColorOpacity: CGFloat = 0.25
	public static var titleLabelColorForNormalState: UIColor = MaterialColor.white
	
	// interaction
	public static var userInteractionEnabled: Bool = true
	
	// position
	public static var zPosition: CGFloat = 200
	
	// font
	public static var titleLabelFont: UIFont = RobotoFont.regular
}
