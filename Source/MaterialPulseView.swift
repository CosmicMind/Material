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

public class MaterialPulseView : MaterialView {
	/**
		:name:	spotlight
	*/
	public lazy var spotlight: Bool = false
	
	/**
		:name:	pulseLayer
	*/
	public private(set) lazy var pulseLayer: CAShapeLayer = CAShapeLayer()
	
	/**
		:name:	pulseScale
	*/
	public lazy var pulseScale: Bool = true
	
	/**
		:name:	pulseFill
	*/
	public lazy var pulseFill: Bool = false
	
	/**
		:name:	pulseColorOpacity
	*/
	public var pulseColorOpacity: CGFloat = MaterialTheme.pulseView.pulseColorOpacity {
		didSet {
			preparePulseLayer()
		}
	}
	
	/**
		:name:	pulseColor
	*/
	public var pulseColor: UIColor? {
		didSet {
			preparePulseLayer()
		}
	}
	
	/**
		:name:	touchesBegan
	*/
	public override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
		super.touchesBegan(touches, withEvent: event)
		let point: CGPoint = layer.convertPoint(touches.first!.locationInView(self), fromLayer: layer)
		if true == layer.containsPoint(point) {
			let s: CGFloat = (width < height ? height : width) / 2
			let f: CGFloat = 3
			let v: CGFloat = s / f
			let d: CGFloat = pulseFill ? 5 * f : 2 * f
			let r: CGFloat = 1.05
			let a: CFTimeInterval = 0.25
			
			MaterialAnimation.animationDisabled({
				self.pulseLayer.hidden = false
				self.pulseLayer.bounds = CGRectMake(0, 0, v, v)
				self.pulseLayer.position = point
				self.pulseLayer.cornerRadius = s / d
			})
			
			if pulseScale {
				layer.addAnimation(MaterialAnimation.scale(CATransform3DMakeScale(r, r, r), duration: a), forKey: nil)
			}
			
			MaterialAnimation.animationWithDuration(a, animations: {
				self.pulseLayer.transform = CATransform3DMakeScale(d, d, d)
			})
		}
	}
	
	/**
		:name:	touchesMoved
	*/
	public override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
		super.touchesMoved(touches, withEvent: event)
		if spotlight {
			let point: CGPoint = layer.convertPoint(touches.first!.locationInView(self), fromLayer: layer)
			if true == layer.containsPoint(point) {
				MaterialAnimation.animationDisabled({
					self.pulseLayer.position = point
				})
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
		:name:	actionForLayer
	*/
	public override func actionForLayer(layer: CALayer, forKey event: String) -> CAAction? {
		return nil // returning nil enables the animations for the layer property that are normally disabled.
	}
	
	//
	//	:name:	prepareView
	//
	internal override func prepareView() {
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
		masksToBounds = MaterialTheme.pulseView.masksToBounds
		cornerRadius = MaterialTheme.pulseView.cornerRadius
		borderWidth = MaterialTheme.pulseView.borderWidth
		borderColor = MaterialTheme.pulseView.bordercolor
		
		// pulseLayer
		pulseLayer.hidden = true
		pulseLayer.zPosition = 1
		visualLayer.addSublayer(pulseLayer)
	}
	
	//
	//	:name:	preparePulseLayer
	//
	internal func preparePulseLayer() {
		pulseLayer.backgroundColor = pulseColor?.colorWithAlphaComponent(pulseColorOpacity).CGColor
	}
	
	//
	//	:name:	shrink
	//
	internal func shrink() {
		MaterialAnimation.animationWithDuration(0.25, animations: {
			self.pulseLayer.hidden = true
			self.pulseLayer.transform = CATransform3DIdentity
		})
		self.layer.addAnimation(MaterialAnimation.scale(CATransform3DIdentity), forKey: nil)
	}
}
