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

public class ControlView: View {
	/// Will render the view.
	public var willRenderView: Bool {
		return 0 < width && 0 < height
	}
	
	/// A preset wrapper around contentInset.
	public var contentEdgeInsetsPreset: EdgeInsetsPreset {
		get {
			return grid.contentEdgeInsetsPreset
		}
		set(value) {
			grid.contentEdgeInsetsPreset = value
		}
	}
	
	/// A wrapper around grid.contentInset.
	@IBInspectable public var contentInset: EdgeInsets {
		get {
			return grid.contentInset
		}
		set(value) {
			grid.contentInset = value
		}
	}
	
	/// A preset wrapper around interimSpace.
	public var interimSpacePreset: InterimSpacePreset = .none {
		didSet {
            interimSpace = InterimSpacePresetToValue(preset: interimSpacePreset)
		}
	}
	
	/// A wrapper around grid.interimSpace.
	@IBInspectable public var interimSpace: InterimSpace {
		get {
			return grid.interimSpace
		}
		set(value) {
			grid.interimSpace = value
		}
	}
	
    public override var intrinsicContentSize: CGSize {
        return CGSize(width: width, height: 44)
    }
    
	/// Grid cell factor.
	@IBInspectable public var gridFactor: CGFloat = 24 {
		didSet {
			assert(0 < gridFactor, "[Material Error: gridFactor must be greater than 0.]")
			layoutSubviews()
		}
	}

	/// ContentView that holds the any desired subviews.
	public private(set) var contentView: View!
	
	/// Left side UIControls.
	public var leftControls: [UIView]? {
		didSet {
			if let v = oldValue {
				for b in v {
					b.removeFromSuperview()
				}
			}
			
			if let v = leftControls {
				for b in v {
					addSubview(b)
				}
			}
			layoutSubviews()
		}
	}
	
	/// Right side UIControls.
	public var rightControls: [UIView]? {
		didSet {
			if let v = oldValue {
				for b in v {
					b.removeFromSuperview()
				}
			}
			
			if let v = rightControls {
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
		frame.size = intrinsicContentSize
	}
	
	/**
     A convenience initializer with parameter settings.
     - Parameter leftControls: An Array of UIControls that go on the left side.
     - Parameter rightControls: An Array of UIControls that go on the right side.
     */
	public init(leftControls: [UIView]? = nil, rightControls: [UIView]? = nil) {
		super.init(frame: CGRect.zero)
		frame.size = intrinsicContentSize
		prepareProperties(leftControls: leftControls, rightControls: rightControls)
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
				if let v = leftControls {
					for c in v {
						let w: CGFloat = c.intrinsicContentSize.width
						(c as? UIButton)?.contentEdgeInsets = UIEdgeInsets.zero
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
				if let v = rightControls {
					for c in v {
						let w: CGFloat = c.intrinsicContentSize.width
						(c as? UIButton)?.contentEdgeInsets = UIEdgeInsets.zero
						c.frame.size.height = frame.size.height - contentInset.top - contentInset.bottom
						
						let q: Int = Int(w / gridFactor)
						c.grid.columns = q + 1
						
						contentView.grid.columns -= c.grid.columns
						
						addSubview(c)
						grid.views?.append(c)
					}
				}
				
				grid.contentInset = contentInset
				grid.interimSpace = interimSpace
				grid.reload()
				contentView.grid.reload()
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
	public override func prepareView() {
		super.prepareView()
		interimSpacePreset = .interimSpace1
		contentEdgeInsetsPreset = .square1
		autoresizingMask = .flexibleWidth
		isShadowPathAutoSizing = false
		prepareContentView()
	}
	
	/**
     Used to trigger property changes that initializers avoid.
     - Parameter leftControls: An Array of UIControls that go on the left side.
     - Parameter rightControls: An Array of UIControls that go on the right side.
     */
	internal func prepareProperties(leftControls: [UIView]?, rightControls: [UIView]?) {
		self.leftControls = leftControls
		self.rightControls = rightControls
	}
	
	/// Prepares the contentView.
	private func prepareContentView() {
		contentView = View()
		contentView.backgroundColor = nil
		addSubview(contentView)
	}
}
