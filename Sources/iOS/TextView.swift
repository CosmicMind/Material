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

@objc(TextViewDelegate)
public protocol TextViewDelegate : UITextViewDelegate {}

@IBDesignable
@objc(TextView)
public class TextView: UITextView {
	/// A property that accesses the backing layer's backgroundColor.
	@IBInspectable public override var backgroundColor: UIColor? {
		didSet {
			layer.backgroundColor = backgroundColor?.cgColor
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
	
	/// A property that accesses the layer.frame.size.width property.
	@IBInspectable public var width: CGFloat {
		get {
			return layer.frame.size.width
		}
		set(value) {
			layer.frame.size.width = value
		}
	}
	
	/// A property that accesses the layer.frame.size.height property.
	@IBInspectable public var height: CGFloat {
		get {
			return layer.frame.size.height
		}
		set(value) {
			layer.frame.size.height = value
		}
	}
	
	/// Enables automatic shadowPath sizing.
	@IBInspectable public var shadowPathAutoSizeEnabled: Bool = true {
		didSet {
			if shadowPathAutoSizeEnabled {
				layoutShadowPath()
			}
		}
	}
	
	/**
	The title UILabel that is displayed when there is text. The 
	titleLabel text value is updated with the placeholderLabel
	text value before being displayed.
	*/
	public var titleLabel: UILabel? {
		didSet {
			prepareTitleLabel()
		}
	}
	
	/// The color of the titleLabel text when the textView is not active.
	@IBInspectable public var titleLabelColor: UIColor? {
		didSet {
			titleLabel?.textColor = titleLabelColor
		}
	}
	
	/// The color of the titleLabel text when the textView is active.
	@IBInspectable public var titleLabelActiveColor: UIColor?
	
	/**
	A property that sets the distance between the textView and
	titleLabel.
	*/
	@IBInspectable public var titleLabelAnimationDistance: CGFloat = 8
	
	/// Placeholder UILabel view.
	public var placeholderLabel: UILabel? {
		didSet {
			preparePlaceholderLabel()
		}
	}
	
	/// An override to the text property.
	@IBInspectable public override var text: String! {
		didSet {
			handleTextViewTextDidChange()
		}
	}
	
	/// An override to the attributedText property.
	public override var attributedText: NSAttributedString! {
		didSet {
			handleTextViewTextDidChange()
		}
	}
	
	/**
	Text container UIEdgeInset preset property. This updates the 
	textContainerInset property with a preset value.
	*/
	public var textContainerEdgeInsetsPreset: EdgeInsetsPreset = .none {
		didSet {
			textContainerInset = EdgeInsetsPresetToValue(preset: textContainerEdgeInsetsPreset)
		}
	}
	
	/// Text container UIEdgeInset property.
	public override var textContainerInset: Insets {
		didSet {
			reloadView()
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
	- Parameter textContainer: A NSTextContainer instance.
	*/
	public override init(frame: CGRect, textContainer: NSTextContainer?) {
		super.init(frame: frame, textContainer: textContainer)
		prepareView()
	}
	
	/**
	A convenience initializer that is mostly used with AutoLayout.
	- Parameter textContainer: A NSTextContainer instance.
	*/
	public convenience init(textContainer: NSTextContainer?) {
		self.init(frame: CGRect.zero, textContainer: textContainer)
	}
	
	/** Denitializer. This should never be called unless you know
	what you are doing.
	*/
	deinit {
		removeNotificationHandlers()
	}
	
	/// Overriding the layout callback for subviews.
	public override func layoutSubviews() {
		super.layoutSubviews()
		layoutShadowPath()
		placeholderLabel?.preferredMaxLayoutWidth = textContainer.size.width - textContainer.lineFragmentPadding * 2
		titleLabel?.frame.size.width = bounds.width
	}
	
	/// Reloads necessary components when the view has changed.
	internal func reloadView() {
		if let p = placeholderLabel {
			removeConstraints(constraints)
			layout(p).edges(
				top: textContainerInset.top,
				left: textContainerInset.left + textContainer.lineFragmentPadding,
				bottom: textContainerInset.bottom,
				right: textContainerInset.right + textContainer.lineFragmentPadding)
		}
	}
	
	/// Notification handler for when text editing began.
	internal func handleTextViewTextDidBegin() {
		titleLabel?.textColor = titleLabelActiveColor
	}
	
	/// Notification handler for when text changed.
	internal func handleTextViewTextDidChange() {
		if let p = placeholderLabel {
			p.isHidden = !(true == text?.isEmpty)
		}
		
		if 0 < text?.utf16.count {
			showTitleLabel()
		} else if 0 == text?.utf16.count {
			hideTitleLabel()
		}
	}
	
	/// Notification handler for when text editing ended.
	internal func handleTextViewTextDidEnd() {
		if 0 < text?.utf16.count {
			showTitleLabel()
		} else if 0 == text?.utf16.count {
			hideTitleLabel()
		}
		titleLabel?.textColor = titleLabelColor
	}
	
	/// Sets the shadow path.
	internal func layoutShadowPath() {
		if shadowPathAutoSizeEnabled {
			if .none == depth {
				shadowPath = nil
			} else if nil == shadowPath {
				shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius).CGPath
			} else {
				animate(MaterialAnimation.shadowPath(UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius).CGPath, duration: 0))
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
		contentScaleFactor = Device.scale
		textContainerInset = EdgeInsets.zero
		backgroundColor = Color.white
		masksToBounds = false
		removeNotificationHandlers()
		prepareNotificationHandlers()
		reloadView()
	}
	
	/// prepares the placeholderLabel property.
	private func preparePlaceholderLabel() {
		if let v: UILabel = placeholderLabel {
			v.font = font
			v.textAlignment = textAlignment
			v.numberOfLines = 0
			v.backgroundColor = Color.clear
			addSubview(v)
			reloadView()
			handleTextViewTextDidChange()
		}
	}
	
	/// Prepares the titleLabel property.
	private func prepareTitleLabel() {
		if let v: UILabel = titleLabel {
			v.isHidden = true
			addSubview(v)
			if 0 < text?.utf16.count {
				showTitleLabel()
			} else {
				v.alpha = 0
			}
		}
	}
	
	/// Shows and animates the titleLabel property.
	private func showTitleLabel() {
		if let v: UILabel = titleLabel {
			if v.isHidden {
				if let s: String = placeholderLabel?.text {
                    v.text = s
				}
				let h: CGFloat = ceil(v.font.lineHeight)
				v.frame = CGRectMake(0, -h, bounds.width, h)
				v.isHidden = false
				UIView.animateWithDuration(0.25, animations: { [weak self] in
					if let s: TextView = self {
						v.alpha = 1
						v.frame.origin.y = -v.frame.height - s.titleLabelAnimationDistance
					}
				})
			}
		}
	}
	
	/// Hides and animates the titleLabel property.
	private func hideTitleLabel() {
		if let v: UILabel = titleLabel {
			if !v.isHidden {
				UIView.animateWithDuration(0.25, animations: {
					v.alpha = 0
					v.frame.origin.y = -v.frame.height
				}) { _ in
					v.isHidden = true
				}
			}
		}
	}
	
	/// Prepares the Notification handlers.
	private func prepareNotificationHandlers() {
		NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(handleTextViewTextDidBegin), name: UITextViewTextDidBeginEditingNotification, object: nil)
		NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(handleTextViewTextDidChange), name: UITextViewTextDidChangeNotification, object: nil)
		NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(handleTextViewTextDidEnd), name: UITextViewTextDidEndEditingNotification, object: nil)
	}
	
	/// Removes the Notification handlers.
	private func removeNotificationHandlers() {
		NSNotificationCenter.defaultCenter().removeObserver(self, name: UITextViewTextDidBeginEditingNotification, object: nil)
		NSNotificationCenter.defaultCenter().removeObserver(self, name: UITextViewTextDidChangeNotification, object: nil)
		NSNotificationCenter.defaultCenter().removeObserver(self, name: UITextViewTextDidEndEditingNotification, object: nil)
	}
}
