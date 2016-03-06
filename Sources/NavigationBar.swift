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
*	*	Neither the name of Material nor the names of its
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

/// A memory reference to the Grid instance for UIView extensions.
private var NavigationBarKey: UInt8 = 0

public class NavigationBarControls {
	/// A preset wrapper around contentInset.
	public var contentInsetPreset: MaterialEdgeInset {
		didSet {
			contentInset = MaterialEdgeInsetToValue(contentInsetPreset)
		}
	}
	
	/// A wrapper around grid.contentInset.
	public var contentInset: UIEdgeInsets
	
	/// Left controls.
	public var leftControls: Array<UIControl>?
	
	/// Right controls.
	public var rightControls: Array<UIControl>?
	
	public init() {
		contentInsetPreset = .Square2
		contentInset = MaterialEdgeInsetToValue(.Square2)
	}
}

public extension UINavigationBar {
	/// NavigationBarControls reference.
	public var controls: NavigationBarControls {
		get {
			return MaterialObjectAssociatedObject(self, key: &NavigationBarKey) {
				return NavigationBarControls()
			}
		}
		set(value) {
			MaterialObjectAssociateObject(self, key: &NavigationBarKey, value: value)
		}
	}
	
	/// Device status bar style.
	public var statusBarStyle: UIStatusBarStyle {
		get {
			return MaterialDevice.statusBarStyle
		}
		set(value) {
			MaterialDevice.statusBarStyle = value
		}
	}
	
	public var leftControls: Array<UIControl>? {
		get {
			return controls.leftControls
		}
		set(value) {
			var c: Array<UIBarButtonItem> = Array<UIBarButtonItem>()
			if let v: Array<UIControl> = value {
				for q in v {
					q.frame.size = CGSizeMake(48, 32)
					if let p: UIButton = q as? UIButton {
						p.contentEdgeInsets = UIEdgeInsetsZero
					}
					c.append(UIBarButtonItem(customView: q))
				}
			}
			
			let spacer: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: .FixedSpace, target: nil, action: nil)
			spacer.width = -20 + controls.contentInset.left
			c.append(spacer)
			
			controls.leftControls = value
			topItem?.leftBarButtonItems = c.reverse()
		}
	}
	
	public var rightControls: Array<UIControl>? {
		get {
			return controls.rightControls
		}
		set(value) {
			var c: Array<UIBarButtonItem> = Array<UIBarButtonItem>()
			if let v: Array<UIControl> = value {
				for q in v {
					q.frame.size = CGSizeMake(48, 32)
					if let p: UIButton = q as? UIButton {
						p.contentEdgeInsets = UIEdgeInsetsZero
					}
					c.append(UIBarButtonItem(customView: q))
				}
			}
			
			let spacer: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: .FixedSpace, target: nil, action: nil)
			spacer.width = -20 + controls.contentInset.right
			c.append(spacer)
			
			controls.rightControls = value
			topItem?.rightBarButtonItems = c.reverse()
		}
	}
}

public class NavigationBar : UINavigationBar {
	/**
	A CAShapeLayer used to manage elements that would be affected by
	the clipToBounds property of the backing layer. For example, this
	allows the dropshadow effect on the backing layer, while clipping
	the image to a desired shape within the visualLayer.
	*/
	public private(set) lazy var visualLayer: CAShapeLayer = CAShapeLayer()
	
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
	public var contentsRect: CGRect {
		get {
			return visualLayer.contentsRect
		}
		set(value) {
			visualLayer.contentsRect = value
		}
	}
	
	/**
	A CGRect that defines a stretchable region inside the visualLayer
	with a fixed border around the edge.
	*/
	public var contentsCenter: CGRect {
		get {
			return visualLayer.contentsCenter
		}
		set(value) {
			visualLayer.contentsCenter = value
		}
	}
	
	/**
	A floating point value that defines a ratio between the pixel
	dimensions of the visualLayer's contents property and the size
	of the view. By default, this value is set to the MaterialDevice.scale.
	*/
	public var contentsScale: CGFloat {
		get {
			return visualLayer.contentsScale
		}
		set(value) {
			visualLayer.contentsScale = value
		}
	}
	
	/// A Preset for the contentsGravity property.
	public var contentsGravityPreset: MaterialGravity {
		didSet {
			contentsGravity = MaterialGravityToString(contentsGravityPreset)
		}
	}
	
	/// Determines how content should be aligned within the visualLayer's bounds.
	public var contentsGravity: String {
		get {
			return visualLayer.contentsGravity
		}
		set(value) {
			visualLayer.contentsGravity = value
		}
	}
	
	/**
	This property is the same as clipsToBounds. It crops any of the view's
	contents from bleeding past the view's frame. If an image is set using
	the image property, then this value does not need to be set, since the
	visualLayer's maskToBounds is set to true by default.
	*/
	public var masksToBounds: Bool {
		get {
			return layer.masksToBounds
		}
		set(value) {
			layer.masksToBounds = value
		}
	}
	
	/// A preset wrapper around contentInset.
	public var contentInsetPreset: MaterialEdgeInset {
		get {
			return grid.contentInsetPreset
		}
		set(value) {
			grid.contentInsetPreset = value
		}
	}
	
	/// A wrapper around grid.contentInset.
	public var contentInset: UIEdgeInsets {
		get {
			return grid.contentInset
		}
		set(value) {
			grid.contentInset = value
		}
	}
	
	/// A preset wrapper around spacing.
	public var spacingPreset: MaterialSpacing = .None {
		didSet {
			spacing = MaterialSpacingToValue(spacingPreset)
		}
	}
	
	/// A wrapper around grid.spacing.
	public var spacing: CGFloat {
		get {
			return grid.spacing
		}
		set(value) {
			grid.spacing = value
		}
	}
	
