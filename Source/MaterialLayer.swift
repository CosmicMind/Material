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

@objc(MaterialLayer)
public class MaterialLayer : CAShapeLayer {
	/**
		:name:	visualLayer
	*/
	public private(set) lazy var visualLayer: CAShapeLayer = CAShapeLayer()
	
	/**
		:name:	animationDelegate
	*/
	public var animationDelegate: MaterialAnimationDelegate?
	
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
		:name:	image
	*/
	public var image: UIImage? {
		get {
			return nil == visualLayer.contents ? nil : UIImage(CGImage: visualLayer.contents as! CGImageRef)
		}
		set(value) {
			visualLayer.contents = value?.CGImage
		}
	}
	
	/**
		:name:	contentsRect
	*/
	public override var contentsRect: CGRect {
		get {
			return visualLayer.contentsRect
		}
		set(value) {
			visualLayer.contentsRect = contentsRect
		}
	}
	
	/**
		:name:	contentsCenter
	*/
	public override var contentsCenter: CGRect {
		get {
			return visualLayer.contentsCenter
		}
		set(value) {
			visualLayer.contentsCenter = contentsCenter
		}
	}
	
	/**
		:name:	contentsScale
	*/
	public override var contentsScale: CGFloat {
		get {
			return visualLayer.contentsScale
		}
		set(value) {
			visualLayer.contentsScale = contentsScale
		}
	}
	
	/**
		:name:	contentsGravity
	*/
	public override var contentsGravity: String {
		get {
			return visualLayer.contentsGravity
		}
		set(value) {
			visualLayer.contentsGravity = value
		}
	}
	
	/**
		:name:	masksToBounds
	*/
	public override var masksToBounds: Bool {
		get {
			return visualLayer.masksToBounds
		}
		set(value) {
			visualLayer.masksToBounds = value
		}
	}
	
	/**
		:name:	cornerRadius
	*/
	public override var cornerRadius: CGFloat {
		get {
			return visualLayer.cornerRadius
		}
		set(value) {
			visualLayer.cornerRadius = value
			if .Circle == shape {
				shape = .None
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
					width = height
				} else {
					height = width
				}
			}
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
		:name: init
	*/
	public required init?(coder aDecoder: NSCoder) {
		shape = .None
		shadowDepth = .None
		super.init(coder: aDecoder)
		prepareLayer()
	}
	
	/**
		:name: init
	*/
	public override init(layer: AnyObject) {
		shape = .None
		shadowDepth = .None
		super.init(layer: layer)
		prepareLayer()
	}
	
	/**
		:name: init
	*/
	public override init() {
		shape = .None
		shadowDepth = .None
		super.init()
		prepareLayer()
	}
	
	/**
		:name: init
	*/
	public convenience init(frame: CGRect) {
		self.init()
		self.frame = frame
	}
	
	public override func layoutSublayers() {
		super.layoutSublayers()
		visualLayer.frame = bounds
		visualLayer.position = CGPointMake(width / 2, height / 2)
		prepareShape()
	}
	
	/**
		:name:	animation
	*/
	public func animation(animation: CAAnimation) {
		animation.delegate = self
		if let a: CABasicAnimation = animation as? CABasicAnimation {
			a.fromValue = (nil == presentationLayer() ? self : presentationLayer() as! CALayer).valueForKeyPath(a.keyPath!)
		}
		if let a: CAPropertyAnimation = animation as? CAPropertyAnimation {
			addAnimation(a, forKey: a.keyPath!)
			if "cornerRadius" == a.keyPath {
				visualLayer.addAnimation(a, forKey: "cornerRadius")
			}
		} else if let a: CAAnimationGroup = animation as? CAAnimationGroup {
			addAnimation(a, forKey: nil)
			for x in a.animations! {
				if let b: CABasicAnimation = x as? CABasicAnimation {
					if "cornerRadius" == b.keyPath {
						visualLayer.addAnimation(b, forKey: "cornerRadius")
					}
				}
			}
		} else if let a: CATransition = animation as? CATransition {
			addAnimation(a, forKey: kCATransition)
		}
	}
	
	/**
		:name:	animationDidStart
	*/
	public override func animationDidStart(anim: CAAnimation) {
		animationDelegate?.materialAnimationDidStart?(anim)
	}
	
	/**
		:name:	animationDidStop
	*/
	public override func animationDidStop(anim: CAAnimation, finished flag: Bool) {
		if let a: CAPropertyAnimation = anim as? CAPropertyAnimation {
			if let b: CABasicAnimation = a as? CABasicAnimation {
				MaterialAnimation.animationDisabled({
					self.setValue(nil == b.toValue ? b.byValue : b.toValue, forKey: b.keyPath!)
				})
			}
			animationDelegate?.materialAnimationDidStop?(anim, finished: flag)
			removeAnimationForKey(a.keyPath!)
			if "cornerRadius" == a.keyPath {
				visualLayer.addAnimation(a, forKey: "cornerRadius")
			}
		} else if let a: CAAnimationGroup = anim as? CAAnimationGroup {
			for x in a.animations! {
				animationDidStop(x, finished: true)
			}
		}
	}
	
	/**
		:name:	prepareLayer
	*/
	public func prepareLayer() {
		// visualLayer
		masksToBounds = true
		visualLayer.zPosition = -1
		addSublayer(visualLayer)
	}
	
	//
	//	:name:	prepareShape
	//
	internal func prepareShape() {
		if .Circle == shape {
			cornerRadius = width / 2
		}
	}
}

