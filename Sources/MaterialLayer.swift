//
// Copyright (C) 2015 - 2016 CosmicMind, Inc. <http://cosmicmind.io>. All rights reserved. 
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

@objc(MaterialDelegate)
public protocol MaterialDelegate {}

@objc(MaterialLayer)
public class MaterialLayer : CAShapeLayer {
	/**
	A CAShapeLayer used to manage elements that would be affected by
	the clipToBounds property of the backing layer. For example, this
	allows the dropshadow effect on the backing layer, while clipping
	the image to a desired shape within the visualLayer.
	*/
	public private(set) lazy var visualLayer: CAShapeLayer = CAShapeLayer()

	/// A property that accesses the layer.frame.origin.x property.
	public var x: CGFloat {
		get {
			return frame.origin.x
		}
		set(value) {
			frame.origin.x = value
		}
	}
	
	/// A property that accesses the layer.frame.origin.y property.
	public var y: CGFloat {
		get {
			return frame.origin.y
		}
		set(value) {
			frame.origin.y = value
		}
	}
	
	/**
	A property that accesses the layer.frame.origin.width property.
	When setting this property in conjunction with the shape property having a
	value that is not .None, the height will be adjusted to maintain the correct
	shape.
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
	A property that accesses the layer.frame.origin.height property.
	When setting this property in conjunction with the shape property having a
	value that is not .None, the width will be adjusted to maintain the correct
	shape.
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
	A property that manages an image for the visualLayer's contents
	property. Images should not be set to the backing layer's contents
	property to avoid conflicts when using clipsToBounds.
	*/
	public var image: UIImage? {
		didSet {
			visualLayer.contents = image?.CGImage
		}
	}
	
	/**
	Allows a relative subrectangle within the range of 0 to 1 to be
	specified for the visualLayer's contents property. This allows
	much greater flexibility than the contentsGravity property in
	terms of how the image is cropped and stretched.
	*/
	public override var contentsRect: CGRect {
		didSet {
			visualLayer.contentsRect = contentsRect
		}
	}
	
	/**
	A CGRect that defines a stretchable region inside the visualLayer
	with a fixed border around the edge.
	*/
	public override var contentsCenter: CGRect {
		didSet {
			visualLayer.contentsCenter = contentsCenter
		}
	}
	
	/**
	A floating point value that defines a ratio between the pixel
	dimensions of the visualLayer's contents property and the size
	of the layer. By default, this value is set to the UIScreen's
	scale value, UIScreen.mainScreen().scale.
	*/
	public override var contentsScale: CGFloat {
		didSet {
			visualLayer.contentsScale = contentsScale
		}
	}
	
	/// Determines how content should be aligned within the visualLayer's bounds.
	public override var contentsGravity: String {
		get {
			return visualLayer.contentsGravity
		}
		set(value) {
			visualLayer.contentsGravity = value
		}
	}
	
	/**
	A property that sets the shadowOffset, shadowOpacity, and shadowRadius
	for the backing layer. This is the preferred method of setting depth
	in order to maintain consitency across UI objects.
	*/
	public var depth: MaterialDepth {
		didSet {
			let value: MaterialDepthType = MaterialDepthToValue(depth)
			shadowOffset = value.offset
			shadowOpacity = value.opacity
			shadowRadius = value.radius
		}
	}
	
	/**
	A property that sets the cornerRadius of the backing layer. If the shape
	property has a value of .Circle when the cornerRadius is set, it will
	become .None, as it no longer maintains its circle shape.
	*/
	public override var cornerRadius: CGFloat {
		didSet {
			if .Circle == shape {
				shape = .None
			}
		}
	}
	
	/**
	A property that manages the overall shape for the object. If either the
	width or height property is set, the other will be automatically adjusted
	to maintain the shape of the object.
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
	An initializer that initializes the object with a NSCoder object.
	- Parameter aDecoder: A NSCoder instance.
	*/
	public required init?(coder aDecoder: NSCoder) {
		shape = .None
		depth = .None
		super.init(coder: aDecoder)
		prepareVisualLayer()
	}
	
	/**
	An initializer the same as init(). The layer parameter is ignored
	to avoid crashes on certain architectures.
	- Parameter layer: AnyObject.
	*/
	public override init(layer: AnyObject) {
		shape = .None
		depth = .None
		super.init()
		prepareVisualLayer()
	}
	
	/// A convenience initializer.
	public override init() {
		shape = .None
		depth = .None
		super.init()
		prepareVisualLayer()
	}
	
	/**
	An initializer that initializes the object with a CGRect object.
	- Parameter frame: A CGRect instance.
	*/
	public convenience init(frame: CGRect) {
		self.init()
		self.frame = frame
	}
	
	public override func layoutSublayers() {
		super.layoutSublayers()
		layoutShape()
		layoutVisualLayer()
	}
	
	/**
	A method that accepts CAAnimation objects and executes.
	- Parameter animation: A CAAnimation instance.
	*/
	public func animate(animation: CAAnimation) {
		animation.delegate = self
		if let a: CABasicAnimation = animation as? CABasicAnimation {
			a.fromValue = valueForKeyPath(a.keyPath!)
		}
		if let a: CAPropertyAnimation = animation as? CAPropertyAnimation {
			addAnimation(a, forKey: a.keyPath!)
		} else if let a: CAAnimationGroup = animation as? CAAnimationGroup {
			addAnimation(a, forKey: nil)
		} else if let a: CATransition = animation as? CATransition {
			addAnimation(a, forKey: kCATransition)
		}
	}
	
	/**
	A delegation method that is executed when the layer starts
	running an animation.
	- Parameter anim: The currently running CAAnimation instance.
	*/
	public override func animationDidStart(anim: CAAnimation) {
		(delegate as? MaterialAnimationDelegate)?.materialAnimationDidStart?(anim)
	}
	
	/**
	A delegation method that is executed when the layer stops
	running an animation.
	- Parameter anim: The CAAnimation instance that stopped running.
	- Parameter flag: A boolean that indicates if the animation stopped
	because it was completed or interrupted. True if completed, false
	if interrupted.
	*/
	public override func animationDidStop(anim: CAAnimation, finished flag: Bool) {
		if let a: CAPropertyAnimation = anim as? CAPropertyAnimation {
			if let b: CABasicAnimation = a as? CABasicAnimation {
				MaterialAnimation.animationDisabled {
					self.setValue(nil == b.toValue ? b.byValue : b.toValue, forKey: b.keyPath!)
				}
			}
			(delegate as? MaterialAnimationDelegate)?.materialAnimationDidStop?(anim, finished: flag)
			removeAnimationForKey(a.keyPath!)
		} else if let a: CAAnimationGroup = anim as? CAAnimationGroup {
			for x in a.animations! {
				animationDidStop(x, finished: true)
			}
		}
		layoutVisualLayer()
	}
	
	/// Prepares the visualLayer property.
	public func prepareVisualLayer() {
		// visualLayer
		visualLayer.zPosition = 0
		visualLayer.masksToBounds = true
		addSublayer(visualLayer)
	}
	
	/// Manages the layout for the visualLayer property.
	internal func layoutVisualLayer() {
		visualLayer.frame = bounds
		visualLayer.position = CGPointMake(width / 2, height / 2)
		visualLayer.cornerRadius = cornerRadius
	}
	
	/// Manages the layout for the shape of the layer instance.
	internal func layoutShape() {
		if .Circle == shape {
			cornerRadius = width / 2
		}
	}
}
