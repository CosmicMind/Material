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

@objc(MaterialButton)
public class MaterialButton : UIButton {
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
	public weak var delegate: MaterialDelegate?
	
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
			updatePulseLayer()
		}
	}
	
	/**
	:name:	pulseColor
	*/
	public var pulseColor: UIColor? {
		didSet {
			updatePulseLayer()
		}
	}
	
	/**
	:name:	masksToBounds
	*/
	public var masksToBounds: Bool {
		get {
			return layer.masksToBounds
		}
		set(value) {
			layer.masksToBounds = value
		}
	}
	
	/**
	:name:	backgroundColor
	*/
	public override var backgroundColor: UIColor? {
		didSet {
			layer.backgroundColor = backgroundColor?.CGColor
		}
	}
	
	/**
	:name:	x
	*/
	public var x: CGFloat {
		get {
			return layer.frame.origin.x
		}
		set(value) {
			layer.frame.origin.x = value
		}
	}
	
	/**
	:name:	y
	*/
	public var y: CGFloat {
		get {
			return layer.frame.origin.y
		}
		set(value) {
			layer.frame.origin.y = value
		}
	}
	
	/**
	:name:	width
	*/
	public var width: CGFloat {
		get {
			return layer.frame.size.width
		}
		set(value) {
			layer.frame.size.width = value
			if .None != shape {
				layer.frame.size.height = value
			}
		}
	}
	
	/**
	:name:	height
	*/
	public var height: CGFloat {
		get {
			return layer.frame.size.height
		}
		set(value) {
			layer.frame.size.height = value
			if .None != shape {
				layer.frame.size.width = value
			}
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
	:name:	cornerRadius
	*/
	public var cornerRadius: MaterialRadius? {
		didSet {
			if let v: MaterialRadius = cornerRadius {
				layer.cornerRadius = MaterialRadiusToValue(v)
				if .Circle == shape {
					shape = .None
				}
			}
		}
	}
	
	/**
	:name:	shape
	*/
	public var shape: MaterialShape {
		didSet {
			if .None != shape {
				if width < height {
					frame.size.width = height
				} else {
					frame.size.height = width
				}
			}
		}
	}
	
	/**
	:name:	borderWidth
	*/
	public var borderWidth: MaterialBorder {
		didSet {
			layer.borderWidth = MaterialBorderToValue(borderWidth)
		}
	}
	
	/**
	:name:	borderColor
	*/
	public var borderColor: UIColor? {
		didSet {
			layer.borderColor = borderColor?.CGColor
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
	public var contentInsets: MaterialEdgeInsets {
		didSet {
			let value: UIEdgeInsets = MaterialEdgeInsetsToValue(contentInsets)
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
		super.init(coder: aDecoder)
		prepareView()
	}
	
	/**
	:name:	init
	*/
	public override init(frame: CGRect) {
		borderWidth = .None
		shadowDepth = .None
		shape = .None
		contentInsets = .None
		super.init(frame: frame)
		prepareView()
	}
	/**
	:name:	init
	*/
	public convenience init() {
		self.init(frame: CGRectNull)
	}
	
	/**
	:name:	layoutSublayersOfLayer
	*/
	public override func layoutSublayersOfLayer(layer: CALayer) {
		super.layoutSublayersOfLayer(layer)
		if self.layer == layer {
			layoutShape()
			layoutVisualLayer()
		}
	}
	
	/**
	:name:	animate
	*/
	public func animate(animation: CAAnimation) {
		animation.delegate = self
		if let a: CABasicAnimation = animation as? CABasicAnimation {
			a.fromValue = (nil == layer.presentationLayer() ? layer : layer.presentationLayer() as! CALayer).valueForKeyPath(a.keyPath!)
		}
		if let a: CAPropertyAnimation = animation as? CAPropertyAnimation {
			layer.addAnimation(a, forKey: a.keyPath!)
		} else if let a: CAAnimationGroup = animation as? CAAnimationGroup {
			layer.addAnimation(a, forKey: nil)
		} else if let a: CATransition = animation as? CATransition {
			layer.addAnimation(a, forKey: kCATransition)
		}
	}
	
	/**
	:name:	animationDidStart
	*/
	public override func animationDidStart(anim: CAAnimation) {
		(delegate as? MaterialAnimationDelegate)?.materialAnimationDidStart?(anim)
	}
	
	/**
	:name:	animationDidStop
	*/
	public override func animationDidStop(anim: CAAnimation, finished flag: Bool) {
		if let a: CAPropertyAnimation = anim as? CAPropertyAnimation {
			if let b: CABasicAnimation = a as? CABasicAnimation {
				MaterialAnimation.animationDisabled {
					self.layer.setValue(nil == b.toValue ? b.byValue : b.toValue, forKey: b.keyPath!)
				}
			}
			(delegate as? MaterialAnimationDelegate)?.materialAnimationDidStop?(anim, finished: flag)
			layer.removeAnimationForKey(a.keyPath!)
		} else if let a: CAAnimationGroup = anim as? CAAnimationGroup {
			for x in a.animations! {
				animationDidStop(x, finished: true)
			}
		}
		layoutVisualLayer()
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
				pulseLayer.addAnimation(MaterialAnimation.scale(pulseFill ? 3 * d : 1.5 * d, duration: t), forKey: nil)
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
	:name:	actionForLayer
	*/
	public override func actionForLayer(layer: CALayer, forKey event: String) -> CAAction? {
		return nil // returning nil enables the animations for the layer property that are normally disabled.
	}
	
	/**
	:name:	prepareView
	*/
	public func prepareView() {
		prepareVisualLayer()
		preparePulseLayer()
	}
	
	/**
	:name:	prepareVisualLayer
	*/
	internal func prepareVisualLayer() {
		visualLayer.zPosition = 0
		visualLayer.masksToBounds = true
		layer.addSublayer(visualLayer)
	}
	
	/**
	:name:	layoutVisualLayer
	*/
	internal func layoutVisualLayer() {
		visualLayer.frame = bounds
		visualLayer.position = CGPointMake(width / 2, height / 2)
		visualLayer.cornerRadius = layer.cornerRadius
	}
	
	/**
	:name:	layoutShape
	*/
	internal func layoutShape() {
		if .Circle == shape {
			layer.cornerRadius = width / 2
		}
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
	:name:	updatePulseLayer
	*/
	internal func updatePulseLayer() {
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