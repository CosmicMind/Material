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
	/// Left spacer moves the items to the left edge of the NavigationBar.
	private var leftSpacer: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: .FixedSpace, target: nil, action: nil)
	
	/// Right spacer moves the items to the right edge of the NavigationBar.
	private var rightSpacer: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: .FixedSpace, target: nil, action: nil)
	
	/// Reference to the backButton.
	public private(set) lazy var backButton: FlatButton = FlatButton()
	
	/**
	The back button image writes to the backIndicatorImage property and
	backIndicatorTransitionMaskImage property.
	*/
	@IBInspectable public var backButtonImage: UIImage? {
		get {
			return backIndicatorImage
		}
		set(value) {
			let image: UIImage? = nil == value ? MaterialIcon.arrowBack : value
			backIndicatorImage = image
			backIndicatorTransitionMaskImage = image
			backButton.setImage(image, forState: .Normal)
			backButton.setImage(image, forState: .Highlighted)
		}
	}
	
	/// A preset for contentInset.
	public var contentInsetPreset: MaterialEdgeInset = .None {
		didSet {
			contentInset = MaterialEdgeInsetToValue(contentInsetPreset)
		}
	}
	
	/// A UIEdgeInsets value for insetting the content.
	public var contentInset: UIEdgeInsets = MaterialEdgeInsetToValue(.None) {
		didSet {
			layoutSubviews()
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
	A property that accesses the layer.frame.origin.width property.
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
	A property that accesses the layer.frame.origin.height property.
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
	public var shadowOffset: CGSize {
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
		self.init(frame: CGRectNull)
	}
	
	public override func layoutSubviews() {
		super.layoutSubviews()
		if let v: UINavigationItem = topItem {
			sizeNavigationItem(v)
		}
		
		if let v: UINavigationItem = backItem {
			sizeNavigationItem(v)
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
		prepareItem(item)
		
		// leftControls
		if let v: Array<UIControl> = item.leftControls {
			var n: Array<UIBarButtonItem> = Array<UIBarButtonItem>()
			for c in v {
				n.append(UIBarButtonItem(customView: c))
			}
			n.append(leftSpacer)
			item.leftBarButtonItems = n.reverse()
		}
		
		// Set the titleView if title is empty.
		if "" == item.title {
			if nil == item.titleView {
				item.titleView = UIView(frame: CGRectMake(0, contentInset.top, MaterialDevice.width < MaterialDevice.height ? MaterialDevice.height : MaterialDevice.width, intrinsicContentSize().height - contentInset.top - contentInset.bottom))
				item.titleView!.autoresizingMask = [.FlexibleWidth]
				item.titleView!.grid.axis.direction = .Vertical
			}
			
			// TitleView alignment.
			if let t: UILabel = item.titleLabel {
				t.grid.rows = 1
				item.titleView!.addSubview(t)
				
				if let d: UILabel = item.detailLabel {
					d.grid.rows = 1
					item.titleView!.addSubview(d)
					item.titleView!.grid.views = [t, d]
				} else {
					item.titleView!.grid.views = [t]
				}
			} else if let d: UIView = item.detailView {
				d.grid.rows = 1
				item.titleView!.addSubview(d)
				item.titleView!.grid.views = [d]
			}
		}
		
		// rightControls
		if let v: Array<UIControl> = item.rightControls {
			var n: Array<UIBarButtonItem> = Array<UIBarButtonItem>()
			for c in v {
				n.append(UIBarButtonItem(customView: c))
			}
			
			n.append(rightSpacer)
			item.rightBarButtonItems = n.reverse()
		}
		
		sizeNavigationItem(item)
	}
	
	/**
	Sizes the UINavigationItem.
	- Parameter item: A UINavigationItem to size.
	*/
	internal func sizeNavigationItem(item: UINavigationItem) {
		let h: CGFloat = intrinsicContentSize().height
		let w: CGFloat = backButton.intrinsicContentSize().width
		let inset: CGFloat = MaterialDevice.landscape ? item.landscapeInset : item.portraitInset
		
		// leftControls
		if let v: Array<UIControl> = item.leftControls {
			for c in v {
				if let b: UIButton = c as? UIButton {
					b.contentEdgeInsets.top = 0
					b.contentEdgeInsets.bottom = 0
				}
				c.bounds.size = c is MaterialSwitch ? CGSizeMake(w, h - contentInset.top - contentInset.bottom) : CGSizeMake(c.intrinsicContentSize().width, h - contentInset.top - contentInset.bottom)
			}
			leftSpacer.width = inset + contentInset.left
		}
		
		item.titleView?.frame.size.width = width
		item.titleView?.frame.size.height = height - contentInset.top - contentInset.bottom
		
		if let t: UILabel = item.titleLabel {
			if 32 >= height || nil == item.detailLabel {
				t.font = t.font.fontWithSize(20)
				
				item.detailLabel?.hidden = true
				item.titleView?.grid.axis.rows = 1
			} else if let d: UILabel = item.detailLabel {
				t.font = t.font.fontWithSize(17)
				
				d.hidden = false
				d.font = d.font.fontWithSize(12)
				
				item.titleView?.grid.axis.rows = 2
			}
		} else if let _: UIView = item.detailView {
			item.titleView?.grid.axis.rows = 1
		}
		
		// rightControls
		if let v: Array<UIControl> = item.rightControls {
			for c in v {
				if let b: UIButton = c as? UIButton {
					b.contentEdgeInsets.top = 0
					b.contentEdgeInsets.bottom = 0
				}
				c.bounds.size = c is MaterialSwitch ? CGSizeMake(w, h - contentInset.top - contentInset.bottom) : CGSizeMake(c.intrinsicContentSize().width, h - contentInset.top - contentInset.bottom)
			}
			rightSpacer.width = inset + contentInset.right
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
		barStyle = .Black
		translucent = false
		backButtonImage = nil
		backgroundColor = MaterialColor.white
		depth = .Depth1
		contentInset = UIEdgeInsetsMake(2, 2, 2, 2)
		prepareBackButton()
	}
	
	/// Prepares the backButton.
	internal func prepareBackButton() {
		backButton.pulseScale = false
		backButton.pulseColor = MaterialColor.white
		backButton.setImage(backButtonImage, forState: .Normal)
		backButton.setImage(backButtonImage, forState: .Highlighted)
	}
	
	/// Prepares the UINavigationItem for layout and sizing.
	internal func prepareItem(item: UINavigationItem) {
		if nil == item.title {
			item.title = ""
		}
	}
}
