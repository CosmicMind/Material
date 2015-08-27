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

public class RaisedButton : MaterialButton {
	/**
		:name:	pulseTitleColor
	*/
	public var pulseTitleColor: UIColor?
	
	/**
		:name:	titleColor
	*/
	public var titleColor: UIColor? {
		didSet {
			setTitleColor(titleColor, forState: .Normal)
		}
	}
	
	//
	//	:name:	prepareButton
	//
	internal override func prepareButton() {
		super.prepareButton()
		pulseColor = .whiteColor()
		backgroundColorView.layer.cornerRadius = 3
	}
	
	//
	//	:name:	pulseTouches
	//
	internal override func pulseTouches(touches: Set<NSObject>) {
		super.pulseTouches(touches)
		UIView.animateWithDuration(0.3, animations: {
			self.pulseView!.transform = CGAffineTransformMakeScale(10, 10)
			self.transform = CGAffineTransformMakeScale(1.05, 1.1)
			if let c = self.pulseTitleColor {
				self.setTitleColor(c, forState: .Normal)
			}
		}) { _ in
			if let c = self.titleColor {
				UIView.animateWithDuration(0.3, animations: {
					self.setTitleColor(c, forState: .Normal)
				})
			}
		}
	}
}

