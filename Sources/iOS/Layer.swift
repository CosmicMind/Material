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
 *	*	Neither the name of CosmicMind nor the names of its
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

@objc(MaterialDelegate)
public protocol MaterialDelegate {}

@objc(Layer)
public class Layer: CAShapeLayer {
	/**
     A CAShapeLayer used to manage elements that would be affected by
     the clipToBounds property of the backing layer. For example, this
     allows the dropshadow effect on the backing layer, while clipping
     the image to a desired shape within the visualLayer.
     */
	public private(set) var visualLayer: CAShapeLayer!

	/// A property that accesses the layer.frame.origin.x property.
	@IBInspectable public var x: CGFloat {
		get {
			return frame.origin.x
		}
		set(value) {
			frame.origin.x = value
		}
	}
	
	/// A property that accesses the layer.frame.origin.y property.
	@IBInspectable public var y: CGFloat {
		get {
			return frame.origin.y
		}
		set(value) {
			frame.origin.y = value
		}
	}
	
	/**
     A property that accesses the layer.frame.size.width property.
     When setting this property in conjunction with the shape property having a
     value that is not .none, the height will be adjusted to maintain the correct
     shape.
     */
	@IBInspectable public var width: CGFloat {
		get {
			return frame.size.width
		}
		set(value) {
			frame.size.width = value
			if .none != shapePreset {
				frame.size.height = value
			}
		}
	}
	
	/**
     A property that accesses the layer.frame.size.height property.
     When setting this property in conjunction with the shape property having a
     value that is not .none, the width will be adjusted to maintain the correct
     shape.
     */
	@IBInspectable public var height: CGFloat {
		get {
			return frame.size.height
		}
		set(value) {
			frame.size.height = value
			if .none != shapePreset {
				frame.size.width = value
			}
		}
	}
	
