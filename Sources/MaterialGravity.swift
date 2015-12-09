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

public enum MaterialGravity {
	case Center
	case Top
	case Bottom
	case Left
	case Right
	case TopLeft
	case TopRight
	case BottomLeft
	case BottomRight
	case Resize
	case ResizeAspect
	case ResizeAspectFill
}

/**
	:name:	MaterialGravityToString
*/
public func MaterialGravityToString(gravity: MaterialGravity) -> String {
	switch gravity {
	case .Center:
		return kCAGravityCenter
	case .Top:
		return kCAGravityTop
	case .Bottom:
		return kCAGravityBottom
	case .Left:
		return kCAGravityLeft
	case .Right:
		return kCAGravityRight
	case .TopLeft:
		return kCAGravityBottomLeft
	case .TopRight:
		return kCAGravityBottomRight
	case .BottomLeft:
		return kCAGravityTopLeft
	case .BottomRight:
		return kCAGravityTopRight
	case .Resize:
		return kCAGravityResize
	case .ResizeAspect:
		return kCAGravityResizeAspect
	case .ResizeAspectFill:
		return kCAGravityResizeAspectFill
	}
}