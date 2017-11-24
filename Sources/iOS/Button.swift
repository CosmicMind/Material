/*
 * Copyright (C) 2015 - 2017, Daniel Dahan and CosmicMind, Inc. <http://cosmicmind.com>.
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
import Motion

open class Button: UIButton, Pulseable, PulseableLayer {
    /**
     A CAShapeLayer used to manage elements that would be affected by
     the clipToBounds property of the backing layer. For example, this
     allows the dropshadow effect on the backing layer, while clipping
     the image to a desired shape within the visualLayer.
     */
	open let visualLayer = CAShapeLayer()

    /// A Pulse reference.
    internal var pulse: Pulse!
    
    /// A reference to the pulse layer.
    internal var pulseLayer: CALayer? {
        return pulse.pulseLayer
    }
    
    /// PulseAnimation value.
    open var pulseAnimation: PulseAnimation {
        get {
            return pulse.animation
        }
        set(value) {
            pulse.animation = value
        }
    }
    
    /// PulseAnimation color.
    @IBInspectable
    open var pulseColor: UIColor {
        get {
            return pulse.color
        }
        set(value) {
            pulse.color = value
        }
    }
    
    /// Pulse opacity.
    @IBInspectable
    open var pulseOpacity: CGFloat {
        get {
            return pulse.opacity
        }
        set(value) {
            pulse.opacity = value
        }
    }
    
	/// A property that accesses the backing layer's background
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
            setImage(image, for: .selected)
            setImage(image, for: .highlighted)
            setImage(image, for: .disabled)
            
            if #available(iOS 9, *) {
                setImage(image, for: .application)
                setImage(image, for: .focused)
                setImage(image, for: .reserved)
            }
        }
    }
    
    /// Sets the normal and highlighted title for the button.
    @IBInspectable
    open var title: String? {
        didSet {
            setTitle(title, for: .normal)
            setTitle(title, for: .selected)
            setTitle(title, for: .highlighted)
            setTitle(title, for: .disabled)
            
            if #available(iOS 9, *) {
                setTitle(title, for: .application)
                setTitle(title, for: .focused)
                setTitle(title, for: .reserved)
            }
            
            guard nil != title else {
                return
            }
            
            guard nil == titleColor else {
                return
            }
            
            titleColor = Color.blue.base
        }
    }
    
    /// Sets the normal and highlighted titleColor for the button.
    @IBInspectable
    open var titleColor: UIColor? {
        didSet {
            setTitleColor(titleColor, for: .normal)
            setTitleColor(titleColor, for: .highlighted)
            setTitleColor(titleColor, for: .disabled)
            
            if nil == selectedTitleColor {
                setTitleColor(titleColor, for: .selected)
            }
            
            if #available(iOS 9, *) {
                setTitleColor(titleColor, for: .application)
                setTitleColor(titleColor, for: .focused)
                setTitleColor(titleColor, for: .reserved)
            }
        }
    }

    /// Sets the selected titleColor for the button.
    @IBInspectable
    open var selectedTitleColor: UIColor? {
        didSet {
            setTitleColor(selectedTitleColor, for: .selected)
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
        tintColor = Color.blue.base
		prepare()
	}
    
    /// A convenience initializer.
    public convenience init() {
        self.init(frame: .zero)
    }
	
    /**
     A convenience initializer that acceps an image and tint
     - Parameter image: A UIImage.
     - Parameter tintColor: A UI
     */
    public init(image: UIImage?, tintColor: UIColor = Color.blue.base) {
        super.init(frame: .zero)
        prepare(with: image, tintColor: tintColor)
        prepare()
    }
    
    /**
     A convenience initializer that acceps a title and title
     - Parameter title: A String.
     - Parameter titleColor: A UI
     */
    public init(title: String?, titleColor: UIColor = Color.blue.base) {
        super.init(frame: .zero)
        prepare(with: title, titleColor: titleColor)
        prepare()
    }
	
    open override func layoutSubviews() {
        super.layoutSubviews()
        layoutShape()
        layoutVisualLayer()
        layoutShadowPath()
    }
	
    /**
     Triggers the pulse animation.
     - Parameter point: A Optional point to pulse from, otherwise pulses
     from the center.
     */
    open func pulse(point: CGPoint? = nil) {
        pulse.expand(point: point ?? center)
        Motion.delay(0.35) { [weak self] in
            self?.pulse.contract()
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
        pulse.expand(point: layer.convert(touches.first!.location(in: self), from: layer))
    }
    
    /**
     A delegation method that is executed when the view touch event has
     ended.
     - Parameter touches: A set of UITouch objects.
     - Parameter event: A UIEvent object.
     */
    open override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        pulse.contract()
    }
    
    /**
     A delegation method that is executed when the view touch event has
     been cancelled.
     - Parameter touches: A set of UITouch objects.
     - Parameter event: A UIEvent object.
     */
    open override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesCancelled(touches, with: event)
        pulse.contract()
    }
    
    open func bringImageViewToFront() {
        guard let v = imageView else {
            return
        }
        
        bringSubview(toFront: v)
    }
    
	/**
     Prepares the view instance when intialized. When subclassing,
     it is recommended to override the prepare method
     to initialize property values and other setup operations.
     The super.prepare method should always be called immediately
     when subclassing.
     */
	open func prepare() {
        contentScaleFactor = Screen.scale
        prepareVisualLayer()
        preparePulse()
	}
}

extension Button {
    /// Prepares the visualLayer property.
    fileprivate func prepareVisualLayer() {
        visualLayer.zPosition = 0
        visualLayer.masksToBounds = true
        layer.addSublayer(visualLayer)
    }
    
    /// Prepares the pulse motion.
    fileprivate func preparePulse() {
        pulse = Pulse(pulseView: self, pulseLayer: visualLayer)
    }
    
    /**
     Prepares the Button with an image and tint
     - Parameter image: A UIImage.
     - Parameter tintColor: A UI
     */
    fileprivate func prepare(with image: UIImage?, tintColor: UIColor) {
        self.image = image
        self.tintColor = tintColor
    }
    
    /**
     Prepares the Button with a title and title
     - Parameter title: A String.
     - Parameter titleColor: A UI
     */
    fileprivate func prepare(with title: String?, titleColor: UIColor) {
        self.title = title
        self.titleColor = titleColor
    }
}

extension Button {
    /// Manages the layout for the visualLayer property.
    fileprivate func layoutVisualLayer() {
        visualLayer.frame = bounds
        visualLayer.cornerRadius = layer.cornerRadius
    }
}
