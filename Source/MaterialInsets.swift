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
	case Inset0
	case Inset1
	case Inset2
	case Inset3
	case Inset4
	case Inset5
}

/**
	:name:	MaterialInsetsToValue
*/
public func MaterialInsetsToValue(inset: MaterialInsets) -> MaterialInsetsType {
	switch inset {
	case .Inset0:
		return (top: 0, left: 0, bottom: 0, right: 0)
	case .Inset1:
		return (top: 4, left: 4, bottom: 4, right: 4)
	case .Inset2:
		return (top: 8, left: 8, bottom: 8, right: 8)
	case .Inset3:
		return (top: 12, left: 12, bottom: 12, right: 12)
	case .Inset4:
		return (top: 16, left: 16, bottom: 16, right: 16)
	case .Inset5:
		return (top: 20, left: 18, bottom: 20, right: 20)
	}
}
