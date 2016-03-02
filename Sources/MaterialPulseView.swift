/*
* Copyright (C) 2015 - 2016, Daniel Dahan and CosmicMind, Inc. <http://cosmicmind.io>.
* All rights reserved.
*
* Redistribution and use in source and binary forms, with or without
* modification, are permitted provided that the following conditions are met:
*
*	*	Redistributions of source code must retain the above copyright notice, this
*		list of conditions and the following disclaimer.
*
*	*	Redistributions in binary form must reproduce the above copyright notice,
*		this list of conditions and the following disclaimer in the documentation
*		and/or other materials provided with the distribution.
*
*	*	Neither the name of Material nor the names of its
*		contributors may be used to endorse or promote products derived from
*		this software without specific prior written permission.
*
* THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
* AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
* IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
* DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE
* FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
* DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
* SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
* CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
* OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
* OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
*/

import UIKit

public class MaterialPulseView : MaterialView {
	/// Sets whether the scaling animation should be used.
	public lazy var pulseScale: Bool = true
	
	/// The opcaity value for the pulse animation.
	public var pulseColorOpacity: CGFloat = 0.25
	
	/// The color of the pulse effect.
	public var pulseColor: UIColor?
	
	/**
	A delegation method that is executed when the view has began a
	touch event.
	- Parameter touches: A set of UITouch objects.
	- Parameter event: A UIEvent object.
	*/
	public override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
		super.touchesBegan(touches, withEvent: event)
		pulseAnimation(layer.convertPoint(touches.first!.locationInView(self), fromLayer: layer))
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
	Triggers the pulse animation.
	- Parameter point: A Optional point to pulse from, otherwise pulses
	from the center.
	*/
	public func pulse(var point: CGPoint? = nil) {
		if nil == point {
			point = CGPointMake(CGFloat(width / 2), CGFloat(height / 2))
		}
		
		if let v: CFTimeInterval = pulseAnimation(point!) {
			MaterialAnimation.delay(v) { [weak self] in
				self?.shrinkAnimation()
			}
		}
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
	}
	
	/**
	Triggers the pulse animation.
	- Parameter point: A point to pulse from.
	- Returns: A Ooptional CFTimeInternal if the point exists within
	the view. The time internal represents the animation time.
	*/
	internal func pulseAnimation(point: CGPoint) -> CFTimeInterval? {
		if true == layer.containsPoint(point) {
			let r: CGFloat = (width < height ? height : width) / 2
			let f: CGFloat = 3
			let v: CGFloat = r / f
			let d: CGFloat = 2 * f
			let s: CGFloat = 1.05
			
			var t: CFTimeInterval = CFTimeInterval(1.5 * width / MaterialDevice.bounds.width)
			if 0.55 < t || 0.25 > t {
				t = 0.55
			}
			t /= 1.3
			
			if nil != pulseColor && 0 < pulseColorOpacity {
				let pulseLayer: CAShapeLayer = CAShapeLayer()
				
				pulseLayer.hidden = true
				pulseLayer.zPosition = 1
				pulseLayer.backgroundColor = pulseColor?.colorWithAlphaComponent(pulseColorOpacity).CGColor
				visualLayer.addSublayer(pulseLayer)
				
				MaterialAnimation.animationDisabled {
					pulseLayer.bounds = CGRectMake(0, 0, v, v)
					pulseLayer.position = point
					pulseLayer.cornerRadius = r / d
					pulseLayer.hidden = false
				}
				pulseLayer.addAnimation(MaterialAnimation.scale(3 * d, duration: t), forKey: nil)
				MaterialAnimation.delay(t) { [weak self] in
					if nil != self && nil != self!.pulseColor && 0 < self!.pulseColorOpacity {
						MaterialAnimation.animateWithDuration(t, animations: {
							pulseLayer.hidden = true
						}) {
							pulseLayer.removeFromSuperlayer()
						}
					}
				}
			}
			
			if pulseScale {
				layer.addAnimation(MaterialAnimation.scale(s, duration: t), forKey: nil)
				return t
			}
		}
		return nil
	}
	
	/// Executes the shrink animation for the pulse effect.
	internal func shrinkAnimation() {
		if pulseScale {
			var t: CFTimeInterval = CFTimeInterval(1.5 * width / MaterialDevice.bounds.width)
			if 0.55 < t || 0.25 > t {
				t = 0.55
			}
			t /= 1.3
			layer.addAnimation(MaterialAnimation.scale(1, duration: t), forKey: nil)
		}
	}
}