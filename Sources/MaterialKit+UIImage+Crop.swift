//
// Copyright (C) 2015 - 2016 CosmicMind, Inc. <http://cosmicmind.io>. All rights reserved.
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

public extension UIImage {
	/**
		:name:	crop
	*/
	public func crop(var toWidth w: CGFloat, var toHeight h: CGFloat) -> UIImage? {
		let g: UIImage?
		let b: Bool = width > height
		let s: CGFloat = b ? h / height : w / width
		let t: CGSize = CGSizeMake(w, h)
		
		w = width * s
		h = height * s
		
		UIGraphicsBeginImageContext(t)
		drawInRect(b ? CGRectMake(-1 * (w - t.width) / 2, 0, w, h) : CGRectMake(0, -1 * (h - t.height) / 2, w, h), blendMode: .Normal, alpha: 1)
		g = UIGraphicsGetImageFromCurrentImageContext()
		UIGraphicsEndImageContext()
		
		return g!
	}
}