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

public class ControlView : MaterialView {
	/// Will render the view.
	public var willRenderView: Bool {
		return 0 < width && 0 < height
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
	@IBInspectable public var contentInset: UIEdgeInsets {
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
	@IBInspectable public var spacing: CGFloat {
		get {
			return grid.spacing
		}
		set(value) {
			grid.spacing = value
		}
	}
	
	/// Grid cell factor.
	@IBInspectable public var gridFactor: CGFloat = 24 {
		didSet {
			assert(0 < gridFactor, "[Material Error: gridFactor must be greater than 0.]")
			layoutSubviews()
		}
	}

	/// ContentView that holds the any desired subviews.
	public private(set) var contentView: MaterialView!
	
	/// Left side UIControls.
	public var leftControls: Array<UIControl>? {
		didSet {
			if let v: Array<UIControl> = oldValue {
				for b in v {
					b.removeFromSuperview()
				}
			}
			
			if let v: Array<UIControl> = leftControls {
				for b in v {
					addSubview(b)
				}
			}
			layoutSubviews()
		}
	}
	
	/// Right side UIControls.
	public var rightControls: Array<UIControl>? {
		didSet {
			if let v: Array<UIControl> = oldValue {
				for b in v {
					b.removeFromSuperview()
				}
			}
			
			if let v: Array<UIControl> = rightControls {
				for b in v {
					addSubview(b)
				}
			}
			layoutSubviews()
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
	
	/// Basic initializer.
	public init() {
		super.init(frame: CGRect.zero)
		frame.size = intrinsicContentSize()
	}
	
	/**
	A convenience initializer with parameter settings.
	- Parameter leftControls: An Array of UIControls that go on the left side.
	- Parameter rightControls: An Array of UIControls that go on the right side.
	*/
	public init(leftControls: Array<UIControl>? = nil, rightControls: Array<UIControl>? = nil) {
		super.init(frame: CGRect.zero)
		frame.size = intrinsicContentSize()
		prepareProperties(leftControls, rightControls: rightControls)
	}
	
	public override func layoutSubviews() {
		super.layoutSubviews()
		if willRenderView {
			layoutIfNeeded()
			
			if let g: Int = Int(width / gridFactor) {
				let columns: Int = g + 1
				
				grid.views = []
				grid.axis.columns = columns
				
				contentView.grid.columns = columns
				
				// leftControls
				if let v: Array<UIControl> = leftControls {
					for c in v {
						let w: CGFloat = c.intrinsicContentSize().width
						(c as? UIButton)?.contentEdgeInsets = UIEdgeInsetsZero
						c.frame.size.height = frame.size.height - contentInset.top - contentInset.bottom
						
						let q: Int = Int(w / gridFactor)
						c.grid.columns = q + 1
						
						contentView.grid.columns -= c.grid.columns
						
						addSubview(c)
						grid.views?.append(c)
					}
				}
				
				addSubview(contentView)
				grid.views?.append(contentView)
				
				// rightControls
				if let v: Array<UIControl> = rightControls {
					for c in v {
						let w: CGFloat = c.intrinsicContentSize().width
						(c as? UIButton)?.contentEdgeInsets = UIEdgeInsetsZero
						c.frame.size.height = frame.size.height - contentInset.top - contentInset.bottom
						
						let q: Int = Int(w / gridFactor)
						c.grid.columns = q + 1
						
						contentView.grid.columns -= c.grid.columns
						
						addSubview(c)
						grid.views?.append(c)
					}
				}
				
				grid.contentInset = contentInset
				grid.spacing = spacing
				grid.reloadLayout()
				contentView.grid.reloadLayout()
			}
		}
	}
	
	public override func intrinsicContentSize() -> CGSize {
		return CGSizeMake(width, 44)
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
		spacingPreset = .Spacing1
		contentInsetPreset = .Square1
		autoresizingMask = .FlexibleWidth
		shadowPathAutoSizeEnabled = false
		prepareContentView()
	}
	
	/**
	Used to trigger property changes that initializers avoid.
	- Parameter leftControls: An Array of UIControls that go on the left side.
	- Parameter rightControls: An Array of UIControls that go on the right side.
	*/
	internal func prepareProperties(leftControls: Array<UIControl>?, rightControls: Array<UIControl>?) {
		self.leftControls = leftControls
		self.rightControls = rightControls
	}
	
	/// Prepares the contentView.
	private func prepareContentView() {
		contentView = MaterialView()
		contentView.backgroundColor = nil
		addSubview(contentView)
	}
}
