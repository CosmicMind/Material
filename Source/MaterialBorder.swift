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

public typealias MaterialBorderType = CGFloat

public enum MaterialBorder {
	case Border0
	case Border1
	case Border2
	case Border3
	case Border4
}

/**
	:name:	MaterialBorderToValue
*/
public func MaterialBorderToValue(border: MaterialBorder) -> MaterialBorderType {
	switch border {
	case .Border0:
		return 0
	case .Border1:
		return 0.5
	case .Border2:
		return 1
	case .Border3:
		return 2
	case .Border4:
		return 3
	}
}
