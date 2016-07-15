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

@IBDesignable
@objc(Button)
public class Button: UIButton {
	/**
     A CAShapeLayer used to manage elements that would be affected by
     the clipToBounds property of the backing layer. For example, this
     allows the dropshadow effect on the backing layer, while clipping
     the image to a desired shape within the visualLayer.
     */
	public private(set) var visualLayer: CAShapeLayer!
	
	/**
     A base delegate reference used when subclassing View.
     */
	public weak var delegate: MaterialDelegate?
	
	/// An Array of pulse layers.
	public private(set) lazy var pulseLayers: Array<CAShapeLayer> = Array<CAShapeLayer>()
	
	/// The opacity value for the pulse animation.
	@IBInspectable public var pulseOpacity: CGFloat = 0.25
	
	/// The color of the pulse effect.
	@IBInspectable public var pulseColor: UIColor = Color.grey.base
	
	/// The type of PulseAnimation.
	public var pulseAnimation: PulseAnimation = .pointWithBacking {
		didSet {
			visualLayer.masksToBounds = .centerRadialBeyondBounds != pulseAnimation
		}
	}
	
	/// A property that accesses the backing layer's backgroundColor.
	@IBInspectable public override var backgroundColor: UIColor? {
		didSet {
			layer.backgroundColor = backgroundColor?.cgColor
		}
	}
	
	/// A property that accesses the layer.frame.origin.x property.
	@IBInspectable public var x: CGFloat {
		get {
			return layer.frame.origin.x
		}
		set(value) {
			layer.frame.origin.x = value
		}
	}
	
	/// A property that accesses the layer.frame.origin.y property.
	@IBInspectable public var y: CGFloat {
		get {
			return layer.frame.origin.y
		}
		set(value) {
			layer.frame.origin.y = value
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
			return layer.frame.size.width
		}
		set(value) {
			layer.frame.size.width = value
			if .none != shapePreset {
				layer.frame.size.height = value
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
			return layer.frame.size.height
		}
		set(value) {
			layer.frame.size.height = value
			if .none != shapePreset {
				layer.frame.size.width = value
			}
		}
	}
	
	/// Enables automatic shadowPath sizing.
	@IBInspectable public var shadowPathAutoSizeEnabled: Bool = true {
		didSet {
			if shadowPathAutoSizeEnabled {
				layoutShadowPath()
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
	
	/// A preset property for updated contentEdgeInsets.
	public var contentEdgeInsetsPreset: EdgeInsetsPreset = .none {
		didSet {
			contentInset = EdgeInsetsPresetToValue(preset: contentEdgeInsetsPreset)
		}
	}
	
    /**
     :name:	contentInset
     */
    @IBInspectable public var contentInset = EdgeInsets.zero {
        didSet {
            contentEdgeInsets = contentInset.asEdgeInsets
        }
    }
    
	/**
     An initializer that initializes the object with a NSCoder object.
     - Parameter aDecoder: A NSCoder instance.
     */
	public required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		prepareView()
	}
	
	/**
     An initializer that initializes the object with a CGRect object.
     If AutoLayout is used, it is better to initilize the instance
     using the init() initializer.
     - Parameter frame: A CGRect instance.
     */
	public override init(frame: CGRect) {
		super.init(frame: frame)
		prepareView()
	}
	
	/// A convenience initializer.
	public convenience init() {
		self.init(frame: CGRect.zero)
	}
	
	public override func layoutSublayers(of layer: CALayer) {
		super.layoutSublayers(of: layer)
		if self.layer == layer {
			layoutShape()
			layoutVisualLayer()
		}
	}
	
	public override func layoutSubviews() {
		super.layoutSubviews()
		layoutShadowPath()
	}
	
	public override func alignmentRectInsets() -> UIEdgeInsets {
		return UIEdgeInsets.zero
	}
	
    /**
     Triggers the pulse animation.
     - Parameter point: A Optional point to pulse from, otherwise pulses
     from the center.
     */
    public func pulse(point: CGPoint? = nil) {
        let p: CGPoint = nil == point ? CGPoint(x: CGFloat(width / 2), y: CGFloat(height / 2)) : point!
        MaterialAnimation.pulseExpandAnimation(layer: layer, visualLayer: visualLayer, pulseColor: pulseColor, pulseOpacity: pulseOpacity, point: p, width: width, height: height, pulseLayers: &pulseLayers, pulseAnimation: pulseAnimation)
        MaterialAnimation.delay(time: 0.35) { [weak self] in
            guard let s = self else {
                return
            }
            MaterialAnimation.pulseContractAnimation(layer: s.layer, visualLayer: s.visualLayer, pulseColor: s.pulseColor, pulseLayers: &s.pulseLayers, pulseAnimation: s.pulseAnimation)
        }
    }
    
    /**
     A delegation method that is executed when the view has began a
     touch event.
     - Parameter touches: A set of UITouch objects.
     - Parameter event: A UIEvent object.
     */
    public override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        MaterialAnimation.pulseExpandAnimation(layer: layer, visualLayer: visualLayer, pulseColor: pulseColor, pulseOpacity: pulseOpacity, point: layer.convert(touches.first!.location(in: self), from: layer), width: width, height: height, pulseLayers: &pulseLayers, pulseAnimation: pulseAnimation)
    }
    
    /**
     A delegation method that is executed when the view touch event has
     ended.
     - Parameter touches: A set of UITouch objects.
     - Parameter event: A UIEvent object.
     */
    public override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        MaterialAnimation.pulseContractAnimation(layer: layer, visualLayer: visualLayer, pulseColor: pulseColor, pulseLayers: &pulseLayers, pulseAnimation: pulseAnimation)
    }
    
    /**
     A delegation method that is executed when the view touch event has
     been cancelled.
     - Parameter touches: A set of UITouch objects.
     - Parameter event: A UIEvent object.
     */
    public override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesCancelled(touches, with: event)
        MaterialAnimation.pulseContractAnimation(layer: layer, visualLayer: visualLayer, pulseColor: pulseColor, pulseLayers: &pulseLayers, pulseAnimation: pulseAnimation)
    }
	
	/**
	Prepares the view instance when intialized. When subclassing,
	it is recommended to override the prepareView method
	to initialize property values and other setup operations.
	The super.prepareView method should always be called immediately
	when subclassing.
	*/
	public func prepareView() {
        contentScaleFactor = Device.scale
		prepareVisualLayer()
	}
	
	/// Prepares the visualLayer property.
	internal func prepareVisualLayer() {
        visualLayer = CAShapeLayer()
        visualLayer.zPosition = 0
		visualLayer.masksToBounds = true
		layer.addSublayer(visualLayer)
	}
	
	/// Manages the layout for the visualLayer property.
	internal func layoutVisualLayer() {
		visualLayer.frame = bounds
		visualLayer.cornerRadius = cornerRadius
	}
	
	/// Manages the layout for the shape of the view instance.
	internal func layoutShape() {
		if .circle == shapePreset {
			let w: CGFloat = (width / 2)
			if w != cornerRadius {
				cornerRadius = w
			}
		}
	}
	
	/// Sets the shadow path.
	internal func layoutShadowPath() {
		if shadowPathAutoSizeEnabled {
			if .none == depthPreset {
				shadowPath = nil
			} else if nil == shadowPath {
				shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius).cgPath
			} else {
				animate(animation: MaterialAnimation.shadowPath(path: UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius).cgPath, duration: 0))
			}
		}
	}
}
