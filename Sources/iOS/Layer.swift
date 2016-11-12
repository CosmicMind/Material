/*
 * Copyright (C) 2015 - 2016, Daniel Dahan and CosmicMind, Inc. <http://cosmicmind.com>.
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

@objc(Layer)
open class Layer: CAShapeLayer {
	/**
     A CAShapeLayer used to manage elements that would be affected by
     the clipToBounds property of the backing layer. For example, this
     allows the dropshadow effect on the backing layer, while clipping
     the image to a desired shape within the visualLayer.
     */
	open internal(set) var visualLayer = CAShapeLayer()
	
	/**
     A property that manages an image for the visualLayer's contents
     property. Images should not be set to the backing layer's contents
     property to avoid conflicts when using clipsToBounds.
     */
	@IBInspectable
    open var image: UIImage? {
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
	open override var contentsRect: CGRect {
		didSet {
			visualLayer.contentsRect = contentsRect
		}
	}
	
	/**
     A CGRect that defines a stretchable region inside the visualLayer
     with a fixed border around the edge.
     */
	open override var contentsCenter: CGRect {
		didSet {
			visualLayer.contentsCenter = contentsCenter
		}
	}
	
	/**
     A floating point value that defines a ratio between the pixel
     dimensions of the visualLayer's contents property and the size
     of the layer. By default, this value is set to the Device.scale.
     */
	@IBInspectable
    open override var contentsScale: CGFloat {
		didSet {
			visualLayer.contentsScale = contentsScale
		}
	}
	
	/// A Preset for the contentsGravity property.
	open var contentsGravityPreset: Gravity {
		didSet {
			contentsGravity = GravityToValue(gravity: contentsGravityPreset)
		}
	}
	
	/// Determines how content should be aligned within the visualLayer's bounds.
	@IBInspectable
    open override var contentsGravity: String {
		get {
			return visualLayer.contentsGravity
		}
		set(value) {
			visualLayer.contentsGravity = value
		}
	}
	
	/**
     A property that sets the cornerRadius of the backing layer. If the shape
     property has a value of .circle when the cornerRadius is set, it will
     become .none, as it no longer maintains its circle shape.
     */
	@IBInspectable
    open override var cornerRadius: CGFloat {
		didSet {
			layoutShadowPath()
			if .circle == shapePreset {
				shapePreset = .none
			}
		}
	}
	
	/**
     An initializer that initializes the object with a NSCoder object.
     - Parameter aDecoder: A NSCoder instance.
     */
	public required init?(coder aDecoder: NSCoder) {
		contentsGravityPreset = .resizeAspectFill
		super.init(coder: aDecoder)
		prepareVisualLayer()
	}
	
	/**
     An initializer the same as init(). The layer parameter is ignored
     to avoid crashes on certain architectures.
     - Parameter layer: Any.
     */
	public override init(layer: Any) {
		contentsGravityPreset = .resizeAspectFill
		super.init()
		prepareVisualLayer()
	}
	
	/// A convenience initializer.
	public override init() {
		contentsGravityPreset = .resizeAspectFill
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
	
	open override func layoutSublayers() {
		super.layoutSublayers()
		layoutShape()
		layoutVisualLayer()
		layoutShadowPath()
	}
	
	/// Prepares the visualLayer property.
	open func prepareVisualLayer() {
        visualLayer.zPosition = 0
		visualLayer.masksToBounds = true
		addSublayer(visualLayer)
	}
	
	/// Manages the layout for the visualLayer property.
	internal func layoutVisualLayer() {
		visualLayer.frame = bounds
		visualLayer.cornerRadius = cornerRadius
	}
}
