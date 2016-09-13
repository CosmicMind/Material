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

@objc(Button)
open class Button: UIButton {
	/**
     A CAShapeLayer used to manage elements that would be affected by
     the clipToBounds property of the backing layer. For example, this
     allows the dropshadow effect on the backing layer, while clipping
     the image to a desired shape within the visualLayer.
     */
	open private(set) lazy var visualLayer = CAShapeLayer()
	
	/// An Array of pulse layers.
	open private(set) lazy var pulseLayers = [CAShapeLayer]()
	
	/// The opacity value for the pulse animation.
	@IBInspectable
    open var pulseOpacity: CGFloat = 0.25
	
	/// The color of the pulse effect.
	@IBInspectable
    open var pulseColor = Color.grey.base
	
	/// The type of PulseAnimation.
	public var pulseAnimation = PulseAnimation.pointWithBacking
	
	/// A property that accesses the backing layer's backgroundColor.
	@IBInspectable
    open override var backgroundColor: UIColor? {
		didSet {
			layer.backgroundColor = backgroundColor?.cgColor
		}
	}
	
	/// A preset property for updated contentEdgeInsets.
	open var contentEdgeInsetsPreset = EdgeInsetsPreset.none {
		didSet {
			contentEdgeInsets = EdgeInsetsPresetToValue(preset: contentEdgeInsetsPreset)
		}
	}
    
    /// Sets the normal and highlighted image for the button.
    @IBInspectable
    open var image: UIImage? {
        didSet {
            setImage(image, for: .normal)
            setImage(image, for: .highlighted)
        }
    }
    
    /// Sets the normal and highlighted title for the button.
    @IBInspectable
    open var title: String? {
        didSet {
            setTitle(title, for: .normal)
            setTitle(title, for: .highlighted)
        }
    }
    
    /// Sets the normal and highlighted titleColor for the button.
    @IBInspectable
    open var titleColor: UIColor? {
        didSet {
            setTitleColor(titleColor, for: .normal)
            setTitleColor(titleColor, for: .highlighted)
        }
    }
    
	/**
     An initializer that initializes the object with a NSCoder object.
     - Parameter aDecoder: A NSCoder instance.
     */
	public required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		prepare()
	}
	
	/**
     An initializer that initializes the object with a CGRect object.
     If AutoLayout is used, it is better to initilize the instance
     using the init() initializer.
     - Parameter frame: A CGRect instance.
     */
	public override init(frame: CGRect) {
		super.init(frame: frame)
		prepare()
	}
	
	/// A convenience initializer.
	public convenience init() {
		self.init(frame: .zero)
	}
    
    /**
     A convenience initializer that acceps an image.
     - Parameter image: A UIImage.
    */
    public convenience init(image: UIImage?) {
        self.init()
        prepare(with: image, tintColor: nil)
    }
    
    /**
     A convenience initializer that acceps an image and tintColor.
     - Parameter image: A UIImage.
     - Parameter tintColor: A UIColor.
     */
    public convenience init(image: UIImage?, tintColor: UIColor?) {
        self.init()
        prepare(with: image, tintColor: tintColor)
    }
    
    /**
     A convenience initializer that acceps a title.
     - Parameter title: A String.
     */
    public convenience init(title: String?) {
        self.init()
        prepare(with: title, titleColor: nil)
    }
    
    /**
     A convenience initializer that acceps a title and titleColor.
     - Parameter title: A String.
     - Parameter titleColor: A UIColor.
     */
    public convenience init(title: String?, titleColor: UIColor?) {
        self.init()
        prepare(with: title, titleColor: titleColor)
    }
	
    open override func layoutSublayers(of layer: CALayer) {
        super.layoutSublayers(of: layer)
        if self.layer == layer {
            layoutShape()
            layoutVisualLayer()
        }
    }
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        layoutShadowPath()
    }
	
    /**
     Triggers the pulse animation.
     - Parameter point: A Optional point to pulse from, otherwise pulses
     from the center.
     */
    open func pulse(point: CGPoint? = nil) {
        let p = nil == point ? CGPoint(x: CGFloat(width / 2), y: CGFloat(height / 2)) : point!
        Animation.pulseExpandAnimation(layer: layer, visualLayer: visualLayer, pulseColor: pulseColor, pulseOpacity: pulseOpacity, point: p, width: width, height: height, pulseLayers: &pulseLayers, pulseAnimation: pulseAnimation)
        _ = Animation.delay(time: 0.35) { [weak self] in
            guard let s = self else {
                return
            }
            Animation.pulseContractAnimation(layer: s.layer, visualLayer: s.visualLayer, pulseColor: s.pulseColor, pulseLayers: &s.pulseLayers, pulseAnimation: s.pulseAnimation)
        }
    }
    
    /**
     A delegation method that is executed when the view has began a
     touch event.
     - Parameter touches: A set of UITouch objects.
     - Parameter event: A UIEvent object.
     */
    open override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        Animation.pulseExpandAnimation(layer: layer, visualLayer: visualLayer, pulseColor: pulseColor, pulseOpacity: pulseOpacity, point: layer.convert(touches.first!.location(in: self), from: layer), width: width, height: height, pulseLayers: &pulseLayers, pulseAnimation: pulseAnimation)
    }
    
    /**
     A delegation method that is executed when the view touch event has
     ended.
     - Parameter touches: A set of UITouch objects.
     - Parameter event: A UIEvent object.
     */
    open override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        Animation.pulseContractAnimation(layer: layer, visualLayer: visualLayer, pulseColor: pulseColor, pulseLayers: &pulseLayers, pulseAnimation: pulseAnimation)
    }
    
    /**
     A delegation method that is executed when the view touch event has
     been cancelled.
     - Parameter touches: A set of UITouch objects.
     - Parameter event: A UIEvent object.
     */
    open override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesCancelled(touches, with: event)
        Animation.pulseContractAnimation(layer: layer, visualLayer: visualLayer, pulseColor: pulseColor, pulseLayers: &pulseLayers, pulseAnimation: pulseAnimation)
    }
	
	/**
     Prepares the view instance when intialized. When subclassing,
     it is recommended to override the prepare method
     to initialize property values and other setup operations.
     The super.prepare method should always be called immediately
     when subclassing.
     */
	open func prepare() {
        contentScaleFactor = Device.scale
        contentEdgeInsetsPreset = .none
		prepareVisualLayer()
	}
	
	/// Prepares the visualLayer property.
	internal func prepareVisualLayer() {
        visualLayer.zPosition = 0
		visualLayer.masksToBounds = true
		layer.addSublayer(visualLayer)
	}
	
	/// Manages the layout for the visualLayer property.
	internal func layoutVisualLayer() {
		visualLayer.frame = bounds
		visualLayer.cornerRadius = cornerRadius
	}
    
    /**
     Prepares the Button with an image and tintColor.
     - Parameter image: A UIImage.
     - Parameter tintColor: A UIColor.
     */
    private func prepare(with image: UIImage?, tintColor: UIColor?) {
        self.image = image
        self.tintColor = tintColor
    }
    
    /**
     Prepares the Button with a title and titleColor.
     - Parameter title: A String.
     - Parameter titleColor: A UIColor.
     */
    private func prepare(with title: String?, titleColor: UIColor?) {
        self.title = title
        self.titleColor = titleColor
    }
}
