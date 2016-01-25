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