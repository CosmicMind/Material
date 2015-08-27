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

public class MaterialButton : UIButton {
	public var color: UIColor?
	public var pulseColor: UIColor?
	
	internal var pulseView: UIView?
	internal var verticalLine: UIView?
	internal var horizontalLine: UIView?
	internal var backgroundColorView: UIView?
	
	/**
		:name:	init
	*/
	public required init(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		prepareShadow()
	}
	
	/**
		:name:	init
	*/
	public required override init(frame: CGRect) {
		super.init(frame: frame)
		prepareShadow()
	}
	
	/**
		:name:	init
	*/
	public convenience init() {
		self.init(frame: CGRectZero)
	}
	
	func prepareShadow() {
		layer.shadowOffset = CGSizeMake(1, 1)
		layer.shadowColor = UIColor.blackColor().CGColor
		layer.shadowOpacity = 0.5
		layer.shadowRadius = 5
	}
	
	/**
		:name:	touchesBegan
	*/
	public override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
		super.touchesBegan(touches, withEvent: event)
		pulseTouches(touches)
	}
	
	/**
		:name:	touchesEnded
	*/
	public override func touchesEnded(touches: Set<NSObject>, withEvent event: UIEvent) {
		super.touchesEnded(touches, withEvent: event)
		shrink()
		removePulse()
	}
	
	/**
		:name:	touchesCancelled
	*/
	public override func touchesCancelled(touches: Set<NSObject>!, withEvent event: UIEvent!) {
		super.touchesCancelled(touches, withEvent: event)
		shrink()
		removePulse()
	}
	
	//
	//	:name:	pulseTouches
	//
	internal func pulseTouches(touches: NSSet) {
		let touch = touches.allObjects.last as! UITouch
		let touchLocation = touch.locationInView(self)
		pulseView = UIView()
		pulseView!.frame = CGRectMake(0, 0, bounds.width, bounds.height)
		pulseView!.layer.cornerRadius = bounds.width / 2.0
		pulseView!.center = touchLocation
		pulseView!.backgroundColor = pulseColor!.colorWithAlphaComponent(0.5)
		backgroundColorView!.addSubview(pulseView!)
		UIView.animateWithDuration(0.3,
			animations: {
				self.pulseView!.transform = CGAffineTransformMakeScale(3, 3)
				self.transform = CGAffineTransformMakeScale(1.1, 1.1)
			},
			completion: nil
		)
	}
	
	//
	//	:name:	shrink
	//
	internal func shrink() {
		UIView.animateWithDuration(0.3,
			delay: 0.0,
			usingSpringWithDamping: 0.2,
			initialSpringVelocity: 10,
			options: nil,
			animations: {
				self.transform = CGAffineTransformIdentity
			},
			completion: nil
		)
	}
	
	//
	//	:name:	removePulse
	//
	internal func removePulse() {
		UIView.animateWithDuration(0.3,
			animations: { _ in
				self.pulseView?.alpha = 0.0
			}
		) { _ in
			self.pulseView?.removeFromSuperview()
			self.pulseView = nil
		}
	}
}
