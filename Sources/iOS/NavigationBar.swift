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

/// NavigationBar styles.
public enum NavigationBarStyle {
	case Tiny
	case Default
	case Medium
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
}

@IBDesignable
public class NavigationBar : UINavigationBar {
	/// NavigationBarStyle value.
	public var navigationBarStyle: NavigationBarStyle = .Default
	
	internal var animating: Bool = false
	
	/// Will render the view.
	public var willRenderView: Bool {
		return 0 < width && 0 < height
	}
	
	/// A preset wrapper around contentInset.
	public var contentInsetPreset: MaterialEdgeInset = .None {
		didSet {
			contentInset = MaterialEdgeInsetToValue(contentInsetPreset)
		}
	}
	
	/// A wrapper around grid.contentInset.
	@IBInspectable public var contentInset: UIEdgeInsets = UIEdgeInsetsZero {
		didSet {
			layoutSubviews()
		}
	}
	
	/// A preset wrapper around spacing.
	public var spacingPreset: MaterialSpacing = .None {
		didSet {
			spacing = MaterialSpacingToValue(spacingPreset)
		}
	}
	
	/// A wrapper around grid.spacing.
	@IBInspectable public var spacing: CGFloat = 0 {
		didSet {
			layoutSubviews()
		}
	}
	
	/// Grid cell factor.
	@IBInspectable public var gridFactor: CGFloat = 24 {
		didSet {
			assert(0 < gridFactor, "[Material Error: gridFactor must be greater than 0.]")
			layoutSubviews()
		}
	}
	
	/**
	The back button image writes to the backIndicatorImage property and
	backIndicatorTransitionMaskImage property.
	*/
	@IBInspectable public var backButtonImage: UIImage? {
		get {
			return backIndicatorImage
		}
		set(value) {
			let image: UIImage? = value
			backIndicatorImage = image
			backIndicatorTransitionMaskImage = image
		}
	}
	
	/**
	This property is the same as clipsToBounds. It crops any of the view's
	contents from bleeding past the view's frame. If an image is set using
	the image property, then this value does not need to be set, since the
	visualLayer's maskToBounds is set to true by default.
	*/
	@IBInspectable public var masksToBounds: Bool {
		get {
			return layer.masksToBounds
		}
		set(value) {
			layer.masksToBounds = value
		}
	}
	
