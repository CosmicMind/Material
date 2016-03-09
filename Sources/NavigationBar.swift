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

public class NavigationBar : UINavigationBar {
	/// Reference to the backButton.
	public private(set) lazy var backButton: FlatButton = FlatButton()
	
	/**
	The back button image writes to the backIndicatorImage property and
	backIndicatorTransitionMaskImage property.
	*/
	public var backButtonImage: UIImage? {
		didSet {
			if nil == backButtonImage {
				backButtonImage = MaterialIcon.arrowBack
			}
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
	public var masksToBounds: Bool {
		get {
			return layer.masksToBounds
		}
		set(value) {
			layer.masksToBounds = value
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
		
		if let item: UINavigationItem = topItem {
			layoutNavigationItem(item)
		}
		
		topItem?.titleView?.grid.reloadLayout()
	}
	
	public override func pushNavigationItem(item: UINavigationItem, animated: Bool) {
		super.pushNavigationItem(item, animated: animated)
		layoutNavigationItem(item)
	}
	
	/**
	Lays out the UINavigationItem.
	- Parameter item: A UINavigationItem to layout.
	*/
	public func layoutNavigationItem(item: UINavigationItem) {
		prepareItem(item)
		
		let h: CGFloat = intrinsicContentSize().height
		let w: CGFloat = backButton.intrinsicContentSize().width
		let inset: CGFloat = MaterialDevice.landscape ? item.landscapeInset : item.portraitInset
		
		// leftControls
		if let v: Array<UIControl> = item.leftControls {
			var n: Array<UIBarButtonItem> = Array<UIBarButtonItem>()
			for c in v {
				if let b: UIButton = c as? UIButton {
					b.contentEdgeInsets.top = 0
					b.contentEdgeInsets.bottom = 0
				}
				c.bounds.size = c is MaterialSwitch ? CGSizeMake(w, h - contentInset.top - contentInset.bottom) : CGSizeMake(c.intrinsicContentSize().width, h - contentInset.top - contentInset.bottom)
				n.append(UIBarButtonItem(customView: c))
			}
			
			// The spacer moves the UIBarButtonItems to the edge of the UINavigationBar.
			let spacer: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: .FixedSpace, target: nil, action: nil)
			spacer.width = inset + contentInset.left
			n.append(spacer)
			
			item.leftBarButtonItems = n.reverse()
		}
		
		if nil == item.titleView {
			item.titleView = UIView()
			item.titleView!.backgroundColor = nil
			item.titleView!.grid.axis.direction = .Vertical
		}
		
		item.titleView!.frame = CGRectMake(0, contentInset.top, MaterialDevice.width < MaterialDevice.height ? MaterialDevice.height : MaterialDevice.width, h - contentInset.top - contentInset.bottom)
		item.titleView!.grid.views = []
		
		// TitleView alignment.
		if let t: UILabel = item.titleLabel {
			t.grid.rows = 1
			
			item.titleView!.addSubview(t)
			item.titleView!.grid.views?.append(t)
			
			if 32 >= height || nil == item.detailLabel {
				t.font = t.font?.fontWithSize(20)
				item.titleView!.grid.axis.rows = 1
				item.detailLabel?.hidden = true
			} else if let d: UILabel = item.detailLabel {
				d.grid.rows = 1
				d.hidden = false
				d.font = d.font.fontWithSize(12)
				t.font = t.font.fontWithSize(17)
				item.titleView!.addSubview(d)
				item.titleView!.grid.axis.rows = 2
				item.titleView!.grid.views?.append(d)
			}
		} else if let d: UIView = item.detailView {
			d.grid.rows = 1
			
			item.titleView!.addSubview(d)
			item.titleView!.grid.axis.rows = 1
			item.titleView!.grid.views?.append(d)
		}
		
		// rightControls
		if let v: Array<UIControl> = item.rightControls {
			var n: Array<UIBarButtonItem> = Array<UIBarButtonItem>()
			for c in v {
				if let b: UIButton = c as? UIButton {
					b.contentEdgeInsets.top = 0
					b.contentEdgeInsets.bottom = 0
				}
				c.bounds.size = c is MaterialSwitch ? CGSizeMake(w, h - contentInset.top - contentInset.bottom) : CGSizeMake(c.intrinsicContentSize().width, h - contentInset.top - contentInset.bottom)
				n.append(UIBarButtonItem(customView: c))
			}
			
			// The spacer moves the UIBarButtonItems to the edge of the UINavigationBar.
			let spacer: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: .FixedSpace, target: nil, action: nil)
			spacer.width = inset + contentInset.right
			n.append(spacer)
			
			item.rightBarButtonItems = n.reverse()
		}
		
		item.titleView!.grid.reloadLayout()
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
		item.title = ""
	}
}

/// A memory reference to the NavigationItem instance for UINavigationBar extensions.
private var NavigationItemKey: UInt8 = 0

public class NavigationItem {
	/// Inset.
	public var portraitInset: CGFloat = .iPad == MaterialDevice.type || "iPhone 6s Plus" == MaterialDevice.model || "iPhone 6 Plus" == MaterialDevice.model ? -20 : -16
	
	public var landscapeInset: CGFloat = -20
	
	/// Detail View.
	public var detailView: UIView?
	
	/// Title label.
	public var titleLabel: UILabel?
	
	/// Detail label.
	public var detailLabel: UILabel?
	
	/// Left controls.
	public var leftControls: Array<UIControl>?
	
	/// Right controls.
	public var rightControls: Array<UIControl>?
}

public extension UINavigationItem {
	/// NavigationBarControls reference.
	public internal(set) var item: NavigationItem {
		get {
			return MaterialAssociatedObject(self, key: &NavigationItemKey) {
				return NavigationItem()
			}
		}
		set(value) {
			MaterialAssociateObject(self, key: &NavigationItemKey, value: value)
		}
	}
	
	/// Portrait inset.
	public var portraitInset: CGFloat {
		get {
			return item.portraitInset
		}
		set(value) {
			item.portraitInset = value
		}
	}
	
	/// Landscape inset.
	public var landscapeInset: CGFloat {
		get {
			return item.landscapeInset
		}
		set(value) {
			item.landscapeInset = value
		}
	}
	
	/// Detail View.
	public var detailView: UIView? {
		get {
			return item.detailView
		}
		set(value) {
			item.detailView = value
		}
	}
	
	/// Title Label.
	public var titleLabel: UILabel? {
		get {
			return item.titleLabel
		}
		set(value) {
			item.titleLabel = value
		}
	}
	
	/// Detail Label.
	public var detailLabel: UILabel? {
		get {
			return item.detailLabel
		}
		set(value) {
			item.detailLabel = value
		}
	}
	
	/// Left side UIControls.
	public var leftControls: Array<UIControl>? {
		get {
			return item.leftControls
		}
		set(value) {
			item.leftControls = value
		}
	}
	
	/// Right side UIControls.
	public var rightControls: Array<UIControl>? {
		get {
			return item.rightControls
		}
		set(value) {
			item.rightControls = value
		}
	}
}