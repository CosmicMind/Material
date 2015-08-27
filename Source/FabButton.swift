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

public class FabButton : MaterialButton {
	/**
		:name:	lineWidth
	*/
	public var lineWidth: CGFloat = 2.0
	
	//
	//	:name:	prepareButton
	//
	internal override func prepareButton() {
		super.prepareButton()
		color = .redColor()
        pulseColor = .whiteColor()
    }
	
	//
	//	:name:	pulseTouches
	//
	internal override func pulseTouches(touches: Set<NSObject>) {
		super.pulseTouches(touches)
		let touch = touches.first as! UITouch
		let touchLocation = touch.locationInView(self)
		pulseView = UIView()
		pulseView!.frame = CGRectMake(0, 0, bounds.width, bounds.height)
		pulseView!.layer.cornerRadius = bounds.width / 2.0
		pulseView!.center = touchLocation
		pulseView!.backgroundColor = pulseColor?.colorWithAlphaComponent(0.5)
		backgroundColorView.addSubview(pulseView!)
		UIView.animateWithDuration(0.3,
			animations: {
				self.pulseView!.transform = CGAffineTransformMakeScale(3, 3)
				self.transform = CGAffineTransformMakeScale(1.1, 1.1)
			},
			completion: nil
		)
	}
}
