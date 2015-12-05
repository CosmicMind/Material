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

public typealias MaterialDepthType = (offset: CGSize, opacity: Float, radius: CGFloat)

public enum MaterialDepth {
	case None
	case Depth1
	case Depth2
	case Depth3
	case Depth4
	case Depth5
}

/**
	:name:	MaterialDepthToValue
*/
public func MaterialDepthToValue(depth: MaterialDepth) -> MaterialDepthType {
	switch depth {
	case .None:
		return (offset: CGSizeZero, opacity: 0, radius: 0)
	case .Depth1:
		return (offset: CGSizeMake(0.2, 0.2), opacity: 0.5, radius: 1)
	case .Depth2:
		return (offset: CGSizeMake(0.4, 0.4), opacity: 0.5, radius: 2)
	case .Depth3:
		return (offset: CGSizeMake(0.6, 0.6), opacity: 0.5, radius: 3)
	case .Depth4:
		return (offset: CGSizeMake(0.8, 0.8), opacity: 0.5, radius: 4)
	case .Depth5:
		return (offset: CGSizeMake(1, 1), opacity: 0.5, radius: 5)
	}
}
