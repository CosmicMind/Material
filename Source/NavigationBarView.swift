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

public class NavigationBarView: MaterialView {
	/**
		:name:	lightContentStatusBar
	*/
	public var lightContentStatusBar: Bool = MaterialTheme.navigation.lightContentStatusBar {
		didSet {
			UIApplication.sharedApplication().setStatusBarStyle(lightContentStatusBar ? .LightContent : .Default, animated: true)
		}
	}
	
	/**
		:name:	init
	*/
	public convenience init() {
		self.init(frame: CGRectMake(MaterialTheme.navigation.x, MaterialTheme.navigation.y, MaterialTheme.navigation.width, MaterialTheme.navigation.height))
		prepareView()
		prepareLayer()
		prepareBounds()
	}
	
	/**
		:name:	prepareView
	*/
	internal override func prepareView() {
		userInteractionEnabled = MaterialTheme.navigation.userInteractionEnabled
		backgroundColor = MaterialTheme.navigation.backgroudColor
		lightContentStatusBar = MaterialTheme.navigation.lightContentStatusBar
	}
	
	/**
		:name:	prepareLayer
	*/
	internal override func prepareLayer() {
		contentsRect = MaterialTheme.navigation.contentsRect
		contentsCenter = MaterialTheme.navigation.contentsCenter
		contentsScale = MaterialTheme.navigation.contentsScale
		contentsGravity = MaterialTheme.navigation.contentsGravity
		shadowColor = MaterialTheme.navigation.shadowColor
		shadowOffset = MaterialTheme.navigation.shadowOffset
		shadowOpacity = MaterialTheme.navigation.shadowOpacity
		shadowRadius = MaterialTheme.navigation.shadowRadius
		masksToBounds = MaterialTheme.navigation.masksToBounds
	}
}
