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
	/// To use a single pulse and have it focused when held.
	@IBInspectable public var pulseFocus: Bool = false
	
	/// A pulse layer for focus handling.
	public private(set) var pulseLayer: CAShapeLayer?
	
	/// Sets whether the scaling animation should be used.
	@IBInspectable public lazy var pulseScale: Bool = true
	
	/// The opcaity value for the pulse animation.
	@IBInspectable public var pulseOpacity: CGFloat = 0.25
	
	/// The color of the pulse effect.
	@IBInspectable public var pulseColor: UIColor?
	
	/**
	Triggers the pulse animation.
	- Parameter point: A Optional point to pulse from, otherwise pulses
	from the center.
	*/
	public func pulse(point: CGPoint? = nil) {
		let p: CGPoint = nil == point ? CGPointMake(CGFloat(width / 2), CGFloat(height / 2)) : point!
		let duration: NSTimeInterval = MaterialAnimation.pulseDuration(width)
		
		if let v: UIColor = pulseColor {
			MaterialAnimation.pulseAnimation(layer, visualLayer: visualLayer, color: v.colorWithAlphaComponent(pulseOpacity), point: p, width: width, height: height, duration: duration)
		}
		
		if pulseScale {
			MaterialAnimation.expandAnimation(layer, scale: 1.05, duration: duration)
			MaterialAnimation.delay(duration) { [weak self] in
				if let l: CALayer = self?.layer {
					if let w: CGFloat = self?.width {
						MaterialAnimation.shrinkAnimation(l, width: w, duration: duration)
					}
				}
			}
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
		let duration: NSTimeInterval = MaterialAnimation.pulseDuration(width)
		
		if pulseFocus {
			pulseLayer = CAShapeLayer()
		}
		
		if let v: UIColor = pulseColor {
			MaterialAnimation.pulseAnimation(layer, visualLayer: visualLayer, color: v.colorWithAlphaComponent(pulseOpacity), point: layer.convertPoint(touches.first!.locationInView(self), fromLayer: layer), width: width, height: height, duration: duration, pulseLayer: pulseLayer)
		}
		
		if pulseScale {
			MaterialAnimation.expandAnimation(layer, scale: 1.05, duration: duration)
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
		MaterialAnimation.shrinkAnimation(layer, width: width, duration: MaterialAnimation.pulseDuration(width), pulseLayer: pulseLayer)
	}
	
	/**
	A delegation method that is executed when the view touch event has
	been cancelled.
	- Parameter touches: A set of UITouch objects.
	- Parameter event: A UIEvent object.
	*/
	public override func touchesCancelled(touches: Set<UITouch>?, withEvent event: UIEvent?) {
		super.touchesCancelled(touches, withEvent: event)
		MaterialAnimation.shrinkAnimation(layer, width: width, duration: MaterialAnimation.pulseDuration(width), pulseLayer: pulseLayer)
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
}
