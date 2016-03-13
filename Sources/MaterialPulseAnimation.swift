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

internal extension MaterialAnimation {
	/**
	Triggers the pulse animation.
	- Parameter layer: Container CALayer.
	- Parameter visualLayer: A CAShapeLayer for the pulseLayer.
	- Parameter color: The UIColor for the pulse.
	- Parameter point: A point to pulse from.
	- Parameter width: Container width.
	- Parameter height: Container height.
	- Parameter duration: Animation duration.
	- Parameter pulseLayer: An Optional pulseLayer to use in the animation.
	*/
	internal static func pulseAnimation(layer: CALayer, visualLayer: CALayer, color: UIColor, point: CGPoint, width: CGFloat, height: CGFloat, duration: NSTimeInterval, var pulseLayer: CAShapeLayer? = nil) {
		
		let r: CGFloat = (width < height ? height : width) / 2
		let f: CGFloat = 3
		let v: CGFloat = r / f
		let d: CGFloat = 2 * f
		
		var b: Bool = false
		
		if nil == pulseLayer {
			pulseLayer = CAShapeLayer()
			b = true
		}
		
		pulseLayer!.hidden = true
		pulseLayer!.zPosition = 1
		pulseLayer!.backgroundColor = color.CGColor
		visualLayer.addSublayer(pulseLayer!)
		
		MaterialAnimation.animationDisabled {
			pulseLayer!.bounds = CGRectMake(0, 0, v, v)
			pulseLayer!.position = point
			pulseLayer!.cornerRadius = r / d
			pulseLayer!.hidden = false
		}
		
		pulseLayer!.addAnimation(MaterialAnimation.scale((b ? 3 : 1.7) * d, duration: duration), forKey: nil)
		
		if b {
			MaterialAnimation.delay(duration) {
				MaterialAnimation.animateWithDuration(duration, animations: {
					pulseLayer?.hidden = true
				}) {
					pulseLayer?.removeFromSuperlayer()
				}
			}
		} else {
			MaterialAnimation.delay(duration / 2) {
				pulseLayer?.addAnimation(MaterialAnimation.scale(1.3 * d, duration: duration), forKey: nil)
			}
		}
	}
	
	/**
	Triggers the expanding animation.
	- Parameter layer: Container CALayer.
	- Parameter scale: The scale factor when expanding.
	- Parameter duration: Animation duration.
	*/
	internal static func expandAnimation(layer: CALayer, scale: CGFloat, duration: NSTimeInterval) {
		layer.addAnimation(MaterialAnimation.scale(scale, duration: duration), forKey: nil)
	}
	
	/**
	Triggers the shrinking animation.
	- Parameter layer: Container CALayer.
	- Parameter width: Container width.
	- Parameter duration: Animation duration.
	- Parameter pulseLayer: An Optional pulseLayer to use in the animation.
	*/
	internal static func shrinkAnimation(layer: CALayer, width: CGFloat, duration: NSTimeInterval, pulseLayer: CAShapeLayer? = nil) {
		if let v: CAShapeLayer = pulseLayer {
			MaterialAnimation.animateWithDuration(duration, animations: {
				v.hidden = true
			}) {
				v.removeFromSuperlayer()
			}
		}
		layer.addAnimation(MaterialAnimation.scale(1, duration: duration), forKey: nil)
	}
	
	/**
	Retrieves the animation duration time.
	- Parameter width: Container width.
	- Returns: An NSTimeInterval value that represents the animation time.
	*/
	internal static func pulseDuration(width: CGFloat) -> NSTimeInterval {
		var t: CFTimeInterval = CFTimeInterval(1.5 * width / MaterialDevice.width)
		if 0.55 < t || 0.25 > t {
			t = 0.55
		}
		return t / 1.3
	}
}