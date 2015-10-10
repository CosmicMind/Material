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

@objc(MaterialButton)
public class MaterialButton : UIButton {
	/**
		:name:	layerClass
	*/
	public override class func layerClass() -> AnyClass {
		return MaterialLayer.self
	}
	
	/**
		:name:	materialLayer
	*/
	public var materialLayer: MaterialLayer {
		return layer as! MaterialLayer
	}
	
	/**
		:name:	visualLayer
	*/
	public private(set) lazy var visualLayer: CAShapeLayer = CAShapeLayer()
	
	/**
		:name:	pulseLayer
	*/
	public private(set) lazy var pulseLayer: CAShapeLayer = CAShapeLayer()
	
	/**
		:name:	delegate
	*/
	public weak var delegate: MaterialAnimationDelegate? {
		get {
			return materialLayer.animationDelegate
		}
		set(value) {
			materialLayer.animationDelegate = delegate
		}
	}
	
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
		:name:	masksToBounds
	*/
	public var masksToBounds: Bool {
		get {
			return materialLayer.masksToBounds
		}
		set(value) {
			materialLayer.masksToBounds = value
		}
	}
	
	/**
		:name:	backgroundColor
	*/
	public override var backgroundColor: UIColor? {
		didSet {
			materialLayer.backgroundColor = backgroundColor?.CGColor
		}
	}
	
	/**
		:name:	x
	*/
	public var x: CGFloat {
		get {
			return materialLayer.x
		}
		set(value) {
			materialLayer.x = value
		}
	}
	
	/**
		:name:	y
	*/
	public var y: CGFloat {
		get {
			return materialLayer.y
		}
		set(value) {
			materialLayer.y = value
		}
	}
	
	/**
		:name:	width
	*/
	public var width: CGFloat {
		get {
			return materialLayer.width
		}
		set(value) {
			materialLayer.width = value
		}
	}
	
	/**
		:name:	height
	*/
	public var height: CGFloat {
		get {
			return materialLayer.height
		}
		set(value) {
			materialLayer.height = value
		}
	}
	
	/**
		:name:	shadowColor
	*/
	public var shadowColor: UIColor? {
		didSet {
			layer.shadowColor = shadowColor?.CGColor
		}
	}
	
	/**
		:name:	shadowOffset
	*/
	public var shadowOffset: CGSize {
		get {
			return layer.shadowOffset
		}
		set(value) {
			layer.shadowOffset = value
		}
	}
	
	/**
		:name:	shadowOpacity
	*/
	public var shadowOpacity: Float {
		get {
			return layer.shadowOpacity
		}
		set(value) {
			layer.shadowOpacity = value
		}
	}
	
	/**
		:name:	shadowRadius
	*/
	public var shadowRadius: CGFloat {
		get {
			return layer.shadowRadius
		}
		set(value) {
			layer.shadowRadius = value
		}
	}
	
	/**
		:name:	cornerRadius
	*/
	public var cornerRadius: MaterialRadius {
		didSet {
			materialLayer.cornerRadius = MaterialRadiusToValue(cornerRadius)
		}
	}
	
	/**
		:name:	shape
	*/
	public var shape: MaterialShape {
		didSet {
			if .None != shape {
				if width < height {
					width = height
				} else {
					height = width
				}
			}
		}
	}
	
	/**
		:name:	borderWidth
	*/
	public var borderWidth: MaterialBorder {
		didSet {
			materialLayer.borderWidth = MaterialBorderToValue(borderWidth)
		}
	}
	
	/**
		:name:	borderColor
	*/
	public var borderColor: UIColor? {
		didSet {
			materialLayer.borderColor = borderColor?.CGColor
		}
	}
	
	/**
		:name:	shadowDepth
	*/
	public var shadowDepth: MaterialDepth {
		didSet {
			let value: MaterialDepthType = MaterialDepthToValue(shadowDepth)
			shadowOffset = value.offset
			shadowOpacity = value.opacity
			shadowRadius = value.radius
		}
	}
	
	/**
		:name:	position
	*/
	public var position: CGPoint {
		get {
			return layer.position
		}
		set(value) {
			layer.position = value
		}
	}
	
	/**
		:name:	zPosition
	*/
	public var zPosition: CGFloat {
		get {
			return layer.zPosition
		}
		set(value) {
			layer.zPosition = value
		}
	}
	
	/**
		:name:	contentInsets
	*/
	public var contentInsets: MaterialInsets {
		didSet {
			let value: MaterialInsetsType = MaterialInsetsToValue(contentInsets)
			contentEdgeInsets = UIEdgeInsetsMake(value.top, value.left, value.bottom, value.right)
		}
	}
	
	/**
		:name:	init
	*/
	public required init?(coder aDecoder: NSCoder) {
		borderWidth = .None
		shadowDepth = .None
		shape = .None
		contentInsets = .None
		cornerRadius = .None
		super.init(coder: aDecoder)
	}
	
	/**
		:name:	init
	*/
	public override init(frame: CGRect) {
		borderWidth = .None
		shadowDepth = .None
		shape = .None
		contentInsets = .None
		cornerRadius = .None
		super.init(frame: frame)
		prepareView()
	}
	
	/**
		:name:	layoutSublayersOfLayer
	*/
	public override func layoutSublayersOfLayer(layer: CALayer) {
		super.layoutSublayersOfLayer(layer)
		if self.layer == layer {
			prepareShape()
		}
	}
	
	/**
		:name:	init
	*/
	public convenience init() {
		self.init(frame: CGRectNull)
	}
	
	/**
		:name:	animation
	*/
	public func animation(animation: CAAnimation) {
		materialLayer.animation(animation)
	}
	
	/**
		:name:	touchesBegan
	*/
	public override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
		super.touchesBegan(touches, withEvent: event)
		let point: CGPoint = layer.convertPoint(touches.first!.locationInView(self), fromLayer: layer)
		if true == layer.containsPoint(point) {
			let s: CGFloat = (width < height ? height : width) / 2
			let f: CGFloat = 4
			let v: CGFloat = s / f
			let d: CGFloat = 2 * f
			let r: CGFloat = 1.05
			let t: CFTimeInterval = 0.25
			
			if nil != pulseColor && 0 < pulseColorOpacity {
				MaterialAnimation.animationDisabled({
					self.pulseLayer.hidden = false
					self.pulseLayer.bounds = CGRectMake(0, 0, v, v)
					self.pulseLayer.position = point
					self.pulseLayer.cornerRadius = s / d
				})
				pulseLayer.addAnimation(MaterialAnimation.scale(pulseFill ? 3 * d : 1.5 * d, duration: t), forKey: nil)
			}
			
			if pulseScale {
				layer.addAnimation(MaterialAnimation.scale(r, duration: t), forKey: nil)
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
		:name:	prepareView
	*/
	public func prepareView() {
		// pulseLayer
		pulseLayer.hidden = true
		pulseLayer.zPosition = 1
		materialLayer.visualLayer.addSublayer(pulseLayer)
	}
	
	//
	//	:name:	prepareShape
	//
	internal func prepareShape() {
		if .Circle == shape {
			materialLayer.cornerRadius = width / 2
		}
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
		let t: CFTimeInterval = 0.25
		
		if nil != pulseColor && 0 < pulseColorOpacity {
			MaterialAnimation.animationWithDuration(t, animations: {
				self.pulseLayer.hidden = true
			})
			pulseLayer.addAnimation(MaterialAnimation.scale(1, duration: t), forKey: nil)
		}
		
		if pulseScale {
			layer.addAnimation(MaterialAnimation.scale(1, duration: t), forKey: nil)
		}
	}
}