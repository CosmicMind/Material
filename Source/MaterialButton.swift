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
		:name:	backgroundColor
	*/
	public override var backgroundColor: UIColor? {
		get {
			return backgroundColorView.backgroundColor
		}
		set(value) {
			backgroundColorView.backgroundColor = value
		}
	}
	
	/**
		:name:	pulseColor
	*/
	public var pulseColor: UIColor? = MaterialTheme.indigo.lighten3
	
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
		pulseBegan(touches, withEvent: event)
	}
	
	/**
		:name:	touchesEnded
	*/
	public override func touchesEnded(touches: Set<NSObject>, withEvent event: UIEvent) {
		super.touchesEnded(touches, withEvent: event)
		shrink()
		pulseEnded(touches, withEvent: event)
	}
	
	/**
		:name:	touchesCancelled
	*/
	public override func touchesCancelled(touches: Set<NSObject>!, withEvent event: UIEvent!) {
		super.touchesCancelled(touches, withEvent: event)
		shrink()
		pulseEnded(touches, withEvent: event)
	}
	
	/**
		:name:	drawRect
	*/
	final public override func drawRect(rect: CGRect) {
		prepareContext(rect)
		prepareBackgroundColorView()
		prepareButton()
	}
	
	//
	//	:name:	prepareView
	//
	internal func prepareView() {
		setTranslatesAutoresizingMaskIntoConstraints(false)
	}
	
	//
	//	:name:	prepareButton
	//
	internal func prepareButton() {}
	
	//
	//	:name:	prepareShadow
	//
	internal func prepareShadow() {
		layer.shadowColor = MaterialTheme.black.color.CGColor
		layer.shadowOffset = CGSizeMake(0.5, 0.5)
		layer.shadowOpacity = 0.5
		layer.shadowRadius = 5
	}
	
	//
	//	:name:	pulseBegan
	//
	internal func pulseBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
		pulseView = UIView(frame: CGRectMake(0, 0, bounds.height, bounds.height))
		pulseView!.layer.cornerRadius = bounds.height / 2
		pulseView!.center = (touches.first as! UITouch).locationInView(self)
		pulseView!.backgroundColor = pulseColor?.colorWithAlphaComponent(0.5)
		backgroundColorView.addSubview(pulseView!)
	}
	
	//
	//	:name:	pulseEnded
	//
	internal func pulseEnded(touches: Set<NSObject>, withEvent event: UIEvent) {
		UIView.animateWithDuration(0.3,
			animations: { _ in
				self.pulseView?.alpha = 0
			}
		) { _ in
			self.pulseView?.removeFromSuperview()
			self.pulseView = nil
		}
	}
	
	//
	//	:name:	prepareContext
	//
	private func prepareContext(rect: CGRect) {
		let context = UIGraphicsGetCurrentContext()
		CGContextSaveGState(context);
		CGContextAddEllipseInRect(context, rect)
		CGContextSetFillColorWithColor(context, MaterialTheme.clear.color.CGColor)
		CGContextFillPath(context)
		CGContextRestoreGState(context);
	}
	
	//
	//	:name: prepareBackgroundColorView
	//
	private func prepareBackgroundColorView() {
		backgroundColorView.setTranslatesAutoresizingMaskIntoConstraints(false)
		backgroundColorView.layer.masksToBounds = true
		backgroundColorView.clipsToBounds = true
		backgroundColorView.userInteractionEnabled = false
		insertSubview(backgroundColorView, atIndex: 0)
		Layout.expandToParent(self, child: backgroundColorView)
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
}
