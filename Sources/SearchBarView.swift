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

@objc(SearchBarViewDelegate)
public protocol SearchBarViewDelegate : MaterialDelegate {
	optional func searchBarViewDidChangeLayout(searchBarView: SearchBarView)
}

public class SearchBarView : MaterialView {
	/// Tracks the old frame size.
	private var oldFrame: CGRect?
	
	/// The UITextField for the searchBar.
	public private(set) lazy var textField: TextField = TextField()
	
	/// StatusBar style.
	public var statusBarStyle: UIStatusBarStyle = UIApplication.sharedApplication().statusBarStyle {
		didSet {
			UIApplication.sharedApplication().statusBarStyle = statusBarStyle
		}
	}
	
	/// A preset wrapper around contentInset.
	public var contentInsetPreset: MaterialEdgeInset = .None {
		didSet {
			contentInset = MaterialEdgeInsetToValue(contentInsetPreset)
		}
	}
	
	/// A wrapper around grid.contentInset.
	public var contentInset: UIEdgeInsets {
		get {
			return grid.contentInset
		}
		set(value) {
			grid.contentInset = contentInset
			reloadView()
		}
	}
	
	/// A wrapper around grid.spacing.
	public var spacing: CGFloat {
		get {
			return grid.spacing
		}
		set(value) {
			grid.spacing = spacing
			reloadView()
		}
	}
	
	/// Left side UIControls.
	public var leftControls: Array<UIControl>? {
		didSet {
			reloadView()
		}
	}
	
	/// Right side UIControls.
	public var rightControls: Array<UIControl>? {
		didSet {
			reloadView()
		}
	}
	
	/// The UIImage for the clear icon.
	public var clearButton: UIButton? {
		didSet {
			if let v: UIButton = clearButton {
				v.contentEdgeInsets = UIEdgeInsetsZero
				v.addTarget(self, action: "handleClearButton", forControlEvents: .TouchUpInside)
			}
			textField.rightView = clearButton
		}
	}
	
	/// TintColor for searchBar.
	public override var tintColor: UIColor? {
		didSet {
			textField.tintColor = tintColor
		}
	}
	
	/// TextColor for searchBar.
	public var textColor: UIColor? {
		didSet {
			textField.textColor = textColor
		}
	}
	
	/// Placeholder textColor.
	public var placeholderTextColor: UIColor? {
		didSet {
			if let v: String = textField.placeholder {
				textField.attributedPlaceholder = NSAttributedString(string: v, attributes: [NSForegroundColorAttributeName: MaterialColor.white])
			}
		}
	}
	
	/// A wrapper for searchBar.placeholder.
	public var placeholder: String? {
		didSet {
			textField.placeholder = placeholder
			if let v: String = textField.placeholder {
				textField.attributedPlaceholder = NSAttributedString(string: v, attributes: [NSForegroundColorAttributeName: MaterialColor.white])
			}
		}
	}
	
