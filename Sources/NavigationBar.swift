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

public class Controls {
	/// Left controls.
	public var leftControls: Array<UIControl>?
	
	/// Right controls.
	public var rightControls: Array<UIControl>?
}

public extension UINavigationBar {
	/// Grid reference.
	public var controls: Controls {
		get {
			return MaterialObjectAssociatedObject(self, key: &NavigationBarKey) {
				return Controls()
			}
		}
		set(value) {
			MaterialObjectAssociateObject(self, key: &NavigationBarKey, value: value)
		}
	}
	
	public var title: String? {
		get {
			return topItem?.title
		}
		set(value) {
			topItem?.title = value
		}
	}
	
	/// Device status bar style.
	public var statusBarStyle: UIStatusBarStyle {
		get {
			return UIApplication.sharedApplication().statusBarStyle
		}
		set(value) {
			UIApplication.sharedApplication().statusBarStyle = value
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
					let b: UIBarButtonItem = UIBarButtonItem(customView: q)
					b.width = q.intrinsicContentSize().width
					c.append(b)
					
				}
			}
			controls.leftControls = value
			topItem?.leftBarButtonItems = c
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
					let b: UIBarButtonItem = UIBarButtonItem(customView: q)
					b.width = q.intrinsicContentSize().width
					c.append(b)
					
				}
			}
			controls.rightControls = value
			topItem?.rightBarButtonItems = c
		}
	}
}

public class NavigationBar : UINavigationBar {
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
//				layoutShadowPath()
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
//			layoutShadowPath()
		}
	}
	
	public required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		prepareView()
	}
	
	public override init(frame: CGRect) {
		super.init(frame: frame)
		prepareView()
	}
	
	public func prepareView() {
		translucent = false
		barStyle = .Black
		backButtonImage = nil
		backgroundColor = MaterialColor.white
		depth = .Depth1
	}
}
