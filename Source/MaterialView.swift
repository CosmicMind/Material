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

@objc(MaterialView)
public class MaterialView : UIView {
	//
	//	:name:	visualLayer
	//
	public private(set) lazy var visualLayer: CAShapeLayer = CAShapeLayer()
	
	/**
		:name:	visualLayer
	*/
	public weak var delegate: MaterialAnimationDelegate?
	
	/**
		:name:	image
	*/
	public var image: UIImage? {
		didSet {
			visualLayer.contents = image?.CGImage
		}
	}
	
	/**
		:name:	contentsRect
	*/
	public var contentsRect: CGRect {
		didSet {
			visualLayer.contentsRect = contentsRect
		}
	}
	
	/**
		:name:	contentsCenter
	*/
	public var contentsCenter: CGRect {
		didSet {
			visualLayer.contentsCenter = contentsCenter
		}
	}
	
	/**
		:name:	contentsScale
	*/
	public var contentsScale: CGFloat {
		didSet {
			visualLayer.contentsScale = contentsScale
		}
	}
	
	/**
		:name:	contentsGravity
	*/
	public var contentsGravity: MaterialGravity {
		didSet {
			visualLayer.contentsGravity = MaterialGravityToString(contentsGravity)
		}
	}
	
	/**
		:name:	masksToBounds
	*/
	public var masksToBounds: Bool {
		get {
			return visualLayer.masksToBounds
		}
		set(value) {
			visualLayer.masksToBounds = value
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
			if .None != shape {
				frame.size.height = value
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
			if .None != shape {
				frame.size.width = value
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
		:name:	init
	*/
	public required init?(coder aDecoder: NSCoder) {
		contentsRect = MaterialTheme.view.contentsRect
		contentsCenter = MaterialTheme.view.contentsCenter
		contentsScale = MaterialTheme.view.contentsScale
		contentsGravity = MaterialTheme.view.contentsGravity
		borderWidth = MaterialTheme.view.borderWidth
		shadowDepth = .None
		shape = .None
		super.init(coder: aDecoder)
	}
	
	/**
		:name:	init
	*/
	public override init(frame: CGRect) {
		contentsRect = MaterialTheme.view.contentsRect
		contentsCenter = MaterialTheme.view.contentsCenter
		contentsScale = MaterialTheme.view.contentsScale
		contentsGravity = MaterialTheme.view.contentsGravity
		borderWidth = MaterialTheme.view.borderWidth
		shadowDepth = .None
		shape = .None
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
		:name:	layoutSubviews
	*/
	public override func layoutSubviews() {
		super.layoutSubviews()
		prepareShape()
		
		visualLayer.frame = bounds
		visualLayer.position = CGPointMake(width / 2, height / 2)
		visualLayer.cornerRadius = layer.cornerRadius
	}
	
	/**
		:name:	animation
	*/
	public func animation(animation: CAAnimation) {
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
		delegate?.materialAnimationDidStart?(anim)
	}
	
	/**
		:name:	animationDidStop
	*/
	public override func animationDidStop(anim: CAAnimation, finished flag: Bool) {
		if let a: CAPropertyAnimation = anim as? CAPropertyAnimation {
			if let b: CABasicAnimation = a as? CABasicAnimation {
				MaterialAnimation.animationDisabled({
					self.layer.setValue(nil == b.toValue ? b.byValue : b.toValue, forKey: b.keyPath!)
				})
			}
			delegate?.materialAnimationDidStop?(anim, finished: flag)
			layer.removeAnimationForKey(a.keyPath!)
		} else if let a: CAAnimationGroup = anim as? CAAnimationGroup {
			for x in a.animations! {
				animationDidStop(x, finished: true)
			}
		}
	}
	
	//
	//	:name:	filterAnimations
	//
	internal func filterAnimations(animation: CAAnimation) -> Bool? {
		if let a: CAPropertyAnimation = animation as? CAPropertyAnimation {
			switch a.keyPath! {
			case "position",
				 "transform",
				 "backgroundColor",
				 "transform.rotation",
				 "transform.scale",
				 "transform.scale.x",
				 "transform.scale.y",
				 "transform.scale.z",
				 "transform.translation",
				 "transform.translation.x",
				 "transform.translation.y",
				 "transform.translation.z":
				 return false
			default:
				return true
			}
		} else if let a: CAAnimationGroup = animation as? CAAnimationGroup {
			for var i: Int = a.animations!.count - 1; 0 <= i; --i {
				if let b: CAPropertyAnimation = a.animations![i] as? CAPropertyAnimation {
					if false == filterAnimations(b) {
						a.animations!.removeAtIndex(i)
					}
				}
			}
		}
		return nil
	}
	
	//
	//	:name:	prepareView
	//
	internal func prepareView() {
		userInteractionEnabled = MaterialTheme.view.userInteractionEnabled
		backgroundColor = MaterialTheme.view.backgroundColor

		shadowDepth = MaterialTheme.view.shadowDepth
		shadowColor = MaterialTheme.view.shadowColor
		zPosition = MaterialTheme.view.zPosition
		masksToBounds = MaterialTheme.view.masksToBounds
		cornerRadius = MaterialTheme.view.cornerRadius
		borderColor = MaterialTheme.view.bordercolor
		
		// visualLayer
		visualLayer.zPosition = -1
		layer.addSublayer(visualLayer)
	}
	
	//
	//	:name:	prepareShape
	//
	internal func prepareShape() {
		if .Circle == shape {
			layer.cornerRadius = width / 2
		}
	}
}

