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
	Triggers the expanding animation.
	- Parameter layer: Container CALayer.
	- Parameter visualLayer: A CAShapeLayer for the pulseLayer.
	- Parameter pulseColor: The UIColor for the pulse.
	- Parameter point: A point to pulse from.
	- Parameter width: Container width.
	- Parameter height: Container height.
	- Parameter duration: Animation duration.
	- Parameter pulseLayers: An Array of CAShapeLayers used in the animation.
	*/
	internal static func pulseExpandAnimation(layer: CALayer, visualLayer: CALayer, pulseColor: UIColor?, pulseOpacity: CGFloat, point: CGPoint, width: CGFloat, height: CGFloat, inout pulseLayers: Array<CAShapeLayer>) {
		if let color: UIColor = pulseColor {
			if let n: CGFloat = width < height ? height : width {
				if let pOpacity: CGFloat = pulseOpacity {
					let bLayer: CAShapeLayer = CAShapeLayer()
					let pLayer: CAShapeLayer = CAShapeLayer()
					bLayer.addSublayer(pLayer)
					pulseLayers.insert(bLayer, atIndex: 0)
					visualLayer.insertSublayer(bLayer, atIndex: 0)
					MaterialAnimation.animationDisabled({
						bLayer.frame = visualLayer.bounds
						pLayer.bounds = CGRectMake(0, 0, n, n)
						pLayer.position = point
						pLayer.cornerRadius = n / 2
						pLayer.backgroundColor = color.colorWithAlphaComponent(pOpacity).CGColor
						pLayer.transform = CATransform3DMakeAffineTransform(CGAffineTransformMakeScale(0, 0))
					})
					bLayer.setValue(false, forKey: "animated")
					bLayer.addAnimation(MaterialAnimation.backgroundColor(color.colorWithAlphaComponent(pOpacity / 2), duration: 0.35), forKey: nil)
					pLayer.addAnimation(MaterialAnimation.scale(1, duration: 0.35), forKey: nil)
					MaterialAnimation.delay(0.35, completion: {
						bLayer.setValue(true, forKey: "animated")
					})
				}
			}
		}
	}
	
	/**
	Triggers the contracting animation.
	- Parameter layer: Container CALayer.
	- Parameter pulseColor: The UIColor for the pulse.
	- Parameter pulseLayers: An Array of CAShapeLayers used in the animation.
	*/
	internal static func pulseContractAnimation(layer: CALayer, pulseColor: UIColor?, inout pulseLayers: Array<CAShapeLayer>) {
		if let color: UIColor = pulseColor {
			if let bLayer: CAShapeLayer = pulseLayers.popLast() {
				let animated: Bool? = bLayer.valueForKey("animated") as? Bool
				MaterialAnimation.delay(true == animated ? 0 : 0.10) {
					if let pLayer: CAShapeLayer = bLayer.sublayers?.first as? CAShapeLayer {
						bLayer.addAnimation(MaterialAnimation.backgroundColor(color.colorWithAlphaComponent(0), duration: 0.35), forKey: nil)
						pLayer.addAnimation(MaterialAnimation.animationGroup([
							MaterialAnimation.scale(1.35),
							MaterialAnimation.backgroundColor(color.colorWithAlphaComponent(0))
							], duration: 0.35), forKey: nil)
						
						MaterialAnimation.delay(0.35) {
							pLayer.removeFromSuperlayer()
							bLayer.removeFromSuperlayer()
						}
					}
				}
			}
		}
	}
}