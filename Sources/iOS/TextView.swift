/*
 * Copyright (C) 2015 - 2017, Daniel Dahan and CosmicMind, Inc. <http://cosmicmind.com>.
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
    /// A boolean indicating whether the text is empty.
    open var isEmpty: Bool {
        return 0 == text?.utf16.count
    }
    
    /// A boolean indicating whether the text is in edit mode.
    open fileprivate(set) var isEditing = true
    
	/// A property that accesses the backing layer's background
	@IBInspectable
    open override var backgroundColor: UIColor? {
		didSet {
			layer.backgroundColor = backgroundColor?.cgColor
		}
	}
	
	/// The placeholderLabel font value.
    @IBInspectable
    open override var font: UIFont? {
        didSet {
            placeholderLabel.font = font
        }
    }
    
    /// The placeholderLabel text value.
    @IBInspectable
    open var placeholder: String? {
        get {
            return placeholderLabel.text
        }
        set(value) {
            placeholderLabel.text = value
            layoutSubviews()
        }
    }
    
    /// The placeholder UILabel.
    @IBInspectable
    open let placeholderLabel = UILabel()
    
    /// Placeholder normal text
    @IBInspectable
    open var placeholderNormalColor = Color.darkText.others {
        didSet {
            updatePlaceholderLabelColor()
        }
    }
    
    /// Placeholder active text
    @IBInspectable
    open var placeholderActiveColor = Color.blue.base {
        didSet {
            updatePlaceholderLabelColor()
        }
    }
	
	/// An override to the text property.
	@IBInspectable
    open override var text: String? {
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
	
	/** 
     Denitializer. This should never be called unless you know
	 what you are doing.
	 */
	deinit {
		NotificationCenter.default.removeObserver(self)
	}
	
    open override func layoutSubviews() {
		super.layoutSubviews()
		layoutShape()
        layoutShadowPath()
		
        placeholderLabel.preferredMaxLayoutWidth = textContainer.size.width - textContainer.lineFragmentPadding * 2
	}
	
	/// Reloads necessary components when the view has changed.
    open func reload() {
        removeConstraints(constraints)
        layout(placeholderLabel).edges(
            top: textContainerInset.top,
            left: textContainerInset.left + textContainer.lineFragmentPadding,
            bottom: textContainerInset.bottom,
            right: textContainerInset.right + textContainer.lineFragmentPadding)
	}
	
	/// Notification handler for when text editing began.
    @objc
	fileprivate func handleTextViewTextDidBegin() {
    
    }
	
	/// Notification handler for when text changed.
	@objc
    fileprivate func handleTextViewTextDidChange() {
		placeholderLabel.isHidden = !isEmpty
	}
	
	/// Notification handler for when text editing ended.
    @objc
	fileprivate func handleTextViewTextDidEnd() {
        
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
        preparePlaceholderLabel()
		prepareNotificationHandlers()
	}
	
	/// prepares the placeholderLabel property.
	fileprivate func preparePlaceholderLabel() {
        placeholderLabel.font = font
        placeholderLabel.textAlignment = textAlignment
        placeholderLabel.numberOfLines = 0
        placeholderLabel.backgroundColor = .clear
	}
	
	/// Prepares the Notification handlers.
	fileprivate func prepareNotificationHandlers() {
		let defaultCenter = NotificationCenter.default
        defaultCenter.addObserver(self, selector: #selector(handleTextViewTextDidBegin), name: NSNotification.Name.UITextViewTextDidBeginEditing, object: self)
		defaultCenter.addObserver(self, selector: #selector(handleTextViewTextDidChange), name: NSNotification.Name.UITextViewTextDidChange, object: self)
		defaultCenter.addObserver(self, selector: #selector(handleTextViewTextDidEnd), name: NSNotification.Name.UITextViewTextDidEndEditing, object: self)
	}
}

extension TextView {
    /// Updates the placeholderLabel text color.
    fileprivate func updatePlaceholderLabelColor() {
        tintColor = placeholderActiveColor
        placeholderLabel.textColor = isEditing ? placeholderActiveColor : placeholderNormalColor
    }
}
