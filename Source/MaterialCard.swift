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

public class MaterialCard : UIView {
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
	public var pulseColor: UIColor = MaterialTheme.blueGrey.lighten3
	
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
	
	//
	//	:name:	prepareView
	//
	internal func prepareView() {
		setTranslatesAutoresizingMaskIntoConstraints(false)
		prepareBackgroundColorView()
		prepareCard()
	}
	
	//
	//	:name:	prepareCard
	//
	internal func prepareCard() {}
	
	//
	//	:name:	prepareShadow
	//
    internal func prepareShadow() {
		layer.shadowColor = MaterialTheme.black.color.CGColor
		layer.shadowOffset = CGSizeMake(0.05, 0.05)
		layer.shadowOpacity = 0.1
		layer.shadowRadius = 3
    }
	
	//
	//	:name:	removeShadow
	//
	internal func removeShadow() {
		layer.shadowColor = MaterialTheme.clear.color.CGColor
		layer.shadowOffset = CGSizeMake(0, 0)
		layer.shadowOpacity = 0
		layer.shadowRadius = 0
	}
	
	//
	//	:name:	layoutSubviews
	//
    public override func layoutSubviews() {
        super.layoutSubviews()
		layer.shadowPath = UIBezierPath(rect: bounds).CGPath
    }
    
    //
	//	:name:	pulseBegan
	//
	internal func pulseBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
		let width: CGFloat = bounds.size.width / 3
		pulseView = UIView(frame: CGRectMake(0, 0, width, width))
		pulseView!.layer.cornerRadius = width / 2
		pulseView!.center = (touches.first as! UITouch).locationInView(self)
		pulseView!.backgroundColor = pulseColor.colorWithAlphaComponent(0.5)
		backgroundColorView.addSubview(pulseView!)
        UIView.animateWithDuration(0.3, animations: {
			self.pulseView!.transform = CGAffineTransformMakeScale(3, 3)
			self.transform = CGAffineTransformMakeScale(1.05, 1.05)
        }, completion: nil)
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
	//	:name: prepareBackgroundColorView
	//
	// We need this view so we can use the masksToBounds
	// so the pulse doesn't animate off the button
	private func prepareBackgroundColorView() {
		backgroundColorView.setTranslatesAutoresizingMaskIntoConstraints(false)
		backgroundColorView.layer.cornerRadius = 2
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