	/**
	An initializer that initializes the object with a NSCoder object.
	- Parameter aDecoder: A NSCoder instance.
	*/
	public required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
	}
	
	/**
	An initializer that initializes the object with a CGRect object.
	If AutoLayout is used, it is better to initilize the instance
	using the init() initializer.
	- Parameter frame: A CGRect instance.
	*/
	public override init(frame: CGRect) {
		super.init(frame: frame)
	}
	
	/// A convenience initializer.
	public convenience init() {
		self.init(frame: CGRectMake(0, 0, UIScreen.mainScreen().bounds.width, 64))
	}
	
	/**
	A convenience initializer with parameter settings.
	- Parameter leftControls: An Array of UIControls that go on the left side.
	- Parameter rightControls: An Array of UIControls that go on the right side.
	*/
	public convenience init?(leftControls: Array<UIControl>? = nil, rightControls: Array<UIControl>? = nil) {
		self.init(frame: CGRectMake(0, 0, UIScreen.mainScreen().bounds.width, 64))
		prepareProperties(leftControls, rightControls: rightControls)
	}
	
	public override func layoutSubviews() {
		super.layoutSubviews()
		
		// General alignment.
		if UIApplication.sharedApplication().statusBarOrientation.isLandscape {
			grid.contentInset.top = 8
			height = 44
		} else {
			grid.contentInset.top = 28
			height = 64
		}
		
		// Column adjustment.
		width = UIScreen.mainScreen().bounds.width
		grid.axis.columns = Int(width / 48)
		if frame.origin.x != oldFrame!.origin.x || frame.origin.y != oldFrame!.origin.y || frame.width != oldFrame!.width || frame.height != oldFrame!.height {
			(delegate as? SearchBarViewDelegate)?.searchBarViewDidChangeLayout?(self)
			oldFrame = frame
		}
		reloadView()
	}
	
	public override func didMoveToSuperview() {
		super.didMoveToSuperview()
		reloadView()
	}
	
	/// Reloads the view.
	public func reloadView() {
		layoutIfNeeded()
		
		// clear constraints so new ones do not conflict
		removeConstraints(constraints)
		for v in subviews {
			if v != textField {
				v.removeFromSuperview()
			}
		}
		
		// Size of single grid column.
		let g: CGFloat = width / CGFloat(0 < grid.columns ? grid.columns : 1)
		
		grid.views = []
		textField.grid.columns = grid.axis.columns
		
		// leftControls
		if let v: Array<UIControl> = leftControls {
			for c in v {
				let w: CGFloat = c.intrinsicContentSize().width
				if let b: UIButton = c as? UIButton {
					b.contentEdgeInsets = UIEdgeInsetsZero
				}
				
				c.grid.columns = 0 == g ? 1 : Int(ceil(w / g))
				textField.grid.columns -= c.grid.columns
				
				addSubview(c)
				grid.views?.append(c)
			}
		}
		
		grid.views?.append(textField)
		
		// rightControls
		if let v: Array<UIControl> = rightControls {
			for c in v {
				let w: CGFloat = c.intrinsicContentSize().width
				if let b: UIButton = c as? UIButton {
					b.contentEdgeInsets = UIEdgeInsetsZero
				}
				
				c.grid.columns = 0 == g ? 1 : Int(ceil(w / g))
				textField.grid.columns -= c.grid.columns
				
				addSubview(c)
				grid.views?.append(c)
			}
		}
		
		/// Prepare the clearButton
		if let v: UIButton = clearButton {
			v.frame = CGRectMake(0, 0, textField.height, textField.height)
		}
		
		textField.grid.columns -= textField.grid.offset.columns
		
		grid.reloadLayout()
	}
	
	/**
	Prepares the view instance when intialized. When subclassing,
	it is recommended to override the prepareView method
	to initialize property values and other setup operations.
	The super.prepareView method should always be called immediately
	when subclassing.
	*/
	public override func prepareView() {
		super.prepareView()
		oldFrame = frame
		grid.spacing = 8
		grid.axis.inherited = false
		grid.contentInset.left = 8
		grid.contentInset.bottom = 8
		grid.contentInset.right = 8
		depth = .Depth1
		prepareTextField()
	}
	
	/// Clears the textField text.
	internal func handleClearButton() {
		textField.text = ""
	}
	
	/// Prepares the textField.
	private func prepareTextField() {
		textField.placeholder = "Search"
		textField.backgroundColor = MaterialColor.clear
		textField.clearButtonMode = .Never
		textField.rightViewMode = .WhileEditing
		addSubview(textField)
	}
	
	/**
	Used to trigger property changes  that initializers avoid.
	- Parameter titleLabel: UILabel for the title.
	- Parameter detailLabel: UILabel for the details.
	- Parameter leftControls: An Array of UIControls that go on the left side.
	- Parameter rightControls: An Array of UIControls that go on the right side.
	*/
	private func prepareProperties(leftControls: Array<UIControl>?, rightControls: Array<UIControl>?) {
		self.leftControls = leftControls
		self.rightControls = rightControls
	}
}
