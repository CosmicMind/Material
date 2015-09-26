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

public enum MaterialBorder : MaterialBorderType {
	case None
	case Thin
	case Light
	case Regular
	case Medium
	case Thick
}

/**
	:name:	MaterialBorderToValue
*/
public func MaterialBorderToValue(width: MaterialBorder) -> MaterialBorderType {
	switch width {
	case .None:
		return 0
	case .Thin:
		return 0.5
	case .Light:
		return 1
	case .Regular:
		return 2
	case .Medium:
		return 3
	case .Thick:
		return 4
	}
}