	/// A property that accesses the backing layer's backgroundColor.
	@IBInspectable public override var backgroundColor: UIColor? {
		didSet {
			barTintColor = backgroundColor
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
	value that is not .None, the height will be adjusted to maintain the correct
	shape.
	*/
	@IBInspectable public var width: CGFloat {
		get {
			return layer.frame.size.width
		}
		set(value) {
			layer.frame.size.width = value
		}
	}
	
	/**
	A property that accesses the layer.frame.size.height property.
	When setting this property in conjunction with the shape property having a
	value that is not .None, the width will be adjusted to maintain the correct
	shape.
	*/
	@IBInspectable public var height: CGFloat {
		get {
			return layer.frame.size.height
		}
		set(value) {
			layer.frame.size.height = value
		}
	}
	
	/// A property that accesses the backing layer's shadowColor.
	@IBInspectable public var shadowColor: UIColor? {
		didSet {
			layer.shadowColor = shadowColor?.CGColor
		}
	}
	
	/// A property that accesses the backing layer's shadowOffset.
	@IBInspectable public var shadowOffset: CGSize {
		get {
			return layer.shadowOffset
		}
		set(value) {
			layer.shadowOffset = value
		}
	}
	
	/// A property that accesses the backing layer's shadowOpacity.
	@IBInspectable public var shadowOpacity: Float {
		get {
			return layer.shadowOpacity
		}
		set(value) {
			layer.shadowOpacity = value
		}
	}
	
	/// A property that accesses the backing layer's shadowRadius.
	@IBInspectable public var shadowRadius: CGFloat {
		get {
			return layer.shadowRadius
		}
		set(value) {
			layer.shadowRadius = value
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
		}
	}
	
	/// A preset property to set the borderWidth.
	public var borderWidthPreset: MaterialBorder = .None {
		didSet {
			borderWidth = MaterialBorderToValue(borderWidthPreset)
		}
	}
	
	/// A property that accesses the layer.borderWith.
	@IBInspectable public var borderWidth: CGFloat {
		get {
			return layer.borderWidth
		}
		set(value) {
			layer.borderWidth = value
		}
	}
	
	/// A property that accesses the layer.borderColor property.
	@IBInspectable public var borderColor: UIColor? {
		get {
			return nil == layer.borderColor ? nil : UIColor(CGColor: layer.borderColor!)
		}
		set(value) {
			layer.borderColor = value?.CGColor
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
	
	public override func intrinsicContentSize() -> CGSize {
		switch navigationBarStyle {
		case .Tiny:
			return CGSize(width: MaterialDevice.width, height: 32)
		case .Default:
			return CGSize(width: MaterialDevice.width, height: 44)
		case .Medium:
			return CGSize(width: MaterialDevice.width, height: 56)
		}
	}
	
	public override func sizeThatFits(size: CGSize) -> CGSize {
		return intrinsicContentSize()
	}
	
	public override func layoutSubviews() {
		super.layoutSubviews()
		
		if let v: UINavigationItem = topItem {
			layoutNavigationItem(v)
		}
		
		if let v: UINavigationItem = backItem {
			layoutNavigationItem(v)
		}
	}
	
	public override func pushNavigationItem(item: UINavigationItem, animated: Bool) {
		super.pushNavigationItem(item, animated: animated)
		layoutNavigationItem(item)
	}
	
	/**
	Lays out the UINavigationItem.
	- Parameter item: A UINavigationItem to layout.
	*/
	internal func layoutNavigationItem(item: UINavigationItem) {
		if willRenderView {
			prepareItem(item)
			
			if let titleView: UIView = prepareTitleView(item) {
				if let contentView: UIView = prepareContentView(item) {
					if let g: Int = Int(width / gridFactor) {
						let columns: Int = g + 1
						
						titleView.frame.origin = CGPoint.zero
						titleView.frame.size = intrinsicContentSize()
						titleView.grid.views = []
						titleView.grid.axis.columns = columns
						
						contentView.grid.columns = columns
						
						// leftControls
						if let v: Array<UIControl> = item.leftControls {
							for c in v {
								let w: CGFloat = c.intrinsicContentSize().width
								(c as? UIButton)?.contentEdgeInsets = UIEdgeInsetsZero
								c.frame.size.height = titleView.frame.size.height - contentInset.top - contentInset.bottom
								
								let q: Int = Int(w / gridFactor)
								c.grid.columns = q + 1
								
								contentView.grid.columns -= c.grid.columns
								
								titleView.addSubview(c)
								titleView.grid.views?.append(c)
							}
						}
						
						titleView.addSubview(contentView)
						titleView.grid.views?.append(contentView)
						
						// rightControls
						if let v: Array<UIControl> = item.rightControls {
							for c in v {
								let w: CGFloat = c.intrinsicContentSize().width
								(c as? UIButton)?.contentEdgeInsets = UIEdgeInsetsZero
								c.frame.size.height = titleView.frame.size.height - contentInset.top - contentInset.bottom
								
								let q: Int = Int(w / gridFactor)
								c.grid.columns = q + 1
								
								contentView.grid.columns -= c.grid.columns
								
								titleView.addSubview(c)
								titleView.grid.views?.append(c)
							}
						}
						
						titleView.grid.contentInset = contentInset
						titleView.grid.spacing = spacing
						titleView.grid.reloadLayout()
						
						// contentView alignment.
						if nil != item.title && "" != item.title {
							if nil == item.titleLabel.superview {
								contentView.addSubview(item.titleLabel)
							}
							item.titleLabel.frame = contentView.bounds
						} else {
							item.titleLabel.removeFromSuperview()
						}
						
						if nil != item.detail && "" != item.detail {
							if nil == item.detailLabel.superview {
								contentView.addSubview(item.detailLabel)
							}
							
							if nil == item.titleLabel.superview {
								item.detailLabel.frame = contentView.bounds
							} else {
								item.titleLabel.sizeToFit()
								item.detailLabel.sizeToFit()
								
								let diff: CGFloat = (contentView.frame.height - item.titleLabel.frame.height - item.detailLabel.frame.height) / 2
								
								item.titleLabel.frame.size.height += diff
								item.titleLabel.frame.size.width = contentView.frame.width
								
								item.detailLabel.frame.size.height += diff
								item.detailLabel.frame.size.width = contentView.frame.width
								item.detailLabel.frame.origin.y = item.titleLabel.frame.height
							}
						} else {
							item.detailLabel.removeFromSuperview()
						}
						
						contentView.grid.reloadLayout()
					}
				}
			}
		}
	}
	
	/**
	Prepares the view instance when intialized. When subclassing,
	it is recommended to override the prepareView method
	to initialize property values and other setup operations.
	The super.prepareView method should always be called immediately
	when subclassing.
	*/
	public func prepareView() {
		translucent = false
		depth = .Depth1
		spacingPreset = .Spacing1
		contentInsetPreset = .Square1
		contentScaleFactor = MaterialDevice.scale
		backButtonImage = MaterialIcon.cm.arrowBack
		let image: UIImage? = UIImage.imageWithColor(MaterialColor.clear, size: CGSizeMake(1, 1))
		shadowImage = image
		setBackgroundImage(image, forBarMetrics: .Default)
		backgroundColor = MaterialColor.white
	}
	
	/**
	Prepare the item by setting the title property to equal an empty string.
	- Parameter item: A UINavigationItem to layout.
	*/
	private func prepareItem(item: UINavigationItem) {
		item.hidesBackButton = false
		item.setHidesBackButton(true, animated: false)
	}
	
	/**
	Prepare the titleView.
	- Parameter item: A UINavigationItem to layout.
	- Returns: A UIView, which is the item.titleView.
	*/
	private func prepareTitleView(item: UINavigationItem) -> UIView {
		if nil == item.titleView {
			item.titleView = UIView(frame: CGRect.zero)
		}
		return item.titleView!
	}
	
	/**
	Prepare the contentView.
	- Parameter item: A UINavigationItem to layout.
	- Returns: A UIView, which is the item.contentView.
	*/
	private func prepareContentView(item: UINavigationItem) -> UIView {
		if nil == item.contentView {
			item.contentView = UIView(frame: CGRect.zero)
		}
		item.contentView!.grid.axis.direction = .Vertical
		return item.contentView!
	}
}