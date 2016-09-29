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

private var TextFieldContext: UInt8 = 0

public protocol TextFieldDelegate: UITextFieldDelegate {}

open class TextField: UITextField {
    /// Default size when using AutoLayout.
    open override var intrinsicContentSize: CGSize {
        return CGSize(width: width, height: 32)
    }
    
    /// A Boolean that indicates if the TextField is in an animating state.
	open internal(set) var isAnimating = false
	
    /// Divider normal height.
    @IBInspectable
    open var dividerNormalHeight: CGFloat = 1
    
    
	/// Divider active height.
	@IBInspectable
    open var dividerActiveHeight: CGFloat = 2
	
	/// Divider normal color.
	@IBInspectable
    open var dividerNormalColor = Color.darkText.dividers {
        didSet {
            guard !isEditing else {
                return
            }
            
            dividerColor = dividerNormalColor
        }
    }
	
	/// Divider active color.
	@IBInspectable
    open var dividerActiveColor = Color.blue.base {
		didSet {
            guard isEditing else {
                return
            }
            
            dividerColor = dividerActiveColor
		}
	}
	
	/// The placeholderLabel font value.
	@IBInspectable
    open override var font: UIFont? {
		didSet {
			placeholderLabel.font = font
		}
	}
 
	/// TextField's text property observer.
	@IBInspectable
    open override var text: String? {
		didSet {
            guard true == text?.isEmpty else {
                return
            }
            
            guard !isFirstResponder else {
                return
            }
            
			placeholderEditingDidEndAnimation()
		}
	}
	
	/// The placeholderLabel text value.
	@IBInspectable
    open override var placeholder: String? {
		get {
			return placeholderLabel.text
		}
		set(value) {
			placeholderLabel.text = value
			
            guard let v = value else {
                return
            }
            
            placeholderLabel.attributedText = NSAttributedString(string: v, attributes: [NSForegroundColorAttributeName: placeholderNormalColor])
		}
	}
	
	/// The placeholder UILabel.
	@IBInspectable
    open private(set) var placeholderLabel: UILabel!
	
	/// Placeholder normal textColor.
	@IBInspectable
    open var placeholderNormalColor = Color.darkText.others {
		didSet {
            guard !isEditing else {
                return
            }
            
            guard let v = placeholder else {
                return
            }
            
            placeholderLabel.attributedText = NSAttributedString(string: v, attributes: [NSForegroundColorAttributeName: placeholderNormalColor])
		}
	}
	
	/// Placeholder active textColor.
	@IBInspectable
    open var placeholderActiveColor = Color.blue.base {
		didSet {
            tintColor = placeholderActiveColor
            
            guard isEditing else {
                return
            }
            
            guard let v = placeholder else {
                return
            }
                
            placeholderLabel.attributedText = NSAttributedString(string: v, attributes: [NSForegroundColorAttributeName: placeholderActiveColor])
		}
	}
	
	/// This property adds a padding to placeholder y position animation
	@IBInspectable
    open var placeholderVerticalOffset: CGFloat = 0
	
	/// The detailLabel UILabel that is displayed.
	@IBInspectable
    open private(set) lazy var detailLabel = UILabel(frame: .zero)
	
	/// The detailLabel text value.
	@IBInspectable
    open var detail: String? {
		get {
			return detailLabel.text
		}
		set(value) {
			detailLabel.text = value
		}
	}
	
	/// Detail textColor.
	@IBInspectable
    open var detailColor = Color.darkText.others {
		didSet {
            updateDetailLabelAttributedText()
		}
	}
    
	/// Vertical distance for the detailLabel from the divider.
	@IBInspectable
    open var detailVerticalOffset: CGFloat = 8 {
		didSet {
			layoutDetailLabel()
		}
	}
	
	/// Handles the textAlignment of the placeholderLabel.
	open override var textAlignment: NSTextAlignment {
		get {
			return super.textAlignment
		}
		set(value) {
			super.textAlignment = value
			placeholderLabel.textAlignment = value
			detailLabel.textAlignment = value
		}
	}
	
