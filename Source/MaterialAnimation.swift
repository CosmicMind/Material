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

public struct MaterialAnimation {
	/**
		:name:	spin
	*/
	public static func spin(view: UIView, duration: CFTimeInterval = 1, rotations: Int = 1, completion: (() -> Void)? = nil) {
		let a: CABasicAnimation = CABasicAnimation()
		a.keyPath = "transform.rotation"
		a.duration = duration
		a.byValue = M_PI * 2 * Double(rotations)
		view.layer.addAnimation(a, forKey: nil)
	}
}
