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

public class MaterialButton : UIButton {
	//
	//	:name:	visualLayer
	//
	public private(set) lazy var visualLayer: CAShapeLayer = CAShapeLayer()
	
	//
	//	:name:	pulseLayer
	//
	internal lazy var pulseLayer: CAShapeLayer = CAShapeLayer()
	
	/**
		:name:	pulseColor
	*/
	public var pulseColor: UIColor? {
		didSet {
			pulseLayer.backgroundColor = pulseColor?.colorWithAlphaComponent(0.5).CGColor
		}
	}
	
	/**
		:name:	backgroundColor
	*/
	public override var backgroundColor: UIColor? {
		get {
			return nil == visualLayer.backgroundColor ? nil : UIColor(CGColor: visualLayer.backgroundColor!)
		}
		set(value) {
			visualLayer.backgroundColor = value?.CGColor
		}
	}
	
	/**
		:name:	x
	*/
	public var x: CGFloat {
		get {
			return frame.origin.x
		}
		set(value) {
			frame.origin.x = value
		}
	}
	
	/**
		:name:	y
	*/
	public var y: CGFloat {
		get {
			return frame.origin.y
		}
		set(value) {
			frame.origin.y = value
		}
	}
	
	/**
		:name:	width
	*/
	public var width: CGFloat {
		get {
			return frame.size.width
		}
		set(value) {
			frame.size.width = value
			if nil != shape {
				frame.size.height = value
				prepareShape()
			}
		}
	}
	
	/**
		:name:	height
	*/
	public var height: CGFloat {
		get {
			return frame.size.height
		}
		set(value) {
			frame.size.height = value
			if nil != shape {
				frame.size.width = value
				prepareShape()
			}
		}
	}
	
	/**
		:name:	shadowColor
	*/
	public var shadowColor: UIColor! {
		didSet {
			layer.shadowColor = nil == shadowColor ? MaterialColor.clear.CGColor : shadowColor!.CGColor
		}
	}
	
	/**
		:name:	shadowOffset
	*/
	public var shadowOffset: CGSize! {
		didSet {
			layer.shadowOffset = nil == shadowOffset ? CGSizeMake(0, 0) : shadowOffset!
		}
	}
	
	/**
		:name:	shadowOpacity
	*/
	public var shadowOpacity: Float! {
		didSet {
			layer.shadowOpacity = nil == shadowOpacity ? 0 : shadowOpacity!
		}
	}
	
	/**
		:name:	shadowRadius
	*/
	public var shadowRadius: CGFloat! {
		didSet {
			layer.shadowRadius = nil == shadowRadius ? 0 : shadowRadius!
		}
	}
	
	/**
		:name:	masksToBounds
	*/
	public var masksToBounds: Bool! {
		didSet {
			visualLayer.masksToBounds = nil == masksToBounds ? false : masksToBounds!
		}
	}
	
	/**
		:name:	cornerRadius
	*/
	public var cornerRadius: MaterialRadius! {
		didSet {
			visualLayer.cornerRadius = MaterialRadiusToValue(nil == cornerRadius ? .Radius0 : cornerRadius!)
			shape = nil
		}
	}
	
	/**
		:name:	shape
	*/
	public var shape: MaterialShape? {
		didSet {
			if nil != shape {
				if width < height {
					frame.size.width = height
				} else {
					frame.size.height = width
				}
				prepareShape()
			}
		}
	}
	
	/**
		:name:	borderWidth
	*/
	public var borderWidth: MaterialBorder! {
		didSet {
			visualLayer.borderWidth = MaterialBorderToValue(nil == borderWidth ? .Border0 : borderWidth!)
		}
	}
	
	/**
		:name:	borderColor
	*/
	public var borderColor: UIColor! {
		didSet {
			visualLayer.borderColor = nil == borderColor ? MaterialColor.clear.CGColor : borderColor!.CGColor
		}
	}
	
	/**
		:name:	shadowDepth
	*/
	public var shadowDepth: MaterialDepth! {
		didSet {
			let value: MaterialDepthType = MaterialDepthToValue(shadowDepth!)
			shadowOffset = value.offset
			shadowOpacity = value.opacity
			shadowRadius = value.radius
		}
	}
	
	/**
		:name:	zPosition
	*/
	public var zPosition: CGFloat! {
		didSet {
			layer.zPosition = zPosition
		}
	}
	
	/**
		:name:	contentInsets
	*/
	public var contentInsets: MaterialInsets! {
		didSet {
			let value: MaterialInsetsType = MaterialInsetsToValue(nil == contentInsets ? .Inset0 : contentInsets)
			contentEdgeInsets = UIEdgeInsetsMake(value.top, value.left, value.bottom, value.right)
		}
	}
	
	/**
		:name:	init
	*/
	public required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}
	
	/**
		:name:	init
	*/
	public override init(frame: CGRect) {
		super.init(frame: frame)
		prepareView()
	}
	/**
		:name:	init
	*/
	public convenience init() {
		self.init(frame: CGRectMake(MaterialTheme.view.x, MaterialTheme.view.y, MaterialTheme.view.width, MaterialTheme.view.height))
	}

	/**
		:name:	layerClass
	*/
	public override class func layerClass() -> AnyClass {
		return CAShapeLayer.self
	}
	
	/**
		:name:	layoutSubviews
	*/
	public override func layoutSubviews() {
		super.layoutSubviews()
		visualLayer.frame = bounds
		visualLayer.zPosition = -1
		pulseLayer.zPosition = 1000
	}
	
	/**
		:name:	touchesBegan
	*/
	public override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
		super.touchesBegan(touches, withEvent: event)
		let point: CGPoint = touches.first!.locationInView(self)
		if nil != visualLayer.presentationLayer()?.hitTest(point) {
			// set start position
			CATransaction.begin()
			CATransaction.setAnimationDuration(0)
			let w: CGFloat = width / 2
			pulseLayer.hidden = false
			pulseLayer.position = point
			pulseLayer.bounds = CGRectMake(0, 0, w, w)
			pulseLayer.cornerRadius = CGFloat(w / 2)
			CATransaction.commit()
			
			// expand
			CATransaction.begin()
			CATransaction.setAnimationDuration(0.3)
			pulseLayer.transform = CATransform3DMakeScale(2.5, 2.5, 2.5)
			visualLayer.transform = CATransform3DMakeScale(1.05, 1.05, 1.05)
			CATransaction.commit()
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
	
	//
	//	:name:	prepareView
	//
	internal func prepareView() {
		// visualLayer
		layer.insertSublayer(visualLayer, atIndex: 0)
		
		// pulseLayer
		pulseLayer.hidden = true
		visualLayer.insertSublayer(pulseLayer, atIndex: 1000)
	}
	
	//
	//	:name:	prepareShape
	//
	internal func prepareShape() {
		visualLayer.cornerRadius = .Square == shape ? 0 : width / 2
	}
	
	//
	//	:name:	shrink
	//
	internal func shrink() {
		CATransaction.begin()
		CATransaction.setAnimationDuration(0.3)
		pulseLayer.hidden = true
		pulseLayer.transform = CATransform3DIdentity
		visualLayer.transform = CATransform3DIdentity
		CATransaction.commit()
	}
}