	/// Enables the clearIconButton.
	@IBInspectable
    open var isClearIconButtonEnabled: Bool {
		get {
			return nil != clearIconButton
		}
		set(value) {
            guard value else {
                clearIconButton?.removeTarget(self, action: #selector(handleClearIconButton), for: .touchUpInside)
                clearIconButton = nil
                return
            }
            
            guard nil == clearIconButton else {
                return
            }
            
            clearIconButton = IconButton(image: Icon.cm.clear, tintColor: placeholderNormalColor)
            clearIconButton!.contentEdgeInsets = .zero
            clearIconButton!.pulseAnimation = .center
            clearButtonMode = .never
            rightViewMode = .whileEditing
            rightView = clearIconButton
            isClearIconButtonAutoHandled = isClearIconButtonAutoHandled ? true : false
		}
	}
	
	/// Enables the automatic handling of the clearIconButton.
	@IBInspectable
    open var isClearIconButtonAutoHandled = true {
		didSet {
			clearIconButton?.removeTarget(self, action: #selector(handleClearIconButton), for: .touchUpInside)
			
            guard isClearIconButtonAutoHandled else {
                return
			}
            
            clearIconButton?.addTarget(self, action: #selector(handleClearIconButton), for: .touchUpInside)
		}
	}
	
	/// Enables the visibilityIconButton.
	@IBInspectable
    open var isVisibilityIconButtonEnabled: Bool {
		get {
			return nil != visibilityIconButton
		}
		set(value) {
            guard value else {
                visibilityIconButton?.removeTarget(self, action: #selector(handleVisibilityIconButton), for: .touchUpInside)
                visibilityIconButton = nil
                return
            }
            
            guard nil == visibilityIconButton else {
                return
            }
            
            visibilityIconButton = IconButton(image: Icon.visibility, tintColor: placeholderNormalColor.withAlphaComponent(isSecureTextEntry ? 0.38 : 0.54))
            visibilityIconButton!.contentEdgeInsets = .zero
            visibilityIconButton!.pulseAnimation = .center
            isSecureTextEntry = true
            clearButtonMode = .never
            rightViewMode = .whileEditing
            rightView = visibilityIconButton
            isVisibilityIconButtonAutoHandled = isVisibilityIconButtonAutoHandled ? true : false
		}
	}
	
	/// Enables the automatic handling of the visibilityIconButton.
	@IBInspectable
    open var isVisibilityIconButtonAutoHandled: Bool = true {
		didSet {
			visibilityIconButton?.removeTarget(self, action: #selector(handleVisibilityIconButton), for: .touchUpInside)
			
            guard isVisibilityIconButtonAutoHandled else {
                return
			}
            
            visibilityIconButton?.addTarget(self, action: #selector(handleVisibilityIconButton), for: .touchUpInside)
		}
	}
	
	/// A reference to the clearIconButton.
	open private(set) var clearIconButton: IconButton?
	
	/// A reference to the visibilityIconButton.
	open private(set) var visibilityIconButton: IconButton?
	
    /**
     `layoutIfNeeded` is called within `becomeFirstResponder` to
     fix an issue that when the TextField calls `becomeFirstResponder`
     immediately when launching an instance, the TextField is not
     calculated correctly.
     */
    open override func becomeFirstResponder() -> Bool {
        layoutIfNeeded()
        return super.becomeFirstResponder()
    }
    
    open override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        guard "detailLabel.text" == keyPath else {
            super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
            return
        }
        
        updateDetailLabelAttributedText()
        layoutDetailLabel()
    }
    
    deinit {
        removeObserver(self, forKeyPath: "detailLabel.text")
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
     */
	public override init(frame: CGRect) {
		super.init(frame: frame)
		prepare()
	}
	
	/// A convenience initializer.
	public convenience init() {
		self.init(frame: .zero)
	}
	
	open override func layoutSubviews() {
		super.layoutSubviews()
        layoutToSize()
        layoutDivider()
	}
	
	open override func layoutSublayers(of layer: CALayer) {
		super.layoutSublayers(of: layer)
        guard self.layer == layer else {
            return
        }
        
        layoutShape()
	}
	
	/// Handles the text editing did begin state.
    @objc
	open func handleEditingDidBegin() {
        dividerEditingDidBeginAnimation()
		placeholderEditingDidBeginAnimation()
	}
	
	/// Handles the text editing did end state.
	@objc
    open func handleEditingDidEnd() {
		dividerEditingDidEndAnimation()
		placeholderEditingDidEndAnimation()
	}
	
	/// Handles the clearIconButton TouchUpInside event.
	@objc
    open func handleClearIconButton() {
        guard true == delegate?.textFieldShouldClear?(self) else {
            return
        }
		
        text = nil
	}
	
	/// Handles the visibilityIconButton TouchUpInside event.
    @objc
	open func handleVisibilityIconButton() {
		isSecureTextEntry = !isSecureTextEntry
		
        if !isSecureTextEntry {
			super.font = nil
			font = placeholderLabel.font
		}
		
        visibilityIconButton?.tintColor = visibilityIconButton?.tintColor.withAlphaComponent(isSecureTextEntry ? 0.38 : 0.54)
	}
	
	/**
     Prepares the view instance when intialized. When subclassing,
     it is recommended to override the prepare method
     to initialize property values and other setup operations.
     The super.prepare method should always be called immediately
     when subclassing.
     */
	open func prepare() {
		super.placeholder = nil
        clipsToBounds = false
		borderStyle = .none
		backgroundColor = nil
		contentScaleFactor = Device.scale
		prepareDivider()
		preparePlaceholderLabel()
		prepareDetailLabel()
		prepareTargetHandlers()
        prepareTextAlignment()
	}
    
	/// Ensures that the components are sized correctly.
	open func layoutToSize() {
		guard !isAnimating else {
            return
        }
        
        layoutPlaceholderLabel()
        layoutDetailLabel()
        layoutButton(button: clearIconButton)
        layoutButton(button: visibilityIconButton)
	}
	
	/// Layout the divider.
	open func layoutDivider() {
        divider.reload()
	}
	
	/// Layout the placeholderLabel.
	open func layoutPlaceholderLabel() {
		if !isEditing && true == text?.isEmpty {
			placeholderLabel.frame = bounds
		} else if placeholderLabel.transform.isIdentity {
			placeholderLabel.frame = bounds
			placeholderLabel.transform = CGAffineTransform(scaleX: 0.75, y: 0.75)
			switch textAlignment {
			case .left, .natural:
				placeholderLabel.x = 0
			case .right:
				placeholderLabel.x = width - placeholderLabel.width
			default:break
			}
			placeholderLabel.y = -placeholderLabel.height + placeholderVerticalOffset
			placeholderLabel.textColor = placeholderNormalColor
		} else {
			switch textAlignment {
			case .left, .natural:
				placeholderLabel.x = 0
			case .right:
				placeholderLabel.x = width - placeholderLabel.width
			case .center:
				placeholderLabel.center.x = width / 2
			default:break
			}
			placeholderLabel.width = width * 0.75
		}
	}
	
	/// Layout the detailLabel.
	open func layoutDetailLabel() {
        guard let v = divider.line else {
            return
        }
        
        let h: CGFloat = nil == detail ? 12 : detailLabel.font.stringSize(string: detail!, constrainedToWidth: Double(width)).height
        detailLabel.frame = CGRect(x: 0, y: v.y + detailVerticalOffset, width: width, height: h)
	}
	
	/// Layout the a button.
    open func layoutButton(button: UIButton?) {
        guard 0 < width && 0 < height else {
            return
        }
        
        button?.frame = CGRect(x: width - height, y: 0, width: height, height: height)
	}
	
	/// The animation for the divider when editing begins.
	open func dividerEditingDidBeginAnimation() {
		dividerHeight = dividerActiveHeight
		dividerColor = dividerActiveColor ?? placeholderActiveColor
	}
	
	/// The animation for the divider when editing ends.
	open func dividerEditingDidEndAnimation() {
		dividerHeight = dividerNormalHeight
		dividerColor = dividerNormalColor
	}
	
	/// The animation for the placeholder when editing begins.
	open func placeholderEditingDidBeginAnimation() {
        guard placeholderLabel.transform.isIdentity else {
            if isEditing {
                placeholderLabel.textColor = placeholderActiveColor
            }
            return
        }
        
        isAnimating = true
        UIView.animate(withDuration: 0.15, animations: { [weak self] in
            guard let s = self else {
                return
            }
            
            s.placeholderLabel.transform = CGAffineTransform(scaleX: 0.75, y: 0.75)
            
            switch s.textAlignment {
            case .left, .natural:
                s.placeholderLabel.x = 0
            case .right:
                s.placeholderLabel.x = s.width - s.placeholderLabel.width
            default:break
            }
            
            s.placeholderLabel.y = -s.placeholderLabel.height + s.placeholderVerticalOffset
            s.placeholderLabel.textColor = s.placeholderActiveColor
        }) { [weak self] _ in
            self?.isAnimating = false
        }
	}
	
	/// The animation for the placeholder when editing ends.
	open func placeholderEditingDidEndAnimation() {
		if !placeholderLabel.transform.isIdentity && true == text?.isEmpty {
			isAnimating = true
			UIView.animate(withDuration: 0.15, animations: { [weak self] in
                guard let s = self else {
                    return
                }
                
                s.placeholderLabel.transform = CGAffineTransform.identity
                s.placeholderLabel.x = 0
                s.placeholderLabel.y = 0
                s.placeholderLabel.textColor = s.placeholderNormalColor
			}) { [weak self] _ in
				self?.isAnimating = false
			}
		} else if !isEditing {
			placeholderLabel.textColor = placeholderNormalColor
		}
	}
	
	/// Prepares the divider.
	private func prepareDivider() {
        dividerColor = dividerNormalColor
	}
	
	/// Prepares the placeholderLabel.
	private func preparePlaceholderLabel() {
        placeholderLabel = UILabel(frame: .zero)
		placeholderNormalColor = Color.darkText.others
        font = RobotoFont.regular(with: 16)
        addSubview(placeholderLabel)
	}
	
	/// Prepares the detailLabel.
	private func prepareDetailLabel() {
        detailLabel.font = RobotoFont.regular(with: 12)
        detailLabel.numberOfLines = 0
		detailColor = Color.darkText.others
		addSubview(detailLabel)
        addObserver(self, forKeyPath: "detailLabel.text", options: [], context: &TextFieldContext)
	}
	
	/// Prepares the target handlers.
	private func prepareTargetHandlers() {
		addTarget(self, action: #selector(handleEditingDidBegin), for: .editingDidBegin)
		addTarget(self, action: #selector(handleEditingDidEnd), for: .editingDidEnd)
	}
    
    /// Prepares the textAlignment.
    private func prepareTextAlignment() {
        textAlignment = .rightToLeft == UIApplication.shared.userInterfaceLayoutDirection ? .right : .left
    }
    
    /// Updates the detailLabel attributedText.
    private func updateDetailLabelAttributedText() {
        guard let v = detail else {
            return
        }
        
        detailLabel.attributedText = NSAttributedString(string: v, attributes: [NSForegroundColorAttributeName: detailColor])
    }
}