	/**
     A property that manages an image for the visualLayer's contents
     property. Images should not be set to the backing layer's contents
     property to avoid conflicts when using clipsToBounds.
     */
	@IBInspectable public var image: UIImage? {
		didSet {
			visualLayer.contents = image?.cgImage
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
     of the layer. By default, this value is set to the Device.scale.
     */
	@IBInspectable public override var contentsScale: CGFloat {
		didSet {
			visualLayer.contentsScale = contentsScale
		}
	}
	
	/// A Preset for the contentsGravity property.
	public var contentsGravityPreset: MaterialGravity {
		didSet {
			contentsGravity = MaterialGravityToValue(gravity: contentsGravityPreset)
		}
	}
	
	/// Determines how content should be aligned within the visualLayer's bounds.
	@IBInspectable public override var contentsGravity: String {
		get {
			return visualLayer.contentsGravity
		}
		set(value) {
			visualLayer.contentsGravity = value
		}
	}
	
	/// Enables automatic shadowPath sizing.
	@IBInspectable public var isShadowPathAutoSizing: Bool = true {
		didSet {
			if isShadowPathAutoSizing {
				layoutShadowPath()
			}
		}
	}
	
    /// A preset value for Depth.
    public var depthPreset: DepthPreset = .none {
        didSet {
            depth = DepthPresetToValue(preset: depthPreset)
        }
    }
    
    /**
     A property that sets the shadowOffset, shadowOpacity, and shadowRadius
     for the backing layer.
     */
    public var depth = Depth.zero {
        didSet {
            shadowOffset = depth.offset.asSize
            shadowOpacity = depth.opacity
            shadowRadius = depth.radius
            layoutShadowPath()
        }
    }
	
	/**
     A property that sets the cornerRadius of the backing layer. If the shape
     property has a value of .circle when the cornerRadius is set, it will
     become .none, as it no longer maintains its circle shape.
     */
	public var cornerRadiusPreset: CornerRadiusPreset = .none {
		didSet {
			if let v: CornerRadiusPreset = cornerRadiusPreset {
				cornerRadius = CornerRadiusPresetToValue(preset: v)
			}
		}
	}
	
	/**
     A property that sets the cornerRadius of the backing layer. If the shape
     property has a value of .circle when the cornerRadius is set, it will
     become .none, as it no longer maintains its circle shape.
     */
	@IBInspectable public override var cornerRadius: CGFloat {
		didSet {
			layoutShadowPath()
			if .circle == shapePreset {
				shapePreset = .none
			}
		}
	}
	
	/**
     A property that manages the overall shape for the object. If either the
     width or height property is set, the other will be automatically adjusted
     to maintain the shape of the object.
     */
	public var shapePreset: ShapePreset = .none {
		didSet {
			if .none != shapePreset {
				if width < height {
					frame.size.width = height
				} else {
					frame.size.height = width
				}
				layoutShadowPath()
			}
		}
	}
	
	/// A preset property to set the borderWidth.
	public var borderWidthPreset: BorderWidthPreset = .none {
		didSet {
			borderWidth = BorderWidthPresetToValue(preset: borderWidthPreset)
		}
	}
	
	/**
     An initializer that initializes the object with a NSCoder object.
     - Parameter aDecoder: A NSCoder instance.
     */
	public required init?(coder aDecoder: NSCoder) {
		contentsGravityPreset = .ResizeAspectFill
		super.init(coder: aDecoder)
		prepareVisualLayer()
	}
	
	/**
     An initializer the same as init(). The layer parameter is ignored
     to avoid crashes on certain architectures.
     - Parameter layer: AnyObject.
     */
	public override init(layer: AnyObject) {
		contentsGravityPreset = .ResizeAspectFill
		super.init()
		prepareVisualLayer()
	}
	
	/// A convenience initializer.
	public override init() {
		contentsGravityPreset = .ResizeAspectFill
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
		layoutShadowPath()
	}
	
    /**
     A method that accepts CAAnimation objects and executes them on the
     view's backing layer.
     - Parameter animation: A CAAnimation instance.
     */
    public func animate(animation: CAAnimation) {
        if let a = animation as? CABasicAnimation {
            a.fromValue = (nil == presentation() ? self : presentation()!).value(forKeyPath: a.keyPath!)
        }
        if let a = animation as? CAPropertyAnimation {
            add(a, forKey: a.keyPath!)
        } else if let a = animation as? CAAnimationGroup {
            add(a, forKey: nil)
        } else if let a = animation as? CATransition {
            add(a, forKey: kCATransition)
        }
    }
    
    /**
     A delegation method that is executed when the backing layer stops
     running an animation.
     - Parameter animation: The CAAnimation instance that stopped running.
     - Parameter flag: A boolean that indicates if the animation stopped
     because it was completed or interrupted. True if completed, false
     if interrupted.
     */
    public func animationDidStop(_ animation: CAAnimation, finished flag: Bool) {
        if let a = animation as? CAPropertyAnimation {
            if let b = a as? CABasicAnimation {
                if let v = b.toValue {
                    if let k = b.keyPath {
                        setValue(v, forKeyPath: k)
                        removeAnimation(forKey: k)
                    }
                }
            }
        } else if let a = animation as? CAAnimationGroup {
            for x in a.animations! {
                animationDidStop(x, finished: true)
            }
        }
    }
	
	/// Prepares the visualLayer property.
	public func prepareVisualLayer() {
		visualLayer = CAShapeLayer()
        visualLayer.zPosition = 0
		visualLayer.masksToBounds = true
		addSublayer(visualLayer)
	}
	
	/// Manages the layout for the visualLayer property.
	internal func layoutVisualLayer() {
		visualLayer.frame = bounds
		visualLayer.cornerRadius = cornerRadius
	}
	
	/// Manages the layout for the shape of the layer instance.
	internal func layoutShape() {
		if .circle == shapePreset {
			let w = width / 2
			if w != cornerRadius {
				cornerRadius = w
			}
		}
	}
	
	/// Sets the shadow path.
	internal func layoutShadowPath() {
		if isShadowPathAutoSizing {
			if .none == depthPreset {
				shadowPath = nil
			} else if nil == shadowPath {
				shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius).cgPath
			} else {
				animate(animation: Animation.shadowPath(path: UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius).cgPath, duration: 0))
			}
		}
	}
}
