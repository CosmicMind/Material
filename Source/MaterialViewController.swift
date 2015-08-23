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

public class MaterialViewController : UIViewController {
	public func topLeft(child: UIView, top: CGFloat, left: CGFloat) {
		Layout.alignFromTopLeft(view, child: child, top: top, left: left)
	}
	
	public func topRight(child: UIView, top: CGFloat, right: CGFloat) {
		Layout.alignFromTopRight(view, child: child, top: top, right: right)
	}
	
	public func bottomLeft(child: UIView, bottom: CGFloat, left: CGFloat) {
		Layout.alignFromBottomLeft(view, child: child, bottom: bottom, left: left)
	}
	
	public func bottomRight(child: UIView, bottom: CGFloat, right: CGFloat) {
		Layout.alignFromBottomRight(view, child: child, bottom: bottom, right: right)
	}
}
