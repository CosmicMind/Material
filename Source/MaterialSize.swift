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

public typealias MaterialSizeType = CGFloat

public enum MaterialSize {
	case Size0
	case Size1
	case Size2
	case Size3
	case Size4
}

/**
	:name:	MaterialSizeToValue
*/
public func MaterialSizeToValue(size: MaterialSize) -> MaterialSizeType {
	switch size {
	case .Size0:
		return 0
	case .Size1:
		return 0.5
	case .Size2:
		return 1
	case .Size3:
		return 2
	case .Size4:
		return 3
	}
}
