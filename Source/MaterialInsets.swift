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

public typealias MaterialInsetsType = (top: CGFloat, left: CGFloat, bottom: CGFloat, right: CGFloat)

public enum MaterialInsets {
	case None
	
	// square
	case Square1
	case Square2
	case Square3
	case Square4
	case Square5
	case Square6
	case Square7
	case Square8
	case Square9
	
	// rectangle
	case Rectangle1
	case Rectangle2
	case Rectangle3
	case Rectangle4
	case Rectangle5
	case Rectangle6
	case Rectangle7
	case Rectangle8
	case Rectangle9
	
	// flipped rectangle
	case FlippedRectangle1
	case FlippedRectangle2
	case FlippedRectangle3
	case FlippedRectangle4
	case FlippedRectangle5
	case FlippedRectangle6
	case FlippedRectangle7
	case FlippedRectangle8
	case FlippedRectangle9
}

/**
	:name:	MaterialInsetsToValue
*/
public func MaterialInsetsToValue(inset: MaterialInsets) -> MaterialInsetsType {
	switch inset {
		
	// square
	case .None:
		return (top: 0, left: 0, bottom: 0, right: 0)
	case .Square1:
		return (top: 4, left: 4, bottom: 4, right: 4)
	case .Square2:
		return (top: 8, left: 8, bottom: 8, right: 8)
	case .Square3:
		return (top: 16, left: 16, bottom: 16, right: 16)
	case .Square4:
		return (top: 24, left: 24, bottom: 24, right: 24)
	case .Square5:
		return (top: 32, left: 32, bottom: 32, right: 32)
	case .Square6:
		return (top: 40, left: 40, bottom: 40, right: 40)
	case .Square7:
		return (top: 48, left: 48, bottom: 48, right: 48)
	case .Square8:
		return (top: 56, left: 56, bottom: 56, right: 56)
	case .Square9:
		return (top: 64, left: 64, bottom: 64, right: 64)
	
	// rectangle
	case .Rectangle1:
		return (top: 2, left: 4, bottom: 2, right: 4)
	case .Rectangle2:
		return (top: 4, left: 8, bottom: 4, right: 8)
	case .Rectangle3:
		return (top: 8, left: 16, bottom: 8, right: 16)
	case .Rectangle4:
		return (top: 12, left: 24, bottom: 12, right: 24)
	case .Rectangle5:
		return (top: 16, left: 32, bottom: 16, right: 32)
	case .Rectangle6:
		return (top: 20, left: 40, bottom: 20, right: 40)
	case .Rectangle7:
		return (top: 24, left: 48, bottom: 24, right: 48)
	case .Rectangle8:
		return (top: 28, left: 56, bottom: 28, right: 56)
	case .Rectangle9:
		return (top: 32, left: 64, bottom: 32, right: 64)
		
	// flipped rectangle
	case .FlippedRectangle1:
		return (top: 4, left: 2, bottom: 4, right: 2)
	case .FlippedRectangle2:
		return (top: 8, left: 4, bottom: 8, right: 4)
	case .FlippedRectangle3:
		return (top: 16, left: 8, bottom: 16, right: 8)
	case .FlippedRectangle4:
		return (top: 24, left: 12, bottom: 24, right: 12)
	case .FlippedRectangle5:
		return (top: 32, left: 16, bottom: 32, right: 16)
	case .FlippedRectangle6:
		return (top: 40, left: 20, bottom: 40, right: 20)
	case .FlippedRectangle7:
		return (top: 48, left: 24, bottom: 48, right: 24)
	case .FlippedRectangle8:
		return (top: 56, left: 28, bottom: 56, right: 28)
	case .FlippedRectangle9:
		return (top: 64, left: 32, bottom: 64, right: 32)
	}
}
