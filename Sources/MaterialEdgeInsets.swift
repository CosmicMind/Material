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

public enum MaterialEdgeInsets {
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
	case WideRectangle1
	case WideRectangle2
	case WideRectangle3
	case WideRectangle4
	case WideRectangle5
	case WideRectangle6
	case WideRectangle7
	case WideRectangle8
	case WideRectangle9
	
	// flipped rectangle
	case TallRectangle1
	case TallRectangle2
	case TallRectangle3
	case TallRectangle4
	case TallRectangle5
	case TallRectangle6
	case TallRectangle7
	case TallRectangle8
	case TallRectangle9
}

/**
	:name:	MaterialEdgeInsetsToValue
*/
public func MaterialEdgeInsetsToValue(inset: MaterialEdgeInsets) -> UIEdgeInsets {
	switch inset {
	case .None:
		return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
	
	// square
	case .Square1:
		return UIEdgeInsets(top: 4, left: 4, bottom: 4, right: 4)
	case .Square2:
		return UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
	case .Square3:
		return UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
	case .Square4:
		return UIEdgeInsets(top: 24, left: 24, bottom: 24, right: 24)
	case .Square5:
		return UIEdgeInsets(top: 32, left: 32, bottom: 32, right: 32)
	case .Square6:
		return UIEdgeInsets(top: 40, left: 40, bottom: 40, right: 40)
	case .Square7:
		return UIEdgeInsets(top: 48, left: 48, bottom: 48, right: 48)
	case .Square8:
		return UIEdgeInsets(top: 56, left: 56, bottom: 56, right: 56)
	case .Square9:
		return UIEdgeInsets(top: 64, left: 64, bottom: 64, right: 64)
	
	// rectangle
	case .WideRectangle1:
		return UIEdgeInsets(top: 2, left: 4, bottom: 2, right: 4)
	case .WideRectangle2:
		return UIEdgeInsets(top: 4, left: 8, bottom: 4, right: 8)
	case .WideRectangle3:
		return UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 16)
	case .WideRectangle4:
		return UIEdgeInsets(top: 12, left: 24, bottom: 12, right: 24)
	case .WideRectangle5:
		return UIEdgeInsets(top: 16, left: 32, bottom: 16, right: 32)
	case .WideRectangle6:
		return UIEdgeInsets(top: 20, left: 40, bottom: 20, right: 40)
	case .WideRectangle7:
		return UIEdgeInsets(top: 24, left: 48, bottom: 24, right: 48)
	case .WideRectangle8:
		return UIEdgeInsets(top: 28, left: 56, bottom: 28, right: 56)
	case .WideRectangle9:
		return UIEdgeInsets(top: 32, left: 64, bottom: 32, right: 64)
		
	// flipped rectangle
	case .TallRectangle1:
		return UIEdgeInsets(top: 4, left: 2, bottom: 4, right: 2)
	case .TallRectangle2:
		return UIEdgeInsets(top: 8, left: 4, bottom: 8, right: 4)
	case .TallRectangle3:
		return UIEdgeInsets(top: 16, left: 8, bottom: 16, right: 8)
	case .TallRectangle4:
		return UIEdgeInsets(top: 24, left: 12, bottom: 24, right: 12)
	case .TallRectangle5:
		return UIEdgeInsets(top: 32, left: 16, bottom: 32, right: 16)
	case .TallRectangle6:
		return UIEdgeInsets(top: 40, left: 20, bottom: 40, right: 20)
	case .TallRectangle7:
		return UIEdgeInsets(top: 48, left: 24, bottom: 48, right: 24)
	case .TallRectangle8:
		return UIEdgeInsets(top: 56, left: 28, bottom: 56, right: 28)
	case .TallRectangle9:
		return UIEdgeInsets(top: 64, left: 32, bottom: 64, right: 32)
	}
}
