//
// Copyright (C) 2015 - 2016 CosmicMind, Inc. <http://cosmicmind.io>. All rights reserved. 
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

public class MaterialPulseView : MaterialView {
	/// A CAShapeLayer used in the pulse animation.
	public private(set) lazy var pulseLayer: CAShapeLayer = CAShapeLayer()
	
	/// Sets whether the scaling animation should be used.
	public lazy var pulseScale: Bool = true
	
	/// Enables and disables the spotlight effect.
	public var spotlight: Bool = false {
		didSet {
			if spotlight {
				pulseFill = false
			}
		}
	}
	
	/**
	Determines if the pulse animation should fill the entire 
	view.
	*/
	public var pulseFill: Bool = false {
		didSet {
			if pulseFill {
				spotlight = false
			}
		}
	}
	
	/// The opcaity value for the pulse animation.
	public var pulseColorOpacity: CGFloat = 0.25 {
		didSet {
			updatePulseLayer()
		}
	}
	
	/// The color of the pulse effect.
	public var pulseColor: UIColor? {
		didSet {
			updatePulseLayer()
		}
	}
	
	/**
	A delegation method that is executed when the view has began a
	touch event.
	- Parameter touches: A set of UITouch objects.
	- Parameter event: A UIEvent object.
	*/
	public override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
		super.touchesBegan(touches, withEvent: event)
		let point: CGPoint = layer.convertPoint(touches.first!.locationInView(self), fromLayer: layer)
		if true == layer.containsPoint(point) {
			let r: CGFloat = (width < height ? height : width) / 2
			let f: CGFloat = 3
			let v: CGFloat = r / f
			let d: CGFloat = 2 * f
			let s: CGFloat = 1.05
			let t: CFTimeInterval = 0.25
			
			if nil != pulseColor && 0 < pulseColorOpacity {
				MaterialAnimation.animationDisabled {
					self.pulseLayer.bounds = CGRectMake(0, 0, v, v)
					self.pulseLayer.position = point
					self.pulseLayer.cornerRadius = r / d
					self.pulseLayer.hidden = false
				}
				pulseLayer.addAnimation(MaterialAnimation.scale(pulseFill ? 3 * d : d, duration: t), forKey: nil)
			}
			
			if pulseScale {
				layer.addAnimation(MaterialAnimation.scale(s, duration: t), forKey: nil)
			}
		}
	}
	
	/**
	A delegation method that is executed when the view touch event is
	moving.
	- Parameter touches: A set of UITouch objects.
	- Parameter event: A UIEvent object.
	*/
	public override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
		super.touchesMoved(touches, withEvent: event)
		if spotlight {
			let point: CGPoint = layer.convertPoint(touches.first!.locationInView(self), fromLayer: layer)
			if layer.containsPoint(point) {
				MaterialAnimation.animationDisabled {
					self.pulseLayer.position = point
				}
			}
		}
	}
	
	/**
	A delegation method that is executed when the view touch event has
	ended.
	- Parameter touches: A set of UITouch objects.
	- Parameter event: A UIEvent object.
	*/
	public override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
		super.touchesEnded(touches, withEvent: event)
		shrinkAnimation()
	}
	
	/**
	A delegation method that is executed when the view touch event has
	been cancelled.
	- Parameter touches: A set of UITouch objects.
	- Parameter event: A UIEvent object.
	*/
	public override func touchesCancelled(touches: Set<UITouch>?, withEvent event: UIEvent?) {
		super.touchesCancelled(touches, withEvent: event)
		shrinkAnimation()
	}
	
	/**
	Prepares the view instance when intialized. When subclassing,
	it is recommended to override the prepareView method
	to initialize property values and other setup operations.
	The super.prepareView method should always be called immediately
	when subclassing.
	*/
	public override func prepareView() {
		super.prepareView()
		pulseColor = MaterialColor.white
		preparePulseLayer()
	}
	
	/// Prepares the pulseLayer property.
	internal func preparePulseLayer() {
		pulseLayer.hidden = true
		pulseLayer.zPosition = 1
		visualLayer.addSublayer(pulseLayer)
	}
	
	/// Updates the pulseLayer when settings have changed.
	internal func updatePulseLayer() {
		pulseLayer.backgroundColor = pulseColor?.colorWithAlphaComponent(pulseColorOpacity).CGColor
	}
	
	/// Executes the shrink animation for the pulse effect.
	internal func shrinkAnimation() {
		let t: CFTimeInterval = 0.25
		let s: CGFloat = 1
		
		if nil != pulseColor && 0 < pulseColorOpacity {
			MaterialAnimation.animateWithDuration(t, animations: {
				self.pulseLayer.hidden = true
			})
			pulseLayer.addAnimation(MaterialAnimation.scale(s, duration: t), forKey: nil)
		}
		
		if pulseScale {
			layer.addAnimation(MaterialAnimation.scale(s, duration: t), forKey: nil)
		}
	}
}