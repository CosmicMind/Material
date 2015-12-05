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


// Code extracted from ContentKit for example usage.
public extension UIImage {
	/**
	:name:	width
	*/
	public var width: CGFloat {
		return size.width
	}
	
	/**
	:name:	height
	*/
	public var height: CGFloat {
		return size.height
	}
	
	/**
	:name:	internalResize
	*/
	private func internalResize(var toWidth w: CGFloat = 0, var toHeight h: CGFloat = 0) -> UIImage? {
		if 0 < w {
			h = height * w / width
		} else if 0 < h {
			w = width * h / height
		}
		
		let g: UIImage?
		let t: CGRect = CGRectMake(0, 0, w, h)
		UIGraphicsBeginImageContext(t.size)
		drawInRect(t, blendMode: .Normal, alpha: 1)
		g = UIGraphicsGetImageFromCurrentImageContext()
		UIGraphicsEndImageContext()
		
		return g
	}
	
	/**
	:name:	resize
	*/
	public func resize(toWidth w: CGFloat) -> UIImage? {
		return internalResize(toWidth: w)
	}
	
	/**
	:name:	resize
	*/
	public func resize(toHeight h: CGFloat) -> UIImage? {
		return internalResize(toHeight: h)
	}
}
