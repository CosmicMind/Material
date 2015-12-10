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

public extension UIFont {
	/**
	:name:	stringSize
	*/
	public func stringSize(string: String, constrainedToWidth width: Double) -> CGSize {
		return string.boundingRectWithSize(CGSize(width: width, height: DBL_MAX),
			options: NSStringDrawingOptions.UsesLineFragmentOrigin,
			attributes: [NSFontAttributeName: self],
			context: nil).size
	}
}
