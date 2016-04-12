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

@objc(TextViewDelegate)
public protocol TextViewDelegate : UITextViewDelegate {}

@IBDesignable
@objc(TextView)
public class TextView: MaterialView {
	/// Reference to the textView.
	public private(set) var textView: MaterialTextView!
	
	/**
	Text container UIEdgeInset preset property. This updates the
	textContainerInset property with a preset value.
	*/
	public var textContainerInsetPreset: MaterialEdgeInset {
		get {
			return textView.textContainerInsetPreset
		}
		set(value) {
			textView.textContainerInsetPreset = value
		}
	}
	
	/// Text container UIEdgeInset property.
	public var textContainerInset: UIEdgeInsets {
		get {
			return textView.textContainerInset
		}
		set(value) {
			textView.textContainerInset = value
		}
	}
	
	/**
	The title UILabel that is displayed when there is text. The
	titleLabel text value is updated with the placeholder text
	value before being displayed.
	*/
	@IBInspectable public private(set) var titleLabel: UILabel!
	
	/// The color of the titleLabel text when the textField is not active.
	@IBInspectable public var titleLabelColor: UIColor? {
		didSet {
			titleLabel.textColor = titleLabelColor
			if nil == lineLayerColor {
				lineLayerColor = titleLabelColor
			}
		}
	}
	
	/// The color of the titleLabel text when the textField is active.
	@IBInspectable public var titleLabelActiveColor: UIColor? {
		didSet {
			if nil == lineLayerActiveColor {
				lineLayerActiveColor = titleLabelActiveColor
			}
			tintColor = titleLabelActiveColor
		}
	}
	
	/**
	A property that sets the distance between the textField and
	titleLabel.
	*/
	@IBInspectable public var titleLabelAnimationDistance: CGFloat = 4
	
	/// The bottom border layer.
	public private(set) lazy var lineLayer: CAShapeLayer = CAShapeLayer()
	
	/**
	A property that sets the distance between the textField and
	lineLayer.
	*/
	@IBInspectable public var lineLayerDistance: CGFloat = 4
	
	/// The lineLayer color when inactive.
	@IBInspectable public var lineLayerColor: UIColor? {
		didSet {
			lineLayer.backgroundColor = lineLayerColor?.CGColor
		}
	}
	
	/// The lineLayer active color.
	@IBInspectable public var lineLayerActiveColor: UIColor?
	
	/// Sets the placeholder value.
	@IBInspectable public var placeholder: String? {
		didSet {
			if let v: String = placeholder {
//				attributedText = NSAttributedString(string: v, attributes: [NSForegroundColorAttributeName: placeholderTextColor])
			}
		}
	}
	
	/// Placeholder textColor.
	@IBInspectable public var placeholderTextColor: UIColor = MaterialColor.darkText.others {
		didSet {
			if let v: String = placeholder {
//				attributedText = NSAttributedString(string: v, attributes: [NSForegroundColorAttributeName: placeholderTextColor])
			}
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
	
	public init() {
		super.init(frame: CGRectNull)
	}
	
	/// Overriding the layout callback for sublayers.
	public override func layoutSublayersOfLayer(layer: CALayer) {
		super.layoutSublayersOfLayer(layer)
		if self.layer == layer {
			layoutLineLayer()
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
		backgroundColor = MaterialColor.white
		masksToBounds = false
		prepareTextView()
		prepareTitleLabel()
		prepareLineLayer()
	}
	
	/// Prepares the textView.
	private func prepareTextView() {
		textView = MaterialTextView()
		addSubview(textView)
		textView.translatesAutoresizingMaskIntoConstraints = false
		MaterialLayout.alignToParent(self, child: textView)
	}
	
	/// Prepares the titleLabel.
	private func prepareTitleLabel() {
		titleLabel = UILabel()
		titleLabel.hidden = true
		titleLabel.font = RobotoFont.mediumWithSize(12)
		addSubview(titleLabel)
		
		titleLabelColor = placeholderTextColor
		titleLabelActiveColor = MaterialColor.blue.accent3
		
//		if 0 < text?.utf16.count {
////			showTitleLabel()
//		} else {
//			titleLabel.alpha = 0
//		}
	}
	
	/// Prepares the lineLayer.
	private func prepareLineLayer() {
		layoutLineLayer()
		layer.addSublayer(lineLayer)
	}
	
	/// Layout the lineLayer.
	private func layoutLineLayer() {
		let h: CGFloat = 1 < lineLayer.frame.height ? lineLayer.frame.height : 1
		lineLayer.frame = CGRectMake(0, bounds.height + lineLayerDistance, bounds.width, h)
		print(lineLayer.frame)
	}
}
