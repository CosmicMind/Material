//
// Copyright (C) 2015 CosmicMind, Inc. <http://cosmicmind.io> and other CosmicMind contributors
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
	/**
	:name:	pulseLayer
	*/
	public private(set) lazy var pulseLayer: CAShapeLayer = CAShapeLayer()
	
	/**
	:name:	pulseScale
	*/
	public lazy var pulseScale: Bool = true
	
	/**
	:name:	spotlight
	*/
	public var spotlight: Bool = false {
		didSet {
			if spotlight {
				pulseFill = false
			}
		}
	}
	
	/**
	:name:	pulseFill
	*/
	public var pulseFill: Bool = false {
		didSet {
			if pulseFill {
				spotlight = false
			}
		}
	}
	
	/**
	:name:	pulseColorOpacity
	*/
	public var pulseColorOpacity: CGFloat = MaterialTheme.pulseView.pulseColorOpacity {
		didSet {
			updatedPulseLayer()
		}
	}
	
	/**
	:name:	pulseColor
	*/
	public var pulseColor: UIColor? {
		didSet {
			updatedPulseLayer()
		}
	}
	
	/**
	:name:	touchesBegan
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
	:name:	touchesMoved
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
	:name:	touchesEnded
	*/
	public override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
		super.touchesEnded(touches, withEvent: event)
		shrink()
	}
	
	/**
	:name:	touchesCancelled
	*/
	public override func touchesCancelled(touches: Set<UITouch>?, withEvent event: UIEvent?) {
		super.touchesCancelled(touches, withEvent: event)
		shrink()
	}
	
	/**
	:name:	prepareView
	*/
	public override func prepareView() {
		super.prepareView()
		userInteractionEnabled = MaterialTheme.pulseView.userInteractionEnabled
		backgroundColor = MaterialTheme.pulseView.backgroundColor
		pulseColor = MaterialTheme.pulseView.pulseColor
		
		contentsRect = MaterialTheme.pulseView.contentsRect
		contentsCenter = MaterialTheme.pulseView.contentsCenter
		contentsScale = MaterialTheme.pulseView.contentsScale
		contentsGravity = MaterialTheme.pulseView.contentsGravity
		shadowDepth = MaterialTheme.pulseView.shadowDepth
		shadowColor = MaterialTheme.pulseView.shadowColor
		zPosition = MaterialTheme.pulseView.zPosition
		borderWidth = MaterialTheme.pulseView.borderWidth
		borderColor = MaterialTheme.pulseView.bordercolor
		
		preparePulseLayer()
	}
	
	/**
	:name:	preparePulseLayer
	*/
	internal func preparePulseLayer() {
		pulseLayer.hidden = true
		pulseLayer.zPosition = 1
		visualLayer.addSublayer(pulseLayer)
	}
	
	/**
	:name:	updatedPulseLayer
	*/
	internal func updatedPulseLayer() {
		pulseLayer.backgroundColor = pulseColor?.colorWithAlphaComponent(pulseColorOpacity).CGColor
	}
	
	/**
	:name:	shrink
	*/
	internal func shrink() {
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