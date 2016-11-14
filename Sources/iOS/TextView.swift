/*
 * Copyright (C) 2015 - 2016, Daniel Dahan and CosmicMind, Inc. <http://cosmicmind.com>.
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

@objc(TextView)
open class TextView: UITextView {
	/// A property that accesses the backing layer's background
	@IBInspectable
    open override var backgroundColor: UIColor? {
		didSet {
			layer.backgroundColor = backgroundColor?.cgColor
		}
	}
	
	/**
	The title UILabel that is displayed when there is text. The 
	titleLabel text value is updated with the placeholderLabel
	text value before being displayed.
	*/
	@IBInspectable
    open var titleLabel: UILabel? {
		didSet {
			prepareTitleLabel()
		}
	}
	
	/// The color of the titleLabel text when the textView is not active.
	@IBInspectable
    open var titleLabelColor: UIColor? {
		didSet {
			titleLabel?.textColor = titleLabelColor
		}
	}
	
	/// The color of the titleLabel text when the textView is active.
	@IBInspectable
    open var titleLabelActiveColor: UIColor?
	
	/**
	A property that sets the distance between the textView and
	titleLabel.
	*/
	@IBInspectable
    open var titleLabelAnimationDistance: CGFloat = 8
	
	/// Placeholder UILabel view.
	open var placeholderLabel: UILabel? {
		didSet {
			preparePlaceholderLabel()
		}
	}
	
	/// An override to the text property.
	@IBInspectable
    open override var text: String! {
		didSet {
			handleTextViewTextDidChange()
		}
	}
	
	/// An override to the attributedText property.
	open override var attributedText: NSAttributedString! {
		didSet {
			handleTextViewTextDidChange()
		}
	}
	
	/**
	Text container UIEdgeInset preset property. This updates the 
	textContainerInset property with a preset value.
	*/
	open var textContainerEdgeInsetsPreset: EdgeInsetsPreset = .none {
		didSet {
			textContainerInset = EdgeInsetsPresetToValue(preset: textContainerEdgeInsetsPreset)
		}
	}
	
	/// Text container UIEdgeInset property.
	open override var textContainerInset: EdgeInsets {
		didSet {
			reload()
		}
	}
	
	/**
	An initializer that initializes the object with a NSCoder object.
	- Parameter aDecoder: A NSCoder instance.
	*/
	public required init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
		prepare()
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
		prepare()
	}
	
	/**
	A convenience initializer that is mostly used with AutoLayout.
	- Parameter textContainer: A NSTextContainer instance.
	*/
	public convenience init(textContainer: NSTextContainer?) {
		self.init(frame: .zero, textContainer: textContainer)
	}
	
	/** Denitializer. This should never be called unless you know
	what you are doing.
	*/
	deinit {
		removeNotificationHandlers()
	}
	
    open override func layoutSublayers(of layer: CALayer) {
        super.layoutSublayers(of: layer)
        layoutShape()
    }
    
    open override func layoutSubviews() {
		super.layoutSubviews()
		layoutShadowPath()
		placeholderLabel?.preferredMaxLayoutWidth = textContainer.size.width - textContainer.lineFragmentPadding * 2
		titleLabel?.frame.size.width = bounds.width
	}
	
	/// Reloads necessary components when the view has changed.
    open func reload() {
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
    @objc
	fileprivate func handleTextViewTextDidBegin() {
		titleLabel?.textColor = titleLabelActiveColor
	}
	
	/// Notification handler for when text changed.
	@objc
    fileprivate func handleTextViewTextDidChange() {
		if let p = placeholderLabel {
			p.isHidden = !(true == text?.isEmpty)
		}
		
        guard let t = text else {
            hideTitleLabel()
            return
        }
        
        if 0 < t.utf16.count {
            showTitleLabel()
        } else {
            hideTitleLabel()
        }
	}
	
	/// Notification handler for when text editing ended.
    @objc
	fileprivate func handleTextViewTextDidEnd() {
        guard let t = text else {
            hideTitleLabel()
            return
        }
        
        if 0 < t.utf16.count {
            showTitleLabel()
        } else {
            hideTitleLabel()
        }
        
        titleLabel?.textColor = titleLabelColor
	}
	
	/**
     Prepares the view instance when intialized. When subclassing,
     it is recommended to override the prepare method
     to initialize property values and other setup operations.
     The super.prepare method should always be called immediately
     when subclassing.
     */
	open func prepare() {
		contentScaleFactor = Screen.scale
		textContainerInset = .zero
		backgroundColor = .white
		clipsToBounds = false
		removeNotificationHandlers()
		prepareNotificationHandlers()
		reload()
	}
	
	/// prepares the placeholderLabel property.
	fileprivate func preparePlaceholderLabel() {
		if let v: UILabel = placeholderLabel {
			v.font = font
			v.textAlignment = textAlignment
			v.numberOfLines = 0
			v.backgroundColor = .clear
			addSubview(v)
			reload()
			handleTextViewTextDidChange()
		}
	}
	
	/// Prepares the titleLabel property.
	fileprivate func prepareTitleLabel() {
		if let v: UILabel = titleLabel {
			v.isHidden = true
			addSubview(v)
            
            guard let t = text, 0 == t.utf16.count else {
                v.alpha = 0
                return
            }
            
            showTitleLabel()
		}
	}
	
	/// Shows and animates the titleLabel property.
	fileprivate func showTitleLabel() {
		if let v: UILabel = titleLabel {
			if v.isHidden {
				if let s: String = placeholderLabel?.text {
                    v.text = s
				}
				let h: CGFloat = ceil(v.font.lineHeight)
                v.frame = CGRect(x: 0, y: -h, width: bounds.width, height: h)
				v.isHidden = false
				UIView.animate(withDuration: 0.25, animations: { [weak self] in
					if let s: TextView = self {
						v.alpha = 1
						v.frame.origin.y = -v.frame.height - s.titleLabelAnimationDistance
					}
				})
			}
		}
	}
	
	/// Hides and animates the titleLabel property.
	fileprivate func hideTitleLabel() {
		if let v: UILabel = titleLabel {
			if !v.isHidden {
				UIView.animate(withDuration: 0.25, animations: {
					v.alpha = 0
					v.frame.origin.y = -v.frame.height
				}) { _ in
					v.isHidden = true
				}
			}
		}
	}
	
	/// Prepares the Notification handlers.
	fileprivate func prepareNotificationHandlers() {
		let defaultCenter = NotificationCenter.default
        defaultCenter.addObserver(self, selector: #selector(handleTextViewTextDidBegin), name: NSNotification.Name.UITextViewTextDidBeginEditing, object: self)
		defaultCenter.addObserver(self, selector: #selector(handleTextViewTextDidChange), name: NSNotification.Name.UITextViewTextDidChange, object: self)
		defaultCenter.addObserver(self, selector: #selector(handleTextViewTextDidEnd), name: NSNotification.Name.UITextViewTextDidEndEditing, object: self)
	}
	
	/// Removes the Notification handlers.
	fileprivate func removeNotificationHandlers() {
        let defaultCenter = NotificationCenter.default
        defaultCenter.removeObserver(self, name: NSNotification.Name.UITextViewTextDidBeginEditing, object: self)
		defaultCenter.removeObserver(self, name: NSNotification.Name.UITextViewTextDidChange, object: self)
		defaultCenter.removeObserver(self, name: NSNotification.Name.UITextViewTextDidEndEditing, object: self)
	}
}
