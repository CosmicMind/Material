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

public class MaterialPulseView: MaterialView {
	/**
		:name:	width
	*/
	public override var width: CGFloat {
		get {
			return super.width
		}
		set(value) {
			super.width = value
			pulseLayer.frame.size.width = value
			if nil != shape {
				pulseLayer.frame.size.height = height
			}
		}
	}
	
	/**
		:name:	height
	*/
	public override var height: CGFloat {
		get {
			return super.height
		}
		set(value) {
			super.height = value
			pulseLayer.frame.size.height = value
			if nil != shape {
				pulseLayer.frame.size.width = width
			}
		}
	}
	
	/**
		:name:	cornerRadius
	*/
	public override var cornerRadius: MaterialRadius! {
		didSet {
			super.cornerRadius = cornerRadius
			pulseLayer.cornerRadius = layer.cornerRadius
		}
	}
	
	/**
		:name:	shape
	*/
	public override var shape: MaterialShape! {
		didSet {
			prepareShape()
		}
	}
	
	//
	//	:name:	pulseLayer
	//
	internal lazy var pulseLayer: CAShapeLayer = CAShapeLayer()
	
	/**
		:name:	init
	*/
	public convenience init() {
		self.init(frame: CGRectMake(MaterialTheme.pulseView.x, MaterialTheme.pulseView.y, MaterialTheme.pulseView.width, MaterialTheme.pulseView.height))
	}
	
	/**
		:name:	touchesBegan
	*/
	public override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
		super.touchesBegan(touches, withEvent: event)
//		pulseLayer.hidden = false
//		let point: CGPoint = touches.first!.locationInView(self)
//		let pulse: CAShapeLayer = CAShapeLayer()
//		pulse.bounds = CGRectMake(point.x, point.y, 0, 0)
//		pulse.backgroundColor = MaterialColor.white.CGColor
	}
	
	/**
		:name:	touchesEnded
	*/
	public override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
		super.touchesEnded(touches, withEvent: event)
//		pulseLayer.hidden = true
		MaterialAnimation.rotate(visualLayer, duration: 1)
	}
	
	/**
		:name:	touchesCancelled
	*/
	public override func touchesCancelled(touches: Set<UITouch>?, withEvent event: UIEvent?) {
		super.touchesCancelled(touches, withEvent: event)
	}
	
	//
	//	:name:	prepareView
	//
	internal override func prepareView() {
		super.prepareView()
		userInteractionEnabled = MaterialTheme.pulseView.userInteractionEnabled
		backgroundColor = MaterialTheme.pulseView.backgroudColor
	}
	
	//
	//	:name:	prepareLayer
	//
	internal override func prepareLayer() {
		super.prepareLayer()
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
		pulseLayer.frame = CGRectMake(0, 0, width, height)
		pulseLayer.masksToBounds = true
		pulseLayer.hidden = true
		pulseLayer.backgroundColor = MaterialColor.red.base.CGColor
		visualLayer.addSublayer(pulseLayer)
	}
	
	//
	//	:name:	prepareShape
	//
	internal override func prepareShape() {
		super.prepareShape()
		if nil != shape {
			pulseLayer.frame.size.width = width
			pulseLayer.frame.size.height = height
			pulseLayer.cornerRadius = layer.cornerRadius
		}
	}
}
