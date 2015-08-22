//
// Copyright (C) 2015 Adam Dahan <https://github.com/adamdahan>.
// Copyright (C) 2015 Daniel Dahan <https://github.com/danieldahan>.
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

extension UIView {
	
	func frameW() -> CGFloat {
		return self.frame.size.width
	}
	
	func frameH() -> CGFloat {
		return self.frame.size.height
	}
	
	func frameX() -> CGFloat {
		return self.frame.origin.x
	}
	
	func frameY() -> CGFloat {
		return self.frame.origin.y
	}
	
	func boundsW() -> CGFloat {
		return self.bounds.size.width
	}
	
	func boundsH() -> CGFloat {
		return self.bounds.size.height
	}
	
	func boundsX() -> CGFloat {
		return self.bounds.origin.x
	}
	
	func boundsY() -> CGFloat {
		return self.bounds.origin.y
	}
	
}
