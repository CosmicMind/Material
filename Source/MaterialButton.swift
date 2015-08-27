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
	//
	//	:name:	backgroundColorView
	//
	internal lazy var backgroundColorView: UIView = UIView()
	
	//
	//	:name:	pulseView
	//
	internal var pulseView: UIView?
	
	/**
		:name:	color
	*/
	public var color: UIColor?
	
	/**
		:name:	pulseColor
	*/
	public var pulseColor: UIColor?
	
	/**
		:name:	init
	*/
	public required init(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		prepareView()
	}
	
	/**
		:name:	init
	*/
	public required override init(frame: CGRect) {
		super.init(frame: frame)
		prepareView()
	}
	
	/**
		:name:	init
	*/
	public convenience init() {
		self.init(frame: CGRectZero)
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
	
	/**
		:name:	drawRect
	*/
	final public override func drawRect(rect: CGRect) {
		prepareContext(rect)
		prepareShadow()
		prepareButton()
		prepareBackgroundColorView()
	}
	
	//
	//	:name:	prepareButton
	//
	internal func prepareButton() {
		backgroundColorView.frame = bounds
	}
	
	//
	//	:name:	pulseTouches
	//
	internal func pulseTouches(touches: Set<NSObject>) {
		let touch = touches.first as! UITouch
		let touchLocation = touch.locationInView(self)
		pulseView = UIView()
		pulseView!.frame = CGRectMake(0, 0, bounds.width, bounds.height)
		pulseView!.layer.cornerRadius = bounds.width / 2
		pulseView!.center = touchLocation
		pulseView!.backgroundColor = pulseColor?.colorWithAlphaComponent(0.5)
		backgroundColorView.addSubview(pulseView!)
	}
	
	//
	//	:name: prepareBackgroundColorView
	//
	// We need this view so we can use the masksToBounds
	// so the pulse doesn't animate off the button
	private func prepareBackgroundColorView() {
		backgroundColorView.backgroundColor = color
		backgroundColorView.layer.masksToBounds = true
		backgroundColorView.userInteractionEnabled = false
		insertSubview(backgroundColorView, atIndex: 0)
	}
	
	//
	//	:name:	prepareView
	//
	private func prepareView() {
		setTranslatesAutoresizingMaskIntoConstraints(false)
	}
	
	//
	//	:name:	prepareShadow
	//
	private func prepareShadow() {
		layer.shadowOffset = CGSizeMake(1, 1)
		layer.shadowColor = UIColor.blackColor().CGColor
		layer.shadowOpacity = 0.5
		layer.shadowRadius = 5
	}
	
	//
	//	:name:	prepareContext
	//
	private func prepareContext(rect: CGRect) {
		let context = UIGraphicsGetCurrentContext()
		CGContextSaveGState(context);
		CGContextAddEllipseInRect(context, rect)
		CGContextSetFillColorWithColor(context, UIColor.clearColor().CGColor)
		CGContextFillPath(context)
		CGContextRestoreGState(context);
	}
	
	//
	//	:name:	shrink
	//
	private func shrink() {
		UIView.animateWithDuration(0.3,
			delay: 0,
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
	private func removePulse() {
		UIView.animateWithDuration(0.3,
			animations: { _ in
				self.pulseView?.alpha = 0
			}
		) { _ in
			self.pulseView?.removeFromSuperview()
			self.pulseView = nil
		}
	}
}
