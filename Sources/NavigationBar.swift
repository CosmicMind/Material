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
	
	/**
	The back button image writes to the backIndicatorImage property and
	backIndicatorTransitionMaskImage property.
	*/
	public var backButtonImage: UIImage? {
		didSet {
			if nil == backButtonImage {
				backButtonImage = UIImage(named: "ic_arrow_back_white", inBundle: NSBundle(identifier: "io.cosmicmind.Material"), compatibleWithTraitCollection: nil)
			}
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
	
	/**
	An initializer that initializes the object with a NSCoder object.
	- Parameter aDecoder: A NSCoder instance.
	*/
	public required init?(coder aDecoder: NSCoder) {
		contentsGravityPreset = .ResizeAspectFill
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
		contentsGravityPreset = .ResizeAspectFill
		super.init(frame: frame)
		prepareView()
	}
	
	/// A convenience initializer.
	public convenience init() {
		self.init(frame: CGRectNull)
	}
	
	/// Overriding the layout callback for sublayers.
	public override func layoutSublayersOfLayer(layer: CALayer) {
		super.layoutSublayersOfLayer(layer)
		if self.layer == layer {
			layoutVisualLayer()
			layoutShadowPath()
		}
	}
	
	public func layoutNavigationItem(item: UINavigationItem) {
		grid.views = []
		grid.axis.columns = Int(width / 48)
		
		let g: CGFloat = width / CGFloat(grid.axis.columns)
			
		var columns: Int = grid.axis.columns
		
		// leftControls
		if let v: Array<UIControl> = item.leftControls {
			for c in v {
				if let b: UIButton = c as? UIButton {
					b.contentEdgeInsets = UIEdgeInsetsZero
				}
				
				c.grid.columns = 0 == g ? 1 : Int(ceil(c.intrinsicContentSize().width / g))
				columns -= c.grid.columns
				grid.views?.append(c)
			}
		}
		
		if nil == item.titleView {
			item.titleView = UIView()
			item.titleView!.backgroundColor = nil
			item.titleView!.grid.axis.direction = .Vertical
		}
		
		item.titleView!.grid.views = []
		
		// TitleView alignment.
		if let t: UILabel = item.titleLabel {
			item.titleView!.addSubview(t)
			item.titleView!.grid.views?.append(t)
			
			if let d: UILabel = item.detailLabel {
				t.grid.rows = 2
				t.font = t.font.fontWithSize(17)
				d.grid.rows = 2
				d.font = d.font.fontWithSize(12)
				item.titleView!.addSubview(d)
				item.titleView!.grid.views?.append(d)
				item.titleView!.grid.axis.rows = 3
				item.titleView!.grid.spacing = -8
				item.titleView!.grid.contentInset.top = -8
			} else {
				t.grid.rows = 1
				t.font = t.font?.fontWithSize(20)
				item.titleView!.grid.axis.rows = 1
				item.titleView!.grid.spacing = 0
				item.titleView!.grid.contentInset.top = 0
			}
		}
		
		grid.views?.append(item.titleView!)
		
		// rightControls
		if let v: Array<UIControl> = item.rightControls {
			for c in v {
				if let b: UIButton = c as? UIButton {
					b.contentEdgeInsets = UIEdgeInsetsZero
				}
				
				c.grid.columns = 0 == g ? 1 : Int(ceil(c.intrinsicContentSize().width / g))
				columns -= c.grid.columns
				
				grid.views!.append(c)
			}
		}
		
		item.titleView!.grid.columns = columns
		
		grid.reloadLayout()
		item.titleView?.grid.reloadLayout()
	}
	
	/**
	Prepares the view instance when intialized. When subclassing,
	it is recommended to override the prepareView method
	to initialize property values and other setup operations.
	The super.prepareView method should always be called immediately
	when subclassing.
	*/
	public func prepareView() {
		prepareVisualLayer()
		barStyle = .Black
		translucent = false
		backButtonImage = nil
		backgroundColor = MaterialColor.white
		depth = .Depth1
		spacingPreset = .Spacing2
		contentInset = UIEdgeInsetsMake(8, 0, 8, 0)
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

/// A memory reference to the NavigationBarControls instance for UINavigationBar extensions.
private var NavigationItemControlsKey: UInt8 = 0

public class NavigationItemControls {
	/// Left controls.
	public var leftControls: Array<UIControl>?
	
	/// Right controls.
	public var rightControls: Array<UIControl>?
}

/// A memory reference to the NavigationItemLabels instance for UINavigationItem extensions.
private var NavigationItemLabelsKey: UInt8 = 0

public class NavigationItemLabels {
	/// Title label.
	public var titleLabel: UILabel?
	
	/// Detail label.
	public var detailLabel: UILabel?
}

public extension UINavigationItem {
	/// NavigationBarControls reference.
	public internal(set) var labels: NavigationItemLabels {
		get {
			return MaterialAssociatedObject(self, key: &NavigationItemLabelsKey) {
				return NavigationItemLabels()
			}
		}
		set(value) {
			MaterialAssociateObject(self, key: &NavigationItemLabelsKey, value: value)
		}
	}
	
	/// Title Label.
	public var titleLabel: UILabel? {
		get {
			return labels.titleLabel
		}
		set(value) {
			labels.titleLabel = value
		}
	}
	
	/// Detail Label.
	public var detailLabel: UILabel? {
		get {
			return labels.detailLabel
		}
		set(value) {
			labels.detailLabel = value
		}
	}
	
	/// NavigationBarControls reference.
	public internal(set) var controls: NavigationItemControls {
		get {
			return MaterialAssociatedObject(self, key: &NavigationItemControlsKey) {
				return NavigationItemControls()
			}
		}
		set(value) {
			MaterialAssociateObject(self, key: &NavigationItemControlsKey, value: value)
		}
	}
	
	/// Left side UIControls.
	public var leftControls: Array<UIControl>? {
		get {
			return controls.leftControls
		}
		set(value) {
			var c: Array<UIBarButtonItem> = Array<UIBarButtonItem>()
			if let v: Array<UIControl> = value {
				for q in v {
					c.append(UIBarButtonItem(customView: q))
				}
			}
			
			let spacer: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: .FixedSpace, target: nil, action: nil)
			spacer.width = 0
			c.append(spacer)
			
			controls.leftControls = value
			leftBarButtonItems = c.reverse()
		}
	}
	
	/// Right side UIControls.
	public var rightControls: Array<UIControl>? {
		get {
			return controls.rightControls
		}
		set(value) {
			var c: Array<UIBarButtonItem> = Array<UIBarButtonItem>()
			if let v: Array<UIControl> = value {
				for q in v {
					c.append(UIBarButtonItem(customView: q))
				}
			}
			
			let spacer: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: .FixedSpace, target: nil, action: nil)
			spacer.width = 0
			c.append(spacer)
			
			controls.rightControls = value
			rightBarButtonItems = c.reverse()
		}
	}
}

public extension UINavigationBar {
	/// Device status bar style.
	public var statusBarStyle: UIStatusBarStyle {
		get {
			return MaterialDevice.statusBarStyle
		}
		set(value) {
			MaterialDevice.statusBarStyle = value
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
	public var spacingPreset: MaterialSpacing {
		get {
			return grid.spacingPreset
		}
		set(value) {
			grid.spacingPreset = value
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
}