	/**
	The back button image writes to the backIndicatorImage property and
	backIndicatorTransitionMaskImage property.
	*/
	public var backButtonImage: UIImage? {
		didSet {
			if nil == backButtonImage {
				backButtonImage = UIImage(named: "ic_arrow_back_white", inBundle: NSBundle(identifier: "io.cosmicmind.Material"), compatibleWithTraitCollection: nil)
			}
			backIndicatorImage = backButtonImage
			backIndicatorTransitionMaskImage = backButtonImage
		}
	}
	
	/// A property that accesses the backing layer's backgroundColor.
	public override var backgroundColor: UIColor? {
		didSet {
			barTintColor = backgroundColor
		}
	}
	
	/// A property that accesses the layer.frame.origin.x property.
	public var x: CGFloat {
		get {
			return layer.frame.origin.x
		}
		set(value) {
			layer.frame.origin.x = value
		}
	}
	
	/// A property that accesses the layer.frame.origin.y property.
	public var y: CGFloat {
		get {
			return layer.frame.origin.y
		}
		set(value) {
			layer.frame.origin.y = value
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
			return layer.frame.size.width
		}
		set(value) {
			layer.frame.size.width = value
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
			return layer.frame.size.height
		}
		set(value) {
			layer.frame.size.height = value
		}
	}
	
	/// A property that accesses the backing layer's shadowColor.
	public var shadowColor: UIColor? {
		didSet {
			layer.shadowColor = shadowColor?.CGColor
		}
	}
	
	/// A property that accesses the backing layer's shadowOffset.
	public var shadowOffset: CGSize {
		get {
			return layer.shadowOffset
		}
		set(value) {
			layer.shadowOffset = value
		}
	}
	
	/// A property that accesses the backing layer's shadowOpacity.
	public var shadowOpacity: Float {
		get {
			return layer.shadowOpacity
		}
		set(value) {
			layer.shadowOpacity = value
		}
	}
	
	/// A property that accesses the backing layer's shadowRadius.
	public var shadowRadius: CGFloat {
		get {
			return layer.shadowRadius
		}
		set(value) {
			layer.shadowRadius = value
		}
	}
	
	/// A property that accesses the backing layer's shadowPath.
	public var shadowPath: CGPath? {
		get {
			return layer.shadowPath
		}
		set(value) {
			layer.shadowPath = value
		}
	}
	
	/// Enables automatic shadowPath sizing.
	public var shadowPathAutoSizeEnabled: Bool = false {
		didSet {
			if shadowPathAutoSizeEnabled {
				layoutShadowPath()
			} else {
				shadowPath = nil
			}
		}
	}
	
	/**
	A property that sets the shadowOffset, shadowOpacity, and shadowRadius
	for the backing layer. This is the preferred method of setting depth
	in order to maintain consitency across UI objects.
	*/
	public var depth: MaterialDepth = .None {
		didSet {
			let value: MaterialDepthType = MaterialDepthToValue(depth)
			shadowOffset = value.offset
			shadowOpacity = value.opacity
			shadowRadius = value.radius
			layoutShadowPath()
		}
	}
	
	
	/// A property that sets the cornerRadius of the backing layer.
	public var cornerRadiusPreset: MaterialRadius = .None {
		didSet {
			if let v: MaterialRadius = cornerRadiusPreset {
				cornerRadius = MaterialRadiusToValue(v)
			}
		}
	}
	
	/// A property that accesses the layer.cornerRadius.
	public var cornerRadius: CGFloat {
		get {
			return layer.cornerRadius
		}
		set(value) {
			layer.cornerRadius = value
			layoutShadowPath()
		}
	}
	
	/// A preset property to set the borderWidth.
	public var borderWidthPreset: MaterialBorder = .None {
		didSet {
			borderWidth = MaterialBorderToValue(borderWidthPreset)
		}
	}
	
	/// A property that accesses the layer.borderWith.
	public var borderWidth: CGFloat {
		get {
			return layer.borderWidth
		}
		set(value) {
			layer.borderWidth = value
		}
	}
	
	/// A property that accesses the layer.borderColor property.
	public var borderColor: UIColor? {
		get {
			return nil == layer.borderColor ? nil : UIColor(CGColor: layer.borderColor!)
		}
		set(value) {
			layer.borderColor = value?.CGColor
		}
	}
	
	/// A property that accesses the layer.position property.
	public var position: CGPoint {
		get {
			return layer.position
		}
		set(value) {
			layer.position = value
		}
	}
	
	/// A property that accesses the layer.zPosition property.
	public var zPosition: CGFloat {
		get {
			return layer.zPosition
		}
		set(value) {
			layer.zPosition = value
		}
	}
	
	public required init?(coder aDecoder: NSCoder) {
		contentsGravityPreset = .ResizeAspectFill
		super.init(coder: aDecoder)
		prepareView()
	}
	
	public override init(frame: CGRect) {
		contentsGravityPreset = .ResizeAspectFill
		super.init(frame: frame)
		prepareView()
	}
	
	public func prepareView() {
		translucent = false
		barStyle = .Black
		backButtonImage = nil
		backgroundColor = MaterialColor.white
		depth = .Depth1
		spacingPreset = .Spacing2
		contentInsetPreset = .Square2
		titleTextAttributes = [NSFontAttributeName: RobotoFont.regularWithSize(20)]
		prepareVisualLayer()
		backgroundColor = MaterialColor.white
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
	
	/// Sets the shadow path.
	internal func layoutShadowPath() {
		if shadowPathAutoSizeEnabled {
			if .None == depth {
				shadowPath = nil
			} else if nil == shadowPath {
				shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius).CGPath
			}
		}
	}
}
